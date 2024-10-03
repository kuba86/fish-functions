function hash_dir --description 'creates sha1 hash of a directory. Takes a single argument, the directory'
  find $argv[1] -type f -print0 | sort -zdf | xargs -0 sha1sum | awk '{print $1}' | sha1sum
end
