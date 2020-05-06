###############
# ZFS Aliases #
###############

# zfs
alias z='zfs'
alias zl='zfs list -o name,used,available,referenced,usedbysnapshots,compressratio,mountpoint'
alias zl2='zfs list -o name,used,usedbysnapshots,quota,compression,compressratio,recordsize,readonly,exec,setuid,devices,mounted,keystatus'
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

# zfs watch operations
alias wzl='watch -n 1 zfs list -o name,used,available,referenced,usedbysnapshots,compressratio,mountpoint'
alias wzl2='watch -n 1 zfs list -o name,used,usedbysnapshots,quota,compression,compressratio,recordsize,readonly,exec,setuid,devices,mounted,keystatus'
alias wzls='watch -n 1 zfs list -r -d 1 -t snapshot -o name,used,refer,compressratio'

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

# zpool
alias zp='zpool'
alias zpl='zpool list'
alias zps='zpool status'
alias zpi='zpool import'
alias zpe='zpool export'
alias zpc='zpool create'
alias zpcc='zpool create -o ashift=12 -O acltype=posixacl -O atime=off -O checksum=sha512 -O compression=lz4 -O dnodesize=auto -O normalization=formD -O reservation=1G -O xattr=sa'
alias zpd='zpool destroy'
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
alias szpcc='sudo zpool create -o ashift=12 -O acltype=posixacl -O atime=off -O checksum=sha512 -O compression=lz4 -O dnodesize=auto -O normalization=formD -O reservation=1G -O xattr=sa'
alias szpd='sudo zpool destroy'
alias szpst='sudo zpool set'
alias szpsc='sudo zpool scrub'
