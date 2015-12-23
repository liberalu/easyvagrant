#!/bin/bash

function script_help() {
    cat << EOF

rtail service management
Options:
 - v  - version
 - h  - help
 - s  - start
 - x  - stop
 
EOF
}


ACTION="";
while getopts "hvsx" arg
do
     case $arg in
         h)
             script_help
             exit 1
             ;;
         v)
             echo "0.1";
             exit 1
             ;;
         s)
             ACTION="start"
             ;;
         x)
             ACTION="stop"
             ;;
         esac
done

function runRtailLog() {
    tail -F "${1}" | rtail --name "${2}" --mute &
}

if [ "$ACTION" == 'start' ]; then
    sudo chmod -R 0777 /var/log/apache2 /var/log/mysql
    if [ -f ~/.config/configstore/update-notifier-rtail.json ]; then
        sudo chmod 0777 ~/.config/configstore/update-notifier-rtail.json
    fi    
    if (( "$(ps aux | grep 'rtail-server --' | wc -l)" < 2 )); then
        sudo rtail-server --web-port 8080 --wh 192.168.33.10 &
        echo "rtail is start"
    else
       echo "rtail is running";   
    fi;
    runRtailLog '/var/log/apache2/webpage.local.dev_access.log' 'apache2 access';    
    runRtailLog '/var/log/apache2/webpage.local.dev_error.log' 'apache2 error';
    runRtailLog '/var/log/mysql/error.log' 'mysql error';
    runRtailLog '/var/log/mysql/general.log' 'mysql query';
elif [ "$ACTION" == 'stop' ]; then
    sudo kill $(ps aux | grep '/usr/bin/rtail' | awk '{print $2}') &>/dev/null;
    echo "rtai is stoped"
else
    script_help
    exit 1; 
fi;


