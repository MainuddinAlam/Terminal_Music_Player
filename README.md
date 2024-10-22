# Terminal_Music_Player
* Project to play music in the terminal.
* Currently under development.

## Reasons for making this project

This is a personal project where I created to listen to music as I code. Since, I use the terminal frequently as I code, I thought it would be nice to play music in it too. It helps me from getting distracted.

## Installation process
* Install ruby
* Install ruby gems which includes mpv, ffmeg, yt-dlp, tty-reader

### For Linux
* sudo apt update
* sudo apt install curl gpg -y
* \curl -sSL https://get.rvm.io | bash -s stable
* source ~/.rvm/scripts/rvm
* rvm install ruby
* ruby -v
* sudo apt install mpv ffmpeg yt-dlp && gem install tty-reader

### For MacOS
* /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
* brew install ruby
* ruby -v
* Add ruby to your path if required
* export PATH="/usr/local/opt/ruby/bin:$PATH"
* source ~/.bash_profile  # or source ~/.zshrc for Zsh users

### For Windows
* Go to Ruby's official page and download the latest version
* Add Ruby to your path so that it can run on command line
* ruby -v

## Running the script
* ruby Muterm.rb

