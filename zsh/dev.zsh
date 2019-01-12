##########################
# Aliases for developers #
##########################

# PostgreSQL (for use with Nix)
alias pgst='pg_ctl -l "$PGDATA/server.log" start'
alias pgsp='pg_ctl stop'
alias pgswitch='killall postgres && pgst'
