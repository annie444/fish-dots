function butane
    podman run --rm --pull=newer -it -v (pwd):/data:rw -w /data \
        quay.io/coreos/coreos-installer:release $argv
end
