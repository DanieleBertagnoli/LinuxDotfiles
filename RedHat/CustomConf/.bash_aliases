#!/bin/bash

alias c='clear'
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias l='eza --icons'
alias lt='eza -a --tree --level=1 --icons'
alias dw='cd ~/Downloads'

alias up='sudo dnf upgrade --refresh && sudo yum update && sudo yum upgrade'

alias ubuntu_docker='sudo chown -R dbertagnoli:docker ~/Documents/UbuntuDockerVolume/ && docker run --name ubuntu \
	-v ~/Documents/UbuntuDockerVolume:/home/ubuntu/UbuntuDockerVolume \
	-w /home/ubuntu/UbuntuDockerVolume \
	-t -i ubuntu'


# Alpaca (CLI proxy)
alias proxy_up='export http_proxy=http://127.0.0.1:3128 && export https_proxy=https://127.0.0.1:3128 && export HTTP_PROXY=http://127.0.0.1:3128 && export HTTPS_PROXY=https://127.0.0.1:3128'
alias proxy_down='unset http_proxy && unset https_proxy && unset HTTP_PROXY && unset HTTPS_PROXY'
alias alpaca='proxy_up && \
	echo -e "\n\nExported proxy vars\n\n" && \
	/usr/bin/alpaca -u dbertagnoli -d elt.elt && \
	echo -e "\n\nShutting down proxy\n\n" && \
	proxy_down'
