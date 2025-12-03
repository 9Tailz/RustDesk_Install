#!/bin/bash

os=$(uname -s)

case $os in
    Linux)
        echo "OS is Linux"
        if grep -q "debian" /etc/os-release; then
            echo "OS is Debian"
            url=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | contains("x86_64.deb")) | .browser_download_url')
            echo $url
        
        elif grep -q "arch" /etc/os-release; then
            echo "OS is Arch"
            url=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | contains("x86_64.pkg.tar.zst")) | .browser_download_url')
            echo $url

        else
            echo "Not Valid Linux OS" 
        
        fi
        ;;
    
    Darwin)
        echo "OS is Mac"
        url=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | contains("x86_64.dmg")) | .browser_download_url')
        echo $url
        ;;
    
    *)
        echo "OS not Defined:" $OS
        exit 1
        ;;

esac

#Debain: curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | contains("x86_64.deb")) | .browser_download_url'

#Arch: curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | contains("x86_64.pkg.tar.zst")) | .browser_download_url'

#Mac: curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | contains("x86_64.dmg")) | .browser_download_url'

