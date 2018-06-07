#!/bin/bash
# Command:
# chmod 700 /vddos/auto-add/vddos-add.sh
# ln -s /vddos/auto-add/vddos-add.sh /usr/bin/vddos-add
# vddos-add your-domain.com
# OR
# vddos-add Website="your-domain.com" Cache="no" Security="no" HTTP_Listen="http://0.0.0.0:80" HTTPS_Listen="https://0.0.0.0:443" HTTP_Backend="http://127.0.0.1:8080" HTTPS_Backend="https://127.0.0.1:8443"

if [ ! -f /usr/bin/vddos-autoadd ] || [ ! -f /usr/bin/vddos-add ]; then
chmod 700 /vddos/auto-add/cron.sh
ln -s /vddos/auto-add/cron.sh /usr/bin/vddos-autoadd
chmod 700 /vddos/auto-add/vddos-add.sh
ln -s /vddos/auto-add/vddos-add.sh /usr/bin/vddos-add
fi

if [ ! -f /vddos/conf.d/website.conf ]; then
echo 'ERROR!

/vddos/conf.d/website.conf not found! 
Please Install vDDoS Proxy Protection!'|tee -a /vddos/auto-add/log.txt
exit 0
fi
if [ ! -d /letsencrypt ] || [ ! -d /vddos/ssl ]; then
mkdir -p /letsencrypt; chmod 700 -R /letsencrypt
mkdir -p /vddos/ssl; chmod 700 -R /vddos/ssl
fi

Issetting="$2" ;

if [ "$Issetting" != "" ] && [ "$1" != "" ] && [ "$2" != "" ] && [ "$3" != "" ] && [ "$4" != "" ] && [ "$5" != "" ] && [ "$6" != "" ] && [ "$7" != "" ]; then
	eval $1
	eval $2
	eval $3
	eval $4
	eval $5
	eval $6
	eval $7
fi

if [ "$Issetting" = "" ]; then
	Website="$1"   ; 
	Cache=`awk -F: '/^Cache/' /vddos/auto-add/setting.conf | awk 'NR==1 {print $2}'`  ;
	Security=`awk -F: '/^Security/' /vddos/auto-add/setting.conf | awk 'NR==1 {print $2}'`  ; 
	HTTP_Listen=`awk -F: '/^HTTP_Listen/' /vddos/auto-add/setting.conf | awk 'NR==1 {print $2}'`  ; 
	HTTPS_Listen=`awk -F: '/^HTTPS_Listen/' /vddos/auto-add/setting.conf | awk 'NR==1 {print $2}'`  ; 
	HTTP_Backend=`awk -F: '/^HTTP_Backend/' /vddos/auto-add/setting.conf | awk 'NR==1 {print $2}'`  ; 
	HTTPS_Backend=`awk -F: '/^HTTPS_Backend/' /vddos/auto-add/setting.conf | awk 'NR==1 {print $2}'`  ; 
fi

function showerror()
{
echo 'ERROR!

Website is ['$Website'] ...
Cache is ['$Cache'] ...
Security is ['$Security'] ...
HTTP_Listen is ['$HTTP_Listen'] ...
HTTPS_Listen is ['$HTTPS_Listen'] ...
HTTP_Backend is ['$HTTP_Backend'] ...
HTTPS_Backend is ['$HTTPS_Backend'] ...

# Please put a value in the file /vddos/auto-add/setting.conf
# Example:
SSL				Auto
Cache			no
Security		no
HTTP_Listen		http://0.0.0.0:80
HTTPS_Listen	https://0.0.0.0:443
HTTP_Backend	http://127.0.0.1:8080
HTTPS_Backend	https://127.0.0.1:8443

# Example Command:
 vddos-add your-domain.com
# OR:
 vddos-add Website="your-domain.com" Cache="no" Security="no" HTTP_Listen="http://0.0.0.0:80" HTTPS_Listen="https://0.0.0.0:443" HTTP_Backend="http://127.0.0.1:8080" HTTPS_Backend="https://127.0.0.1:8443"

'|tee -a /vddos/auto-add/log.txt
return 0
}

if [ "$Website" = "" ] || [ "$HTTPS_Backend" = "" ] || [ "$HTTP_Backend" = "" ] || [ "$HTTPS_Listen" = "" ] || [ "$HTTP_Listen" = "" ] || [ "$Security" = "" ] || [ "$Cache" = "" ]; then
showerror
exit 0
fi

Websitestringcheck=`echo $Website | grep -P '(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)'`
if [ "$Website" != "$Websitestringcheck" ]; then
	echo '- Re-check: '$Website' the domain is not properly formatted ===> Skip!'|tee -a /vddos/auto-add/log.txt
exit 0
fi


echo "
		[[[[[[[ `date` ]]]]]]]
" >> /vddos/auto-add/log.txt

# Request FOR non-www

Available=`awk -F: "/^$Website/" /vddos/conf.d/website.conf`

if [ "$Available" != "" ]; then
	echo '- Re-check: '$Website' is already in /vddos/conf.d/website.conf ===> Skip!'|tee -a /vddos/auto-add/log.txt
	exit 0
fi
if [ "$Available" = "" ]; then
	random=`cat /dev/urandom | tr -cd 'A-Z0-9' | head -c 5`
	echo $random > /vddos/letsencrypt/.well-known/acme-challenge/$Website.txt
	randomchecknonwww=`curl -s -L http://$Website/.well-known/acme-challenge/$Website.txt`
	randomcheckwww=`curl -s -L http://www.$Website/.well-known/acme-challenge/$Website.txt`
	rm -f /vddos/letsencrypt/.well-known/acme-challenge/$Website.txt
	if [ "$randomchecknonwww" = "$random" ]; then
		mkdir -p /letsencrypt/
		/root/.acme.sh/acme.sh --issue -d $Website -w /vddos/letsencrypt --keylength ec-256 --key-file /letsencrypt/$Website.pri --fullchain-file /letsencrypt/$Website.crt  >>/vddos/auto-add/log.txt 2>&1
		if [ -f /letsencrypt/"$Website".crt ]; then
			ln -s /letsencrypt/$Website.crt /vddos/ssl/$Website.crt 
			ln -s /letsencrypt/$Website.pri /vddos/ssl/$Website.pri 
		fi

		if [ ! -f /vddos/ssl/$Website.crt ] && [ -f /root/.acme.sh/"$Website"_ecc/fullchain.cer ]; then
			ln -s /root/.acme.sh/"$Website"_ecc/fullchain.cer /vddos/ssl/$Website.crt 
			ln -s /root/.acme.sh/"$Website"_ecc/"$Website".key /vddos/ssl/$Website.pri
		fi
	fi

	if [ "$randomchecknonwww" != "$random" ] || [ ! -f /vddos/ssl/"$Website".crt ]; then
		openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /vddos/ssl/$Website.pri -out /vddos/ssl/$Website.crt -subj "/C=US/ST=$Website/L=$Website/O=$Website/OU=vddos.voduy.com/CN=$Website" >>/vddos/auto-add/log.txt 2>&1
		chmod -R 750 /vddos/ssl/$Website.*
	fi

	echo "
$Website $HTTP_Listen $HTTP_Backend $Cache $Security no no
$Website $HTTPS_Listen $HTTPS_Backend $Cache $Security /vddos/ssl/$Website.pri /vddos/ssl/$Website.crt
" >> /vddos/conf.d/website.conf

	echo '+ New-Success: '$Website' auto add to /vddos/conf.d/website.conf ===> Done!'|tee -a /vddos/auto-add/log.txt
	sleep 1
fi

# Request FOR www

is2www=`echo "www.$Website"| awk '{print substr($0,1,8)}'`
if [ "$is2www" = "www.www." ]; then
	exit 0
fi
Available=`awk -F: "/^www.$Website/" /vddos/conf.d/website.conf`
if [ "$Available" != "" ]; then
	echo '- Re-check: 'www.$Website' is already in /vddos/conf.d/website.conf ===> Skip!' |tee -a /vddos/auto-add/log.txt
	exit 0
fi
if [ "$Available" = "" ]; then
	if [ "$randomcheckwww" = "$random" ]; then
		/root/.acme.sh/acme.sh --issue -d www.$Website -w /vddos/letsencrypt --keylength ec-256 --key-file /letsencrypt/www.$Website.pri --fullchain-file /letsencrypt/www.$Website.crt  >>/vddos/auto-add/log.txt 2>&1
		if [ -f /letsencrypt/www."$Website".crt ]; then
			ln -s /letsencrypt/www.$Website.crt /vddos/ssl/www.$Website.crt 
			ln -s /letsencrypt/www.$Website.pri /vddos/ssl/www.$Website.pri 
		fi

		if [ ! -f /vddos/ssl/www."$Website".crt ] && [ -f /root/.acme.sh/www."$Website"_ecc/fullchain.cer ]; then
			ln -s /root/.acme.sh/www."$Website"_ecc/fullchain.cer /vddos/ssl/www.$Website.crt 
			ln -s /root/.acme.sh/www."$Website"_ecc/"$Website".key /vddos/ssl/www.$Website.pri
		fi

		if [ ! -f /vddos/ssl/"$Website".crt ]; then
			ln -s /vddos/ssl/$Website.crt /vddos/ssl/www.$Website.crt 
			ln -s /vddos/ssl/$Website.pri /vddos/ssl/www.$Website.pri
		fi

echo "
www.$Website $HTTP_Listen $HTTP_Backend $Cache $Security no no
www.$Website $HTTPS_Listen $HTTPS_Backend $Cache $Security /vddos/ssl/www.$Website.pri /vddos/ssl/www.$Website.crt
" >> /vddos/conf.d/website.conf

	echo '+ New-Success: 'www.$Website' auto add to /vddos/conf.d/website.conf ===> Done!'|tee -a /vddos/auto-add/log.txt
	sleep 1
	exit 0
	fi
fi

