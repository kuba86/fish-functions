#! /usr/bin/env fish

argparse 'm/min=' 'd' 'v' 'op' 'ov'  -- $argv

set -l volumes

if test $_flag_d;
set --append volumes "--volume=/mnt/data1/syncthing/Kuba-media-download:/mnt/media/Kuba-media-download:ro,z";
end;

if test $_flag_v;
set --append volumes "--volume=/mnt/data1/syncthing/Kuba-media-videos:/mnt/media/Kuba-media-videos:ro,z";
end;

if test $_flag_op;
set --append volumes "--volume=/mnt/data1/syncthing/Kuba-media-other-photos:/mnt/trash/Kuba-media-other-photos:ro,z";
end;

if test $_flag_ov;
set --append volumes "--volume=/mnt/data1/syncthing/Kuba-media-other-videos:/mnt/trash/Kuba-media-other-videos:ro,z";
end;

# pull image to make sure it is the latest and not from cache
podman pull ghcr.io/kuba86/minidlna:latest

podman run \
-d --rm \
--name=minidlna-1.3.3 \
--net=host \
--userns=keep-id \
$volumes \
--env=MINIDLNA_MEDIA_DIR_1=/mnt/trash \
--env=MINIDLNA_MEDIA_DIR_2=/mnt/media \
--env=MINIDLNA_FRIENDLY_NAME=wyse01 \
--env=MINIDLNA_INOTIFY=yes \
--env=MINIDLNA_ROOT_CONTAINER=B \
ghcr.io/kuba86/minidlna:latest;

sleep (math 60 x $_flag_min);

podman container rm --force minidlna-1.3.3;