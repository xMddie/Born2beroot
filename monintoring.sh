architecture=$(uname -a)
phycpu=$(nproc)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
usedram=$(free -m | grep "Mem" | awk '{print $3}')
totalram=$(free -m | grep "Mem" | awk '{print $2}')
percentram=$(free | grep "Mem" | awk '{printf("%.2f"), $3/$2*100}')
useddisk=$(df -Bm --total | grep "total" | awk '{print $3}' | grep -oE '[0-9]{1,}')
totaldisk=$(df -Bg --total | grep "total" | awk '{print $2}')
percentdisk=$(df -Bm --total | grep "total" | awk '{printf("%.2f"), $3/$2*100}')
cpuload=$(top -bn 1 | grep "%Cpu" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
lastboot=$(uptime -s)
lvmuse="no"
if [ $(cat /etc/fstab | grep '/dev/mapper' | wc -l) -ne 0 ]
then
	lvmuse="yes"
fi
tcp=$(cat /proc/net/sockstat | grep "TCP" | awk '{print $3}')
users=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip addr | grep "ether" | awk '{print $2}')
sudo=$(journalctl | grep "COMMAND=" | wc -l)
wall  "	#Architecture: $architecture
	#CPU physical: $phycpu
	#vCPU: $vcpu
	#Memory Usage: $usedram/${totalram}MB ($percentram%)
	#Disk Usage: ${useddisk}/${totaldisk}b ($percentdisk%)
	#CPU load: ${cpuload}%
	#Last boot: $lastboot
	#LVM use: $lvmuse
	#Connections TCP: $tcp ESTABLISHED
	#User log: $users
	#Network: IP $ip ($mac)
	#Sudo: $sudo cmd"