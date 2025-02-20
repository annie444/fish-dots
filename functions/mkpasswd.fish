function mkpasswd
    podman run --rm -it --pull=newer \
        quay.io/coreos/mkpasswd:latest $argv
end
