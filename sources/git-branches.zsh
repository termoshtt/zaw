# zaw source for git branch

function zaw-src-git-branches() {
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
	: ${(A)candidates::=${${(f)"$(git show-ref | awk '{ print $2}' |sed '/^\/refs\/stash/d')"}#refs/(heads|remotes|tags)/}}
    fi
    actions=(zaw-src-git-branches-checkout zaw-src-git-branches-create zaw-src-git-branches-delete)
    act_descriptions=("check out" "create new branch from..." "delete")
    options=(-n)
}

function zaw-src-git-branches-checkout () {
    local base=$(basename $1)
    if [[ "$base" == "$1" ]]; then
        BUFFER="git checkout $1"
        zle accept-line
    else
        BUFFER="git checkout -t $1"
        zle accept-line
    fi
}

function zaw-src-git-branches-create () {
    LBUFFER="git checkout -b "
    RBUFFER=" $1"
}

function zaw-src-git-branches-delete () {
    local base=$(basename $1)
    local orig=$(dirname $1)
    if [[ "$base" == "$1" ]]; then
        BUFFER="git branch -d $1"
        zle accept-line
    else
        BUFFER="git push $orig :$base"
        zle accept-line
    fi
}

zaw-register-src -n git-branches zaw-src-git-branches
