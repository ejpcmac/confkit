###################
# Jujutsu Aliases #
###################

alias j='jj'

# Init & clone
alias ji='jj git init --colocate'
alias jcl='jj git clone --colocate'

# Information
alias js='jj status --no-pager'
alias jl='jj log --config ui.show-cryptographic-signatures=true'
alias jla='jl -r ::'
alias jll='jl -T builtin_log_detailed --stat'
alias jllp='jl -T builtin_log_detailed -s --patch'
alias jlla='jll -r ::'
alias jllap='jllp -r ::'
alias jlw='watch -n 1 --color jj log --color=always --config ui.show-cryptographic-signatures=true'
alias jlaw='jlw -r ::'
alias jllw='jlw -T builtin_log_detailed --stat'
alias jel='jj evolog --config ui.show-cryptographic-signatures=true'
alias jelp='jel -s --patch'
alias jelpw='watch -n 1 --color jj evolog --color=always -s --patch --config ui.show-cryptographic-signatures=true'
alias jol='jj operation log'
alias joll='jol --stat'
alias jolp='jol -s --patch'
alias jolpw='watch -n 1 --color jj operation log --color=always -s --patch'
alias jsh='jj show --config ui.show-cryptographic-signatures=true'
alias jd='jj diff'
alias jdg='jj diff --git'

# Changes
alias jn='jj new'
alias jnm='jj new main'
alias jnd='jj new develop'
alias jns='jj new @-'
alias jnn='jj next --no-edit'
alias jnp='jj prev --no-edit'
alias jnb='jj new -B@'
alias jib='jj new -B@ && jj next --edit'
alias je='jj edit'
alias jen='jj next --edit'
alias jep='jj prev --edit'
alias jrid='jj metaedit --update-change-id'
alias jsa='jj metaedit --author'
alias jsat='jj metaedit --author-timestamp'
alias jrat='jj metaedit --update-author-timestamp'
alias jratp='jrat @-'
alias jde='jj describe'
alias jdep='jj describe @-'
alias jdemsg='jj describe --message'
alias jdez='jj-z describe'
alias jdezp='jj-z describe @-'
alias jc='jj commit'
alias jcmsg='jj commit --message'
alias jcz='jj-z commit'
alias jsp='jj split'
alias jspm='jj split --tool meld'
alias jspz='jj-z split'
alias jsq='jj squash'
alias jsqi='jj squash -i'
alias jsqim='jj squash -i --tool meld'
alias jsqz='jj-z squash'
alias ja='jj absorb'
alias jdup='jj duplicate'
alias jrb='jj rebase'
alias jrbd='jj rebase -o'
alias jrbc='jj rebase -r@ -o'
alias jrs='jj resolve'
alias jrst='jj restore'
alias jab='jj abandon'
alias jsi='jj sign'
alias jsip='jsi -r@-'
alias jsu='jj unsign'

# Bookmarks
alias jbl='jj bookmark list --no-pager'
alias jbla='jj bookmark list --all --no-pager'
alias jbc='jj bookmark create -r'
alias jbcc='jj bookmark create -r@'
alias jbcp='jj bookmark create -r@-'
alias jbs='jj bookmark set -r'
alias jbsc='jj bookmark set -r@'
alias jbsp='jj bookmark set -r@-'
alias jbsf='jj bookmark set --allow-backwards -r'
alias jbup='jj bookmark move --from "heads(::@- & bookmarks())" --to @-'
alias jbr='jj bookmark rename'
alias jbd='jj bookmark delete'
alias jbf='jj bookmark forget'
alias jbt='jj bookmark track'
alias jbu='jj bookmark untrack'

# Tags
alias jtl='jj tag list'
alias jts='jj tag set -r'
alias jtsc='jj tag set -r@'
alias jtsp='jj tag set -r@-'
alias jtd='jj tag delete'

# Workspaces
alias jwl='jj workspace list'
alias jwa='jj workspace add'
alias jwr='jj workspace forget'
alias jwmv='jj workspace rename'

# Remotes
alias jf='jj git fetch'
alias jfa='jj git fetch --all-remotes'
alias jrl='jj git remote list'
alias jra='jj git remote add'
alias jrrm='jj git remote remove'
alias jrmv='jj git remote rename'
alias jp='jj git push'
alias jup='jbup && tp'
alias jpns='jj git push --config git.sign-on-push=false'
alias jpc='jp --change @-'
alias jpn='jp --allow-new --bookmark'
alias jpt='jp --tracked'
alias jpa='jp --all'
alias jpd='jp --deleted'

# Files
alias jft='jj file track'
alias jfu='jj file untrack'

# Misc
alias ju='jj undo'
alias jrd='jj redo'
alias jdi="jj config set --repo 'revset-aliases.\"immutable_heads()\"' 'builtin_immutable_heads() | develop@origin'"

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
