# Contributing to confkit

## Setup

### Local repository

1. Fork the repository

2. Clone your fork to a local repository:

        $ git clone https://github.com/you/confkit.git
        $ cd confkit

3. Add the main repository as a remote:

        $ git remote add upstream https://github.com/ejpcmac/confkit.git

## Workflow

To make a change, please use this workflow:

1. Select the base branch:

    * `stable-<version>` if there is no breaking change,
    * `develop-<version>` if you plan to introduce a breaking change.

2. Checkout the selected branch and apply the last upstream changes (use rebase,
    not merge!). For instance, if the branch is `develop-24.11`:

        $ git checkout develop-24.11
        $ git fetch --all --prune
        $ git rebase upstream/develop-24.11

3. Create a new branch with an explicit name:

        $ git checkout -b <my-branch>

4. Work on your feature:

        # Some work
        $ git commit -am "feat: add something"
        # Some work
        $ git commit -am "refactor: change something"
        ...

5. When your feature is ready, feel free to use
    [interactive rebase](https://help.github.com/articles/about-git-rebase/) so
    your history looks clean and is easy to follow. Then, apply the last
    upstream changes on the selected branch to prepare integration:

        $ git checkout develop-24.11
        $ git fetch --all --prune
        $ git rebase upstream/develop-24.11

5. If there were commits on the base branch since the beginning of your feature
    branch, integrate them by **rebasing** if your branch has few commits, or
    merging if you had a long-lived branch:

        $ git checkout <my-branch>
        $ git rebase develop-24.11

    *Note: the only case you should merge is when you are working on a big
    feature. If it is the case, we should have discussed this before as stated
    above.*

6. Open a pull request to merge your branch into the branch you have selected on
    the main repository (i.e. `develop-24.11` in the example).

## Coding style

Please format your code with `nixpkgs-fmt`.

## Commit style

This project uses [Conventional
Commits](https://www.conventionalcommits.org/en/v1.0.0/). Please follow these
rules when naming your commits.
