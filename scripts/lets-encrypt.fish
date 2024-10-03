#! /usr/bin/env fish

set -g lego_version latest
set -g email ot8eyr6w@kuba86.com
set -g cf_dns_api_token /.lego/secrets/cf_dns_api_token
set -g cf_pooling_interval 60
set -g cf_propagation_timeout 300
set -g cf_ttl 120
set -g domains k86.dev k86.pl kuba86.com kuba86.dev kuba86.pl
set -g lets_encrypt_path /var/mnt/data1/lets-encrypt-goacme-lego
set -g caddy_path /var/mnt/data1/caddy
set -g cert_counter 0

echo mkdir -p $lets_encrypt_path/.lego/secrets
echo mkdir -p $caddy_path/tls/live

function renew
  for domain in $domains
    echo ------ $domain -------
    podman \
      run \
      --rm \
      --name=letsencrypt \
      --volume=$lets_encrypt_path/.lego:/.lego:z \
      --env=CF_DNS_API_TOKEN_FILE=$cf_dns_api_token \
      --env=CLOUDFLARE_POLLING_INTERVAL=$cf_pooling_interval \
      --env=CLOUDFLARE_PROPAGATION_TIMEOUT=$cf_propagation_timeout \
      --env=CLOUDFLARE_TTL=$cf_ttl \
      docker.io/goacme/lego:$lego_version \
        --accept-tos \
        --email=$email \
        --dns=cloudflare \
        --domains="$domain,*.$domain" \
          renew --no-random-sleep
    copy-certs $domain
  end
end

function check_if_modified_in_past_hour --argument-names file
  set last_modified (date -r "$file" +%s)
  set one_hour_ago (math (date +%s) - 3600)

  if test "$last_modified" -ge "$one_hour_ago"
    echo "The file was modified in the last hour. $file"
    return 0
  else
    echo "The file was not modified in the last hour. $file"
    return 1
  end
end

function copy-certs --argument-names domain
  check_if_modified_in_past_hour $lets_encrypt_path/.lego/certificates/$domain.crt
  switch $status
    case 0
      echo "The function copy-certs will execute."
      cp --update $lets_encrypt_path/.lego/certificates/$domain.crt $caddy_path/tls/live/$domain.crt
      cp --update $lets_encrypt_path/.lego/certificates/$domain.key $caddy_path/tls/live/$domain.key
      set cert_counter (math $cert_counter + 1)
      echo "cert_counter is $cert_counter"
    case '*'
      echo "The function copy-certs will NOT execute."
  end
end

function restart-caddy
  if test "$cert_counter" -gt 0
    echo "The environment variable cert_counter is larger than 0."
    podman exec caddy caddy reload --config /etc/caddy/Caddyfile
  else
    echo "The environment variable is not larger than 0."
  end
end

renew
restart-caddy
