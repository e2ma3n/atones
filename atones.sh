#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Gitbub : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# atones v1.0 - attack on esxi
# Last update : 29-December-2019_14:05:20
# Finding attack on vSphere web client and ssh in VMware ESXi
# ------------------------------------------------------------------ #

address=$1

function help {
    echo "[>] Usage:"
    echo "[>]    $0 [ESXi ip address]"
    echo "[>]    Example: $0 192.168.1.1"
}

function check {
    # create atones in tmp directory
    [ ! -d /tmp/atones ] && mkdir -p /tmp/atones/

    # remove all file in atones directory
    rm -rf /tmp/atones/* &> /dev/null

    # check $address is empty or not
    [ -z $address ] && help && exit 1

    # check python-pandas is installed or not
    apt list python-pandas 2> /dev/null | grep -o installed &> /dev/null
    [ "$?" != "0" ] && echo "[#] apt install python-pandas" && exit 1

    # check python-tabulate is installed or not
    apt list python-tabulate 2> /dev/null | grep -o installed &> /dev/null
    [ "$?" != "0" ] && echo "[#] apt install python-tabulate" && exit 1
}

function connection {
    echo "[>] scp root@$address:/var/log/{hostd.log,auth.log} /tmp/atones/"

    # copy hostd.log & auth.log from ESXi to this system
    scp root@$address:/var/log/{hostd.log,auth.log} /tmp/atones/

    # check connection status
    [ "$?" != "0" ] && echo "[!] Can not connect to esxi" \
    && echo "[!] Maybe ssh service is not actived in esxi" \
    && echo "[!] Check firewall settings" \
    && exit 1
}

function compute {
    # check hostd.log is exist or not
    [ ! -f /tmp/atones/hostd.log ] && echo "[!] hostd.log not found" && exit 1

    # check auth.log is exist or not
    [ ! -f /tmp/atones/auth.log ] && echo "[!] auth.log not found" && exit 1


    # create and compute csv file attacks on vsphere web client [for ESXi]
    cat /tmp/atones/hostd.log | grep 'Cannot login' | cut -d '.' -f 1 | tr 'T' '_' > /tmp/atones/time_date
    cat /tmp/atones/hostd.log | grep 'Cannot login' | cut -d ':' -f 4 | cut -d ' ' -f 4 | tr '@' ',' > /tmp/atones/out
    paste /tmp/atones/time_date /tmp/atones/out | tr '\t' ',' > /tmp/atones/attack_console.csv
    [ -s /tmp/atones/attack_console.csv ] && sed -i '1 i\Time and Date,Try login to,From IP Address' /tmp/atones/attack_console.csv


    # create and compute csv file for attacks on ssh [for ESXi]
    cat /tmp/atones/auth.log | grep 'ssh' | grep 'authentication failure' | cut -d ' ' -f 1 | tr 'T' '_' | tr -d 'Z' > /tmp/atones/time_date
    cat /tmp/atones/auth.log | grep 'ssh' | grep 'authentication failure' | cut -d ';' -f 2 | cut -d '=' -f 7,8 | tr -s ' ' | tr ' ' ',' > /tmp/atones/out
    paste /tmp/atones/time_date /tmp/atones/out | tr '\t' ',' > /tmp/atones/attack_ssh.csv
    [ -s /tmp/atones/attack_ssh.csv ] && sed -i '1 i\Time and Date,From IP Address,Try login to' /tmp/atones/attack_ssh.csv


    # create and compute csv file login on vsphere web client [for ESXi]
    cat /tmp/atones/hostd.log | grep 'Accepted password for user' | grep -v '127.0.0.1' | cut -d ' ' -f 1 | tr 'T' '_' | cut -d '.' -f 1 > /tmp/atones/time_date
    cat /tmp/atones/hostd.log | grep 'Accepted password for user' | grep -v '127.0.0.1' | cut -d '=' -f 3 | cut -d ']' -f 2 | cut -d ' ' -f 6,8 | tr ' ' ',' > /tmp/atones/out
    paste /tmp/atones/time_date /tmp/atones/out | tr '\t' ',' > /tmp/atones/login_console.csv
    [ -s /tmp/atones/login_console.csv ] && sed -i '1 i\Time and Date,Login to,From IP Address' /tmp/atones/login_console.csv


    # create and compute csv file login on shh [for ESXi]
    cat /tmp/atones/auth.log | grep 'ssh' | grep 'Accepted' | cut -d ' ' -f 1 | tr 'T' '_' | tr -d 'Z' > /tmp/atones/time_date
    cat /tmp/atones/auth.log | grep 'ssh' | grep 'Accepted' | cut -d '/' -f 2 | cut -d ' ' -f 3,5 | tr ' ' ',' > /tmp/atones/out
    paste /tmp/atones/time_date /tmp/atones/out | tr '\t' ',' > /tmp/atones/login_ssh.csv
    [ -s /tmp/atones/login_ssh.csv ] && sed -i '1 i\Time and Date,Login to,From IP Address' /tmp/atones/login_ssh.csv
}

function c_python {
    # create python script
    echo "import pandas" > /tmp/atones.py
    echo "import sys" >> /tmp/atones.py
    echo "from tabulate import tabulate" >> /tmp/atones.py
    echo "data = pandas.read_csv(sys.argv[1], encoding = 'utf-8' ). fillna('NULL')" >> /tmp/atones.py
    echo "print(tabulate(data, headers=data.columns, tablefmt=\"grid\"))" >> /tmp/atones.py
}

function view {
    for (( ;; )) ; do
        # check attack_console.csv file is exist or not
        [ ! -f /tmp/atones/attack_console.csv ] && \
        # check attack_ssh.csv file is exist or not
        [ ! -f /tmp/atones/attack_ssh.csv ] && \
        # check login_console.csv file is exist or not
        [ ! -f /tmp/atones/login_console.csv ] && \
        # check login_ssh.csv file is exist or not
        [ ! -f /tmp/atones/login_ssh.csv ] && \
        echo "[!] No result" && exit 1

        # clean up terminal
        reset
        echo "[+] -------------------------------------------------------------------------- [+]"
        echo "[+] Atones v1.0 - Finding attack on vSphere web client and ssh in VMware ESXi"
        echo "[+] Programming and idea by : E2MA3N [Iman Homayouni]"
        echo "[+] Gitbub : https://github.com/e2ma3n"
        echo "[+]"

        [ -f /tmp/atones/attack_console.csv ] && echo "[1] View attack on vSphere web client"
        [ -f /tmp/atones/attack_ssh.csv ] && echo "[2] View attack on ssh"
        [ -f /tmp/atones/login_console.csv ] && echo "[3] View login on vSphere web client"
        [ -f /tmp/atones/login_ssh.csv ] && echo "[4] View login on ssh"

        echo "[5] Exit"
        echo -en "[>] Select: " ; read q
        echo "[+]"

        #  View attack on vSphere web client
        if [ "$q" = "1" ] ; then
            echo "[1] View attack on vSphere web client"
            python /tmp/atones.py /tmp/atones/attack_console.csv
            echo "[>] File: /tmp/atones/attack_console.csv"
            echo -en "[>] Press enter for back to menu" ; read null

        # View attack on ssh
        elif [ "$q" = "2" ] ; then
            echo "[2] View attack on ssh"
            python /tmp/atones.py /tmp/atones/attack_ssh.csv
            echo "[>] File: /tmp/atones/attack_ssh.csv"
            echo -en "[>] Press enter for back to menu" ; read null

        # View login on vSphere web client
        elif [ "$q" = "3" ] ; then
            python /tmp/atones.py /tmp/atones/login_console.csv
            echo "[3] View login on vSphere web client"
            echo "[>] File: /tmp/atones/login_console.csv"
            echo -en "[>] Press enter for back to menu" ; read null

        # View login on ssh
        elif [ "$q" = "4" ] ; then
            echo "[4] View login on ssh"
            python /tmp/atones.py /tmp/atones/login_ssh.csv
            echo "[>] File: /tmp/atones/login_ssh.csv"
            echo -en "[>] Press enter for back to menu" ; read null

        # exit from program
        elif [ "$q" = "5" ] ; then
            echo "[+] -------------------------------------------------------------------------- [+]"
            exit 0
        else
            echo "[!] Bad input"
            echo "[>] Try again"
            sleep 3
        fi
    done
}

# run functions
check
connection
compute
c_python
view
