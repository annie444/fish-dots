function asdf-install -a package -a ver -a pkg_cmd
    if set -q asdf_install_retries
        if test $asdf_install_retries -gt 3
            fish-log error "Failed to install $package after $asdf_install_retries attempts"
            set --erase asdf_install_retries
            return
        else
            set -g asdf_install_retries (math $asdf_install_retries + 1)
        end
    else
        set -gx asdf_install_retries 1
    end
    log-cmd asdf plugin add $package
    log-cmd asdf install $package $ver
    log-cmd asdf set --home $package $ver
    asdf reshim
    set package_path (asdf which "$pkg_cmd")
    fish-log trace "Package $package is at path $package_path"
    if not test -e "$package_path"
        for v in (asdf list $package)
            set local_ver (echo $v | sed -e 's/*//')
            log-cmd asdf uninstall $package $local_ver
        end
        asdf reshim
        asdf_install $package $ver $pkg_cmd
    end
    set --erase asdf_install_retries
end
