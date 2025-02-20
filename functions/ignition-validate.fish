function ignition-validate
    podman run --rm --pull=newer -it -v (pwd):/data:rw -w /data \
        quay.io/coreos/ignition-validate:latest $argv
end
