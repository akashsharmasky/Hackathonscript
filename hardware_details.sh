#!/bin/bash

# Script: hardware_details.sh 
# Author: Akash Sharma
# Date: July 24, 2023
# Description: This script collects information about the hardware details of the server, including disk, RAID, and HBA details.

function hardware_details() {

#head_details()
#{
    echo -e "\n******************************************************************************************************"
    echo -e "**        Welcome to migration script which fetches basic details from the system              **"
    echo -e "******************************************************************************************************"
    printf "\nPlease wait while the script fetches the required details!\n\n";
#}

#define details action to fetch main system details on servers
#os_details()
#{
 echo -e '\n\n\t\t' "System Basic Details"
 echo -e '\t' "----------------------------------"
echo -e "Hostname" '\t\t\t\t' ":" `hostname`
echo -e "Operating System" '\t\t\t' ":" "`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`"
echo -e "Kernel Version" '\t\t\t\t' ":" `uname -r`
printf "OS Architecture\t\t\t\t :"
 if [ "`arch`" == "x86_64" ]
 then
 printf " 64 Bit OS\n"
 else
 printf " 32 Bit OS\n"
 fi

uptime|egrep "day|min" 2>&1 > /dev/null
if [ `echo $?` == 0 ]
then
 echo -e "System Uptime"  '\t\t\t\t' ":" `uptime|awk '{print $2" "$3" "$4}'|sed -e 's/,.*//g'`
else
  echo -e "System Uptime"  '\t\t\t\t' ":" `uptime|awk '{print $2" "$3}'|sed -e 's/,.*//g'`" hours"
fi
echo -e "Current System Date & Time" '\t\t' ":" `date +%c`
#}

#defining details action for server hardware details
#server_details()
#{
    echo -e '\n\n\t\t' "System Hardware Details"
    echo -e '\t' "----------------------------------"
    echo -e "Machine Type" '\t\t\t\t' ":" "`vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi`"
    echo -e "Product Name" '\t\t\t\t' ":" `dmidecode -s system-product-name`
    echo -e "Manufacturer" '\t\t\t\t' ":" `dmidecode -s system-manufacturer`
    echo -e "System Serial Number" '\t\t\t' ":" `dmidecode -s system-serial-number`
    echo -e '\n'
#}

#defining details action to fetch motherboard details
#mobo_details()
#{
 dmidecode --type baseboard > /tmp/baseboard.out;
    echo -e '\t\t' "System Motherboard Details"
    echo -e '\t' "----------------------------------"
    echo -e "Manufacturer" '\t\t\t\t' ":" `grep "Manufacturer" /tmp/baseboard.out|awk '{print $2}'`
    echo -e "Product Name" '\t\t\t\t' ":" `grep "Product Name" /tmp/baseboard.out|awk -F: '{print $2}'`
    echo -e "Version" '\t\t\t\t' ":" `grep "Version" /tmp/baseboard.out|awk '{print $2}'`
    echo -e "Serial Number" '\t\t\t\t' ":" `grep "Serial Number" /tmp/baseboard.out|awk -F: '{print $2}'`
    echo -e '\n'
#}

#details action for BIOS call
#bios_details()
#{
    echo -e '\t\t' "System BIOS Details"
    echo -e '\t' "----------------------------------"
    echo -e "BIOS Vendor" '\t\t\t\t' ":" `dmidecode -s bios-vendor`
    echo -e "BIOS Version" '\t\t\t\t' ":" `dmidecode -s bios-version`
    echo -e "BIOS Release Date" '\t\t\t' ":" `dmidecode -s bios-release-date`
    echo -e '\n'
#}

#details action call for processor
#proc_details()
#{
dmidecode --type processor > /tmp/proc.out

 echo -e '\t\t' "System Processor Details"
 echo -e '\t' "----------------------------------"
 echo -e "Manufacturer" '\t\t\t\t' ":" `grep "vendor_id" /proc/cpuinfo|uniq|awk -F: '{print $2}'`
 echo -e "Model Name" '\t\t\t\t' ":" `grep "model name" /proc/cpuinfo|uniq|awk -F: '{print $2}'`
 echo -e "CPU Family" '\t\t\t\t' ":" `grep "family" /proc/cpuinfo|uniq|awk -F: '{print $2}'`
 echo -e "CPU Stepping" '\t\t\t\t' ":" `grep "stepping" /proc/cpuinfo|awk -F":" '{print $2}'|uniq`

if [ -e /usr/bin/lscpu ]
then
{
 echo -e "No. Of Processors" '\t\t\t' ":" `lscpu|grep -w "Socket(s):"|awk -F":" '{print $2}'`
 echo -e "No. of Cores/Processor" '\t\t\t' ":" `lscpu|grep -w "Core(s) per socket:"|awk -F":" '{print $2}'`
}
else
{
 echo -e "No. Of Processors Found" '\t\t' ":" `grep -c processor /proc/cpuinfo`
}
fi


echo -e '\n'
#}


#details action call for memory
#mem_details()
#{
dmidecode --type memory > /tmp/mem.out
sed -n -e '/Memory Device/,$p' /tmp/mem.out > /tmp/memory-device.out

echo -e '\t\t' "System Memory Details (RAM)"
echo -e '\t' "----------------------------------"

echo -e "Total (Based On Free Command)" '\t\t' ":" $((`grep -w MemTotal /proc/meminfo|awk '{print $2}'`/1024))" MB" $((`grep -w MemTotal /proc/meminfo|awk '{print $2}'`/1024/1024))" GB"
#echo -e "Error Detecting Method" '\t\t' ":" `grep -w "Error Detecting Method" /tmp/mem.out|awk -F":" '{print $2}'`
#echo -e "Error Correcting Capabilities" '\t\t' ":" `grep -w -m1 "Error Correcting Capabilities" /tmp/mem.out|awk -F":" '{print $2}'`
echo -e "Maximum Capacity" '\t\t\t' ":"  `dmidecode --type memory |grep "Maximum Capacity" | awk '{print $3,$4}'`

echo -e "Number Of Devices" '\t\t\t' ":" `dmidecode --type memory |grep "Number Of Devices" | awk '{print $4}'`

echo -e "No. Of Memory Modules Found" '\t\t' ":" `dmidecode --type memory | grep -v "No Module Installed"| grep -c Size`

echo -e "Size of 1st Memory Module" '\t\t' ":" `dmidecode --type memory |grep -m1 "Size:" | awk '{print $2,$3}'`

echo -e "Type" '\t\t\t\t\t' ":" `dmidecode --type memory |grep -m2 "Type:" | tail -1 | awk '{print $2}'`
echo -e "Speed" '\t\t\t\t\t' ":" `dmidecode --type memory |grep -m1 "Speed:" | awk '{print $2,$3}'`
#}

#details action call to fetch PCI devices
#pci_details()
#{
    echo -e '\n\t\t' "PCI Controller(s) Found" '\t' '\t' '\t'
    echo -e '\t' "----------------------------------"

if command -v lspci >/dev/null 2>&1; then
    lspci | grep controller|awk -F":" '{print $2}'|sed -e 's/^....//'|awk '{ ... printf "%-10s\n", $1}'| grep -viE 'usb|vga' > /tmp/n1.txt;
    lspci | grep controller|awk -F":" '{print ":"$3}'|sed -e 's/^\s*//' -e '/^$/d' ... -e 's/^/\t\t\t/g'| grep -ivE 'usb|vga' > /tmp/n2.txt;
    paste -d" " /tmp/n1.txt /tmp/n2.txt|sort -u
else
    echo -e "\nlspci command is not found. Either it's a Cloud Server or VM."
fi

#}

#details action call to fetch Hard Disk Drive (HDD) details
#disk_details()
#{
# Print disk details header
echo -e "\n\t\tDisk Details\t\t\t"
echo -e "--------------------------------------------------------------"
printf "%-10s %-20s %s\n" "Device type" "Logical Name" "Size"
echo -e "--------------------------------------------------------------"

# Fetch disk details using lsblk command
lsblk -o TYPE,NAME,SIZE | awk '/disk/ {printf "%-10s %-20s %s\n", $1, $2, $3}' | sort

# Print details of each disk
echo -e "\n\t\tDetails Of Each Hard Drive(s) Found"

# Store the list of disk names in a static variable
disks=$(lsblk -o TYPE,NAME | awk '/disk/ {print $2}' | sort)

# Iterate over the list of disk names using a for loop
for name in $disks; do
    echo -e "\t--------------------------------------------------"
    echo -e "\t\t\tDisk $name"
    echo -e "\t--------------------------------------------------"

    # Fetch additional disk details using udevadm command
    udevadm info --query=all --name="/dev/$name" | grep -w "ID_MODEL\|ID_VENDOR" | awk -F"=" '{gsub("E: ID_", ""); print "\t"$1"\t\t\t:", $2}'

    # Fetch device path using readlink command
    device_path=$(readlink -f "/dev/$name")
    echo -e "\tDevice Path\t\t: $device_path"
done
echo -e "\n"

#}


#RAID Details for physical Server.
#raid_details() {
    # Check if it's an HP Server
    if [ "$(dmidecode -s system-manufacturer)" == "HP" ]; then
        echo -e '\n\t\t' "RAID controller Details for HP Server " '\t' '\t' '\t'
        echo -e '\t' "--------------------------------------------------"

        # Check if ssacli command is available
        if command -v ssacli >/dev/null 2>&1; then
            controller_id=$(ssacli ctrl all show | awk '{print $6}' | tr -d '\n')
            controller_name=$(ssacli ctrl all show | awk '{print $1,$2,$3}'|tr -d '\n')
            echo "Controller ID: $controller_id"
            echo -e "Controller Name: $controller_name\n"

            echo -e '\n\t\t' "Virtual Disks Details" '\t' '\t' '\t'
            echo -e '\t' "----------------------------------"
            vdisk_ids=$(ssacli controller slot=$controller_id logicaldrive all show | grep logicaldrive | awk '{print $2}')
            for vdisk_id in $vdisk_ids; do
                echo -e "Virtual Disk ID: $vdisk_id\n"
                ssacli controller slot=$controller_id logicaldrive $vdisk_id show detail 2>/dev/null | awk '/Logical Drive:|Size:|Fault Tolerance|Disk Name/ {if ($0 ~ /Size:/ && seen["Size"]++) next; print}'

                echo -e "\nPhysical Disks Belonging to Virtual Disk $vdisk_id:\n"
                ssacli controller slot=$controller_id logicaldrive $vdisk_id  show detail | grep -i physicaldrive
                echo -e '\t' "--------------------------------------------------\n"
            done
        # Check if hpssacli command is available
        elif command -v hpssacli >/dev/null 2>&1; then
            controller_id=$(hpssacli ctrl all show | awk '{print $6}' | tr -d '\n')
            controller_name=$(hpssacli ctrl all show | awk '{print $1,$2,$3}'|tr -d '\n')
            echo "Controller ID: $controller_id"
            echo -e "Controller Name: $controller_name\n"

            echo -e '\n\t\t' "Virtual Disks Details" '\t' '\t' '\t'
            echo -e '\t' "----------------------------------"
            vdisk_ids=$(hpssacli controller slot=$controller_id logicaldrive all show | grep logicaldrive | awk '{print $2}')
            for vdisk_id in $vdisk_ids; do
                echo -e "Virtual Disk ID: $vdisk_id\n"
                hpssacli controller slot=$controller_id logicaldrive $vdisk_id show detail 2>/dev/null | awk '/Logical Drive:|Size:|Fault Tolerance|Disk Name/ {if ($0 ~ /Size:/ && seen["Size"]++) next; print}'

                echo -e "\nPhysical Disks Belonging to Virtual Disk $vdisk_id:\n"
                hpssacli controller slot=$controller_id logicaldrive $vdisk_id  show detail | grep -i physicaldrive
                echo -e '\t' "--------------------------------------------------\n"
            done
        else
            echo "Neither ssacli nor hpssacli command found. Skipping HP server RAID details."
        fi
    fi

    # Check if it's a Dell Server
    if [ "$(dmidecode -s system-manufacturer)" == "Dell Inc." ]; then
        echo -e '\n\t\t' "RAID controller Details for Dell Server" '\t' '\t' '\t'
        echo -e '\t' "--------------------------------------------------"
        controller_id=$(omreport storage controller | awk '/^ID/ {print $3}')
        controller_name=$(omreport storage controller | grep -i name | cut -d ":" -f2 | awk '{$1=$1};1')
        echo "Controller ID: $controller_id"
        echo -e "Controller Name: $controller_name\n"

        echo -e "####  Virtual Disks Details ####\n"
        vdisk_ids=$(omreport storage vdisk | awk '/^ID/ {print $3}')
        for vdisk_id in $vdisk_ids; do
            echo -e "Virtual Disk ID: $vdisk_id\n"
            omreport storage vdisk controller=$controller_id vdisk=$vdisk_id | egrep -w 'ID|Name|Layout|^Size|Device Name'

            echo -e "\nPhysical Disks Belonging to Virtual Disk $vdisk_id:\n"
            omreport storage pdisk controller=$controller_id vdisk=$vdisk_id | egrep -w '^ID|Name|Capacity'
            echo -e '\t' "--------------------------------------------------\n"
        done
    elif [ "$(dmidecode -s system-manufacturer)" != "HP" ]; then
        echo -e "\nRAID details are not available for this server."
    fi
#}

#hba_details()
#{
# Check if there are files in /sys/class/fc_host
if [ -d "/sys/class/fc_host)" ]; then
echo -e '\n\t\t' "HBA card details" '\t' '\t' '\t'
echo -e '\t' "----------------------------------"
  lspci -nn | egrep -i 'hba|fibre'
 echo -e "\n" 

# Check if the necessary files exist in /sys/class/fc_host
    if [ -n "$(ls -A /sys/class/fc_host 2>/dev/null)" ] && [ -n "$(ls -A /sys/class/fc_host/host*/port_name 2>/dev/null)" ] && [ -n "$(ls -A /sys/class/fc_host/host*/port_state 2>/dev/null)" ] && [ -n "$(ls -A /sys/class/fc_host/host*/port_type 2>/dev/null)" ] && [ -n "$(ls -A /sys/class/fc_host/host*/device/fc_host/host*/port_id 2>/dev/null)" ]; then
        echo -e "\033[1;33mPort WWN\t\t\tPort Number\t\tPort State\033[0m"
        for host in /sys/class/fc_host/host*; do
            port_wwn=$(cat "$host/port_name")
            port_number=$(basename "$host")
            port_state=$(cat "$host/port_state")
            printf "%-15s\t\t%-15s\t\t%s\n" "$port_wwn" "$port_number" "$port_state"
        done
    else
        echo "Unable to find necessary files in /sys/class/fc_host"
    fi
else
    echo -e "\nHBA is not being used"
fi

#}

#details action call for footer
#foot_details()
#{
# echo -e "!!!!! If any of the above fields are marked as \"blank\" or \"NONE\" or \"UNKNOWN\" or \"Not Available\" or \"Not Specified\" that means either there is no value present in the system for these fields, otherwise that value may not be available !!!!!"
# echo -e "Wiping out temporarily created files under \"/tmp\" directory"'\t'"...DONE";
 rm -rf /tmp/n1.txt /tmp/n2.txt /tmp/n3.txt /tmp/baseboard.out /tmp/mem.out /tmp/memory-device.out;
 echo -e "\n";
#}

}
#hardware_details
#######calling above details actions #######

#function call_all_functions_hardware_details() {
#head_details
#os_details
#server_details
#mobo_details
#bios_details
#proc_details
#mem_details
#pci_details
#disk_details
#raid_details
#hba_details
#foot_details
#}
# Call the combined function
#call_all_functions_hardware_details
#exit

