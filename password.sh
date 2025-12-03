#!/bin/bash

$encrypted_string="U2FsdGVkX1/Ign+br1E73Jez5YpnipPlBwpi8m5A1F/X4Pcihy+NpgpMBKl+ZLR2
D3XbeoRlIGW4puEcNNvGFUT7i7Kq0I+U7t5rIxLOzMjXu3agmV29jW9M9cjsyjGh
83zKE4NwLyVjb4j8yebJ0rQsv/d0h3XtI0fX/xeNkrO2K9OO1p/kEk7zbOvTSTqj
TnYWBKKk9IDOthTeKfpkQMftevmCCydGXHwWjq1BrkI="

# Prompt for password
read -sp "Enter password for decryption: " password
echo  # To move to the next line after password input

# Decrypt the string
$configstring=echo "$encrypted_string" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:"$password" 2>/dev/null

# Check if decryption was successful
if [ $? -eq 0 ]; then
    echo "Decrypted String: $configString"
else
    echo "Decryption failed. Please check your password."
fi