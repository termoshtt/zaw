# zaw source for git branch

function zaw-src-git-branches() {
    : ${(A)candidates::=${${(f)"$(git show-ref | awk '{print $2}')"}#refs/(heads|remotes)/}}
    actions=(zaw-src-git-branches-checkout zaw-src-git-branches-delete)
    act_descriptions=("check out" "delete")
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
