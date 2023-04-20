#Download packages from Arch website instead of pacman for wifi
#And rename cache directory to avoid not downloading the packages
#sudo mv /var/cache/pacman/pkg /var/cache/pacman/pkg2
#sudo pacman -Syw --cachedir . base-devel linux-headers broadcom-wl
#sudo mv /var/cache/pacman/pkg2 /var/cache/pacman/pkg

#Install downloaded packages for wifi
#sudo pacman -U base-devel*.pkg.tar.zst
#sudo pacman -U linux*-headers*.pkg.tar.zst
#sudo pacman -U *broadcom-wl*.pkg.tar.zst

#Load modules for broadcom wifi driver
#rmmod b43 && rmmod ssb && modprobe wl


#Basic tools to build Arch Linux packages
sudo pacman -S base-devel --needed

#Print kernel release to know what linux-headers to install
uname -r
#Headers and scripts for building modules for the Linux kernel
sudo pacman -S linux-headers

#Print network controller to add driver for wifi
lspci | grep network -i
#Install dkms to specific version of dkms driver
sudo pacman -S dkms
#Install wifi driver from dkms to rebuild with kernel updates
sudo pacman -S broadcom-wl-dkms

#Update system
sudo pacman -Syu


#Configure printer settings
#sudo pacman -S cups cups-pdf
sudo systemctl enable --now cups
#Install GUI for printer
#sudo pacman -S system-config-printer
#Add wireless printer support
#sudo pacman -S avahi nss-mdns
sudo systemctl enable avahi-daemon.service
echo 'Edit /etc/nsswitch.conf and change the hosts line to look like this
"hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns"'


#Install git and add user name and email
sudo pacman -S git --needed
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com


#Get yay to install google-chrome
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay -S google-chrome


#Install snap
sudo pacman -S snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap


#Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
#Show Oh-My-Zsh prompt (in Manjaro)
echo 'Comment this lines from /usr/share/zsh/manjaro-zsh-prompt to show Oh-My-Zsh prompt'
echo '   source /usr/share/zsh/p10k-portable.zsh'
echo '   source /usr/share/zsh/p10k.zsh'
#Combine zshrc files
if [ -f ~/.zshrc.pre-oh-my-zsh ]; then
    mv ~/.zshrc ~/.zshrc.oh-my-zsh && cat ~/.zshrc.pre-oh-my-zsh ~/.zshrc.oh-my-zsh > ~/.zshrc
fi


#Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
#Change ZSH_THEME in zshrc
echo 'Change ZSH_THEME in zshrc to "powerlevel10k/powerlevel10k"'


#Download Meslo Nerd Fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip -O $HOME/Downloads/Meslo.zip
#Extract files
ark -b $HOME/Downloads/Meslo.zip --destination $HOME/Downloads/Meslo\ NF
#Install fonts globally
sudo cp $HOME/Downloads/Meslo\ NF/Meslo\ LG\ S\ Regular\ Nerd\ Font\ Complete.ttf /usr/local/share/fonts/m
sudo cp $HOME/Downloads/Meslo\ NF/Meslo\ LG\ S\ Italic\ Nerd\ Font\ Complete.ttf /usr/local/share/fonts/m
sudo cp $HOME/Downloads/Meslo\ NF/Meslo\ LG\ S\ Bold\ Nerd\ Font\ Complete.ttf /usr/local/share/fonts/m
sudo cp $HOME/Downloads/Meslo\ NF/Meslo\ LG\ S\ Bold\ Italic\ Nerd\ Font\ Complete.ttf /usr/local/share/fonts/m


#Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#Write brew lines to .zshrc
echo '
#BREW
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

#BREW COMPLETION
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi
' >> $HOME/.zshrc
#Use brew in the same session without reloading
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)


#Install github cli
brew install go gh

#Install zsh plugins (in case not preinstalled in system)
#brew install zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search

#Install vscode
sudo snap install code --classic


#Install powershell
sudo snap install powershell --classic
[[ -d "$HOME/.config/powershell/" ]] || mkdir "$HOME/.config/powershell/"

#Make directory for Github and gists
mkdir "$HOME/Github/gist"
#Clone git repository
git clone https://github.com/shyguyCreate/installation-Setup.git "$HOME/Github/installation-Setup"

#Create symbolic link to powershell profile file
ln -s "$HOME/Github/installation-Setup/Linux/Microsoft.PowerShell_profile.ps1" "$HOME/.config/powershell/Microsoft.PowerShell_profile.ps1"
ln -s "$HOME/Github/installation-Setup/Linux/Microsoft.PowerShell_profile.ps1" "$HOME/.config/powershell/Microsoft.VSCode_profile.ps1"

#Install Oh-My-Posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh
#Get ohmyposh config from gist
git clone https://gist.github.com/387ff25579b25bff63a6bc1a7635be27.git "$HOME/Github/gist/ohmyposh"
#Create symbolic link of ohmyposh to powershell profile file
ln -s "$HOME/Github/gist/ohmyposh/ohmyposhCustome.omp.json" "$HOME/.config/powershell/ohmyposhCustome.omp.json"

#Install Powershell modules
pwsh -c { Install-Module -Name Terminal-Icons }
pwsh -c { Install-Module -Name PSReadLine -Force }
