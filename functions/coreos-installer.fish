function coreos-installer --description 'Run the `coreos-installer` command from the coreos container'
    podman run --privileged --rm -it --pull=newer \
        -v /dev:/dev -v /run/udev:/run/udev -v (pwd):/data:rw -w /data \
        quay.io/coreos/coreos-installer:release $argv
end
