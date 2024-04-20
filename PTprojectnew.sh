#!/bin/bash
#Welcome to my Project
#student's name: Peleg odi
#student code: S24 
#Class code: 7736
#lecturer's name: Natali erez
################################################
							       	

#Colors Codes
Background_Red="\033[1;31m"
Background_Green="\\033[1;30m"
Background_Yellow="\033[1;33m"
Background_Blue="\033[1;34m"


#Following the user's input of the network range, proceed to create a new directory
	figlet -t -c  "PENETRATION TESTING" |lolcat -a -d 3
	clear
	sleep 2
	printf "${Background_Blue}"

	
	echo
	read -p  "[!] Specify the network address range for scanning: " RANGE

	echo
	printf "${Reset}"
	
	echo
	read -p  "[!] Specify the directory you want all your data to be stored: " DirName
	echo
	
function MK () #This function, named "mkdir," essentially establishes the directory where the user intends to store all output.
{
	printf "${Background_Green}"
	echo
	echo "[*] Building directory.."
	sleep 2
	mkdir $DirName
	printf "${Background_Green}"
	echo
	printf "${Background_Blue}"
	echo "[!] Directory Successfully Created!"
	sleep 2
	printf "${Reset}"
	
	sleep 2
} 
 

function SC() #This function, named " script scans" - This function orchestrates a series of network scans using Nmap and Masscan, saving results in various formats while maintaining user interface aesthetic
{
    echo
    printf "${Background_Green}"
    echo "[*] Beginning Nmap Scan, Please Be Patient!"
    printf "${Reset}"
    sleep 2

    cd $DirName
    nmap $RANGE -sV --open -T5 -oN NmapResults.txt -oX NmapResults.xml >/dev/null 2>&1

    
    xsltproc NmapResults.xml -o NmapResults.html >/dev/null 2>&1
    sleep 2

    echo 
    printf "${Background_Blue}"
    echo "[!] Completed"
    printf "${Reset}"
    sleep 2

    
    nmap -sL -n $RANGE > Hosts.txt
    cat Hosts.txt |awk '{print $(NF)}' |grep -E ^[0-9] > HOSTS.txt
    rm -rf Hosts.txt
    sleep 2

}  

   





function NSE() #This function executes an Nmap NSE (Nmap Scripting Engine) scan to identify vulnerabilities within the specified range, converting results into XML and HTML formats.
{
	echo
	printf "${Background_Green}"
	echo "[*] Commencing Nmap NSE Scan, Please Wait a Moment!"
	printf "${Reset}"


	nmap -sV --open -T5 --script vuln "$RANGE" -oX NseResults.xml >/dev/null 2>&1


	xsltproc NseResults.xml -o NseResults.html >/dev/null 2>&1

	sleep 2
	echo 
	printf "${Background_Blue}"
	echo "[!] Completed"
	printf "${Reset}"
	echo
}


function SP()#This function executes a SearchSploit scan, excluding "Privilege Escalation" exploits, disabling color output, and saving results to a text file.
{
	printf "${Background_Green}"
    echo "[*] Beginning SearchSploit Scan, Please Be Patient!"
    printf "${Reset}"

    
    searchsploit --exclude="Privilege Escalation" --disable-colour --nmap NmapResults.xml > SearchSploitResults.txt 2>/dev/null
    sleep 2

    echo
    printf "${Background_Blue}"
    echo "[!] Completed"
    printf "${Reset}"
    echo
}



function BF() #This function executes a SearchSploit scan, excluding "Privilege Escalation" exploits, disabling color output, and saving results to a text file. 
{
    printf "${Background_Green}"
    echo "[*] Preparing to Launch Hydra, Please Stand By!"
    printf "${Reset}"
    echo

    printf "${Background_Blue}"
    echo "[!] Create Your usernames list (CTRL+D after finished)"
    printf "${Reset}"
    cat > User.lst
    echo

    printf "${Background_Blue}"
    echo "[!] Create Your password list (CTRL+D after finished)"
    printf "${Reset}"
    cat > Password.lst 2>/dev/null
    echo

    echo
    printf "${Background_Blue}"
    read -p "[!] Enter a service to use it in [Hydra] Brute-Force (ssh, ftp): " SERVICE
    printf "${Reset}"
    echo

    printf "${Background_Green}"
    echo "[*] Starting Hydra Brute Force!"
    printf "${Reset}"

    # Using -v option for verbose output
    hydra -L User.lst -P Password.lst -M HOSTS.txt $SERVICE -V > HydraResults.txt 2>/dev/null

    # Filtering out unnecessary lines
    grep -ivE "Attempt|Data|targets|hydra" HydraResults.txt > HydraCracked.txt

    # Removing temporary results file
    rm HydraResults.txt

    echo 
    printf "${Background_Green}"
    echo "[!] Done."
    printf "${Reset}"
    echo
}



function LOG()#This function compiles various statistics and findings from different scan results into a single log file named "LOG.txt"
{
	cat HOSTS.txt | wc -l >> LOG.txt
	echo "Open Ports By 'Nmap':" >> LOG.txt
	cat NmapResulets.txt | grep -i open | grep -i /tcp | sort | uniq | wc -l >> LOG.txt
	echo "Open Ports By 'Masscan Scan':" >> LOG.txt
	cat MasscanResulets.txt | grep -i open | grep -i /tcp | sort | uniq | wc -l >> LOG.txt
	echo "Number of VMware Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i VMware | sort | uniq | wc -l >> LOG.txt
	echo "Number of VSFTPD Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i vsftpd | sort | uniq | wc -l >> LOG.txt
	echo "Number of OpenSSH Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i OpenSSH | sort | uniq | wc -l >> LOG.txt
	echo "Number of BOINC Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i BOINC | sort | uniq | wc -l >> LOG.txt
	echo "Number of Telnet Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i Telnet | sort | uniq | wc -l >> LOG.txt
	echo "Number of ISC BIND Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i ISC | sort | uniq | wc -l >> LOG.txt
	echo "Number of Apache Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i Apache | sort | uniq | wc -l >> LOG.txt
	echo "Number of RpcBind Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i rpcbind | sort | uniq | wc -l >> LOG.txt
	echo "Number of ProFTPd Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i ProFTPd | sort | uniq | wc -l >> LOG.txt
	echo "Number of PostgreSQL Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i PostgreSQL | sort | uniq | wc -l >> LOG.txt
	echo "Number of VNC Vulnerability Found By 'Searchsploit':" >> LOG.txt
	cat SearchsploitResults.txt | grep -i VNC | sort | uniq | wc -l >> LOG.txt
	echo "Number of Cracked Logins Found by 'Hydra':" >> LOG.txt
	cat HydraCracked.txt | wc -l >> LOG.txt
	clear
	
}


function MENU()#This function presents a menu interface to the user, allowing them to access various results generated by the script
{
	EXIT=EXIT
	printf "${Background_Blue}"
	echo "Welcome to the script MENU!"
	printf "${Reset}"
	printf "${Background_Green}"
	printf "${Reset}"
	echo "*Displayed here are the results from running the script*"
	echo
	echo "[*] Enter [E] - NSE Results"
	echo
	echo "[*] Enter [N] - Nmap Results"
	echo
	echo "[*] Enter [H] - Hosts List Results"
	echo
	echo "[*] Enter [S] - Searchsploits Results"
	echo
	echo "[*] Enter [T] - For EXIT"
	echo
	while [ "$EXIT" == EXIT ];
	do
	read -p "[!] Please enter your choose:" CHOOSE
	case $CHOOSE in
	N)
	firefox NmapResults.html 2>/dev/null
	;;
	H)
	firefox HOSTS.txt 2>/dev/null
	;;
	E)
	firefox NseResults.html 2>/dev/null
	;;
	S)
	firefox SearchSploitResults.txt 2>/dev/null
	BRUTEFORCE
	clear
	MENUec
	clear
	MENU
	;;
	T)
	function AD() {
    read -p "Do you want to save the output to a zip file? (yes/no): " choice
    case "$choice" in 
        yes|YES|Yes)
            zip -r output.zip . >/dev/null 2>&1
            echo "This Is The End Of The Script"
            sleep 3
            exit
            ;;
        no|NO|No)
            echo "This Is The End Of The Script"
            sleep 3
            exit
            ;;
        * ) 
            echo "Invalid choice"
            ;;
    esac
}
AD
	exit 
	;;
	esac
	done
}

function VL()#valid-This function is intended to validate the accuracy of the IP range inputted by the user.
{
		printf "${Background_Green}"
		read -p "[*] Choose B(Basic) or F(Full) scan: " CH
		printf "${Background_Blue}"
		echo
		
case $CH in
    B)
        echo "[!] B Was Chosen"
        ;;
        
    F)
        echo "[!] F Was Chosen"
        ;;
    *)
        echo "Invalid choice. Please choose B or F."
        ;;
esac
}

function NT() #needed tools-This function is designed to verify whether the necessary tools are available for executing this script and, if not, to proceed with their installation.
{
	echo "[!] Verifying The Presence Of All Required Tools"
	echo
	sleep 1
	echo "[!] It Shouldn't Take Too Long"
	sleep 1
	printf "${Background_Green}"
	apps=" nmap hydra medusa searchsploit "
	for app in $apps
	do
		if command -v $app &> /dev/null
		then
			echo "$app is already installed"
			sleep 1
			echo
		else
			 Install the program
			echo "$app is not installed,installing..."
			sleep 1
			sudo apt-get install $app &> /dev/null
			echo
		fi
	done
	sleep 2
	clear
}	


    
	
		


#Activating the Functions
NT
VL
MK
SC
NSE
SP
BF
LOG
MENU

