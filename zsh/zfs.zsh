###############
# ZFS Aliases #
###############

# zfs
alias z='zfs'
alias zl='zfs list -o name,used,available,referenced,usedbysnapshots,compressratio,mountpoint'
alias zl2='zfs list -o name,used,usedbysnapshots,readonly,compression,compressratio,quota,keystatus'
alias zls='zfs list -r -d 1 -t snapshot -o name,used,refer,compressratio'
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

# sudo operations
alias szm='sudo zfs mount'
alias szum='sudo zfs unmount'

# zpool
alias zp='zpool'
alias zpl='zpool list'
alias zps='zpool status'
alias zpg='zpool get'
alias zpst='zpool set'
