#!/bin/bash

# https://qiita.com/PigeonsHouse/items/beca0b14974ca2a1d869
# https://dashboard.ngrok.com/get-started/setup/linux
docker compose up -d

nohup /opt/ngrok tcp 25565&

# 以下discord連携
DISCORD_BOT_TOKEN=OTU4NTQ1MTc5MzE5NjI3Nzk2.GeDTmj.Lwf-Lu9Kw68XyI6_pwRgXxZSw4UYjp_w246KUE
DISCORD_CHANNEL_ID=1209641606685134868
MESSAGE="サーバーが起動しました"

# メッセージ送信関数
function send_discord_message() {
  curl \
    -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bot $DISCORD_BOT_TOKEN" \
    -d "{\"content\": \"$MESSAGE\"}" \
    "https://discordapp.com/api/channels/$DISCORD_CHANNEL_ID/messages"
  }

# サーバー機動メッセージ送信
send_discord_message

# ngrokのURLを取得
# URLを取得,ただしjq以外の方法
address=$(curl -s http://localhost:4040/api/tunnels | sed -n 's/.*public_url":"\([^"]*\).*/\1/p')
# さらに頭のtcp://を削除
address=${address/tcp:\/\//}
# メッセージを送信
MESSAGE="サーバーのアドレスは $addressです"
send_discord_message
