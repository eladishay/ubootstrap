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

### Install oh my zsh ###
echo -e "${LIGHT_GREEN}### Installing oh my zsh${NC}"
sudo apt-get install -y zsh
curl -L http://install.ohmyz.sh > install.sh
sh install.sh
rm -f install.sh

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
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

### Clone vimrc file ###
echo -e "${LIGHT_GREEN}### Clone vimrc file${NC}"
cd $CURRENT_DIR
git clone https://github.com/eladishay/vimrc.git 
echo -e "${LIGHT_GREEN}### Move vimrc file to $HOME ${NC}"
mv vimrc/vimrc ~/.vimrc
rm -rf vimrc

