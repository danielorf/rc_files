# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

test -s ~/.alias && . ~/.alias || true

###################################################
###################################################
###### Remaining lines added manually by dorf #####
###################################################
###################################################

alias ll='ls -l'
alias lla='ls -la'
alias ls='ls --color'
alias kg='kubectl get'
alias k='kubectl'

# Sets CaaSP image download location to provo instead of default nuremburg
export CAASP_LOCATION=provo

# Setup virsh so that the user can access the system qemu
export VIRSH_DEFAULT_CONNECT_URI="qemu:///system"

# Point kubectl to use a downloaded kubeconfig from Kubic velum
export KUBECONFIG=~/Downloads/kubeconfig

###
### Borrowed the following from David:  https://github.com/nanoscopic/dotfiles/blob/master/os_suse/.bashrc
###

# Easier to type path to root, automatically setting window title
alias sup='sudo su -; rtitle'

# Function to easily start and stop services with less typing
function sc() {
  case $* in
    d* ) shift 1; echo "Stopping $@"; sudo systemctl stop "$@" ;;
    u* ) shift 1; echo "Starting $@"; sudo systemctl start "$@" ;;
    r* ) shift 1; echo "Restarting $@"; sudo systemctl restart "$@" ;;
    s* ) shift 1; echo "Status $@"; systemctl status "$@" ;;
    sa*) shift 1; echo "Status All"; systemctl --type=service list-units;;
    * ) sudo systemctl "$@" ;;
  esac
}

# Function to easily start and stop openvpn service
function vpn() {
  local cmd=$1
  local endpoint=${2^^}
  local serv=openvpn@$endpoint
  case $cmd in
    d* )
      echo "Stopping $serv";
      sudo systemctl stop "$serv" ;;
    u* )
      echo "Starting $serv";
      sudo systemctl start "$serv" ;
      sudo journalctl -u $serv -f |
      while IFS= read line;
        do
          echo $line;
          if [[ $line =~ Initialization ]];
            then sudo pkill journalctl;
          fi;
      done;;
    r* )
      echo "Restarting $serv";
      sudo systemctl restart "$serv" ;
      sudo journalctl -u $serv -f |
      while IFS= read line;
        do
          echo $line;
          if [[ $line =~ Initialization ]];
            then sudo pkill journalctl;
          fi;
      done;;
    s* )
      echo "Status $serv"; systemctl status "$serv" ;;
    * )
      sudo systemctl "$serv" ;;
  esac
}

# Function to easily ssh into the various nodes of a default Kubic devenv
function cssh() {
  case $* in
    a|admin*     ) echo -en "\033];caasp-admin\a"   ; ssh root@10.17.1.0; rtitle; ;;
    m|m0|master* ) echo -en "\033];caasp-master-0\a"; ssh root@10.17.2.0; rtitle; ;;
    w0|worker0*  ) echo -en "\033];caasp-worker-0\a"; ssh root@10.17.3.0; rtitle; ;;
    w1|worker1*  ) echo -en "\033];caasp-worker-1\a"; ssh root@10.17.3.1; rtitle; ;;
    my|mysql     ) echo -en "\033];mysql\a";
      ssh -t root@10.17.1.0 'docker exec -it \
        $(docker ps -f name=mariadb --format="{{.ID}}") \
        mysql -u velum -D velum_production --password=$(cat /var/lib/misc/infra-secrets/mariadb-velum-password)'; ;;
    sm|salt-master) echo -en "\033];salt-master\a";
      ssh -t root@10.17.1.0 'docker exec \
        $(docker ps -f name=salt-master --format="{{.ID}}") \
        /bin/bash'; ;;
    v|velum) echo -en "\033];velum dashboard\a";
      ssh -t root@10.17.1.0 'docker exec -it \
        $(docker ps -f name=velum-dashboard --format="{{.ID}}") \
        entrypoint.sh /bin/bash'; ;;
    vapi|velum-api)
      ssh root@10.17.1.0 '\
        echo -n "Username: ";\
        cat /var/lib/misc/infra-secrets/velum-internal-api-username;\
        echo -n "Password: ";\
        cat /var/lib/misc/infra-secrets/velum-internal-api-password;\
        ' ;;
    *) echo 'a | m | w0 | w1'; ;;
  esac
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
