function cdl
  cd $argv
  sudo eza --all --header --long --classify --octal-permissions --git --time-style long-iso
end
