function p.alma
    podman run -it --rm almalinux:9 bash -c '\
    dnf -y -q upgrade && \
    dnf -y -q install "dnf-command(config-manager)" && \
    dnf config-manager --set-enabled crb && \
    dnf -y -q install epel-release epel-next-release && \
    dnf -y -q install nano bat eza && \
    dnf -y -q install https://prerelease.keybase.io/keybase_amd64.rpm && \
    curl -L -o fish https://github.com/mliszcz/fish-shell/releases/download/fish-3.7.0-x86_64/fish-3.7.0-x86_64.AppImage && \
    chmod +x fish && \
    adduser core && \
    echo \'if [[ $- == *i* ]]
    then
        if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]
        then
            exec /fish --appimage-extract-and-run
        fi
    fi\' > /home/core/.bashrc
    su core \
    '
end
