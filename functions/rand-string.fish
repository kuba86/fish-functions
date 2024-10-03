function rand-string
  strings /dev/urandom | grep -o '[0-9a-zA-Z]' | head -n $argv[1] | tr -d '\n'; echo
end
