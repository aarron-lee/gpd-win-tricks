#!/usr/bin/env bash

cd /tmp

git clone --depth=1 https://github.com/aarron-lee/gpd-win-tricks.git

cd /tmp/gpd-win-tricks/win2

if command -v nbfc &> /dev/null
then
    echo "nbfc command line utility is present."

    sudo mkdir -p /usr/local/share/nbfc/configs/
    sudo mkdir -p /etc/nbfc

    sudo cp WIN2.json /usr/local/share/nbfc/configs/
    sudo cp nbfc.json /etc/nbfc/

    echo "nbfc has been downloaded and installed"

    sudo nbfc config --set /usr/local/share/nbfc/configs/WIN2.json

    sudo systemctl enable nbfc_service.service
    sudo systemctl start nbfc_service.service

    echo "Installation complete!"
else
    echo "Getting nbfc from official github repo"
    RELEASE_URL=$(curl -s https://api.github.com/repos/nbfc-linux/nbfc-linux/releases/latest | grep "browser_download_url" | grep "fedora" | cut -d '"' -f 4)
    echo "Downloading $RELEASE_URL"
    curl -L $RELEASE_URL -o ./fedora-nbfc.rpm

    echo "nbfc command line utility is NOT present."
    sudo rpm-ostree install ./fedora-nbfc*.rpm

    rm ./fedora-nbfc.rpm

    echo "READ THIS: RERUN THIS SCRIPT AFTER REBOOTING FOR TO COMPLETE THE INSTALLATION!"
fi

sudo rm -rf /tmp/gpd-win-tricks
