# bbs-docker
---
## 用 docker 安裝 pttbbs
---
## 下載
```bash
git clone https://github.com/william920429/bbs-docker.git
```
## 安裝
如果你的 cpu 支援 SSE4.2 指令集，可以將 Dockerfile 第一行  
從這個
```dockerfile
FROM openresty/openresty:bionic-nosse42
```
改成這個
```dockerfile
FROM openresty/openresty:bionic
```
之後
```bash
docker build . -t "bbs"
```

## 修改 config
### docker-compose.yml
Port:  
如果希望可由外部連線，可以將 `127.0.0.1:` 刪除或改成 `0.0.0.0:`  
從這個
```yml
ports:
  # - 127.0.0.1:3000:3000 #telnet
  - 127.0.0.1:3001:3001 #openresty
```
改成這個
```yml
ports:
  # - 127.0.0.1:3000:3000 #telnet
  - 3001:3001 #openresty
```
或是
```yml
ports:
  # - 127.0.0.1:3000:3000 #telnet
  - 0.0.0.0:3001:3001 #openresty
```
Pttchrome:
```yml
environment:
  PTTCHROME_PAGE_TITLE: "附中電算bbs"
  DEFAULT_SITE: "wsstelnet://ws.crc.cnmc.tw/bbs"
  # Take effect only when "PttChrome/dist" does not exist on startup.
```
>PTTCHROME_PAGE_TITLE: 網頁的標題

>DEFAULT_SITE: 目標主機
>要能從 client 連線，記得開防火牆  
>單人測試時可以用 `wstelnet://127.0.0.1:3001/bbs`  
>如果改成 `wsstelnet://ws.crc.cnmc.tw/bbs`，就會連到電算 bbs 喔！(還沒修好  
>* `wstelnet://` 表示連線未加密，預設連接 port 80  
>* `wsstelnet://` 表示連線已加密，預設連接 port 443  

### files/pttbbs.conf
請參考 <https://github.com/ptt/pttbbs/wiki/CONFIG>

## 啟動！！
```bash
cd bbs-docker
docker-compose up -d
```
第一次啟動要花一點時間  
想看看發生什麼事，可以
```bash
docker logs -f bbs
```
沒意外的話，可以在 <http://127.0.0.1:3001> 看到新鮮的 bbs   
有意外的話......加油！相信你可以ㄉ！

---
## 參考
1. pttbbs <https://github.com/ptt/pttbbs>
2. PttChrome <https://github.com/robertabcd/PttChrome>
3. 非官方Docker image <https://github.com/bbsdocker/imageptt>

---
## 補充
### nginx reverse proxy
將 bbs 放在 nginx 後面
由 nginx  負責 SSL 加/解密 & 處理連線

在 nginx 加入以下設定檔
```nginx
upstream bbs {
    server localhost:3001;
    keepalive 64;
}
...
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name bbs.crc.cnmc.tw;
    location / {
        proxy_pass http://bbs;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        add_header X-Frame-Options SAMEORIGIN;
        proxy_hide_header X-Frame-Options;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
    }
}
```
SSL 相關設定請參考 <https://ssl-config.mozilla.org>  
可以使用 let's encrypt 免費憑證
