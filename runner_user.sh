#!/bin/bash
# Copyright (C) 2019 The Raphielscape Company LLC.
#
# Licensed under the Raphielscape Public License, Version 1.b (the "License");
# you may not use this file except in compliance with the License.
#
# CI Runner Script for Generation of blobs

# We need this directive
# shellcheck disable=1090


##### Build Env Dependencies
build_env()
{
. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"/telegram
TELEGRAM_TOKEN=$(cat /tmp/tg_token)
export TELEGRAM_TOKEN
tg_sendinfo "<code>[MaestroCI]: GCC-10 Compiler Job rolled!</code>"
cd ~
git clone https://github.com/akhilnarang/scripts > /dev/null 2>&1
cd scripts
bash setup/android_build_env.sh  > /dev/null 2>&1
cd ..
rm -rf scripts
git clone https://github.com/crosstool-ng/crosstool-ng
cd crosstool-ng
./bootstrap
./configure
make -j$(nproc)
sudo make install
cd ..
rm -rf crosstool-ng
echo "Build Dependencies Installed....."
}
##### Build Configs

build_conf()
{
mkdir repo
cd repo
git config --global user.email "baalajimaestro@computer4u.com"
git config --global user.name "baalajimaestro"
export LOC=$(cat /tmp/loc)
}

run()
{
git clone https://github.com/baalajimaestro/ct-ng-configs -b GCC-10
cd ct-ng-configs
ct-ng build
}

##### Here's the blecc megik
push()
{
sudo chmod -R 777 $HOME/x-tools
cd $HOME/x-tools/aarch64-maestro-linux-gnu
git init
git add .
git checkout -b $(date +%d%m%y)
git commit -m "[MaestroCI]: GCC-10 $(date +%d%m%y)" --signoff
git remote add origin https://baalajimaestro:$(cat /tmp/GH_TOKEN)@github.com/baalajimaestro/aarch64-maestro-linux-android.git
git push --force origin $(date +%d%m%y)
tg_sendinfo "<code>Checked out and pushed GCC-10</code>"
echo "Job Successful!"
}

build_env
build_conf
run
push