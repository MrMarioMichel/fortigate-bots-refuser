#!/bin/bash

TandC=$(tail -n 1 Terms_and_Conditions | awk 'NF>1{print $NF}')
if [ "$TandC" = "YES" ]; then
    SRCINTF=$(egrep -v "^\s*(#|$)" config.conf | egrep -v "^\s*(#|$)" | grep -w "Source_Interface" | sed 's/Source_Interface=//g' | tr -d '\r')
    DSTADDR=$(egrep -v "^\s*(#|$)" config.conf | grep -w "Destination_Address" | sed 's/Destination_Address=//g' | tr -d '\r')
    AUTODSTADDR=$(egrep -v "^\s*(#|$)" config.conf | grep -w "AutoConfigure_Destination_Address" | sed 's/AutoConfigure_Destination_Address=//g' | tr -d '\r')
    DSTINTF=$(egrep -v "^\s*(#|$)" config.conf | grep -w "Destination_Interface" | sed 's/Destination_Interface=//g' | tr -d '\r')
    SERVICE=$(egrep -v "^\s*(#|$)" config.conf | grep -w "Service" | sed 's/Service=//g' | tr -d '\r')
    POLICYID=$(egrep -v "^\s*(#|$)" config.conf | grep -w "Policy_ID" | sed 's/Policy_ID=//g' | tr -d '\r')
    AUTOMOVEPOLICY=$(egrep -v "^\s*(#|$)" config.conf | grep -w "Auto_Move_Policy" | sed 's/Auto_Move_Policy=//g' | tr -d '\r')
    AUTOPOLICYID=$(egrep -v "^\s*(#|$)" config.conf | grep -w "AutoConfigure_Policy_ID" | sed 's/AutoConfigure_Policy_ID=//g' | tr -d '\r')
    MGNTIP=$(egrep -v "^\s*(#|$)" config.conf | grep -w "FortiGate_IP" | sed 's/FortiGate_IP=//g' | tr -d '\r')
    MGNTPORT=$(egrep -v "^\s*(#|$)" config.conf | grep -w "FortiGate_Port" | sed 's/FortiGate_Port=//g' | tr -d '\r')
    MGNTUSER=$(egrep -v "^\s*(#|$)" config.conf | grep -w "FortiGate_User" | sed 's/FortiGate_User=//g' | tr -d '\r')
    MGNTPASSWD=$(egrep -v "^\s*(#|$)" config.conf | grep -w "FortiGate_Password" | sed 's/FortiGate_Password=//g' | tr -d '\r')
    IPFEED=$(egrep -v "^\s*(#|$)" config.conf | grep -w "Bot_IP_List" | sed 's/Bot_IP_List=//g' | tr -d '\r')
    MAXIPSPERADRGRP=$(egrep -v "^\s*(#|$)" config.conf | grep -w "Max_Addresses_Per_Address_Group" | sed 's/Max_Addresses_Per_Address_Group=//g' | tr -d '\r')
    AUTOMAXIPSPERADRGRP=$(egrep -v "^\s*(#|$)" config.conf | grep -w "AutoConfigure_Max_Addresses_Per_Address_Group" | sed 's/AutoConfigure_Max_Addresses_Per_Address_Group=//g' | tr -d '\r')
    MAXVIPSPERVIPGRP=$(egrep -v "^\s*(#|$)" config.conf | grep -w "Max_VIPs_Per_VIP_Group" | sed 's/Max_VIPs_Per_VIP_Group=//g' | tr -d '\r')
    AUTOMAXVIPSPERVIPGRP=$(egrep -v "^\s*(#|$)" config.conf | grep -w "AutoConfigure_Max_VIPs_Per_VIP_Group" | sed 's/AutoConfigure_Max_VIPs_Per_VIP_Group=//g' | tr -d '\r')
    UPDATEINTERVAL=$(egrep -v "^\s*(#|$)" config.conf | grep -w "Update_Fortigate_Bots_Refuser" | sed 's/Update_Fortigate_Bots_Refuser=//g' | tr -d '\r')
    LOGTRAFFIC=$(egrep -v "^\s*(#|$)" config.conf | grep -w "LOGTRAFFIC" | sed 's/LOGTRAFFIC=//g' | tr -d '\r')
    GUIVISIBILITY=$(egrep -v "^\s*(#|$)" config.conf | grep -w "GUIVISIBILITY" | sed 's/GUIVISIBILITY=//g' | tr -d '\r')

    echo "[i]: Init start"
    RUNID=1
    while true; do
        if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
            echo "Usage ./fortigate-bots-refuser.sh [OPTIONS]"
            echo "      OPTIONS"
            echo "          -h, --help          Prints out this help page"
            echo "          -r, --remove        Starts the removal process"
            echo "          -p, --removeautopolicy    Removes the already configured policy ID. New polcy ID will be Autoconfigured if enabled"
            echo "          -t, --test          Will not push config to FortiGate (What would happen)"
            exit 0
        fi
        if [ "$1" = "-p" ] || [ "$1" = "--removeautopolicy" ]; then
            if ! [ -f pol-id ]; then
                echo "[e]: There is no policy ID configured"
                exit 1
            else
                echo "[i]: Removal of already configured policy ID resulting in a new polcy ID cofigured if Autoconfigured is enabled"
                echo "Do you wish to remove the the already configured policy ID? Current ID is $(cat pol-id)"
                read -p "Are you sure? " -n 1 -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    rm pol-id
                    echo "Configured policy ID has been removed this policy ID can be re-selected by enabling AutoConfigure_Policy_ID"
                    exit 0
                else
                    exit 0
                fi
            fi
        fi
        if [ "$1" = "-r" ] || [ "$1" = "--remove" ] || [ "$2" = "-r" ] || [ "$2" = "--remove" ]; then
            echo "[i]: Removal initialized"
            echo "Do you wish to remove all configs made by fortigate-bots-refuser?"
            read -p "Are you sure? " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo ""
                echo "Please use the GUI for sefe and easy removal"
                echo "  *Note:"
                echo "        1. Delete the policy created by the fortigate-bots-refuser (Can by verified if the comment says \"DO NOT DELETE # This policy is auto generated by fortigate-bots-refuser\")"
                echo "        2. Delete the addresses which all have got the same syntx \"<IP>-is-a-bot-adr\" (Can be quickly done by seaching in the adresses for \"-is-a-bot\")"
                echo "        3. Delete the address group/s which all have got the same syntx \"is-a-bot-ip-grp-<NUMBER>\" (Can be quickly done by seaching in the adresses for \"is-a-bot-ip-grp\")"
                echo "        4. Delete the vip group/s which all have got the same syntx \"is-a-bot-vip-grp-<NUMBER>\" (Can be quickly done by seaching in the VIPs for \"is-a-bot-vip-grp\")"
                exit 0
            else
                exit 0
            fi
            echo "[i]: Re-run"
            echo "[i]: └─ Run-ID $RUNID"
        else
            if [ -f vips ]; then
                echo "[i]: Removing old file \"vips\" (Seems you exited the script before it finished. STOP THAT!)"
                rm vips
            else
                if [ -f show-firewall ]; then
                    echo "[i]: Removing old file \"show-firewall\" (Seems you exited the script before it finished. STOP THAT!)"
                    rm show-firewall
                else
                    if [ -f show-temp ]; then
                        echo "[i]: Removing old file \"show-temp\" (Seems you exited the script before it finished. STOP THAT!)"
                        rm show-temp
                    else
                        if [ -f bots ]; then
                            echo "[i]: Removing old file \"bots\" (Seems you exited the script before it finished. STOP THAT!)"
                            rm bots
                        else
                            printf ""
                        fi
                    fi
                fi
            fi
            if [ $AUTOMOVEPOLICY = True ] || [ $AUTOPOLICYID = True ] || [ $AUTOMAXIPSPERADRGRP = True ] || [ $AUTODSTADDR = True ]; then
                echo "show firewall policy | grep \"set name\"" >show-firewall
                echo "#GREP-SPACE" >>show-firewall
                if [ $AUTODSTADDR = True ]; then
                    echo "[i]: Preparing Autoconfigure Destination_Address"
                    echo "show firewall vip | grep edit" >>show-firewall
                    echo "#GREP-SPACE" >>show-firewall
                fi
                if [ $AUTOMAXIPSPERADRGRP = True ]; then
                    echo "[i]: Preparing Autoconfigure Max_Addresses_Per_Address_Group"
                    echo "print tablesize" >>show-firewall
                    echo "#GREP-SPACE" >>show-firewall
                fi
                if [ $AUTOPOLICYID = True ]; then
                    echo "[i]: Preparing Autoconfigure AutoConfigure_Policy_ID"
                    echo "config firewall policy" >>show-firewall
                    echo "edit 0" >>show-firewall
                    echo "show " >>show-firewall
                    echo "end " >>show-firewall
                    echo "#GREP-SPACE" >>show-firewall
                fi
                if [ $AUTOMOVEPOLICY = True ]; then
                    echo "[i]: Preparing Autoconfigure Auto_Move_Policy"
                    echo "show firewall policy | grep edit" >>show-firewall
                    echo "#GREP-SPACE" >>show-firewall
                fi
                echo "exit" >>show-firewall
                echo "[i]: Getting configuration"
                if ((MGNTPORT >= 1 && MGNTPORT <= 65535)); then
                    VALIDIP=$(echo $MGNTIP | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
                    if ! [ -z $VALIDIP ]; then
                        sshpass -p "$MGNTPASSWD" ssh -o LogLevel=QUIET -tt -o "StrictHostKeyChecking=no" $MGNTUSER@$MGNTIP -p $MGNTPORT <show-firewall >show-temp
                        rm show-firewall
                        if [[ $(find show-temp -type f -size +100c 2>/dev/null) ]]; then
                            echo "[i]: Configuration successfully received"
                        else
                            echo "[e]: Getting configuration was unsuccessful"
                            rm show-temp
                            exit 1
                        fi
                        if [ $AUTODSTADDR = True ]; then
                            echo "[i]: Reading configuration"
                            for VIP in $(awk '/show firewall vip/,/#GREP-SPACE/' show-temp | grep -w "edit" | grep -v "show firewall vip" | sed 's/"//g' | sed 's/edit//g' | sed 's/     //g' | tr -d '\r'); do
                                echo "$VIP" >>vips
                            done
                            CHECKWHITESPACED=$(grep "[[:space:]]" vips | sed ':a;N;$!ba;s/\n/ " and " /g')
                            if [ -z "$CHECKWHITESPACED" ]; then
                                sed -i ':a;N;$!ba;s/\n/ /g' vips
                                DSTADDR=$(cat vips)
                                echo "[i]: Autoconfigure AutoConfigure_Destination_Addresss \"$DSTADDR\""
                            else
                                echo "[e]: Whitespace detected! You need to remove the whitespace at VIP \"$CHECKWHITESPACED\" The script will not proceed until you remove this."
                                echo "[n]: └─ Do NOT try to modify the code! You will have problems at the policy creation/configuration"
                                rm vips show-temp
                                exit 1
                            fi
                        fi
                        if [ $AUTOMAXIPSPERADRGRP = True ]; then
                            MAXIPSPERADRGRP=$(awk '/print tablesize/,/#GREP-SPACE/' show-temp | grep "firewall.addrgrp:member" | awk '{print $2}' | tr -d '\r')
                            echo "[i]: Autoconfigure AutoConfigure_Max_Addresses_Per_Address_Group \"$MAXIPSPERADRGRP\""
                        fi
                        if [ $AUTOMAXVIPSPERVIPGRP = True ]; then
                            MAXVIPSPERVIPGRP=$(awk '/print tablesize/,/#GREP-SPACE/' show-temp | grep "firewall.vipgrp:member" | awk '{print $2}' | tr -d '\r')
                            echo "[i]: Autoconfigure AutoConfigure_Max_VIPs_Per_VIP_Group \"$MAXVIPSPERVIPGRP\""
                        fi
                        if [ "$RUNID" -ge "2" ]; then
                            printf ""
                        else
                            EXISTINGPOLICY=$(awk '/show firewall policy | grep "set name"/,/#GREP-SPACE/' show-temp | grep "forti-bots-refuseer")
                        fi
                        if ! [ -z "$EXISTINGPOLICY" ]; then
                            echo "[e]: There is a policy named \"forti-bots-refuseer\". The script will not proceed until you delete this policy, update the policy ID in the file pol-id or set the right policy ID in the config file."
                            echo "[d]: Check on the firewall via this cli command # show firewall policy | grep \"forti-bots-refuseer\" -f"
                            echo "[n]: └─ This shows you the already created policy by this script."
                            rm vips show-temp
                            exit 1
                        fi
                        if [ -f pol-id ]; then
                            POLICYID=$(cat pol-id | tr -d '\r')
                            echo "[i]: Autoconfigure AutoConfigure_Policy_ID"
                            echo "[i]: └─ Useig already configured policy ID \"$POLICYID\"!"
                            echo "[n]:  └─ Remove the reusing of the already configured policy ID by using the -p or --autopolicy option"
                        else
                            if [ $AUTOPOLICYID = True ]; then
                                POLICYID=$(awk '/new entry/,/#GREP-SPACE/' show-temp | grep "edit" | awk '{print $2}' | tr -d '\r')
                                echo "[i]: Autoconfigure AutoConfigure_Policy_ID \"$POLICYID\""
                                echo "$POLICYID" >pol-id
                            fi
                        fi
                        if [ $AUTOMOVEPOLICY = True ]; then
                            FIRSTSEQENCEPOLICYID=$(awk '/show firewall policy \| grep edit/,/#GREP-SPACE/' show-temp | grep "edit" | head -n 3 | tail -n 1 | awk '{print $2}' | tr -d '\r')
                            echo "[i]: Fist policy ID in sequence \"$FIRSTSEQENCEPOLICYID\""
                            echo "[i]: └─ Will move policy $POLICYID befor policy $FIRSTSEQENCEPOLICYID to be first in seqence"
                            MOVEPOLICYSEQUENCE=1
                        fi
                        if [ "$GUIVISIBILITY" = "False" ]; then
                            GUIVISIBILITY="disable"
                        else
                            GUIVISIBILITY="enabled"
                        fi
                        echo "[i]: Done reading configuration"
                        rm show-temp
                    else
                        echo "[e]: IP \"$MGNTIP\" does not look like a valid IP. Use one like this 192.168.10.1"
                    fi
                else
                    echo "[e]: Port \"$MGNTPORT\" does not look like a valid port. Use one out of this range 1-65535"
                fi
            else
                printf ""
            fi
            echo "[i]: Getting bot IP feed"
            CURLSTART=$(($(date +%s%N) / 1000000))
            curl -s $IPFEED | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort | uniq >bots
            CURLEND=$(($(date +%s%N) / 1000000))
            CURLTIME=$(($CURLEND - $CURLSTART))
            IPSCURLED=$(wc -l bots | awk '{print $1}')
            if [[ $(find bots -type f -size +10c 2>/dev/null) ]]; then
                echo "[i]: IP feed successfully received $IPSCURLED IPs in $CURLTIME ms"
                grep -e "^192\.168\." -e "^10\." -e "^172\.[1-3][0-9]\." -e "0\.0\.0\.0" -e "255\.255\.255\.255" bots >invalid
                for INVALID in $(cat invalid); do
                    echo "[i] Invalid or Private IPs will NOT be added! $INVALID"
                    sed -i "s/$INVALID//g" bots
                done
                rm invalid
            else
                echo "[e]: Getting IP feed was unsuccessful. No IPs where provided"
                exit 1 # <-- I need to do a loop that it retries curl feed
            fi
            PROGRESS=$IPSCURLED
            echo "[i]: └─ Total of $PROGRESS IPs received from feed"
            PROGRESS=$((PROGRESS / 10))
            LINE=1
            COUNT=1
            printf "[i]: Generating config 1/5 (Addresses) "
            echo "config firewall address" >commands.txt
            for IP in $(cat bots); do
                echo "  edit $IP-is-a-bot-adr" >>commands.txt
                echo "$IP" | sed 's/^/    set subnet /' | sed 's/$/ 255.255.255.255/' >>commands.txt

                printf "    set visibility " >>commands.txt
                echo "$GUIVISIBILITY"  >>commands.txt
                LINE=$((LINE + 1))
                if [ "$LINE" = "$PROGRESS" ]; then
                    printf "."
                    LINE=1
                else
                    printf ""
                fi
                echo "  next" >>commands.txt
            done
            echo ""
            echo "end" >>commands.txt
            MAXIPSPERADRGRP=$((MAXIPSPERADRGRP - 1))
            echo "[i]: Generating config 2/5 (Splitting IPs into chucks)"
            split -d -a 3 -l $MAXIPSPERADRGRP bots bs-
            echo "[i]: └─ Splitted into chucks"
            ls -l | grep "bs-*" | awk '{print $9}' >files
            GROUPS=$(wc -l files | awk '{print $1}')
            PROGRESS=$((MAXIPSPERADRGRP / 100))
            LINE=1
            COUNT=1
            echo "[i]: Generating config 3/5 (Address Groups)"
            echo "config firewall addrgrp" >>commands.txt
            for FILE in $(cat files); do
                echo "  edit is-a-bot-ip-grp-$COUNT" >>commands.txt
                echo "is-a-bot-ip-grp-$COUNT" >>addressgroup
                printf "set member" >>commands.txt
                printf "[i]: └─ Adding members to address group \"$COUNT\" "
                for IP in $(cat $FILE); do
                    ENTRY=$((ENTRY + 1))
                    printf " $IP-is-a-bot-adr" >>commands.txt
                    LINE=$((LINE + 1))
                    if [ "$LINE" = "$PROGRESS" ]; then
                        printf "."
                        LINE=1
                    else
                        printf ""
                    fi
                done
                echo ""
                echo "" >>commands.txt
                echo "  next" >>commands.txt
                FILESPLIT=$((FILESPLIT + 1))
                COUNT=$((COUNT + 1))
            done
            echo "end" >>commands.txt
            SRCADDR=$(sed ':a;N;$!ba;s/\n/ /g' addressgroup)
            rm addressgroup
            rm bots bs-* files
            echo "[i]: Generating config 5/5 (VIP Groups)"
            if ! [ "$AUTODSTADDR" = "True" ]; then # If AUTODSTADDR isn't true write all DSTADDR to vip file
                if ! [ -z $DSTADDR ]; then
                    echo "$DSTADDR" >vips # Write DSTADDR to vip file
                else
                    echo "[e]: Missing variable value detected! You need to define for every variable a value. The script will not proceed until you define a value for every variable."
                    echo "[d]: DSTADDR= \"$DSTADDR\""
                    exit 1
                fi
            fi
            if ! [ "$AUTOMAXVIPSPERVIPGRP" = "True" ]; then
                if [ -z $DSTADDR ]; then
                    echo "[e]: Missing variable value detected! You need to define for every variable a value. The script will not proceed until you define a value for every variable."
                    echo "[d]: MAXVIPSPERVIPGRP= \"$MAXVIPSPERVIPGRP\""
                    exit 1
                fi
            fi
            split -d -a 3 -l $MAXVIPSPERVIPGRP vips vip-
            rm vips
            ls -l | grep "vip-*" | awk '{print $9}' >files
            GROUPS=$(wc -l files | awk '{print $1}')
            PROGRESS=$((MAXVIPSPERVIPGRP / 100))
            COUNT=1
            echo "config firewall vipgrp" >>commands.txt
            for FILE in $(cat files); do
                echo "  edit is-a-bot-vip-grp-$COUNT" >>commands.txt
                echo "is-a-bot-vip-grp-$COUNT" >>vipgroup
                echo "    set interface "any"" >>commands.txt
                printf "    set member" >>commands.txt
                printf "[i]: └─ Adding members to VIP group \"$COUNT\" "
                for VIP in $(cat $FILE); do
                    ENTRY=$((ENTRY + 1))
                    printf " $VIP" >>commands.txt
                    LINE=$((LINE + 1))
                    if [ "$LINE" = "$PROGRESS" ]; then
                        printf "."
                        LINE=1
                    else
                        printf ""
                    fi
                done
                echo ""
                echo "" >>commands.txt
                echo "  next" >>commands.txt
                FILESPLIT=$((FILESPLIT + 1))
                COUNT=$((COUNT + 1))
            done
            echo "end" >>commands.txt
            DSTADDR=$(sed ':a;N;$!ba;s/\n/ /g' vipgroup)
            rm vipgroup
            rm vip-* files
            echo "[i]: Generating config 4/4 (Policy)"
            echo "config firewall policy" >>commands.txt
            echo "  edit $POLICYID" >>commands.txt
            echo "    set name forti-bots-refuseer" >>commands.txt
            echo "    set srcintf $SRCINTF" >>commands.txt
            echo "    set dstintf $DSTINTF" >>commands.txt
            echo "    set srcaddr $SRCADDR" >>commands.txt
            echo "    set dstaddr $DSTADDR" >>commands.txt
            echo "    set service $SERVICE" >>commands.txt
            echo "    set schedule always" >>commands.txt
            echo "    set logtraffic $LOGTRAFFIC" >>commands.txt
            echo "    set action deny" >>commands.txt
            echo "    set comments \"DO NOT DELETE # This policy is auto generated by fortigate-bots-refuser\"" >>commands.txt
            echo "  next" >>commands.txt
            if [ "$MOVEPOLICYSEQUENCE" = "1" ]; then
                printf "[i]: └─ Move policy to first in sequence: "
                if [ "$AUTOMOVEPOLICY" = "True" ]; then
                    echo "enabled"
                    echo "    move $POLICYID before $FIRSTSEQENCEPOLICYID" >>commands.txt
                else
                    echo "disbale"
                    echo "[i]: └─ Please move policy to affect traffic flow in sequence"
                fi
            fi
            echo "end" >>commands.txt
            echo "exit" >>commands.txt
            echo "[i]: Done Generating config"
            echo "[i]: Validating config"
            if [ -z "$POLICYID" ] || [ -z "$SRCINTF" ] || [ -z "$DSTINTF" ] || [ -z "$SRCADDR" ] || [ -z "$DSTADDR" ] || [ -z "$SERVICE" ] || [ -z "$LOGTRAFFIC" ]; then
                echo "[e]: Missing variable value detected! You need to define for every variable a value. The script will not proceed until you define a value for every variable."
                echo "[d]: POLICYID= \"$POLICYID\", SRCINTF= \"$SRCINTF\", DSTINTF= \"$DSTINTF\", SRCADDR= \"$SRCADDR\", DSTADDR= \"$DSTADDR\", SERVICE= \"$SERVICE\", LOGTRAFFIC= \"$LOGTRAFFIC\""
                exit 1
            else
                echo "[i]: └─ Config seems okay"
            fi
            if [ "$1" = "--test" ] || [ "$1" = "-t" ]; then
                echo "[i]: Test mode enabled"
                echo "---------- BEGIN SHOWING COMMANDS.TXT ----------"
                cat commands.txt
                echo "---------- END SHOWING COMMANDS.TXT ----------"
                echo "[i]: Review configuration that would have been made in commands.txt"
                rm pol-id 2 &>/dev/null
                echo "[i]: End"
                exit 0
            else
                echo "[i]: Pushing to FortiGate"
                sshpass -p "$MGNTPASSWD" ssh -o LogLevel=QUIET -tt -o "StrictHostKeyChecking=no" $MGNTUSER@$MGNTIP -p $MGNTPORT <commands.txt >log/push@$(date +%d-%m-%Y--%H-%M).txt
                echo "[i]: Pushed to FortiGate"
            fi
            echo "[i]: End"
            rm commands.txt
        fi
        echo "[i]: Sleeping now for $UPDATEINTERVAL sec"
        sleep $UPDATEINTERVAL
        RUNID=$((RUNID + 1))
    done
else
    echo "PLEASE GO READ THE TERMS AND CONDITIONS"
fi
