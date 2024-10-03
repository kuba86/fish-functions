function p.check;
  string repeat -n 50 -
  podman image ls
  string repeat -n 50 -
  podman container ls --all --size
  string repeat -n 50 -
  podman pod ls
  string repeat -n 50 -
  podman network ls
  string repeat -n 50 -
  podman system df
  string repeat -n 50 -
  podman volume ls
  string repeat -n 50 -
end
