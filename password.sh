#!/bin/bash

# Prompt for password
echo "Enter the password to decrypt the configuration string."
read -s password
echo  # To move to the next line after password input

# Decrypt the string
configstring=$(openssl enc -aes-256-cbc -d -in secret.enc -base64 -pbkdf2 -pass "pass: $password")
configpassword=$(openssl enc -aes-256-cbc -d -in secret2.enc -base64 -pbkdf2 -pass "pass: $password")

# Check if decryption was successful
if [ $? -eq 0 ]; then
    echo "Decrypted Successfully."
    echo "Running RustDesk Config..."

    rustdesk --config $configstring
    rustdesk --password $configpassword

else
    echo "Decryption failed. Please check your password."
fi
