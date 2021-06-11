#!/bin/sh
show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${menu} ENV CHECH ${normal}\n"
    printf "${menu}**${number} 2)${menu} DOCKER  ${normal}\n"
    printf "${menu}**${number} 3)${menu} ANSIBLE  ${normal}\n"
    printf "${menu}**${number} 4)${menu} KUBERNETES  ${normal}\n"
    printf "${menu}**${number} 5)${menu} play game  ${normal}\n"
    printf "${menu}*********************************************${normal}\n"
    printf "Please enter a menu option and enter or ${fgred}x to exit. ${normal}"
    read opt
}


server_name=$(hostname)

#menu1_check



function memory_check() {
    echo ""
	echo "Memory usage on ${server_name} is: "
	free -h
	echo ""
}

function cpu_check() {
    echo ""
	echo "CPU load on ${server_name} is: "
    echo ""
	uptime
    echo ""
}

function tcp_check() {
    echo ""
	echo "TCP connections on ${server_name}: "
    echo ""
	cat  /proc/net/tcp | wc -l
    echo ""
}

function kernel_check() {
    echo ""
	echo "Kernel version on ${server_name} is: "
	echo ""
	uname -r
    echo ""
}

function all_checks() {
    echo ------------------------------------HOSTNAME-------------------------------------------------------------- | tee -a info.txt 
    cat /proc/sys/kernel/hostname       | tee -a info.txt 
    echo ------------------------------------RELEASE--------------------------------------------------------------------- | tee -a info.txt 
    echo --------------------hello--world-------------
    cat /etc/*release | tee -a info.txt 
    #CPU info: 
    echo -------------------------------------------------CPU----------------------------------------------------------------- | tee -a info.txt 
    lscpu | tee -a info.txt 
    #MEM info: 
    echo ---------------------------------------MEMORY----------------------------------------------------------------- | tee -a info.txt 
    free -m | tee -a info.txt 
    #torage 
    echo ---------------------------------------STORAGE----------------------------------------------------------------- | tee -a info.txt 
    sudo df -h | tee -a info.txt 
    echo ---------------------------------------PORTS----------------------------------------------------------------- | tee -a info.txt 
    sudo netstat -lntu | tee -a info.txt 
    echo ---------------------------------------DOCKER------------------------------------------------------------- | tee -a info.txt 
    sudo docker version | tee -a info.txt 
    echo ---------------------------------------DOCKER-NODE-LABEL------------------------------------------------------------ | tee -a info.txt 
    sudo docker node  ls | tee -a info.txt   
    echo ----------------------------------------DOCKER-STACK-------------------------------------------------- | tee -a info.txt 
    sudo docker stack ls | tee -a info.txt   
    echo ---------------------------------------DOCKER-SERVICE------------------------------------------------------------- | tee -a info.txt 
    sudo docker service ls | tee -a info.txt   
    echo ---------------------------------------DOCKER-NODE-LABEL------------------------------------------------------------- | tee -a info.txt 
    sudo docker node ls -q | xargs docker node inspect \ 
    -f '{{ .ID }} [{{ .Description.Hostname }}]: {{ .Spec.Labels }}' | tee -a info.txt 
    echo ---------------------------------------DOCKER-Volume------------------------------------------------------------ | tee -a info.txt 
    sudo docker Volume ls | tee -a info.txt   
    echo ---------------------------------------DOCKER-network------------------------------------------------------------ | tee -a info.txt 
    sudo docker network ls | tee -a info.txt   
    echo ----------------------------------------firewall------------------------------------------------------------ | tee -a info.txt 
    sudo systemctl status firewalld | tee -a info.txt 
    sudo firewall-cmd --permanent --zone=public --list-sources | tee -a info.txt


	
}



#menu2 functions

function docker_check(){
    echo " docker status on server ${server_name} is :"
    systemctl status docker

}

function docker_install(){
    echo "docker installation on server ${server_name} begings: "
    echo   ------------- installing docker---------------------------------- 
    sudo yum install docker-ce docker-ce-cli containerd.io 
    sudo systemctl start docker  
    sudo docker version  
    echo   ------------- ---------------------------------------------------- 
}

function docker_remove(){
    echo ----ARE YOU SURE WANT TO UNINSTALL DOCKER -------------------------------
    read -p "Press enter to continue"

   
    sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
    echo -------------docker remove-------------------------------------------



}

function image_check(){
    echo ----------cheching images --------------------------
    docker image ls
    echo-----------checking container-----------------------
    docker ps -a



}
#menu3 functions
function ansible_check(){
    echo ------cheching ansible_version------------------
    ansible --version

}


function ansible_install(){
    echo      ---instiatlize--installation-----------
    read -p "Press enter to continue"
    bash ansible_install.sh



}

#menu4 functions 
function ktruble(){
    # If exposed deployment intermittently responds with "no route to host", run the following on the troublesome host
    sudo sh -c "iptables --flush && iptables --flush" && sudo systemctl restart docker.service

    # If the previous command fixes the intermittent problem, there is most likely an iptables rule preventing incoming traffic to the ingress controller
    sudo sh -c "cp /etc/sysconfig/iptables /etc/sysconfig/iptables.ORIG && iptables --flush && iptables --flush && iptables-save > /etc/sysconfig/iptables"
    sudo systemctl restart iptables.service
    sudo systemctl restart docker.service

}


function restkcluster(){
    echo ------warning----------------------------------
    echo --------changes rset k8s culster--------------------------
    read -p "presss enter to continue"
    sudo kubeadm reset

    # Clean up iptable remnants
    sudo sh -c "iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X"

    # Clean up network overlay remnants
    sudo ip link delete cni0
    sudo ip link delete flannel.1
}







#menu_1 code 
menu1(){
echo -ne "
My First Menu
$(ColorGreen '1)') Memory usage
$(ColorGreen '2)') CPU load
$(ColorGreen '3)') Number of TCP connections 
$(ColorGreen '4)') Kernel version
$(ColorGreen '5)') Check All
$(ColorGreen '0)') Go to main menu
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) memory_check ; menu1 ;;
	        2) cpu_check ; menu1 ;;
	        3) tcp_check ; menu1 ;;
	        4) kernel_check ; menu1 ;;
	        5) all_checks ; menu1 ;;
		    0) go to main menu; menu ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

#menu2 code 
menu2(){
echo -ne "
My second Menu
$(ColorGreen '1)') status check
$(ColorGreen '2)') install docker
$(ColorGreen '3)') remove docker  
$(ColorGreen '4)') image list
$(ColorGreen '5)') Check All
$(ColorGreen '0)') Go to main menu
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) docker_check ; menu2 ;;
	        2) docker_install ; menu2 ;;
	        3) docker_remove ; menu2 ;;
	        4) image_check ; menu2 ;;
	        5) all_checks ; menu2 ;;
		    0) go to main menu; menu ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}
#menu3 code
menu3(){
echo -ne "
My third  Menu
$(ColorGreen '1)') status check
$(ColorGreen '2)') install Ansible
$(ColorGreen '0)') Go to main menu
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) ansible_check ; menu3 ;;
	        2) ansible_install ; menu3 ;;
	        0) go to main menu; menu ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}


#menu4code
menu4(){
echo -ne "
My fourth Menu
$(ColorGreen '1)') insatll kubernetes(all node)
$(ColorGreen '2)') Config master
$(ColorGreen '3)') Config worker 
$(ColorGreen '4)') Trobleshoot
$(ColorGreen '5)') Rest cluster
$(ColorGreen '0)') Go to main menu
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) bash ksystem.sh ; menu4 ;;
	        2) bash k8smaster.sh ; menu4 ;;
	        3) bash k8sworker.sh ; menu4 ;;
	        4) ktruble; menu4 ;;
	        5) restkcluster ; menu4 ;;
		    0) go to main menu; menu ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}













ENV(){
    echo ------------------------------------HOSTNAME-------------------------------------------------------------- | tee -a info.txt 
    cat /proc/sys/kernel/hostname       | tee -a info.txt 
    echo ------------------------------------RELEASE--------------------------------------------------------------------- | tee -a info.txt 
    cat /etc/*release | tee -a info.txt 
    #CPU info: 
    echo -------------------------------------------------CPU----------------------------------------------------------------- | tee -a info.txt 
    lscpu | tee -a info.txt 
    #MEM info: 
    echo ---------------------------------------MEMORY----------------------------------------------------------------- | tee -a info.txt 
    free -m | tee -a info.txt 
    #torage 
    echo ---------------------------------------STORAGE----------------------------------------------------------------- | tee -a info.txt 
    sudo df -h | tee -a info.txt 
    echo ---------------------------------------PORTS----------------------------------------------------------------- | tee -a info.txt 
    sudo netstat -lntu | tee -a info.txt 
    echo ---------------------------------------DOCKER------------------------------------------------------------- | tee -a info.txt 
    sudo docker version | tee -a info.txt 
    echo ---------------------------------------DOCKER-NODE-LABEL------------------------------------------------------------ | tee -a info.txt 
    sudo docker node  ls | tee -a info.txt   
    echo ----------------------------------------DOCKER-STACK-------------------------------------------------- | tee -a info.txt 
    sudo docker stack ls | tee -a info.txt   
    echo ---------------------------------------DOCKER-SERVICE------------------------------------------------------------- | tee -a info.txt 
    sudo docker service ls | tee -a info.txt   
    echo ---------------------------------------DOCKER-NODE-LABEL------------------------------------------------------------- | tee -a info.txt 
    sudo docker node ls -q | xargs docker node inspect \ 
    -f '{{ .ID }} [{{ .Description.Hostname }}]: {{ .Spec.Labels }}' | tee -a info.txt 
    echo ---------------------------------------DOCKER-Volume------------------------------------------------------------ | tee -a info.txt 
    sudo docker Volume ls | tee -a info.txt   
    echo ---------------------------------------DOCKER-network------------------------------------------------------------ | tee -a info.txt 
    sudo docker network ls | tee -a info.txt   
    echo ----------------------------------------firewall------------------------------------------------------------ | tee -a info.txt 
    sudo systemctl status firewalld | tee -a info.txt 
    sudo firewall-cmd --permanent --zone=public --list-sources | tee -a info.txt


    
}
#!/bin/bash

##
# BASH menu script that checks:
#   - Memory usage
#   - CPU load
#   - Number of TCP connections 
#   - Kernel version
##

server_name=$(hostname)

function memory_check() {
    echo ""
	echo "Memory usage on ${server_name} is: "
	free -h
	echo ""
}

function cpu_check() {
    echo ""
	echo "CPU load on ${server_name} is: "
    echo ""
	uptime
    echo ""
}

function tcp_check() {
    echo ""
	echo "TCP connections on ${server_name}: "
    echo ""
	cat  /proc/net/tcp | wc -l
    echo ""
}

function kernel_check() {
    echo ""
	echo "Kernel version on ${server_name} is: "
	echo ""
	uname -r
    echo ""
}

function all_checks() {
	memory_check
	cpu_check
	tcp_check
	kernel_check
    ENV
    
}

##
# Color  Variables
##
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

##
# Color Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}

option_picked(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}

clear
show_menu
while [ $opt != '' ]
    do
    if [ $opt = '' ]; then
      exit;
    else
      case $opt in
        1) clear;
            option_picked "Option 1 Picked";
            menu1;
            printf "YOU ARE IN MAIN MENU";
            show_menu;
        ;;
        2) clear;
            option_picked "Option 2 Picked";
            menu2;
            show_menu;
        ;;
        3) clear;
            option_picked "Option 3 Picked";
            menu3;
            show_menu;
        ;;
        4) clear;
            option_picked "Option 4 Picked";
            menu4;
            show_menu;
        ;;
        5) clear;
            option_picked "Option 5 Picked";
            bash lgame.sh;
            show_menu;
        ;;
        x)exit;
        ;;
        \n)exit;
        ;;
        *)clear;
            option_picked "Pick an option from the menu";
            show_menu;
        ;;
      esac
    fi
done
