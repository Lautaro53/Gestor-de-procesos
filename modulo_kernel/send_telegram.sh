#!/bin/bash
TOKEN="8389227483:AAH8nG_kJ0Ql31-17ynvSzLU-NYBqEyV-58"
CHAT_ID="-1003403977612" 

MESSAGE="$1"

curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
     -d "chat_id=${CHAT_ID}" \
     -d "text=${MESSAGE}"
