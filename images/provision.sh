#!/bin/sh

PACKAGELIST='singularity git awscli tmux screen'

echo "Installing EPEL..."
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

echo "Updating repositories..."
sudo dnf -y update

echo "Installing packages..."
for package in $PACKAGELIST; do
    echo "  - $package..."
    sudo dnf -y install $package
done

echo "Performing system upgrade..."
sudo dnf -y upgrade

echo "Adding eessi user..."
sudo useradd -m -G wheel eessi
sudo mkdir /home/eessi/.ssh

# EESSI_SSH_KEYS is exported through packer.
sudo sh -c "echo \"$EESSI_SSH_KEYS\" > /home/eessi/.ssh/authorized_keys"

echo "Fixing permissions and ownership of ~eessi/.ssh"
sudo chmod 0700 /home/eessi/.ssh
sudo chown -R eessi:eessi /home/eessi/.ssh 

sudo su -c "echo 'eessi ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/eessi"
