function signal-api-send
  argparse 'from=' 'to=' 'msg=' -- $argv
  or return

  set -g from $(printf "%s" "$_flag_from" | jq -R -s -c)
  set -g to $(printf "%s" "$_flag_to" | jq -R -s -c)
  set -g msg $(printf "%s" "$_flag_msg" | jq -R -s -c)

  if not set -q _flag_from || not set -q _flag_to || not set -q _flag_msg
      echo "ERROR: some flag were not set. from= to= msg= are required"
      return 1
  end

  set -g json $(string join '' '{"message":' $msg ',"number":' $from ',"recipients":[' $to ']}')

  echo "signal-api-send from: $from"
  echo "signal-api-send to: $to"
  echo "signal-api-send msg: $msg"
  echo "signal-api-send remaining argv: $argv"
  echo "signal-api-send json: $json"

  podman exec signal-api \
    curl --silent \
    -X POST \
    -H "Content-Type: application/json" \
    "http://localhost:8080/v2/send" \
    -d $json
end
