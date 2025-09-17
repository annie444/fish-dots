function mkpasswd --description 'Generate a hashed password using mkpasswd from the coreos container'
    podman run --rm -it --pull=newer \
        quay.io/coreos/mkpasswd:latest $argv
end
