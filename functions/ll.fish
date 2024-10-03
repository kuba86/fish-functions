function ll
  if test -d $argv
    eza --all --header --long --classify --octal-permissions --git --time-style long-iso $argv
  else if test -f $argv
    bat $argv
  else
    echo "'$argv' is not a directory or file"
  end
end
