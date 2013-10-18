# This is for reading, not running (provisioning ubolonton.org)

# To get add-apt-repository
sudo apt-get install python-software-properties

sudo add-apt-repository ppa:cassou/emacs

sudo apt-get install tmux zsh git-core emacs24 emacs24-el man locate ufw
sudo apt-get install gitolite mosh

# Default shell is zsh
chsh -s /usr/bin/zsh

# Host name
echo ubolonton.org | sudo tee /etc/hostname

# Firewall
sudo ufw enable
sudo ufw logging on
sudo ufw allow ssh/tcp
sudo ufw allow http/tcp

# Key pairs
ssh-keygen -t rsa -C "ubolonton@ubolonton.org"
ssh-keygen -f id_rsa -p

# Stuffs
cd ~
git clone --recursive https://github.com/ubolonton/.emacs.d
git clone --recursive https://github.com/ubolonton/magit-wrapper
git clone https://github.com/ubolonton/dotfiles
git clone https://github.com/robbyrussell/oh-my-zsh.git
# Sym links dot files to ~

# To avoid typing passphrase twice
eval "$(ssh-agent)"
ssh-add

# Install nodejs & npm
sudo npm install -g jshint

# For gtags (PHP, C/C++, Java)
sudo apt-get install global

# Python
sudo apt-get install python-pip
sudo pip install virtualenv virtualenvwrapper

# For htpasswd
sudo apt-get install apache2-utils
