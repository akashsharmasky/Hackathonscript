#!/bin/bash

# Function to check the status of the PCS cluster
check_pcs_cluster() {
    echo "===== PCS Cluster Status ====="

    # Check if pcs command is available
    if ! command -v pcs &> /dev/null; then
        echo "Error: PCS command-line utility not found. Please install PCS (Pacemaker/Corosync) on this system."
        return 1
    fi

    # Check if the current user has sufficient privileges (root) to run the pcs command
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This script requires root privileges. Please run it as root or with sudo."
        return 1
    fi

    # Determine the package manager and service management commands
    if command -v yum &> /dev/null; then
        pkg_manager="yum"
        service_cmd="service"
    elif command -v apt &> /dev/null; then
        pkg_manager="apt"
        service_cmd="systemctl"
    else
        echo "Error: Unsupported package manager. Please use yum (RHEL) or apt (Ubuntu)."
        return 1
    fi

    # Check if corosync service is running
    if ! $service_cmd is-active corosync &> /dev/null; then
        echo "Corosync is not running."
    else
        echo "Corosync is running."
    fi

    # Check if pacemaker service is running
    if ! $service_cmd is-active pacemaker &> /dev/null; then
        echo "Pacemaker is not running."
    else
        echo "Pacemaker is running."
    fi

    # Display the status of the cluster nodes
    echo "Cluster Nodes:"
    pcs status nodes

    # Display the status of cluster resources
    echo "Cluster Resources:"
    pcs status resources

    # Display resource details
    echo "Resource Details:"
    pcs resource show

    echo "===== End of PCS Cluster Status ====="
}

# Call the function to check the PCS cluster status
#check_pcs_cluster
