function signal-api-send
  set -g from $(printf "%s" "$argv[1]" | jq -R -s -c)
  set -g to $(printf "%s" "$argv[2]" | jq -R -s -c)
  set -g string $(printf "%s" "$argv[3..]" | jq -R -s -c)
  set -g message $(string join '' '{"message":' $string ',"number":' $from ',"recipients":[' $to ']}')
  echo "signal-api-send from: $from"
  echo "signal-api-send to: $to"
  echo "signal-api-send string: $string"
  echo "signal-api-send message: $message"
  podman exec signal-api \
    curl \
    -X POST \
    -H "Content-Type: application/json" \
    "http://localhost:8080/v2/send" \
    -d $message
end
