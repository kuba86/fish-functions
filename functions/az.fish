function az
#  podman run -it --rm --volume=$HOME/.azure:/root/.azure:z --volume=$HOME/.kube:/root/.kube:z --volume=$HOME/.ssh:/root/.ssh:z localhost/az-kubelogin:latest az $argv
end
