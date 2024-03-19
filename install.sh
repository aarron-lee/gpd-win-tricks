#!/usr/bin/bash
# installs the following:
# - PowerControl Decky Plugin
if [ "$EUID" -eq 0 ]
  then echo "Please do not run as root"
  exit
fi

VERSION=${VERSION_TAG:-"LATEST"}


echo "removing previous install if it exists"

cd $HOME

sudo rm -rf $HOME/homebrew/plugins/PowerControl

echo "installing PowerControl plugin for TDP control"

FINAL_URL='https://api.github.com/repos/mengmeet/PowerControl/releases/latest'
if [ $VERSION != "LATEST" ] ; then
  FINAL_URL="https://api.github.com/repos/mengmeet/PowerControl/releases/tags/${VERSION}"
fi

echo $FINAL_URL

# download + install plugin
curl -L $(curl -s "${FINAL_URL}" | grep "browser_download_url" | cut -d '"' -f 4) -o $HOME/PowerControl.tar.gz
sudo tar -xzf PowerControl.tar.gz -C $HOME/homebrew/plugins

# install complete, remove build dir
rm  $HOME/PowerControl.tar.gz
sudo systemctl restart plugin_loader.service

echo "Installation complete"
