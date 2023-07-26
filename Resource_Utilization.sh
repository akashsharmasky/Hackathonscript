#!/bin/bash
#echo "********************************************************************************************
#This part of script help us to get the Memory CPU LOAD SWAP and Network Utilization Details
#
#By Default we will get the details of last 15 days but this can be changed depending upon the requirement.
#
#********************************************************************************************"


get_cpu_memory_utilization() {

if [[ -f /etc/redhat-release ]]
then
        OS="rhel"

elif [[ -f /etc/lsb-release && $(grep -c "Ubuntu" /etc/lsb-release) -gt 0 ]]
then
        OS="ubuntu"
elif [[ -f /etc/debian_version ]]
then
        OS="debian"
else
        OS="Not Supported"
fi

while ( true )
        do

                days=15
                echo -n "Would like to change the number of days for which utilization is needed [y/Y or n/N]: "
                read response
                if [ "$response" = "y" ] || [ "$response" = "Y"  ]
                then
                        echo -n "Enter the number of days [numeriv value ]: "
                        read days
                        if [[ $days -gt 0 ]]
                        then
                        break
                        else
                                echo "You enter invalid number, please select again"
                                continue
                        fi
                elif [ "$response" = "N" ] || [ "$response" = "n" ]
                then
                        echo "Proceeding with default 15 days"
                        break
                else
                        echo "Wrong Choice, try again"
                        continue
                fi
        done

if  [ "$OS" = "rhel" ]
then
        if [ `ls -ltr /var/log/sa/sa*|wc -l` -gt 0 ]
        then
                data=`ls -ltr /var/log/sa/sa*|grep -v sar|tail -n $days|awk '{print $NF}'`
        else
                echo "Sar is not installed on server, exiting the script"
        break
fi
elif [ "$OS" = "ubuntu" ] || [ "$1" = "debian" ]
then
        if [ `/var/log/sysstat/sa*|wc -l` -gt 0 ]
        then
                data=`ls -ltr /var/log/sysstat/sa*|grep -v sar|tail -n $days|awk '{print $NF}'`
        else
                echo "Sar is not installed on server, exiting the script"
                break
        fi
else
        echo "Not Supported OS type, therefore exiting"
exit 0
fi
echo "
**************************************************************************************************************************
*                                              CPU Statistics                                                            *
**************************************************************************************************************************
"
echo "+----------------------------------------------------------------------------------+"
echo "|Average:         CPU     %user     %nice   %system   %iowait    %steal     %idle  |"
echo "+----------------------------------------------------------------------------------+"
for file in $data
do
        dat=`sar -f $file | head -n 1 | awk '{print $4}'`
        echo -n $dat
        sar -f $file  | grep -i Average | sed "s/Average://"
done
echo "+----------------------------------------------------------------------------------+"
echo "
**************************************************************************************************************************
*                                          Memory Statistics                                                             *
**************************************************************************************************************************
"
echo "+-------------------------------------------------------------------------------------------------------------------+"
echo "|Average:       kbmemfree kbmemused  %memused kbbuffers kbcached  kbcommit   %commit  kbactive   kbinact   kbdirty  |"
echo "+-------------------------------------------------------------------------------------------------------------------+"

for file in $data
do
        dat=`sar -f $file | head -n 1 | awk '{print $4}'`
        echo -n $dat
        sar -r -f $file  | grep -i Average | sed "s/Average://"
done
echo "+-------------------------------------------------------------------------------------------------------------------+"
echo "
**************************************************************************************************************************
*                                          Load Statistics                                                               *
**************************************************************************************************************************
"
echo "+--------------------------------------------- ----------------------------+"
echo "|Average:       runq-sz  plist-sz   ldavg-1   ldavg-5  ldavg-15   blocked  |"
echo "+----------------------------------------------- --------------------------+"
for file in $data
do
        dat=`sar -f $file | head -n 1 | awk '{print $4}'`
        echo -n $dat
        sar -q -f $file  | grep -i Average | sed "s/Average://"
done
echo "+--------------------------------------------------------------------------+"
echo "
**************************************************************************************************************************
*                                          Swap Statistics                                                               *
**************************************************************************************************************************
"
echo "+--------------------------------------------- --------------------+"
echo "|Average:       kbswpfree kbswpused  %swpused  kbswpcad   %swpcad  |"
echo "+----------------------------------------------- ------------------+"
for file in $data
do
        dat=`sar -f $file | head -n 1 | awk '{print $4}'`
        echo -n $dat
        sar -S -f $file  | grep -i Average | sed "s/Average://"
done
echo "+--------------------------------------------------------------------------+"

echo "
**************************************************************************************************************************
*                                          Network Statistics                                                            *
**************************************************************************************************************************
"
echo "+--------------------------------------------- ----------------------------------------------+"
echo "|Average:       IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s  |"
echo "+--------------------------------------------------------------------------------------------+"
for file in $data
do
        dat=`sar -f $file | head -n 1 | awk '{print $4}'`
        echo  $dat
        sar -n DEV -f $file  | grep -i Average | egrep -v lo|sed "s/Average://"|sed 's/^/       /'
done
echo "+--------------------------------------------------------------------------------------------+"

}


# get_cpu_memory_utilization


