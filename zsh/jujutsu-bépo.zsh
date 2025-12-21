########################################
# Jujutsu Aliases (optimised for bépo) #
########################################

alias t='jj'

# Init & clone
alias ti='jj git init --colocate'
alias tcl='jj git clone --colocate'

# Information
alias ts='jj status --no-pager'
alias tl='jj log --config ui.show-cryptographic-signatures=true'
alias tla='tl -r ::'
alias tll='tl -T builtin_log_detailed --stat'
alias tllp='tl -T builtin_log_detailed -s --patch'
alias tlla='tll -r ::'
alias tllap='tllp -r ::'
alias tlw='watch -n 1 --color jj log --color=always --config ui.show-cryptographic-signatures=true'
alias tlaw='tlw -r ::'
alias tllw='tlw -T builtin_log_detailed --stat'
alias tel='jj evolog --config ui.show-cryptographic-signatures=true'
alias telp='tel -s --patch'
alias telpw='watch -n 1 --color jj evolog --color=always -s --patch --config ui.show-cryptographic-signatures=true'
alias tol='jj operation log'
alias toll='tol --stat'
alias tolp='tol -s --patch'
alias tolpw='watch -n 1 --color jj operation log --color=always -s --patch'
alias tsh='jj show --config ui.show-cryptographic-signatures=true'
alias td='jj diff'
alias tdg='jj diff --git'

# Changes
alias tn='jj new'
alias tnm='jj new main'
alias tnd='jj new develop'
alias tns='jj new @-'
alias tnn='jj next --no-edit'
alias tnp='jj prev --no-edit'
alias tnb='jj new -B@'
alias tib='jj new -B@ && jj next --edit'
alias te='jj edit'
alias ten='jj next --edit'
alias tep='jj prev --edit'
alias trid='jj metaedit --update-change-id'
alias tsa='jj metaedit --author'
alias tsat='jj metaedit --author-timestamp'
alias trat='jj metaedit --update-author-timestamp'
alias tratp='trat @-'
alias tde='jj describe'
alias tdep='jj describe @-'
alias tdemsg='jj describe --message'
alias tdez='jj-z describe'
alias tdezp='jj-z "describe @-"'
alias tc='jj commit'
alias tcmsg='jj commit --message'
alias tcz='jj-z commit'
alias tsp='jj split'
alias tspm='jj split --tool meld'
alias tspz='jj-z split'
alias tsq='jj squash'
alias tsqi='jj squash -i'
alias tsqim='jj squash -i --tool meld'
alias tsqz='jj-z squash'
alias ta='jj absorb'
alias tdup='jj duplicate'
alias trb='jj rebase'
alias trbo='jj rebase -o'
alias trbc='jj rebase -r@ -o'
alias trs='jj resolve'
alias trst='jj restore'
alias tab='jj abandon'
alias tsi='jj sign'
alias tsip='tsi -r@-'
alias tsu='jj unsign'

# Bookmarks
alias tbl='jj bookmark list --no-pager'
alias tbla='jj bookmark list --all --no-pager'
alias tbc='jj bookmark create -r'
alias tbcc='jj bookmark create -r@'
alias tbcp='jj bookmark create -r@-'
alias tbs='jj bookmark set -r'
alias tbsc='jj bookmark set -r@'
alias tbsp='jj bookmark set -r@-'
alias tbsf='jj bookmark set --allow-backwards -r'
alias tbup='jj bookmark move --from "heads(::@- & bookmarks())" --to @-'
alias tbr='jj bookmark rename'
alias tbd='jj bookmark delete'
alias tbf='jj bookmark forget'
alias tbt='jj bookmark track'
alias tbu='jj bookmark untrack'

# Tags
alias ttl='jj tag list'
alias tts='jj tag set -r'
alias ttsc='jj tag set -r@'
alias ttsp='jj tag set -r@-'
alias ttd='jj tag delete'

# Workspaces
alias twl='jj workspace list'
alias twa='jj workspace add'
alias twr='jj workspace forget'
alias twmv='jj workspace rename'

# Remotes
alias tf='jj git fetch'
alias tfa='jj git fetch --all-remotes'
alias trl='jj git remote list'
alias tra='jj git remote add'
alias trrm='jj git remote remove'
alias trmv='jj git remote rename'
alias tp='jj git push'
alias tup='tbup && tp'
alias tpns='jj git push --config git.sign-on-push=false'
alias tpc='tp --change @-'
alias tpn='tp --allow-new --bookmark'
alias tpt='tp --tracked'
alias tpa='tp --all'
alias tpd='tp --deleted'

# Files
alias tft='jj file track'
alias tfu='jj file untrack'

# Misc
alias tu='jj undo'
alias trd='jj redo'
alias tdi="jj config set --repo 'revset-aliases.\"immutable_heads()\"' 'builtin_immutable_heads() | develop@origin'"

##
## Integration with git-z
##

__jj_closest_bookmarks() {
    local workflow=$1
    local direction=$2

    local base="@"
    if [[ "$workflow" == "squash" ]]; then
        base="@-"
    fi

    local revset="roots($base:: & bookmarks())"
    if [[ "$direction" == "prev" ]]; then
        revset="heads(::@ & bookmarks())"
    fi

    __jj log --no-graph -r "$revset" -T 'self.bookmarks()'
}

jj-z() {
    local bookmarks="$(__jj_closest_bookmarks edit next)"
    if [[ -z "$bookmarks" ]]; then
        bookmarks="$(__jj_closest_bookmarks squash next)"
    fi
    if [[ -z "$bookmarks" ]]; then
        bookmarks="$(__jj_closest_bookmarks squash prev)"
    fi

    git z commit \
        --topic "$bookmarks" \
        --command "sh -c \"\
            msg=\\\"\$(echo -n '\$message' | sed 's/^#\(.*\)/JJ:\1/')\\\"; \
            jj $@ --editor --message \\\"\$msg\\\"\" \
            "
}
