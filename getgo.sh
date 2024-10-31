#!/bin/bash -e

# Script to download and install the latest version of Go on Debian/Ubuntu-based systems

go_ver="go1.23.2.linux-"

clear

echo -e "Select a CPU architecture (64-bit) : \n"
echo "1 : Intel / AMD (amd64)"
echo "2 : ARM64 (arm64)"
echo "3 : RISCV (riscv64)"

read -p "Enter your choice (1/2/3): " option

case $option in
    1)
        cpu_arch="amd64"
        ;;
    2)
        cpu_arch="arm64"
        ;;
    3)
        cpu_arch="riscv64"
        ;;
    *)
        echo -e "\nInvalid option. Please select 1, 2, or 3."
        exit 1
        ;;
esac

clear 

# Downloading Go
echo -e "Downloading Go... Please wait\n"
curl -sL "https://go.dev/dl/${go_ver}${cpu_arch}.tar.gz" -o "${go_ver}${cpu_arch}.tar.gz"
echo -e "\nDownloaded ${go_ver}${cpu_arch}.tar.gz successfully."

sleep 2S
clear

# Extracting Go to /usr/local
echo -e "Extracting Go to /usr/local (sudo / root access required)\n"
sudo tar -xzf "${go_ver}${cpu_arch}.tar.gz" -C /usr/local
echo -e "\nGo has been successfully extracted to /usr/local."

sleep 2
clear

export PATH=$PATH:/usr/local/go/bin

# Display Go version to confirm installation
echo -e "\nInstallation complete. Go version:"
go version

echo -e "\nAll done! Go has been installed successfully.\n"
exit 0