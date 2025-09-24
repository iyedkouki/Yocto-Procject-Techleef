#!/bin/bash

do_check_argument()
{
echo "number of argument is  $#"
if [[ "$#" -ne 2 ]]; then
    echo "you must provide 2 arguments"
    read -p "Enter the first argument: (virtual env name)  " VEN_DIR
    read -p "enter the second arqument: (shell)  " shell_file
else 
    if [[ ! -f "$1" ]]; then
         VEN_DIR="$1"
        shell_file="$2"
    else
        VEN_DIR="$2"
        shell_file="$1"
    fi
    echo "The directory name is $VEN_DIR"
    echo "The file name is $shell_file"
fi
}

do_checkout(){
    local yml="$shell_file"
    kas-container checkout "${yml}" || {
        echo "[X] failed to checkout the file"
        exit 1
    }
}


do_shell_file(){
    local yml="$shell_file"
    kas-container shell "${yml}" || {
        echo "[X]Failed to shell the file"
        exit 1
    }
}
do_build_file(){
    local yml="$shell_file"
    kas-container build "${yml}" || {
        echo "[X]Failed to build the file"
        exit 1
    }
}

do_prepare_envirement(){
    if [[ ! -d "${VEN_DIR}" ]];then
        mkdir "${VEN_DIR}"
        echo "[+] Mkdir the directory"

    fi
    if [[ ! -f "${VEN_DIR}/pyvenv.cfg" ]]; then
            echo "[+] created the envirement the directory"
            python3 -m venv "${VEN_DIR}" || { 
            echo "[X] Failed setup the envirement"
            exit 1
            }
    fi
    echo "The envirement is succefully set up"

    source "${VEN_DIR}/bin/activate" || {
        echo "[X] Failed to sourcing the envirement"
        exit 1
    }
    echo "The envirement is succefully sourced"
    if ! pip3 list | grep -q kas; then
        echo "[+] Installing Kas"
        if ! pip3 install kas; then 
            echo "[X] failed to install kas"
            exit 1
        fi
    fi
    echo "[+] kas is installed"
}

main(){
    local action="$1"
    do_check_argument "$2" "$3"
    do_prepare_envirement

    if [[ "${action}" == "checkout" ]]; then
    echo "The Action chechout is lancing"
    do_checkout
    elif [[ "${action}" == "shell"  ]]; then
        echo "The Action Shell is lancing"
        do_shell_file 
    elif [[ "${action}" == "build" ]]; then
        echo "The Action build is lancing"
        do_build_file
    else
        echo "please choise one of this Action checkou/shell/build"
        exit 1
    fi

}
main "$@"

# kas-container --repo-rw --runtime-args "-v /home/iyed/yocto/build/downloads:/work/build/downloads" --runtime-args "-v /home/iyed/yocto/build/sstate-cache:/work/build/sstate-cache" shell kas/kas-raspberrypi0-2w-64.yml 

