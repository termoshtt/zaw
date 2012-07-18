# zaw source for git branch

function zaw-src-git-branches() {
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        : ${(A)candidates::=${${(f)"$(git show-ref | awk '{print $2}')"}#refs/}}
    fi
    actions=(zaw-src-git-branches-checkout zaw-src-git-branches-create zaw-src-git-branches-delete)
    act_descriptions=("check out" "create new branch from..." "delete")
    options=(-n)
}

function zaw-src-git-branches-checkout () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    if [[ "$b_type" == "heads" ]]; then
        BUFFER="git checkout $b_name"
        zle accept-line
    else
        BUFFER="git checkout -t $b_name"
        zle accept-line
    fi
}

function zaw-src-git-branches-create () {
    local b_name=${1#(heads|remotes|tags)/}
    LBUFFER="git checkout -b "
    RBUFFER=" $b_name"
}

function zaw-src-git-branches-delete () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    if [[ "$b_type" == "heads" ]] ; then
        BUFFER="git branch -d $1"
        zle accept-line
    elif [[ "$b_type" == "remotes" ]] ; then
        local b_loc=${b_name%%/*}
        local b_base=${b_name#$b_loc}
        BUFFER="git push $b_loc :$b_base"
        zle accept-line
    fi
}

zaw-register-src -n git-branches zaw-src-git-branches
