#!/bin/bash
# https://qiita.com/PigeonsHouse/items/beca0b14974ca2a1d869

skip_docker_compose=false
skip_discord_message=false
skip_logs=false

# オプションの処理
while getopts "cdl" opt; do
  case $opt in
    c)
      skip_docker_compose=true
      ;;
    d)
      skip_discord_message=true
      ;;
    l)
      skip_logs=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# vpsとvpnで接続
sudo ./vps鯖用/vpnclient/vpnclient start # vpncmdでaccountstartupsetを設定していること！
sudo dhcpcd vpn_aws

# Docker Composeをバックグラウンドで起動
if [ "$skip_docker_compose" = false ]; then
  docker compose up -d
fi

# Docker Composeのログを表示し続ける
if [ "$skip_logs" = false ]; then
  docker compose logs -f &
fi

# Discordへのメッセージ送信関数
function send_discord_message() {
  if [ "$skip_discord_message" = true ]; then
    return
  fi
  curl \
    -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bot $DISCORD_BOT_TOKEN" \
    -d "{\"content\": \"$MESSAGE\"}" \
    "https://discordapp.com/api/channels/$DISCORD_CHANNEL_ID/messages"
}

# サーバー起動メッセージ送信
source ./.env
MESSAGE="サーバーが起動しました"
send_discord_message

# hostname -IでIPアドレスを取得
address=$(hostname -I | cut -d ' ' -f 1)
MESSAGE="ローカルネットワークのアドレスは $address です"
send_discord_message
