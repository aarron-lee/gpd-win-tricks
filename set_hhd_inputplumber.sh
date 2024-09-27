#/bin/bash

# must install InputPlumber rpm and steam-powerbuttond
# curl -L https://raw.githubusercontent.com/ShadowBlip/steam-powerbuttond/refs/heads/main/bazzite_install.sh | sh

if [[ "$1" == "hhd" ]]; then
    sudo systemctl disable --now steam-powerbuttond
    sudo systemctl disable --now inputplumber.service
    sudo udevadm control --reload-rules
    sudo udevadm trigger

    sudo systemctl unmask hhd@$(whoami).service
    sudo systemctl enable --now hhd@$(whoami)

    sudo rm -rf $HOME/homebrew/plugins/DeckyPlumber
    sudo systemctl restart plugin_loader.service

elif [[ "$1" == "ip" ]]; then
    sudo systemctl disable --now hhd@$(whoami)
    sudo systemctl mask hhd@$(whoami)

    sudo udevadm control --reload-rules
    sudo udevadm trigger
    sudo systemctl daemon-reload
    sudo systemctl enable inputplumber.service
    sudo systemctl start inputplumber.service
    sudo systemctl enable --now steam-powerbuttond

    curl -L https://github.com/aarron-lee/DeckyPlumber/raw/main/install.sh | sh

else
    echo "Invalid arg $1"
fi
