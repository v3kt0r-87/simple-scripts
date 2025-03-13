#!/bin/bash -e

# Colors for output formatting
green="\e[32m"
red="\e[31m"
nocolor="\e[0m"

# Paths to DXVK and VKD3D source repositories
dxvk_path="/mnt/Others/projects/vulkan/DXVK-LLVM_MINGW"
vkd3d_path="/mnt/Others/projects/vulkan/VKD3D_LLVM-Mingw"

# Paths where built files will be copied
dxvk_copy_path="/home/$(whoami)/Downloads/"
vkd3d_copy_path="/home/$(whoami)/Downloads/"

# List of required dependencies
deps="git meson ninja-build python3-pip python3-setuptools python3-wheel python3-mako \
zip curl flex bison patchelf glslang-tools libdisplay-info-dev libdisplay-info1 python-is-python3"

deps_missing=0

clear

echo -e "\nThis script will build DXVK and VKD3D on your system using LLVM-Mingw \n"
echo -e "It will take a while to complete, so please be patient.\n\n"

echo "Checking dependencies..."

# Check for each dependency and install if missing
for dep in $deps; do
    sleep 0.25
    if command -v "$dep" >/dev/null 2>&1 || dpkg -l | grep -qw "$dep"; then
        echo -e "$green - $dep found $nocolor"
    else
        echo -e "$red - $dep not found, installing... $nocolor"
        deps_missing=1
    fi
done

# Install missing dependencies
if [ "$deps_missing" -eq 1 ]; then
    echo -e "\nInstalling missing dependencies..."
    sudo apt update && sudo apt install -y $deps
fi

echo -e "\nAll dependencies are installed."
sleep 2s
clear

echo -e "Building DXVK using LLVM-Mingw\n"

# Navigate to DXVK repository and update it
cd "$dxvk_path" || { echo -e "$red Failed to change directory to $dxvk_path $nocolor"; exit 1; }
git pull && git submodule update

# Clean up previous build and start a new build
rm -rf DXVK && ./package-release.sh master DXVK --no-package

# Copy the built files to the designated path
cd DXVK && cp -r dxvk-master "$dxvk_copy_path" || { echo -e "$red Failed to copy DXVK to $dxvk_copy_path $nocolor"; exit 1; }

echo -e "\nDXVK build completed successfully\n"

clear

echo -e "Building VKD3D using LLVM-Mingw\n"

# Navigate to VKD3D repository and update it
cd "$vkd3d_path" || { echo -e "$red Failed to change directory to $vkd3d_path $nocolor"; exit 1; }
git pull && git submodule update

# Clean up previous build and start a new build
rm -rf VKD3D && ./package-release.sh master VKD3D --no-package

# Copy the built files to the designated path
cd VKD3D && cp -r vkd3d-proton-master "$vkd3d_copy_path" || { echo -e "$red Failed to copy VKD3D to $vkd3d_copy_path $nocolor"; exit 1; }

echo -e "\nVKD3D build completed successfully\n"

clear

echo -e "DXVK and VKD3D build completed successfully\n"
echo -e "DXVK and VKD3D are copied to $vkd3d_copy_path \n"

exit 0
