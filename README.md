# BlacklistCheck


*********************************
 MX Record and Malware Checker
 GPLv3
*********************************

 Usage:

   ./Blacklist.sh -d \<DOMAIN\> -b -> Malware Check

   ./Blacklist.sh -d \<DOMAIN\> -m -> MX and SPF Record Check

   ./Blacklist.sh -d \<DOMAIN\> -a -> Malware and MX Record Check combined

When only a domain is given, the script will check the MX and SPF record. You can only check one domain per execution.
