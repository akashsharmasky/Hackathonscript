#!/bin/bash

# Fetch user details and sort by UID
user_script() {

user_details=$(cat /etc/passwd | sort -t ':' -k 3n)

# Prepare table headers for local users
printf "\nLocal users:\n"
printf "%-5s %-15s %-30s %-15s %-10s %-20s\n" "UID" "Username" "Home Directory" "Shell" "Sudo Access" "Last Login"
printf "%s\n" "==============================================================================="

# Process each line in user details for local users
while IFS=':' read -r username password uid gid user_info home_directory shell; do
   # Fetch sudo access
   sudo_access=$(sudo -l -U "$username" 2>/dev/null | grep -q '(ALL)' && echo "Yes" || echo "No")

   # Fetch last login
   last_login=$(lastlog -u "$username" -t 1 | awk 'NR==2 {print $4, $5, $6}')

   # Check UID conditions for local users
   if [[ "$uid" -ge 1000 ]] || [[ "$uid" -eq 0 ]]; then
       # Print user details for local users in tabular format
       printf "%-5s %-15s %-30s %-15s %-10s %-20s\n" "$uid" "$username" "$home_directory" "$shell" "$sudo_access" "$last_login"
   fi
done <<< "$user_details"

# Prepare table headers for system users
printf "\nSystem users:\n"
printf "%-5s %-15s %-30s %-15s %-10s %-20s\n" "UID" "Username" "Home Directory" "Shell" "Sudo Access" "Last Login"
printf "%s\n" "==============================================================================="

# Process each line in user details for system users
while IFS=':' read -r username password uid gid user_info home_directory shell; do
   # Fetch sudo access
   sudo_access=$(sudo -l -U "$username" 2>/dev/null | grep -q '(ALL)' && echo "Yes" || echo "No")

   # Fetch last login
   last_login=$(lastlog -u "$username" -t 1 | awk 'NR==2 {print $4, $5, $6}')

   # Check UID conditions for system users
   if [[ "$uid" -lt 1000 ]] && [[ "$uid" -ne 0 ]]; then
       # Print user details for system users in tabular format
       printf "%-5s %-15s %-30s %-15s %-10s %-20s\n" "$uid" "$username" "$home_directory" "$shell" "$sudo_access" "$last_login"
   fi
done <<< "$user_details"

# Fetch group details and sort by GID
group_details=$(cat /etc/group | sort -t ':' -k 3n)

# Prepare table headers for general groups
printf "\nGeneral groups:\n"
printf "%-5s %-25s %-s\n" "GID" "Group Name" "Users"
printf "%s\n" "============================================================"

# Process each line in group details for general groups
while IFS=':' read -r group_name password gid users; do
   # Check GID conditions for general groups
   if [[ "$gid" -ge 1000 ]] || [[ "$gid" -eq 0 ]]; then
       # Print group details for general groups in tabular format
       printf "%-5s %-25s " "$gid" "$group_name"

       # Print users belonging to the group
       IFS=',' read -ra user_list <<< "$users"
       for user in "${user_list[@]}"; do
           printf "%s " "$user"
       done

       printf "\n"
   fi
done <<< "$group_details"

# Prepare table headers for system groups
printf "\nSystem groups:\n"
printf "%-5s %-25s %-s\n" "GID" "Group Name" "Users"
printf "%s\n" "============================================================"

# Process each line in group details for system groups
while IFS=':' read -r group_name password gid users; do
   # Check GID conditions for system groups
   if [[ "$gid" -lt 1000 ]] && [[ "$gid" -ne 0 ]]; then
       # Print group details for system groups in tabular format
       printf "%-5s %-25s " "$gid" "$group_name"

       # Print users belonging to the group
       IFS=',' read -ra user_list <<< "$users"
       for user in "${user_list[@]}"; do
           printf "%s " "$user"
       done

       printf "\n"
   fi
done <<< "$group_details"

# Prepare table headers for SFTP details
printf "\nSFTP details:\n"
printf "%-15s %-10s %-15s\n" "Username" "SFTP" "Bind Mount"
printf "%s\n" "========================================="

# Process each line in user details for SFTP users
while IFS=':' read -r username password uid gid user_info home_directory shell; do
   # Check UID conditions for SFTP users
   if [[ "$uid" -eq 0 ]] || [[ "$uid" -eq 1000 ]] || [[ "$uid" -gt 1000 ]]; then
       # Check if user account is SFTP related
       if grep -qE "^Match User $username$|Subsystem\s+sftp" /etc/ssh/sshd_config; then
           # Fetch SFTP bind mount details
           sftp_bind_mount=$(grep -i "$username" /etc/fstab | awk '{print $1 "   " $2}')
           printf "%-15s %-10s %-15s\n" "$username" "Yes" "$sftp_bind_mount"
       else
           printf "%-15s %-10s %-15s\n" "$username" "NO" "No"
       fi
   fi
done <<< "$user_details"
}
#user_script
