#!/bin/bash

php_check () {

#!/bin/bash

# Check if OS is Ubuntu
if [[ -f /etc/lsb-release ]]; then
    source /etc/lsb-release
    if [[ "$DISTRIB_ID" == "Ubuntu" ]]; then
        echo "----------------"
        echo "Detected OS: Ubuntu"
        echo "----------------"
        echo ""
        echo "----------------"
        echo "Installed PHP versions:"
        echo "----------------"
        php_versions=$(dpkg -l | grep '^ii' | grep 'php' | awk '{print $2}' | cut -d':' -f2)
        echo "----------------"
        echo "$php_versions"
        echo "----------------"
        echo ""

        echo "----------------"
        echo "Installed PHP modules:"
        echo "----------------"
        php_modules=$(dpkg -l | grep '^ii' | grep 'php' | awk '{print $2}' | grep -v '^php[0-9].[0-9]-common$')
        echo "----------------"
        echo "$php_modules"
        echo "----------------"
        echo ""

        echo "Checking PHP-FPM pools:"
        if [[ -d /etc/php/$php_versions/fpm/pool.d ]]; then
            php_fpm_pools=$(ls /etc/php/$php_versions/fpm/pool.d/)
            echo "----------------"
            echo "$php_fpm_pools"
            echo "----------------"
        else
            echo "----------------"
            echo "No PHP-FPM pools found."
            echo "----------------"
        fi
    fi
fi

# Check if OS is CentOS
if [[ -f /etc/centos-release ]]; then
    echo "----------------"
    echo "Detected OS: CentOS"
    echo "----------------"
    echo ""
    echo "----------------"
    echo "Installed PHP versions:"
    echo "----------------"
    #php_versions=$(rpm -qa | grep 'php[0-9][0-9]*' | cut -d'-' -f1)
    php_versions=$(rpm -qa | grep ^php)
    echo "----------------"
    echo "$php_versions"
    echo "----------------"
    echo ""

    echo "Installed PHP modules:"
    php_modules=$(rpm -qa | grep 'php[0-9][0-9]*' | cut -d'-' -f1 | xargs php -m | uniq)
    echo "----------------"
    echo "$php_modules"
    echo "----------------"
    echo ""

    echo "Checking PHP-FPM pools:"
    if [[ -d /etc/php-fpm.d ]]; then
        php_fpm_pools=$(ls /etc/php-fpm.d/)
        echo "----------------"
        echo "$php_fpm_pools"
        echo "----------------"
    else
        echo "No PHP-FPM pools found."
    fi
fi

# Check if OS is Debian
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" == "debian" ]]; then
        echo "----------------"
        echo "Detected OS: Debian"
        echo "----------------"
        echo ""
        echo "----------------"
        echo "Installed PHP versions:"
        echo "----------------"
        php_versions=$(dpkg -l | grep '^ii' | grep 'php' | awk '{print $2}' | cut -d':' -f2)
        echo "----------------"
        echo "$php_versions"
        echo "----------------"
        echo ""

        echo "----------------"
        echo "Installed PHP modules:"
        echo "----------------"
        php_modules=$(dpkg -l | grep '^ii' | grep 'php' | awk '{print $2}' | grep -v '^php[0-9].[0-9]-common$')
        echo "----------------"
        echo "$php_modules"
        echo "----------------"
        echo ""

        echo "Checking PHP-FPM pools:"
        if [[ -d /etc/php/$php_versions/fpm/pool.d ]]; then
            php_fpm_pools=$(ls /etc/php/$php_versions/fpm/pool.d/)
            echo "----------------"
            echo "$php_fpm_pools"
            echo "----------------"
        else
            echo "----------------"
            echo "No PHP-FPM pools found."
            echo "----------------"
        fi
    fi
fi
}

#php_check
