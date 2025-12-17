#!/bin/bash


# openssl enc -aes-256-cbc -e -in text.txt -out secret.env -base64 -pbkdf2 -pass "pass: password"

openssl enc -aes-256-cbc -e -in paswd.txt -out secret2.enc -base64 -pbkdf2 -pass "pass: asdasd1032"
