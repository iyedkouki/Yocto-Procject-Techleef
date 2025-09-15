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

do_check_file()
{
    echo "Check file"
 if [[ ! -f "$shell_file" ]]; then {
 echo "the file not existe"
 exit 1
 }
 else 
  {
  if [[ -s "$shell_file" ]]; then
  echo "the file is empty" 
  exit 1
  elif [[ -x "$shell_file" ]];then
   echo "check the right of exxecution"
   exit 1
  elif [[ -r "$shell_file" ]]; then
   echo "check the right of read"
   exit 1
  else
   echo "the file is existe and not empty with the right of excecution and reading"
  fi   
  }
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
    if ! pip3 list | grep kas; then
        echo "[+] Installing Kas"
        if ! pip3 install kas; then 
            echo "[X] failed to install kas"
            exit 1
        fi
    fi
    echo "[+] kas is installed"
}

main(){
do_check_argument "$@"

do_prepare_envirement

do_check_file

do_checkout

do_shell_file


}
main "$@"
