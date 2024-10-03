function l
  if sudo test -d $argv
    sudo eza --all --header --long --classify --octal-permissions --git --time-style long-iso $argv
  else if sudo test -f $argv
    sudo bat $argv
  else
    echo "'$argv' is not a directory or file"
  end
end
