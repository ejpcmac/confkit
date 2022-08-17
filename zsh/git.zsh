###############
# Git Aliases #
###############

alias gi='git init'
alias glgs='glg --show-signature'
alias glol="git log --graph --pretty=format:'%Cgreen%G?%Creset %C(yellow)%h%Creset - %s%C(auto)%d%Creset %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glola='glol --all'
alias gbv='git branch -vv'
alias gba='git branch -avv'
alias gfa='git fetch --all --prune --tag'
alias gmff='git merge --ff-only'
alias grbp='git rebase -p'
alias gwl='git worktree list'
alias gwa='git worktree add'
alias gwr='git worktree remove'
alias gwm='git worktree move'
alias gsa='git submodule add'
alias gli='git clean -dxn -e ".direnv/" -e "/config/"'
alias gclean='git clean -idx -e ".direnv/" -e "/config/"'

##
## GitHub CLI
##


# Setup
export HUB_PROTOCOL=https

# Aliases
alias hcl='hub clone --recurse-submodules'
alias hcr='hub create'
alias hf='hub fork'
alias hprl='hub pr list'
alias hprc='hub pr checkout'
alias hprs='hub pr show'
alias hprc='hub pull-request'
alias hr='hub release'
alias hrc='hub release create'
alias hre='hub release edit'
alias hci='hub ci-status'
alias hi='hub issue'
alias hic='hub issue create'

his() {
    hub issue show $@ | bat -l md
}
