#!/bin/bash
#
# SPDX-FileCopyrightText: 2021 UdS AES <https://www.uni-saarland.de/lehrstuhl/frey.html>
# SPDX-License-Identifier: Unlicense

# Unset whatever was configured before
# https://stackoverflow.com/a/52128244
unset ${!PROVISION_@}

# Prepare directory for file exchange with VM
DIRECTORY_XFER=./xfer
if [ ! -d $DIRECTORY_XFER ]; then
  mkdir $DIRECTORY_XFER
fi

# Provision the virtual machine and install GUI
export PROVISION_FIRST_RUN="true"
vagrant up --provision

# Make user login once so disabling the GNOME default folders works
echo -n "Did you login at least once (credentials \`vagrant\`/\`vagrant\`)? y/n: "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
  echo "Ok, continuing..."
  vagrant halt
else
  echo "That's required! Aborting. Try again."
  exit 1
fi

# Verify that directory `./linux_x86_64` exists
DIRECTORY_INSTALL=./linux_x86_64
if [ ! -d $DIRECTORY_INSTALL ]; then
  echo "Copy `linux_x86_64/` from the Dymola installation files to `./linux_x86_64`! Aborting."
  exit 1
fi

# Install Dymola
export PROVISION_FIRST_RUN="false"
export PROVISION_MOUNT_VAGRANT="true"

vagrant up --provision
vagrant halt

unset ${!PROVISION_@}

# Done!
echo "Done! Boot the VM using \`vagrant up\`"
echo "Then, login with credentials \`vagrant\`/\`vagrant\`"
