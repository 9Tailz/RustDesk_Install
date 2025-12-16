#!/bin/bash


# openssl enc -aes-256-cbc -e -in text.txt -out secret.env -base64 -pbkdf2 -pass "pass: password"

openssl enc -aes-256-cbc -e -in config.txt -out secret.env -base64 -pbkdf2 -pass "pass: password"
