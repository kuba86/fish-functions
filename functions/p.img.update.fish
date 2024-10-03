#! /usr/bin/env fish

function p.img.update
  set podman_images (podman image list --format "{{.Repository}}:{{.Tag}}" | grep -e docker.io -e quay.io -e registry.fedoraproject.org)

  for img in $podman_images
      podman pull $img
  end
end



