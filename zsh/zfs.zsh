###############
# ZFS Aliases #
###############

# zfs
alias z='zfs'
alias zl='zfs list -o name,used,available,referenced,usedbysnapshots,compressratio,mountpoint'
alias zl2='zfs list -o name,usedbydataset,usedbysnapshots,compression,compressratio,recordsize,readonly,exec,setuid,canmount,mounted,keystatus'
alias zl3='zfs list -o name,available,used,usedbydataset,usedbysnapshots,com.sun:auto-snapshot,compression,compressratio,recordsize,readonly,exec,setuid,canmount,mounted,mountpoint'
alias zlsp='zfs list -o space'
alias zlas='zfs list -o name,usedbydataset,usedbysnapshots,com.sun:auto-snapshot,readonly'
alias zls='zfs list -r -d 1 -t snapshot -o name,used,refer,compressratio'
alias zlb='zfs list -r -d 1 -t bookmark -o name,refer'
alias zc='zfs create'
alias zs='zfs snapshot'
alias zsr='zfs snapshot -r'
alias zd='zfs destroy'
alias zmv='zfs rename'
alias zg='zfs get'
alias zst='zfs set'
alias zih='zfs inherit'
alias zm='zfs mount'
alias zum='zfs unmount'
alias zlk='zfs load-key'
alias zulk='zfs unload-key'

# zfs watch operations
alias wzl='watch -n 1 zfs list -o name,used,available,referenced,usedbysnapshots,compressratio,mountpoint'
alias wzl2='watch -n 1 zfs list -o name,usedbydataset,usedbysnapshots,compression,compressratio,recordsize,readonly,exec,setuid,canmount,mounted,keystatus'
alias wzl3='watch -n 1 zfs list -o name,available,used,usedbydataset,usedbysnapshots,com.sun:auto-snapshot,compression,compressratio,recordsize,readonly,exec,setuid,canmount,mounted,mountpoint'
alias wzlsp='watch -n 1 zfs list -o space'
alias wzlas='zfs list -o name,usedbydataset,usedbysnapshots,com.sun:auto-snapshot,readonly'
alias wzls='watch -n 1 zfs list -r -d 1 -t snapshot -o name,used,refer,compressratio'
alias wzlb='watch -n 1 zfs list -r -d 1 -t bookmark -o name,refer'

# zfs sudo operations
alias szc='sudo zfs create'
alias szs='sudo zfs snapshot'
alias szsr='sudo zfs snapshot -r'
alias szd='sudo zfs destroy'
alias szmv='sudo zfs rename'
alias szst='sudo zfs set'
alias szih='sudo zfs inherit'
alias szm='sudo zfs mount'
alias szum='sudo zfs unmount'
alias szlk='sudo zfs load-key'
alias szulk='sudo zfs unload-key'

# Helpers to work from within the current file system
alias pwz='zfs list -Ho name,mountpoint | grep -e "\s$(pwd)$" | cut -f 1'
alias zlc='zl -r $(pwz)'
alias zl2c='zl2 -r $(pwz)'
alias zl3c='zl3 -r $(pwz)'
alias zlspc='zlsp -r $(pwz)'
alias zlasc='zlas -r $(pwz)'
alias zlsc='zls $(pwz)'
alias zgac='zfs get all $(pwz)'
alias zcc='zfs-create-current'
alias zccnm='zcc -o canmount=off'
alias zccnb='zcc -o com.sun:auto-snapshot=false -o syncoid:sync=false'
alias zdc='zfs-destroy-current'
alias zmvc='zfs-rename-current'
alias ctz='convert-to-zfs'

zfs-create-current() {
    if [ $# -lt 1 ]; then
        echo "usage: zfs-create-current [options] <fs>"
        return 1
    fi

    local options=(${@: 1:-1})
    local fs=${@: -1}
    local current_fs="$(pwz)"

    if [[ "$current_fs" == "" ]]; then
        echo "error: cannot find current filesystem"
        return 1
    fi

    echo "will create $current_fs/$fs"
    sudo zfs create $options $current_fs/$fs &&
    sudo chown $UID:$GID $fs 2>/dev/null
}

zfs-destroy-current() {
    if [ $# -ne 1 ]; then
        echo "usage: zfs-destroy-current <fs>"
        return 1
    fi

    local fs=$1
    local current_fs="$(pwz)"

    if [[ "$current_fs" == "" ]]; then
        echo "error: cannot find current filesystem"
        return 1
    fi

    zfs destroy -rvn $current_fs/$fs
    echo
    read "continue?Do you really want to destroy the mentioned file systems (y/n)? "
    if [[ "$continue" == "y" ]]; then
        sudo zfs destroy -rv $current_fs/$fs
    else
        echo "Aborting"
    fi
}

zfs-rename-current() {
    if [ $# -ne 2 ]; then
        echo "usage: zfs-rename-current <old> <new>"
        return 1
    fi

    local old=$1
    local new=$2
    local current_fs="$(pwz)"

    if [[ "$current_fs" == "" ]]; then
        echo "error: cannot find current filesystem"
        return 1
    fi

    echo "will rename $current_fs/$old to $current_fs/$new"
    sudo zfs rename $current_fs/$old $current_fs/$new
}

convert-to-zfs() {
    if [ $# -lt 1 ]; then
        echo "usage: convert-to-zfs [create-options] <dir>"
        return 1
    fi

    local options=(${@: 1:-1})
    local dir=${@: -1}
    local current_fs="$(pwz)"

    if [[ "$current_fs" == "" ]]; then
        echo "error: cannot find current filesystem"
        return 1
    fi

    echo "will convert $current_fs/$dir to a ZFS filesystem"
    sudo echo &&
    mv $dir __$dir &&
    sudo zfs create $options $current_fs/$dir &&
    sudo chown $UID:$GID $dir &&
    rsync -a __$dir/ $dir/ &&
    rm -rf __$dir
}

# zpool
alias zp='zpool'
alias zpl='zpool list'
alias zps='zpool status'
alias zpi='zpool import'
alias zpe='zpool export'
alias zpc='zpool create'
alias zpcc='zpool create -o ashift=12 -O acltype=posixacl -O atime=off -O checksum=sha512 -O compression=zstd -O dnodesize=auto -O normalization=formD -O reservation=1G -O xattr=sa'
alias zpd='zpool destroy'
alias zpp='zpool checkpoint'
alias zppd='zpool checkpoint -d'
alias zpg='zpool get'
alias zpst='zpool set'
alias zpsc='zpool scrub'

# zpool watch operations
alias wzpl='watch -n 1 zpool list'
alias wzps='watch -n 1 zpool status'

# zpool sudo operations
alias szpi='sudo zpool import'
alias szpe='sudo zpool export'
alias szpc='sudo zpool create'
alias szpcc='sudo zpool create -o ashift=12 -O acltype=posixacl -O atime=off -O checksum=sha512 -O compression=zstd -O dnodesize=auto -O normalization=formD -O reservation=1G -O xattr=sa'
alias szpd='sudo zpool destroy'
alias szpp='sudo zpool checkpoint'
alias szppd='sudo zpool checkpoint -d'
alias szpst='sudo zpool set'
alias szpsc='sudo zpool scrub'
