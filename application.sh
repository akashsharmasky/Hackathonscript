#!/bin/bash

check_application () {

echo "***********************************************************************************
This part of script help us to get the information on Running applications on the server.
*****************************************************************************************"

apache=$(systemctl status httpd.service 2>/dev/null)
mysql=$(systemctl status mariadb.service 2>/dev/null)
phpfpm=$(systemctl status php-fpm.service 2>/dev/null)
nginx=$(systemctl status nginx.service 2>/dev/null)
iptables=$(systemctl status iptables.service 2>/dev/null)
postfix=$(systemctl status postfix.service 2>/dev/null)
varnish=$(systemctl status varnish.service 2>/dev/null)
redis=$(systemctl status redis 2>/dev/null)
tomcat=$(ps -ef | awk '/[t]omcat/{print $2}' 2>/dev/null)
armor=$(systemctl status armor-agent.service 2>/dev/null)
sophos=$(/opt/sophos-av/bin/savdstatus 2>/dev/null)

if [ -f /etc/redhat-release ]
then
        echo "OS is Redhat/Centos"
        if [[ $apache == *"active (running)"* ]];
        then
                echo "Found a http service on the server:$(httpd -v | grep 'Server version')"
        else
                echo "Not found httpd on the server."
        fi

        if [[ $mysql == *"active (running)"* ]];
        then
                echo "Found a MySQL service on the server:$(mysql -V)"
        else
                echo "Not found MySQL on the server."
        fi

        if [[ $phpfpm == *"active (running)"* ]];
        then
                echo "PHP-FPM is running on the server:$(php-fpm -v | grep fpm)"
        else
                echo "Not found PHP-FPM on the server."
        fi

        if [[ $nginx == *"active (running)"* ]];
        then
                echo "Nginx is running on the server."
        else
                echo "Not found Nginx on the server."
        fi

        if [[ $iptables == *"active (running)"* ]];
        then
                echo "Iptables is running on the server."
        else
                echo "Not found IPtables On the server."
        fi

        if [[ $postfix == *"active (running)"* ]];
        then
                echo "Postfix is running on the server."
        else

                echo "Not found Postfix on the server."
        fi

        if [[ $varnish == *"active (running)"* ]];
        then
                echo "Varnish is running on the server."
#               echo "$(varnishd -V | grep varnishd)"
        else
                echo "Not found Varnish on the server."
        fi
        if [[ $redis == *"active (running)"* ]];
        then
                echo "Redis is running on the server."
        else
                echo "Not found redis on the server."
        fi

        if [ -z "$tomcat" ]
        then
            echo "Tomcat is not running on the server."
        else
            echo "Tomcat is running on the server."
        fi
        if [[ $sophos == *"active"* ]]
        then
            echo "Sophos is installed on the server."
        else
            echo "Sophos is not installed on the server."
        fi
        if [[ $sophos == *"active"* ]]
        then
            echo "Armor is installed on the server."
        else
            echo "Armor is not installed on the server."
        fi

fi

Uapache=$(systemctl status apache2.service 2>/dev/null)
Umysql=$(systemctl status mysql.service 2>/dev/null)
Uphpfpm=$(systemctl status php8.1-fpm.service 2>/dev/null)
Unginx=$(systemctl status nginx.service 2>/dev/null)
Ufw=$(ufw status 2>/dev/null)
Upostfix=$(systemctl status postfix 2>/dev/null)
Uvarnish=$(systemctl status varnish.service 2>/dev/null)
Uredis=$(systemctl status redis 2>/dev/null)
Utomcat=$(ps -ef | awk '/[t]omcat/{print $2}' 2>/dev/null)
Uarmor=$(systemctl status armor-agent.service 2>/dev/null)
Usophos=$(/opt/sophos-av/bin/savdstatus 2>/dev/null)

if [[ -f /etc/lsb-release && $(grep -c "Ubuntu" /etc/lsb-release) -gt 0 ]]
then
        echo "OS is Ubuntu"
        if [[ $Uapache == *"active (running)"* ]];
        then
                echo "Found a http service on the server:$(apache2 -V | grep 'Server version' 2>/dev/null)"
        else
                echo "Not found httpd on the server."
        fi

        if [[ $Umysql == *"active (running)"* ]];
        then
                echo "Found a MySQL service on the server:$(mysql -V)"
        else
                echo "Not found MySQL on the server."
        fi

        if [[ $Uphpfpm == *"active (running)"* ]];
        then
                echo "PHP-FPM is running on the server."
        else
                echo "Not found PHP-FPM on the server."
        fi

        if [[ $Unginx == *"active (running)"* ]];
        then
                echo "Nginx is running on the server:$(nginx -v)"
        else
                echo "Not found Nginx on the server."
        fi

        if [[ $Ufw == *"active"* ]];
        then
                echo "UFW is running on the server."
        else
                echo "Not found UFW on the server."
        fi

        if [[ $Upostfix == *"active"* ]];
        then
                echo "Postfix is running on the server."
        else

                echo "Not found Postfix on the server."
        fi

        if [[ $Uvarnish == *"active (running)"* ]];
        then
                echo "Varnish is running on the server."
                echo "$(varnishd -V | grep varnishd)"
        else
                echo "Not found Varnish on the server."
        fi

        if [[ $Uredis == *"active (running)"* ]];
        then
                echo "Redis is running on the server."
        else
                echo "Not found redis on the server."
        fi

        if [ -z "$Utomcat" ]
        then
            echo "Tomcat is not running on the server."
        else
            echo "Tomcat is running on the server."
        fi
        if [[ $Usophos == *"active"* ]]
        then
            echo "Sophos is installed on the server."
        else
            echo "Sophos is not installed on the server."
        fi
        if [[ $Uarmor == *"active"* ]]
        then
            echo "Armor is installed on the server."
        else
            echo "Armor is not installed on the server."
        fi
fi

}

#check_application
