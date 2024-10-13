function signal-api-send
  argparse 'from=' 'to=' 'msg=' -- $argv
  or return

  if not set -q _flag_from || not set -q _flag_to || not set -q _flag_msg
      echo "ERROR: some flag were not set. from= to= msg= are required"
      return 1
  end

  set -g json $(string join '' '{"message":' $_flag_msg ',"number":' $_flag_from ',"recipients":[' $_flag_to ']}')

  echo "signal-api-send from: $_flag_from"
  echo "signal-api-send to: $_flag_to"
  echo "signal-api-send msg: $_flag_msg"
  echo "signal-api-send remaining argv: $argv"
  echo "signal-api-send json: $json"

  podman exec signal-api \
    curl \
    -X POST \
    -H "Content-Type: application/json" \
    "http://localhost:8080/v2/send" \
    -d $json
end
