#!/bin/bash

# Assign a random value to the password variable
$rustdesk_pw="1amGh0st1ine"

$encrypted_string="U2FsdGVkX1/Ign+br1E73Jez5YpnipPlBwpi8m5A1F/X4Pcihy+NpgpMBKl+ZLR2
D3XbeoRlIGW4puEcNNvGFUT7i7Kq0I+U7t5rIxLOzMjXu3agmV29jW9M9cjsyjGh
83zKE4NwLyVjb4j8yebJ0rQsv/d0h3XtI0fX/xeNkrO2K9OO1p/kEk7zbOvTSTqj
TnYWBKKk9IDOthTeKfpkQMftevmCCydGXHwWjq1BrkI="

read -sp "Enter password for decryption: " password
echo

# Get your config string from your Web portal and Fill Below
$rustdesk_cfg=echo "$encrypted_string" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:"$password" 2>/dev/null

################################## Please Do Not Edit Below This Line #########################################

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Identify OS
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID

    UPSTREAM_ID=${ID_LIKE,,}

    # Fallback to ID_LIKE if ID was not 'ubuntu' or 'debian'
    if [ "${UPSTREAM_ID}" != "debian" ] && [ "${UPSTREAM_ID}" != "ubuntu" ]; then
        UPSTREAM_ID="$(echo ${ID_LIKE,,} | sed s/\"//g | cut -d' ' -f1)"
    fi

elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian, Ubuntu, etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSE-release ]; then
    # Older SuSE etc.
    OS=SuSE
    VER=$(cat /etc/SuSE-release)
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    OS=RedHat
    VER=$(cat /etc/redhat-release)
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

# Install RustDesk

echo "Installing RustDesk"
if [ "${ID}" = "debian" ] || [ "$OS" = "Ubuntu" ] || [ "$OS" = "Debian" ] || [ "${UPSTREAM_ID}" = "ubuntu" ] || [ "${UPSTREAM_ID}" = "debian" ]; then
    url=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep -o '"browser_download_url": *"[^"]*\x86_64.deb"' | sed 's/"browser_download_url": "//;s/"//g')
    packagename=${url##*/}
    wget $url
    apt-get install -fy ./$packagename > null
elif [ "$OS" = "CentOS" ] || [ "$OS" = "RedHat" ] || [ "$OS" = "Fedora Linux" ] || [ "${UPSTREAM_ID}" = "rhel" ] || [ "$OS" = "Almalinux" ] || [ "$OS" = "Rocky*" ] ; then
    url=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep -o '"browser_download_url": *"[^"]*\x86_64.rpm"' | sed 's/"browser_download_url": "//;s/"//g')
    packagename=${url##*/}
    wget $url
    yum localinstall ./rustdesk-1.2.6-0.x86_64.rpm -y > null
else
    echo "Unsupported OS"
    # here you could ask the user for permission to try and install anyway
    # if they say yes, then do the install
    # if they say no, exit the script
    exit 1
fi

# Run the rustdesk command with --get-id and store the output in the rustdesk_id variable
rustdesk_id=$(rustdesk --get-id)

# Apply new password to RustDesk
sudo rustdesk --password $rustdesk_pw &> /dev/null

sudo rustdesk --config $rustdesk_cfg

sudo systemctl restart rustdesk

echo "..............................................."
# Check if the rustdesk_id is not empty
if [ -n "$rustdesk_id" ]; then
    echo "RustDesk ID: $rustdesk_id"
else
    echo "Failed to get RustDesk ID."
fi

# Echo the value of the password variable
echo "Password: $rustdesk_pw"
echo "..............................................."