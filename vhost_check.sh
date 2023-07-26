#!/bin/bash

vhost_check () {
# Check if Apache or Nginx is running
if systemctl is-active --quiet apache2; then
  web_server="Apache"
elif systemctl is-active --quiet nginx; then
  web_server="Nginx"
elif systemctl is-active --quiet httpd; then
  web_server="httpd"
else
  echo "No Webserver Found!"
  exit 1
fi

echo "-----------------"
echo "Web server: $web_server"
echo "-----------------"
echo ""

echo "List of Domains hosted on this server:"
echo ""

# Grep domain names from vhost config files

for i in `apachectl -S 2>/dev/null | awk '/^[[:space:]]*.*namevhost/ {print $NF}' | sort -u | cut -d : -f 1 | cut -c 2- | tr ' ' '\n'`;
do
domain=$(grep -hiRoE "ServerName\s+([a-zA-Z0-9.-]+)" $i | sed -E "s/ServerName\s+(.+)/\1/" | uniq)

# Function to check if the 'dig' command is available
check_dig_command() {
    if ! command -v dig &> /dev/null; then
        echo "The 'dig' command does not exist."
        echo "Please make sure 'dig' is installed on your system and re-run the script."
        exit 1
    fi
}

# Call the function to check if 'dig' is available
check_dig_command

# Fetch A records for each domain using dig
  echo "Domain Name: $domain"
  a_record=$(dig +short "$domain" A)

  if [ -n "$a_record" ]; then
    echo "-----------------------"
    echo "$domain points to IP: $a_record"
    echo "-----------------------"
    echo ""
  else
    echo "Failed to fetch A record for $domain"
  fi
done
}

#vhost_check
