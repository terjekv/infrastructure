#!/bin/sh

PACKAGELIST='ansible singularity git awscli tmux screen'

echo "Installing EPEL..."
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

echo "Updating repositories..."
sudo dnf -y update

echo "Installing packages..."
for package in $PACKAGELIST; do
    echo "  - $package..."
    sudo dnf -y install $package
done

# This only supports x86_64 and ARM:
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf -y install gh

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

echo "Installing eessi software"
# sudo mkdir /usr/local/bin
sudo curl --silent -o /usr/local/bin/eessi-upload-to-staging https://raw.githubusercontent.com/EESSI/infrastructure/main/eessi-upload-to-staging
sudo chmod a+rx /usr/local/bin/eessi-upload-to-staging
