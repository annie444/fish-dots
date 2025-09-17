function ignition-validate --description 'Run the `ignition-validate` command from the coreos container'
    podman run --rm --pull=newer -it -v (pwd):/data:rw -w /data \
        quay.io/coreos/ignition-validate:latest $argv
end
