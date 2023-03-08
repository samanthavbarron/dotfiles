#!/bin/bash

# Usage -- note quotes on last part
# ./deploy_key.sh pearl ~/.ssh/id_rsa_ipad.pub "~/.ssh/authorized_keys"

# Variables
target_host="$1"
ssh_pub_key_path="$2"
auth_key_path="$3"

ssh_pub_key="$(cat $ssh_pub_key_path)"

#ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"
#auth_key_path="~/.ssh/authorized_keys"

echo "Deploying key: ${ssh_pub_key:0:25}..."
echo "Looking in $auth_key_path"

# Get hostnames from current machine, validate ssh hostname
hosts=$(cat ~/.ssh/config | grep "Host " | sed "s/Host //")
if [[ $hosts == *"$target_host"* ]]; then
    true
else
    echo "Invalid host given: $target_host"
fi

# Execute command on target host
function ssh_exec() {
    ssh $target_host "$1 2>/dev/null || exit 100"
}

##########################################################
# Main script: Get $ssh_pub_key from current machine into
# $auth_key_path on remote
##########################################################

# Check if $auth_key_path exists on remote.
# If it doesn't, error.

res=1
ssh_exec "cat $auth_key_path" >> /dev/null && res=0

if [[ "$res" == 0 ]]; then
    echo "Found authorized_keys file"
else
    echo "No authorized_keys file found, exiting"
    exit 1
fi

# Check if $ssh_pub_key already present in $auth_key_path
# If it does, quit
if [[ -z $(ssh_exec "cat $auth_key_path | grep \"$ssh_pub_key\"") ]]; then
    echo "Key not already present in authorized_keys file, adding"
else
    echo "Key already present in authorized_keys file, exiting"
    exit 0
fi

# Append $ssh_pub_key to the end of $auth_key_path

ssh_exec "echo \"$ssh_pub_key\" >> $auth_key_path"

echo "Key deployed"
