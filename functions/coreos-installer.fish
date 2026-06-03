function coreos-installer --description 'Run the `coreos-installer` command from the coreos container'
    set volumes -v "$(pwd):/data:rw"
    if test -d /dev
        set --append volumes -v "/dev:/dev"
    else
        echo "[coreos-installer] WARNING: The /dev directory doesn't exist. The CoreOS Installer might not work." >&2
    end
    if test -d /run/udev
        set --append volumes -v "/run/udev:/run/udev"
    else
        echo "[coreos-installer] WARNING: The /run/udev directory doesn't exist. The CoreOS Installer might not work." >&2
    end
    podman run --privileged --rm -it --pull=newer \
        $volumes -w /data \
        quay.io/coreos/coreos-installer:release $argv
end
