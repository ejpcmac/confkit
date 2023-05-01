################################################################################
##                                                                            ##
##                    User declaration for root@nixos-host                    ##
##                                                                            ##
################################################################################

{ inputs, ... }:

{
  users.users.root = {
    # Password: root
    # Use `mkpasswd -m SHA-512` to generate a new password hash.
    hashedPassword = "$6$10ANBznle.bUMU$ex8BpjzUzYQKiOX5cYVT0v4NoPujGza0oPQEqZv.WQguj9p8MAOfiXiFkBkiY1Wt9ePe3fA4J3jw4KjG.pwDH1";
  };

  home-manager.users.root = inputs.confkit.nixosModules.home-config-root;
}
