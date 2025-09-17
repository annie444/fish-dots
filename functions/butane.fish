function butane --description 'Run the `butane` command from the coreos container'
    podman run --rm --pull=newer -it -v (pwd):/data:rw -w /data \
        quay.io/coreos/butane:latest $argv
end
