#!/bin/bash

# Prompt for password
echo "Enter the password to decrypt the configuration string."
read password
echo  # To move to the next line after password input

# Decrypt the string
configstring=$(openssl enc -aes-256-cbc -d -in secret.env -base64 -pbkdf2 -pass "pass: $password")



# Check if decryption was successful
if [ $? -eq 0 ]; then
    echo "Decrypted String: $configstring"
else
    echo "Decryption failed. Please check your password."
fi
