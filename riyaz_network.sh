#!/bin/bash

network_details() {
# Function to print "NA" if the input is empty
print_or_na() {
   local value=$1
   if [ -z "$value" ]; then
       echo "-----"
   else
       echo "$value"
   fi
}

# Print Network Details table header
echo "Network Details:"
echo "================"
echo ""
echo "+---------------------------------------------------+"
echo "| Interface  |    IP Address    |     Gateway IP    |"
echo "+---------------------------------------------------+"

# Loop through each interface and display its details (excluding bonding_masters)
interfaces=$(ls /sys/class/net/)
for interface in $interfaces; do
   if [ "$interface" != "lo" ] && [ "$interface" != "bonding_masters" ]; then
       ip_addr=$(ip addr show dev $interface | awk '/inet / {print $2}')
       gateway_ip=$(ip route show dev $interface | awk '/default/ {print $3}')
       cidr=$(ip -o -f inet addr show dev $interface | awk '{print $NF}')

       printf "%-15s %-20s %-15s\n" "$interface" "$(print_or_na "$ip_addr")" "$(print_or_na "$gateway_ip")"
   fi
done


# Check if bonding is present and display Bonding Details table
echo ""
bonds=$(ls /sys/class/net/ | grep "bond")
if [ -n "$bonds" ]; then
   echo "Bonding Details:"
   echo "================="
   echo ""
   echo "----------------------------------------+"
   echo "| Master_Interface  |  Slave_Interfaces |"
   echo "+---------------------------------------+"
   for bond in $bonds; do
     if [ "$bond" != "bonding_masters" ]; then
       slave_interfaces=$(cat /sys/class/net/$bond/bonding/slaves)
       printf "%-25s %-70s\n" "$bond" "$(print_or_na "$slave_interfaces")"
     fi
   done
fi

echo ""
echo "DNS Servers:"
echo "===="
cat /etc/resolv.conf | grep nameserver | awk '{print $2}'
echo ""
echo "IP Routes:"
echo "========="
routes_ns=$(netstat -nr 2> /dev/null)
if [ $? -ne "0" ];then
ip r
else
echo "$routes_ns"
fi
}
#network_details
