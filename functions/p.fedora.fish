function p.fedora
    podman run -it --rm fedora:latest bash -c '\
    dnf -y -q upgrade && \
    dnf -y -q install bat eza nano git fish && \
    dnf -y -q install https://prerelease.keybase.io/keybase_amd64.rpm && \
    adduser core && \
    echo \'if [[ $- == *i* ]]
    then
        if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]
        then
            exec fish
        fi
    fi\' > /home/core/.bashrc
    su core \
    '
end
