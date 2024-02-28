<span style="color: red; "></span>
- VPSサーバーをレンタルする(azure,awsとかはsignup直後から1年間は無料なのでサブ垢で数年持つ)
- vps鯖でvpnserverを、vps鯖、自宅鯖両方でvpnclientを立ち上げる
    - vpnserverpassword,userpassword,accountpasswordちゃんと設定したか確認！！！
- vps鯖をnginxを使ってreverseproxy的な感じにさせる

# vps鯖レンタル
設定すべきところは開放するポートくらいでそれ以外は無料になるように設定すれば良い。<br>
ssh接続など不安も残ると思うが、大抵は管理サイトでコピペできるように用意してくれている。<br>
##### 開放するポート
- 22 (tcp)
    - ssh接続用。おそらくデフォルトで有効
- 443 (tcp)
    - vpn用
- 25565 (tcp)
    - minecraftで使われるport

# vps鯖にてvpnserver確立
https://www.softether-download.com/ja.aspx?product=softether<br>
まずはここから適したversionのsoftether VPN serverを取得(ダウンロードリンクをwgetすれば直接vpsにダウンロードできる)<br>
- tar -xvf {ダウンロードしたもの}
- cd ./vpnserver
- make
    - すると./vpnserverの中にvpnserverとvpncmdの実行ファイルができる
    - sudo apt-get install build-essential <- これはコピペ用
- cd ../
- sudo vi ./vpnserver/lang.conf
    - enをjaに変更する（jpではない！！）
    - sudoが無いとだめらしい？
- sudo ./vpnserver/vpnserver start
- sudo ./vpnserver/vpncmd
    - 1を選ぶ
    - localhostの鯖を使いたいので何も入力せずEnter
    - hubはDEFAULT
    - こうしてvpncmd環境に入れる
        - <span style="color: red; ">serverpasswordset</span>
        - UserCreate pomu /GROUP:none /REALNAME:none /NOTE:none
        - <span style="color: red; ">userpasswordset pomu</span>
        - <span style="color: red; ">SecureNatEnable</span>
        - exit

# vps鯖にてvpnclient確立
vpnserverと同じ要領でvpnclientの実行ファイルを取得し、言語を日本語にしよう
- sudo ./vpnclient/vpnclient start
- sudo ./vpnclient/vpncmd
    - 2を選ぶ
    - localhostをいじりたいので何も入力せずEnter
    - 以下vpncmd環境
        - NicCreate
        - AccountCreate
            - accountというのはつまり"接続設定"ということ
            - VPN server host name and port number: localhost:443
            - virtual hub name: DEFAULT
            - connecting user name: pomu
            - used virtual network adapter name: {ひとつ前のネストでniccreateをしたときに設定したnicの名前}
        - <span style="color: red; ">AccountPasswordSed</span>
        - AccountConnect
        - AccountList
            - 接続処理中やconnectingなどではなく接続完了になっているか確認する
        - exit
    - sudo ip addr show
    - sudo dhcpcd {明らかにvpnに関連ありそうなnicがあるはずなのでそれを書く}

# 自宅鯖にてvpnclient確立(前sectionとほぼ同じ)
vpnserverと同じ要領でvpnclientの実行ファイルを取得し、言語を日本語にしよう
- sudo ./vpnclient/vpnclient start
- sudo ./vpnclient/vpncmd
    - 2を選ぶ
    - localhostをいじりたいので何も入力せずEnter
    - 以下vpncmd環境
        - NicCreate
        - AccountCreate
            - accountというのはつまり"接続設定"ということ
            - VPN server host name and port number: <span style="color: red; ">{vps鯖のパブリックipアドレス(管理画面などで確認)}:443</span>
            - virtual hub name: DEFAULT
            - connecting user name: pomu
            - used virtual network adapter name: {ひとつ前のネストでniccreateをしたときに設定したnicの名前}
        - <span style="color: red; ">AccountPasswordSed</span>
        - AccountConnect
        - AccountList
            - 接続処理中やconnectingなどではなく接続完了になっているか確認する
        - exit
    - sudo ip addr show
    - sudo dhcpcd {明らかにvpnに関連ありそうなnicがあるはずなのでそれを書く}

# vps鯖にnginxをインストールしてreverseproxyに魔改造
依存関係は以下をダウンロードすれば大体いける<br>
$ sudo apt-get install build-essential	←基本的な開発環境<br>
$ sudo apt-get install libpcre3 libpcre3-dev	←Perl互換正規表現ライブラリ<br>
$ sudo apt-get install zlib1g zlib1g-dev	←圧縮転送に必要なzlibライブラリ<br>
$ sudo apt-get install openssl libssl-dev	←HTTPSに必要なOpenSSLライブラリ<br>
- wget http://nginx.org/download/nginx-1.21.6.tar.gz
- tar zxvf nginx-1.21.6.tar.gz
- cd nginx-1.21.6.tar.gz
- ./configure --with-stream --sbin-path=/usr/sbin/nginx --prefix=/etc/nginx
    - error出たら都度対応
- make && sudo make install
- vi /usr/lib/systemd/system/nginx.service
```
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/conf/nginx.conf
ExecStart=/usr/sbin/nginx -c /etc/nginx/conf/nginx.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
- sudo nginx -t
    - もしかしたらPATHが通ってない
    - export PATH=$PATH:/usr/sbin
- sudo rm /etc/nginx/conf/nginx.conf
- sudo vi /etc/nginx/conf/nginx.conf
```
worker_processes  1;

pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}
stream {
    upstream mcserver {
        server 192.168.30.10:25565;
    }
    server {
        listen     25565;
        proxy_pass mcserver;
    }
}
```
- sudo nginx -t
- sudo systemctl dawmon-reload
- sudo systemctl enable nginx
- sudo systemctl start nginx
- sudo systemctl status nginx
