# zaw source for processes

function zaw-src-process () {
    local process_list="$(ps -U $USER | sed 1d)"
    local pid_list="$(echo $process_list| awk '{print $1}')"
    : ${(A)candidates::=${(f)pid_list}}
    : ${(A)cand_descriptions::=${(f)process_list}}
    actions=(zaw-src-process-kill zaw-src-process-insert)
    act_descriptions=("kill" "insert")
    options=()
}

function zaw-src-process-insert () {
    BUFFER+=$1
}

function zaw-src-process-kill () {
    BUFFER="kill $1"
    zle accept-line
}

zaw-register-src -n process zaw-src-process
