#!/bin/bash

# Script: data_details.sh
# Author: Akash Sharma
# Date: July 24, 2023
# Description: This script collects information about the data stored on the server, including Website Data, Disk Usage, Database Usage Data, etc.



data_details()
{
# File System Usage Details

echo -e =======================================
echo -e "\tFile System Usage Details"
echo -e "=======================================\n"
# Get the list of mounted filesystems
fs_list=$(df -T | awk '{print $1,$2,$3,$4,$5,$7}')

# Print the header
printf "%-15s %5s %5s %8s\n" "Filesystem" "used+reserved" "Size" "Type"

# Loop through each filesystem
while read -r fs type used avail percent mount; do
  # Skip the header line
  if [ "$fs" == "Filesystem" ]; then
    continue
  fi

  # Skip the tmpfs and devtmpfs types
  if [ "$type" == "tmpfs" ] || [ "$type" == "devtmpfs" ]; then
    continue
  fi

  # Convert the size and used+reserved values from KB to GB
  size_gb=$(echo "scale=1; $((used + avail)) / 1024 / 1024" | bc)
  used_gb=$(echo "scale=1; $used / 1024 / 1024" | bc)

  # Calculate the percentage of used+reserved space
  percent=$(echo "scale=0; $used_gb * 100 / $size_gb" | bc)

  # Print the formatted output
  printf "%-15s %3d%% of %10.1f GiB (%s)\n" "$mount" "$percent" "$size_gb" "$type"
done <<< "$fs_list"




echo -e "\n\nWebsite Data Size by Domain Name"
echo -e "=======================================\n"
if command -v apachectl &>/dev/null; then
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        if [[ $ID == "ubuntu" || ($ID == "centos" && $VERSION_ID == "7") ]]; then
            # Ubuntu or CentOS 7
            domains=$(apachectl -S 2>/dev/null | grep -i namevhost | awk '{print $4}')
            echo "======================================="
            echo "Domains                        Size"
            echo -e "======================================="
            for domain in $domains; do
                document_root=$(apachectl -S 2>/dev/null | grep -i namevhost | grep -i $domain | awk '{print $NF}' | cut -d '(' -f 2 | cut -d ':' -f 1 | xargs -I {} grep -im1 "DocumentRoot" {} | awk '{print $2}')
                if [[ -d $document_root ]]; then
                    size=$(du -sh $document_root 2>/dev/null | awk '{print $1}')
                    printf "%-30s %s\n" "$domain" "$size"
                fi
            done
        elif [[ $ID_LIKE =~ "rhel" && $PLATFORM_ID == "platform:el8" ]]; then
            # EL8-based OS (including AlmaLinux)
            domains=$(apachectl -S 2>/dev/null | grep -i '80\|443' | awk '{print $2}' | egrep -v 'localhost|127.0.0.1')
            echo "======================================="
            echo "Domains                        Size"
            echo -e "======================================="
            for domain in $domains; do
                document_root=$(apachectl -S 2>/dev/null | grep -i '80\|443' | grep -i $domain | awk '{print $NF}' | cut -d '(' -f 2 | cut -d ':' -f 1 | xargs -I {} grep -im1 "DocumentRoot" {} | awk '{print $2}')
                if [[ -d $document_root ]]; then
                    size=$(du -sh $document_root 2>/dev/null | awk '{print $1}')
                    printf "%-30s %s\n" "$domain" "$size"
                fi
            done
        fi
    elif [[ -d /etc/nginx/sites-enabled ]]; then
        # Nginx
        for file in /etc/nginx/sites-enabled/*; do
            if [[ -f $file ]]; then
                domain=$(grep -oP 'server_name \K\S+' $file)
                document_root=$(grep -oP 'root \K\S+' $file)
                if [[ -d $document_root ]]; then
                    size=$(du -sh $document_root 2>/dev/null | awk '{print $1}')
                    echo "$domain: $size"
                fi
            fi
        done
    else
        echo -e "\nError: Could not find Apache or Nginx configuration files.\n"
    fi
fi


# Check if MySQL service is running
if systemctl is-active --quiet mysql; then
    # Check if the MySQL credential file is present
    if [ -f /root/.my.cnf ]; then
        # Print database version
        echo -e "Database Version"
        echo -e "================================\n"
        mysql -V
        echo -e "\n"

        # Print database name and size
        echo -e "Database Name and Size"
        echo -e "================================\n"
        mysql -e "SELECT table_schema AS \"Database\", ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS \"Size (MB)\" FROM information_schema.tables GROUP BY table_schema;"
        echo -e "\n"

        # Print InnoDB and MyISAM details from a size point of view
        echo -e "InnoDB and MyISAM details from a size point of view"
        echo -e "=======================================================\n"
        mysql -e "SELECT TABLE_SCHEMA, ENGINE, ROUND(SUM(DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS \"Size (MB)\" FROM information_schema.tables WHERE ENGINE IN ('InnoDB', 'MyISAM') GROUP BY TABLE_SCHEMA, ENGINE;"

        # Check and print the size of other hosted data except website data
        # echo "Other hosted data:"
        # du -sh /path/to/other/hosted/data/* 2>/dev/null | awk '{print $2 ": " $1}'
    else
        echo "MySQL credential file /root/.my.cnf is not available."
    fi
else
    echo -e "\nMySQL service is not running. Skipping tasks.\n"
fi

}
