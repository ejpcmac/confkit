###############
# Git Aliases #
###############

alias gi='git init'
alias gdne='git diff --no-ext-diff'
alias gsh='git show --ext-diff'
alias glg='git log --stat'
alias glgp='glg --patch --ext-diff'
alias glgs='glg --show-signature'
alias glgps='glgp --show-signature'
alias glol="git log --graph --pretty=format:'%Cgreen%G?%Creset %C(yellow)%h%Creset - %s%C(auto)%d%Creset %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glola='glol --all'
alias gbv='git branch -vv'
alias gba='git branch -avv'
alias gfa='git fetch --all --prune --tag'
alias gmff='git merge --ff-only'
alias grbp='git rebase -p'
alias gfx='git fixup'
alias gwl='git worktree list'
alias gwa='git worktree add'
alias gwr='git worktree remove'
alias gwm='git worktree move'
alias gsa='git submodule add'
alias gli='git clean -dxn -e ".direnv/" -e "/config/"'
alias gclean='git clean -idx -e ".jj/" -e ".direnv/" -e "/config/"'

# Interactive rebase of the current branch.
grbim() {
    if [ -n "$1" ]; then
        base="$1"
    else
        base=develop
    fi

    git rebase -i $(git merge-base HEAD $base)
}

##
## git-z
##

alias gzi='git z init'
alias gzu='git z update'
alias gzc='git z commit'
