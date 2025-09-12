#!/bin/bash
if [$# -ne 2]; then
 echo "Usage: $0 checkout|sheell|build <path/to/yml>"
 exit 1 
fi

VEN_DIR="yocto-venv"

do_prepare_env(){
    if [-d "${VENV_DIR}" ]; then
    #make sure that it is actually a python virtual envirement (tested)
    #if it is not, then fail with error message (and exit)
    else #this repo isn't exist thana lets create and envirement 
     python3 -m venv "${VEN_DIR}"
    fi
    # source the env
    echo "[+] Sourcing the Python venv"
    source "${VEN_DIR}/bin/activate" || {
        echo "[X] Failed to setup the venv"
        exit 1
        }
    if ! pip3 install kas; then 
     echo "[X] error installing kas"
     exit 1
    fi

}


do_kas_checkout(){
    local yml="${1}"
    kas-container checkout "${yml}"
}

KAS_DIR=$(pwd)
kas-container checkout ${KASfilr}


main(){

    if [ ! -f "${yml}" ]; then
        echo "[X] ${yml} does not exisit"
        exit 1
    fi

    do_prepare_env
    local action="$1"
    local yml="$2"
    local cmd=""
    if ["${action}" == "checkout" ]; then
        do_kas_checkout $"{yml}"
    elif ["${action}" == "shell" ]; then
        do_kas_shell $"{yml}"
    elif ["${action}" == "build" ]; then
        do_kas_build $"{yml}"
    else
        echo "[X] Wrong action"
        exit 1
    fi

    do_kas_checkout
    do_kas_shell
    do_kas_build
}