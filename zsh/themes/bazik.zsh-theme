###################
# Bazik Zsh theme #
###################

setopt prompt_subst
autoload -U colors && colors

##
## Left prompt with contextual colours
##

prompt_color() {
    local color_root="$fg_bold[red]"
    local color_nix="$fg_bold[blue]"
    local color_normal="$fg_bold[green]"

    if [ $(id -u) -eq 0 ]; then
        echo "$fg_bold[red]"
    elif [ -n "$IN_NIX_SHELL" ]; then
        echo "$fg_bold[blue]"
    else
        echo "$fg_bold[green]"
    fi
}

PROMPT='%{$(prompt_color)%}[%n@%M]:%{$reset_color%}%~ %# '

##
## Right prompt with VCS info and the clock.
##

# Modify the colors and symbols in these variables as desired.
VCS_PROMPT_SYMBOL="%{$fg[blue]%}±"
VCS_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
VCS_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
VCS_PROMPT_EMPTY_COLOR="%{$fg[green]%}"
VCS_PROMPT_NONEMPTY_COLOR="%{$fg[magenta]%}"
VCS_PROMPT_PROBLEM_COLOR="%{$fg[red]%}"
VCS_PROMPT_EDIT_COLOR="%{$fg[blue]%}"
VCS_PROMPT_SQUASH_COLOR="%{$fg[green]%}"
VCS_PROMPT_STALE_COLOR="%{$fg[yellow]%}"
VCS_PROMPT_CONFLICT_MARKER="%{$fg[magenta]%}⚡︎%{$reset_color%}"
VCS_PROMPT_UNTRACKED_MARKER="%{$fg[red]%}●%{$reset_color%}"
VCS_PROMPT_MODIFIED_MARKER="%{$fg[yellow]%}●%{$reset_color%}"
VCS_PROMPT_STAGED_MARKER="%{$fg[green]%}●%{$reset_color%}"
VCS_PROMPT_AHEAD="%{$fg[red]%}↑NUM%{$reset_color%}"
VCS_PROMPT_BEHIND="%{$fg[cyan]%}↓NUM%{$reset_color%}"

##
## Jujutsu info
##

__jj() {
    jj --no-pager "$@" 2> /dev/null
}

# Shows current change ID with empty / non-empty / problem color info.
__jj_change() {
    local template="
        if(self.conflict(), '$VCS_PROMPT_CONFLICT_MARKER')
        ++ if(self.conflict() || self.divergent(),
            '$VCS_PROMPT_PROBLEM_COLOR',
            if(self.empty(),
                '$VCS_PROMPT_EMPTY_COLOR',
                '$VCS_PROMPT_NONEMPTY_COLOR'))
        ++ self.change_id().shortest(3)
        ++ if(self.divergent(), '??')
    "

    local change=$(__jj log --no-graph -r @ -T "$template")
    [[ -n $change ]] && echo "$VCS_PROMPT_PREFIX$change$VCS_PROMPT_SUFFIX"
}

# Gets the closest commit with a bookmark in a given workflow and direction.
__jj_closest_commit_with_bookmark() {
    local workflow=$1
    local direction=$2

    local base="@"
    if [[ $workflow == "squash" ]]; then
        base="@-"
    fi

    local revset="roots($base:: & bookmarks())"
    if [[ $direction == "prev" ]]; then
        revset="heads(::@ & bookmarks())"
    fi

    __jj log --limit 1 --no-graph -r "$revset" -T 'self.commit_id()'
}

# Gets the distance to a commit in the given direction.
__jj_distance_to_commit() {
    local change=$1
    local direction=$2

    if [[ $direction == "prev" ]]; then
        local sign="+"
        local revset="$change..@"
    else
        local sign="-"
        local revset="@..$change"
    fi

    local distance=$(
        __jj log --no-graph -r "$revset" -T 'self.commit_id() ++ "\n"' | wc -l
    )

    echo $sign$distance
}

# Shows the closest bookmark with edit / squash / stale color info.
__jj_bookmark() {
    local workflow="edit"
    local direction="next"
    local commit_with_bookmark="$(__jj_closest_commit_with_bookmark edit next)"

    if [[ -z $commit_with_bookmark ]]; then
        workflow="squash"
        commit_with_bookmark="$(__jj_closest_commit_with_bookmark squash next)"
    fi

    if [[ -z $commit_with_bookmark ]]; then
        direction="prev"
        commit_with_bookmark="$(__jj_closest_commit_with_bookmark squash prev)"
    fi

    if [[ -z $commit_with_bookmark ]]; then
        return
    fi

    local dist=$(__jj_distance_to_commit $commit_with_bookmark $direction)

    local color=""
    local symbol=" $dist"

    if [[ $workflow == "edit" ]]; then
        color="$VCS_PROMPT_EDIT_COLOR"
        if [[ $dist -eq 0 ]]; then
            symbol=" @"
        fi
    elif [[ $dist -le 0 ]]; then
        color="$VCS_PROMPT_SQUASH_COLOR"
        if [[ $dist -eq 0 ]]; then
            symbol=""
        fi
    else
        symbol=" +$(($dist-1))"
        color="$VCS_PROMPT_STALE_COLOR"
    fi

    local bookmarks=$(
        __jj log --no-graph -r "$commit_with_bookmark" -T 'self.bookmarks()'
    )

    echo "$VCS_PROMPT_PREFIX$color$bookmarks$symbol%{$reset_color%}$VCS_PROMPT_SUFFIX"
}

# Shows the remote status.
__jj_remote_status() {
    local bookmark=$(
        __jj log --no-graph \
            -r 'heads(::@ & bookmarks())' \
            -T 'self.bookmarks().map(|b| b.name())'
    )

    [[ -z $bookmark ]] && return

    local ahead=$(
        __jj bookmark list $bookmark -T '
            if(self.tracked(),
                self.tracking_behind_count().lower()
                ++ if(!self.tracking_behind_count().upper(), "+"))
            '
    )

    local behind=$(
        __jj bookmark list $bookmark -T '
            if(self.tracked(),
                self.tracking_ahead_count().lower()
                ++ if(!self.tracking_ahead_count().upper(), "+"))
            '
    )

    local remote_status=""

    if [[ $ahead != "" && $ahead != 0 ]]; then
        remote_status=$remote_status${VCS_PROMPT_AHEAD//NUM/$ahead}
    fi

    if [[ $behind != "" && $behind != 0 ]]; then
        remote_status=$remote_status${VCS_PROMPT_BEHIND//NUM/$behind}
    fi

    if [[ -n $remote_status ]]; then
        echo "$VCS_PROMPT_PREFIX$remote_status$VCS_PROMPT_SUFFIX"
    fi
}

# Shows change / bookmark / remote information if inside a Jujutsu repo.
__jj_prompt() {
    local info="$(__jj_change)$(__jj_bookmark)$(__jj_remote_status)"
    [[ -n $info ]] && echo "$VCS_PROMPT_SYMBOL$info "
}

##
## Git info
##
## (Adapted from code found at https://gist.github.com/joshdick/4415470.)
##

# Shows Git branch/tag, or name-rev if on detached head.
__git_branch() {
    (
        git symbolic-ref -q HEAD \
        || git name-rev --name-only --no-undefined --always HEAD \
    ) 2> /dev/null
}

# Shows the git remote status.
__git_remote_status() {
    local remote_status=""

    local ahead="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [[ $ahead -gt 0 ]]; then
        remote_status=$remote_status${VCS_PROMPT_AHEAD//NUM/$ahead}
    fi

    local behind="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [[ $behind -gt 0 ]]; then
        remote_status=$remote_status${VCS_PROMPT_BEHIND//NUM/$behind}
    fi

    if [[ -n $remote_status ]]; then
        echo "$VCS_PROMPT_PREFIX$remote_status$VCS_PROMPT_SUFFIX"
    fi
}

# Shows the Git working copy untracked / modified / staged / conflict status.
__git_status() {
    local git_state=""

    local git_dir="$(git rev-parse --git-dir 2> /dev/null)"
    if [[ -n "$git_dir" ]] && test -r "$git_dir/MERGE_HEAD"; then
        git_state=$GIT_STATE$VCS_PROMPT_CONFLICT_MARKER
    fi

    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        git_state=$GIT_STATE$VCS_PROMPT_UNTRACKED_MARKER
    fi

    if ! git diff --quiet 2> /dev/null; then
        git_state=$GIT_STATE$VCS_PROMPT_MODIFIED_MARKER
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
        git_state=$GIT_STATE$VCS_PROMPT_STAGED_MARKER
    fi

    if [[ -n $git_state ]]; then
        echo "$VCS_PROMPT_PREFIX$git_state$VCS_PROMPT_SUFFIX"
    fi
}

# Shows the status, remote and branch information if inside a Git repo.
__git_prompt() {
    local git_where="$(__git_branch)"
    if [[ -n $git_where ]]; then
        echo "$VCS_PROMPT_SYMBOL$(__git_status)$VCS_PROMPT_PREFIX%{$fg[green]%}${git_where#(refs/heads/|tags/)}$VCS_PROMPT_SUFFIX$(__git_remote_status) "
    fi
}

##
## Complete prompt & async registration
##

vcs_prompt() {
    __jj_prompt || __git_prompt
}

vcs_prompt_async() {
    echo -n $_OMZ_ASYNC_OUTPUT[vcs_prompt]
}

clock() {
    echo "%{$fg[cyan]%}[%D{%H:%M:%S}]%{$reset_color%}"
}

_omz_register_handler vcs_prompt

# Set the right-hand prompt
RPROMPT='$(vcs_prompt_async)$(clock)'
