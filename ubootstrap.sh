#!/bin/bash 

LIGHT_GREEN='\033[1;32m'
NC='\033[0m'
CURRENT_DIR=`pwd`
### Passwordless sudo ###
echo -e "${LIGHT_GREEN}### Setting passwordless sudo ${NC}"

if sudo grep -Fxq "$USER ALL=(ALL) NOPASSWD:ALL" /etc/sudoers
then
    echo -e "${LIGHT_GREEN}### $USER is already a passwordless sudoer ${NC}"
else
    sudo echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
fi

### Install git ###
echo -e "${LIGHT_GREEN}### Installing git ${NC}"
sudo apt-get update
sudo apt-get install -y git-core
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global core.editor "vim"

### Install terminator - A better terminal
echo -e "${LIGHT_GREEN}### Install terminator - A better terminal${NC}"
sudo apt-get install -y terminator

### Compile vim with lua support ###
echo -e "${LIGHT_GREEN}### Compile vim with lua support${NC}"
sudo apt-get remove -y --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common
sudo apt-get install -y liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev mercurial libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev

sudo mkdir /usr/include/lua5.1/include
sudo ln -s /usr/include/luajit-2.0 /usr/include/lua5.1/include
 
cd ~
git clone https://github.com/vim/vim.git
cd vim/src
make distclean
./configure --with-features=huge \
	    --enable-rubyinterp \
	    --enable-largefile \
	    --disable-netbeans \
	    --enable-pythoninterp \
	    --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
	    --enable-perlinterp \
	    --enable-luainterp \
	    --with-luajit \
	    --enable-gui=auto \
	    --enable-fail-if-missing \
	    --with-lua-prefix=/usr/include/lua5.1 \
	    --enable-cscope 
make 
sudo make install
cd ..
sudo mkdir /usr/share/vim
sudo mkdir /usr/share/vim/vim74
sudo cp -fr runtime/* /usr/share/vim/vim74/

### Python stuff ###
echo -e "${LIGHT_GREEN}### Installing python-pip, pudb, ipython and django${NC}"
sudo apt-get install -y python-pip
pip install pudb
pip install ipython
sudo pip install django

### GUI stuff ###
echo -e "${LIGHT_GREEN}### Setting some GUI stuff${NC}"
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
gsettings set com.canonical.Unity.Launcher launcher-position Bottom

### Install vim plugin manager ###
echo -e "${LIGHT_GREEN}### Installing VIM plugin manager (vim-plug)${NC}"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
### Clone vimrc file ###
echo -e "${LIGHT_GREEN}### Clone vimrc file${NC}"
cd $CURRENT_DIR
git clone https://github.com/eladishay/vimrc.git 
echo -e "${LIGHT_GREEN}### Move vimrc file to $HOME ${NC}"
mv vimrc/vimrc ~/.vimrc
rm -rf vimrc

### Install chrome ###
echo -e "${LIGHT_GREEN}### Installing Chrome${NC}"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update
sudo apt-get install google-chrome-stable

### Install virtualbox ###
echo -e "${LIGHT_GREEN}### Installing Virtualbox${NC}"
echo 'echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list' | sudo tee /etc/apt/sources.list

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox-5.2

### Install oh my zsh ###
sudo apt-get install curl -y
echo -e "${LIGHT_GREEN}### Installing oh my zsh${NC}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo -e "${LIGHT_GREEN}### In order to install all VIM plugins enter command mode and type PlugInstall - That's it (:${NC}"



