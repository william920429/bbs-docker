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
如果不支援，直接
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
