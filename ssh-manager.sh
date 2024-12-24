#!/bin/bash
#This script allows the user to save ssh logins and then connect to the server
#by just entering the number of the server
#I created this script because remembering all the ssh logins is a pain in the @$$
#Also i didn't want to use a programming language like python or ruby,
#because I wanted to keep it simple and avoid installing any dependencies
#I also wanted to learn more about bash scripting with awk and sed
# -- Scott Gopaulchan 2023

warning="\033[1;31m" #Red
success="\033[1;32m" #Green
info="\033[1;33m" #Yellow
reset="\033[0m" #Reset color
cfg_file_name="$HOME/.ssh_manager_config" #The file where the server details are stored

#Check if the config file exists if not create it
if [ ! -f "$cfg_file_name" ]
then
    touch "$cfg_file_name"
fi

fileEmptyCheck(){
    if [ ! -s "$cfg_file_name" ] # -s checks if the file is empty
    then
        printf "%s${warning}No SSH connections added yet${reset}\n"
        menu
    fi
}

addNewServerName(){


read -p "Enter the server name/alias: " name

#Check if the server name is blank
if [ -z "$name" ] # -z checks if the string is empty
then
    printf "%s${warning}Server name cannot be blank${reset}\n"
    addNewServerName
fi


}

editServerName(){

    printf "Current name is: %s \n " "$name"
    read -p "Enter the new name or leave blank to use current name : " newName
    printf "\n"

    if [ -z "$newName" ]
    then
        name=$name
    else
        name=$newName
    fi
}

addNewServerIp(){

read -p "Enter the server IP or domain name: " ip

#Check if  ip is blank and conforms to the regex pattern for ip address or domain name i.e xxx.xxx.xxx.xxx or example.com
if [ -z "$ip" ] || ! [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && ! [[ "$ip" =~ ^([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$ ]]
#Yeah no idea what this regex does looks like gibberish to me, I used it from stackoverflow and confimed it works using regex101.com
then
    printf "%s${warning}Invalid IP or domain name${reset}\n"
    addNewServerIp
fi

}

editServerIp(){

    printf "Current IP is: %s \n" "$ip"
    read -p "Enter the new IP or domain name or leave blank to use current IP : " newIp
    printf "\n"
    if [ -z "$newIp" ]
    then
        ip=$ip
    else

        if ! [[ "$newIp" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && ! [[ "$newIp" =~ ^([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$ ]]
        then
            printf "%s${warning}Invalid IP or domain name${reset}\n"
            editServerIp $ip
        else
            ip=$newIp
        fi
    fi

}

addNewServerPort(){


read -p "Enter the port number leave blank for default of 22 : " port

#check if the port is blank
if [ -z "$port" ]
then
    port=22
fi

#Check if the port is a number and is between 1 and 65535 (Valid Port ranges)
if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -gt 65535 ] || [ "$port" -lt 1 ]
then
    printf "%s${warning}Invalid port number${reset}\n"
    addNewServerPort
fi



}

editServerPort(){

    printf "Current port is: %s \n " "$port"
    read -p "Enter the new port number or leave blank to use current port : " newPort
    printf "\n"

    if [ -z "$newPort" ]
    then
        port=$port
    else

        if ! [[ "$newPort" =~ ^[0-9]+$ ]] || [ "$newPort" -gt 65535 ] || [ "$newPort" -lt 1 ]
            then
                printf "%s${warning}Invalid port number${reset}\n"
                editServerPort $port
        else
            port=$newPort
        fi
    fi
}

addNewServerUser(){


read -p "Enter the username: " user

#Check if the user is blank
if [ -z "$user" ] # -z checks if the string is empty
then
    printf "%s${warning}Username cannot be blank${reset}\n"
    addNewServerUser
fi



}

editServerUser(){

    printf "Current user is %s \n " "$user"
    read -p "Enter the new username or leave blank to use current name : " newUser

    if [ -z "$newUser" ]
    then
        user=$user
    else
        user=$newUser
    fi

}

addNewServerPassword(){


read -p "Enter the password: " password

#Check if the user is blank
if [ -z "$password" ] # -z checks if the string is empty
then
    printf "%s${warning}Password cannot be blank${reset}\n"
    addNewServerPassword
fi


}

editServerPassword(){

    printf "Current password is %s \n " "$password"
    read -p "Enter the new password or leave blank to use current password : " newPassword

    if [ -z "$newPassword" ]
    then
        user=$password
    else
        user=$newPassword
    fi

}

addNewServerKeyFile(){


read -p "Enter the path to the key file or leave blank if not used: " keyfile

if ! [ -z "$keyfile" ]
then
    #check if the key file exists
    if ! [ -f "$keyfile" ]
    then
        printf "%s${warning}File does not exist.${reset}\n"
        addNewServerKeyFile
    fi
fi

}

editServerKeyFile(){

    printf "Current key file is %s \n " "$keyfile"
    read -p "Enter the path to the key file or leave blank to use current key file: " newKeyFile

    if [ -z "$newKeyFile" ]
    then
        keyfile=${keyfile//\//\\/}
    else
        #check if the key file exists
        if ! [ -f "$newKeyFile" ]
        then
            printf "%s${warning}File does not exist.${reset}\n"
            editServerKeyFile
        else
            keyfile=${newKeyFile//\//\\/}
        fi
    fi

}

addNewServerOption(){
    read -p "Enter the options leave blank if not used: " option

}

editServerOption(){

    printf "Current option is %s \n " "$option"
    read -p "Enter the path to the key file or leave blank to use current option: " newOption
}


createNewSSHCredentials(){

    printf "%s${info}===========================${reset}\n"
    echo -e "${info}Add New SSH Connection${reset}"
    printf "%s${info}===========================${reset}\n"

    addNewServerName
    addNewServerIp
    addNewServerPort
    addNewServerUser
    addNewServerPassword
    addNewServerKeyFile
    addNewServerOption


    echo "$name,$ip,$port,$user,$password,$keyfile,$option," >> "$cfg_file_name"

    echo -e "${success}SSH Connection added successfully${reset}"
    read -p "Do you want to connect to the added SSH connection now? (y/n) " selection
    if [[ $selection =~ ^[Yy]$ ]]
    then
        connectToSSHServer "qc"
    fi

    menu

}

 editSSHConnection(){

        fileEmptyCheck
        printf "%s${info}===========================${reset}\n"
        echo -e "${info} Saved SSH Connections ${reset}"
        printf "%s${info}===========================${reset}\n"
        #Now to use awk to list the servers in a nice format 1 , 2 , 3 etc
        printf "%s${info}#  Name IP/Host \tPort Username\t Password\t Key File${reset}\n"
        awk -F, '{print NR " " $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7}' "$cfg_file_name" | column -t # -t is used to align the columns,  using awk is always awkward .... but it works

        printf "%s${warning}Enter the number of the SSH connection you want to edit or enter 0 to cancel : ${reset}"
        read -p "" serverNumber

        #Check if the user wants to cancel
        if [ "$serverNumber" -eq 0 ]
        then
            menu
        fi

        if [ -z "$serverNumber" ] || ! [[ "$serverNumber" =~ ^[0-9]+$ ]] || [ "$serverNumber" -gt "$(wc -l < "$cfg_file_name")" ] || [ "$serverNumber" -lt 1 ]
        then
            printf "%s${warning}Invalid selection${reset}\n"
            editSSHConnection # You have to love reursive functions
        fi


        #Now to use awk to filter the server number and get the details name,ip,host etc
        name=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $1}' "$cfg_file_name")
        ip=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $2}' "$cfg_file_name")
        port=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $3}' "$cfg_file_name")
        user=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $4}' "$cfg_file_name")
        password=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $5}' "$cfg_file_name")
        keyfile=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $6}' "$cfg_file_name")
        option=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $7}' "$cfg_file_name")

        editServerName
        editServerIp
        editServerPort
        editServerUser
        editServerPassword
        editServerKeyFile
        editServerOption

        #Now to replace the selected lines info with the updated info to the file

        sed -i "${serverNumber}s/.*/$name,$ip,$port,$user,$password,$keyfile,$option/" "$cfg_file_name"
        printf "%s${success}SSH Connection has been edited${reset}\n"
        menu




}

listSSHCredentials(){
    fileEmptyCheck
    printf "%s${info}===========================${reset}\n"
    echo -e "${info} Saved SSH Connections ${reset}"
    printf "%s${info}===========================${reset}\n"
    #Now to use awk to list the servers in a nice format 1 , 2 , 3 etc in a table format starting with the header but starting the numbering at from the second line
    printf "%s${info}#  Name IP/Host Port Username Password Key file Option${reset}\n"
    # -t is used to align the columns,  using awk is always awkward .... but it works
    awk -F, '{print NR " " $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7}' "$cfg_file_name" | column -t

    menu

}

SSHSearchCredential(){
    fileEmptyCheck
    printf "%s${info}===========================${reset}\n"
    echo -e "${info} Saved SSH Connections ${reset}"
    printf "%s${info}===========================${reset}\n"
    connection="$(cat $cfg_file_name | fzf)"

    serverName=$(echo $connection | awk -F, '{print $1}')
    serverIp=$(echo $connection | awk -F, '{print $2}')
    serverPort=$(echo $connection | awk -F, '{print $3}')
    serverUser=$(echo $connection | awk -F, '{print $4}')
    serverPassword=$(echo $connection | awk -F, '{print $5}')
    serverKeyFile=$(echo $connection | awk -F, '{print $6}')
    serverOption=$(echo $connection | awk -F, '{print $7}')

    #echo $serverPort
    #Here we go connecting to the server
    printf "%s${success}Connecting to ${serverName} ...${reset}\n"
    if [ ! -z $serverKeyFile ];
    then 
        commande="ssh -i "$serverKeyFile" -p "$serverPort" "$serverUser""@""$serverIp" "$serverOption""
        echo $commande
        $commande
    elif [ ! -z $serverPassword ];
    then
        commande="sshpass -p "$serverPassword" ssh -p "$serverPort" "$serverUser""@""$serverIp" "$serverOption""
        echo $commande
        $commande
    else
        commande="ssh -p "$serverPort" "$serverUser""@""$serverIp" "$serverOption""
        echo $commande
        $commande
    fi

    menu
   

}

connectToSSHServer(){

    if [ "$1" == "qc" ] #qc is the quick connect option
    then
        fileEmptyCheck
        serverName=$name
        serverIp=$ip
        serverPort=$port
        serverUser=$user
	serverPassword=$password
        serverKeyFile=$keyfile
        serverOpttion=$option
    else

    fileEmptyCheck
    printf "%s${info}===========================${reset}\n"
     echo -e "${info} Saved SSH Connections ${reset}"
     printf "%s${info}===========================${reset}\n"
    #Now to use awk to list the servers in a nice format 1 , 2 , 3 etc
    printf "%s${info}#  Name \t IP/Host \tPort Username\t Password\t Key file${reset}\n"
    awk -F, '{print NR " " $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7}' "$cfg_file_name" | column -t # -t is used to align the columns,  using awk is always awkward .... but it works

    printf "%s${info}Enter the number of the SSH connection you want to connect to or enter 0 to cancel : ${reset}"
    read -p "" serverNumber

    if [ "$serverNumber" == 0 ]
    then
        menu
    fi
    # Now we  have to check if the server number is blank
    # or not a number or valid using regex (I HATE REGEX )
    #and the wc command to count the number of lines in the file
    if [ -z "$serverNumber" ] || ! [[ "$serverNumber" =~ ^[0-9]+$ ]] || [ "$serverNumber" -gt "$(wc -l < "$cfg_file_name")" ] || [ "$serverNumber" -lt 1 ]
    then
        printf "%s${warning}Invalid selection ${reset}\n"
        connectToSSHServer # You have to love reursive functions
    fi

        #Now to use awk to filter the server number and get the details

        # Alright so this part is where it get bannans  and confusing
        # -F, is used to specify the field separator which in this case is a comma
        # -v is used to pass a variable to awk,
        # NR is the current line number,
        #serverNumber is the variable passed to awk
        # and the last part is the action to perform on the current line
        # so if the current line number is equal to the server number then print the column n which we are storing in the variable
        #and the last part is the file to read from
    serverName=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $1}' "$cfg_file_name")
    serverIp=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $2}' "$cfg_file_name")
    serverPort=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $3}' "$cfg_file_name")
    serverUser=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $4}' "$cfg_file_name")
    serverPassword=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $5}' "$cfg_file_name")
    serverKeyFile=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $6}' "$cfg_file_name")
    serverOption=$(awk -F, -v serverNumber="$serverNumber" 'NR==serverNumber {print $7}' "$cfg_file_name")
    echo "Option=$serverOption"

fi
    #echo $serverPort
    #Here we go connecting to the server
    printf "%s${success}Connecting to ${serverName} ...${reset}\n"
    if [ ! -z $serverKeyFile ];
    then
        commande="ssh -i "$serverKeyFile" -p "$serverPort" "$serverUser""@""$serverIp" "$serverOption""
        #echo $commande
        $commande
    elif [ ! -z $serverPassword ];
    then
        commande="sshpass -p "$serverPassword" ssh -p "$serverPort" "$serverUser""@""$serverIp" "$serverOption""
        #echo $commande
        $commande
    else
        commande="ssh -p "$serverPort" "$serverUser""@""$serverIp" "$serverOption""
        #echo $commande
        $commande
    fi
    menu



}

 deleteSSHServer(){

    fileEmptyCheck
    printf "%s${info}===========================${reset}\n"
    echo -e "${info} Saved SSH Connections ${reset}"
    printf "%s${info}===========================${reset}\n"
    #Now to use awk to list the servers in a nice format 1 , 2 , 3 etc
    printf "%s${info}#  Name IP/Host \tPort Username${reset}\n"
    awk -F, '{print NR " " $1 " " $2 " " $3 " " $4}' "$cfg_file_name" | column -t # -t is used to align the columns,  using awk is always awkward .... but it works

    printf "%s${warning}Enter the number of the SSH connection you want to delete or enter 0 to cancel : ${reset}"
    read -p "" serverNumber

    #Check if the user wants to cancel
    if [ "$serverNumber" -eq 0 ]
    then
        menu
    fi
    # Now we  have to check if the server number is blank
    # or not a number or valid using regex (I HATE REGEX )
    #and the wc command to count the number of lines in the file
    if [ -z "$serverNumber" ] || ! [[ "$serverNumber" =~ ^[0-9]+$ ]] || [ "$serverNumber" -gt "$(wc -l < "$cfg_file_name")" ] || [ "$serverNumber" -lt 1 ]
    then
        printf "%s${warning}Invalid selection${reset}\n"
        deleteSSHServer # You have to love reursive functions
    fi

    #Now to delete the server from the file using sed and the info from awk then save the file
    # -i is used to edit the file in place
    # -e is used to specify the command to run
    # '' is used to specify the line number
    # serverNumber is the variable passed to sed
    # d is used to delete the line
    # and the last part is the pattern to match
    # so in this case we are matching the line number and deleting it
    #Hopefully my comments are clear enough to whoever is reading this

    sed -i -e ''"$serverNumber"'d' "$cfg_file_name"

    printf "%s${success}SSH Connection deleted successfully${reset}\n\n"

    listSSHCredentials


}

 menu(){

    printf "%s${info}===========================${reset}\n"
    printf "%s${success}SSH Manager${reset}\n"
    printf "%s${info}===========================${reset}\n"
    printf "1. List Saved SSH connections \n"
    printf "2. Connect to a saved SSH connection \n"
    printf "3. Search and connect to a saved SSH connection \n"
    printf "4. Add new SSH connection \n"
    printf "5. Edit a saved SSH connection \n"
    printf "%s${warning}6. Delete a saved SSH connection ${reset}\n"
    printf "7. Exit\n"
    printf "Enter your choice [1-7] : "
    read -p "" choice

    case $choice in
        1) listSSHCredentials;;
        2) connectToSSHServer;;
        3) SSHSearchCredential;;
        4) createNewSSHCredentials;;
        5) editSSHConnection;;
        6) deleteSSHServer;;
        7) exit;;
        *) printf "%s${warning}Invalid choice${reset}\n"; menu;;
    esac

}



menu
