function yubipgp
  sudo systemctl restart pcscd.service
  gpg --card-status
end
