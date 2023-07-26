#!/bin/bash

#sourcing all contributers scripts
source ./riyaz_user.sh
source ./riyaz_network.sh
source ./Resource_Utilization.sh
source ./PCS_Status.sh
source ./php_check.sh
source ./vhost_check.sh
source ./hardware_details.sh
source ./data_details.sh
source ./application.sh
echo "Data gathering script Version 1.0.0"
echo ""
echo "What data are you interested in?"
echo ""
echo "1 - User, group, network details" 
echo "2 - Hardware Specs"
echo "3 - Data hosting metrics and attributes"
echo "4 - Resource utilization Specs"
echo "5 - PCS cluster Stats"
echo "6 - PHP config stats"
echo "7 - Apache config stats"
echo "8 - Show what all applications are running on the server"
echo "9 - Show all stats which are available"
read option;
case $option in
  1) user_script
     network_details
  ;;
  2) hardware_details;;
  3) data_details ;;
  4) get_cpu_memory_utilization  ;;
  5) check_pcs_cluster ;;
  6) php_check ;;
  7) vhost_check ;;
  8) check_application ;; 
  9) user_script
     network_details
     hardware_details
     data_details
     get_cpu_memory_utilization
     check_pcs_cluster
     php_check
     vhost_check
     check_application
     ;;
  *) echo "Invalid option. Please choose a correct one.";; 
esac
