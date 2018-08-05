#!/bin/bash
# Command:
# chmod 700 /vddos/auto-add/cron.sh
# ln -s /vddos/auto-add/cron.sh /usr/bin/vddos-autoadd
# chmod 700 /vddos/auto-add/vddos-add.sh
# ln -s /vddos/auto-add/vddos-add.sh /usr/bin/vddos-add

# Auto add for a domain:
# vddos-autoadd [domain] your-domain.com
# OR:
# vddos-autoadd [domain] Website="your-domain.com" Cache="no" Security="no" HTTP_Listen="http://0.0.0.0:80" HTTPS_Listen="https://0.0.0.0:443" HTTP_Backend="http://127.0.0.1:8080" HTTPS_Backend="https://127.0.0.1:8443"

# Auto get/add domains from a list file domains in Local Disk:
# vddos-autoadd [list] /etc/listdomains.txt

# Auto get/add domains from a list file domains on HTTP server public:
# vddos-autoadd [http] http://private.domain.com/add-this/listdomains.txt

# Auto get/add domains from Local Web Server:
# vddos-autoadd [webserver] [apache/nginx]

# Auto get/add domains from Local Hosting Panel:
# vddos-autoadd [panel] [plesk] [apache/litespeed]
# vddos-autoadd [panel] [cpanel] [apache/litespeed]
# vddos-autoadd [panel] [directadmin] [apache/nginx/litespeed]
# vddos-autoadd [panel] [cwp] [apache/litespeed]
# vddos-autoadd [panel] [vestacp] [apache/nginx]
# vddos-autoadd [panel] [cyberpanel] [openlitespeed]
# vddos-autoadd [panel] [webuzo] [apache/nginx]
# vddos-autoadd [panel] [aapanel] [apache/nginx]
# vddos-autoadd [panel] [virtualmin] [apache/nginx]
# vddos-autoadd [panel] [kloxo-mr] [apache/nginx]
# vddos-autoadd [panel] [sentora] [apache]

# Auto remove a domain:
# vddos-autoadd [remove] your-domain.com

# Auto recheck/renew ssl again for all domains:
# vddos-autoadd [ssl-again]

#################################################################################

if [ ! -f /usr/bin/vddos-autoadd ] || [ ! -f /usr/bin/vddos-add ]; then
chmod 700 /vddos/auto-add/cron.sh
ln -s /vddos/auto-add/cron.sh /usr/bin/vddos-autoadd
chmod 700 /vddos/auto-add/vddos-add.sh
ln -s /vddos/auto-add/vddos-add.sh /usr/bin/vddos-add
fi

if [ ! -f /vddos/conf.d/website.conf ] || [ ! -f /usr/bin/vddos ]; then
echo 'ERROR!

/vddos/conf.d/website.conf not found! 
Please Install vDDoS Proxy Protection!'|tee -a /vddos/auto-add/log.txt
exit 0
fi

Command="$1"

function showerror()
{
echo '
ERROR!

Please enter the correct syntax for the command: ['$Command'] ...

# Auto add for a domain:
 vddos-autoadd [domain] your-domain.com
# OR:
 vddos-autoadd [domain] Website="your-domain.com" Cache="no" Security="no" HTTP_Listen="http://0.0.0.0:80" HTTPS_Listen="https://0.0.0.0:443" HTTP_Backend="http://127.0.0.1:8080" HTTPS_Backend="https://127.0.0.1:8443"

# Auto get/add domains from a list file domains in Local Disk:
 vddos-autoadd [list] /etc/listdomains.txt

# Auto get/add domains from a list file domains on HTTP server public:
 vddos-autoadd [http] http://private.domain.com/add-this/listdomains.txt

# Auto get/add domains from Local Web Server:
 vddos-autoadd [webserver] [apache/nginx]

# Auto get/add domains from Local Hosting Panel:
 vddos-autoadd [panel] [plesk] [apache/litespeed]
 vddos-autoadd [panel] [cpanel] [apache/litespeed]
 vddos-autoadd [panel] [directadmin] [apache/nginx/litespeed]
 vddos-autoadd [panel] [cwp] [apache/litespeed]
 vddos-autoadd [panel] [vestacp] [apache/nginx]
 vddos-autoadd [panel] [cyberpanel] [openlitespeed]
 vddos-autoadd [panel] [webuzo] [apache/nginx]
 vddos-autoadd [panel] [aapanel] [apache/nginx]
 vddos-autoadd [panel] [virtualmin] [apache/nginx]
 vddos-autoadd [panel] [kloxo-mr] [apache/nginx]
 vddos-autoadd [panel] [sentora] [apache]

# Auto remove a domain:
 vddos-autoadd [remove] your-domain.com

# Auto recheck/renew ssl again for all domains:
 vddos-autoadd [ssl-again]

'|tee -a /vddos/auto-add/log.txt
return 0
}
function checklog()
{
echo '
(Check logs at /vddos/auto-add/log.txt)
'
return 0
}


if [ "$1" = "" ]; then
showerror
exit 0
fi	

if [ "$1" != "ssl-again" ] && [ "$2" = "" ]; then
showerror
exit 0
fi	

if [ "$Command" != "domain" ] && [ "$Command" != "list" ] && [ "$Command" != "http" ] && [ "$Command" != "panel" ] && [ "$Command" != "webserver" ] && [ "$Command" != "remove" ] && [ "$Command" != 'ssl-again' ];  then
showerror
exit 0

fi



#################################################################################
# Auto add for a domain:
# vddos-autoadd [domain] your-domain.com
# OR:
# vddos-autoadd [domain] Website="your-domain.com" Cache="no" Security="no" HTTP_Listen="http://0.0.0.0:80" HTTPS_Listen="https://0.0.0.0:443" HTTP_Backend="http://127.0.0.1:8080" HTTPS_Backend="https://127.0.0.1:8443"
if [ "$Command" = "domain" ]; then

	md5sum_website_conf_latest=`md5sum /vddos/conf.d/website.conf| awk 'NR==1 {print $1}'`

	Issetting="$3" ;
	if [ "$Issetting" != "" ] && [ "$1" != "" ] && [ "$2" != "" ] && [ "$3" != "" ] && [ "$4" != "" ] && [ "$5" != "" ] && [ "$6" != "" ] && [ "$7" != "" ] && [ "$8" != "" ]; then
		/usr/bin/vddos-add $2 $3 $4 $5 $6 $7 $8
	fi
	if [ "$Issetting" = "" ]; then
		/usr/bin/vddos-add "$2"
	fi

	md5sum_website_conf_new=`md5sum /vddos/conf.d/website.conf| awk 'NR==1 {print $1}'`
	if [ "$md5sum_website_conf_latest" != "$md5sum_website_conf_new" ]; then
		/usr/bin/vddos reload |tee -a /vddos/auto-add/log.txt
	fi
fi


#################################################################################
# Auto get/add domains from a list file domains in Local Disk:
# vddos-autoadd [list] /etc/listdomains.txt
if [ "$Command" = "list" ]; then
	listdomains_source="$2"
	listdomains="/vddos/auto-add/list/listdomains.txt"
	if [ ! -f $listdomains_source ]; then
		showerror
		echo ''$listdomains_source' not found!'
		exit 0
	fi

	if [ ! -f /vddos/auto-add/list/md5sum-latest.txt ]; then
		mkdir -p /vddos/auto-add/list/
		touch /vddos/auto-add/list/md5sum-latest.txt
	fi

	md5sum_latest=`cat /vddos/auto-add/list/md5sum-latest.txt | awk 'NR==1 {print $1}'`
	md5sum_new=`cat $listdomains_source | md5sum | awk 'NR==1 {print $1}'`
	md5sum_website_conf_latest=`cat /vddos/conf.d/website.conf| grep . | awk '!x[$0]++'| md5sum | awk 'NR==1 {print $1}'`

	if [ "$md5sum_latest" != "$md5sum_new" ]; then

		echo $md5sum_new > /vddos/auto-add/list/md5sum-latest.txt
		echo "
		[[[[[[[ `date` ]]]]]]]
		" > /vddos/auto-add/log.txt
		echo "`cat $listdomains_source | grep . | awk '!x[$0]++'`" > $listdomains
		numberlinelistdomains=`cat $listdomains | grep . | wc -l`
		startlinenumber=1

		dong=$startlinenumber
		while [ $dong -le $numberlinelistdomains ]
		do
		Website=$(awk " NR == $dong " $listdomains)
		Available=`awk -F: "/^$Website/" /vddos/conf.d/website.conf`

		if [ "$Available" != "" ]; then
			echo '- Re-check: '$Website' is already in /vddos/conf.d/website.conf ===> Skip!'|tee -a /vddos/auto-add/log.txt
		fi
		if [ "$Available" = "" ]; then
			echo ' Found '$Website' ['$dong'/'$numberlinelistdomains'] in '$listdomains_source':'|tee -a /vddos/auto-add/log.txt
			/usr/bin/vddos-add "$Website" 
		fi
		dong=$((dong + 1))
		done
	fi
	md5sum_website_conf_new=`cat /vddos/conf.d/website.conf| grep . | awk '!x[$0]++'| md5sum | awk 'NR==1 {print $1}'`
	if [ "$md5sum_website_conf_latest" != "$md5sum_website_conf_new" ]; then
		/usr/bin/vddos reload |tee -a /vddos/auto-add/log.txt
	fi
	checklog
	exit 0
fi

#################################################################################
# Auto get/add domains from a list file domains on HTTP server public:
# vddos-autoadd [http] http://private.domain.com/add-this/listdomains.txt
if [ "$Command" = "http" ]; then
	httplistdomains="$2"
	listdomains="/vddos/auto-add/http/httplistdomains.txt"
	if [ ! -f /vddos/auto-add/http/md5sum-latest.txt ]; then
		mkdir -p /vddos/auto-add/http/
		touch /vddos/auto-add/http/md5sum-latest.txt
	fi
	rm -f /vddos/auto-add/http/httplistdomains.txt
	curl --silent -L $httplistdomains -o $listdomains
	echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

	md5sum_latest=`cat /vddos/auto-add/http/md5sum-latest.txt | awk 'NR==1 {print $1}'`
	md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

	if [ "$md5sum_latest" != "$md5sum_new" ]; then
		echo $md5sum_new > /vddos/auto-add/http/md5sum-latest.txt
		/usr/bin/vddos-autoadd list $listdomains
	fi
	exit 0
fi


#################################################################################
# Auto get/add domains from Local Web Server:
# vddos-autoadd [webserver] [apache/nginx]
if [ "$Command" = "webserver" ]; then
	webserver="$2"

	if [ "$webserver" = "apache" ]; then
		if [ ! -f /usr/sbin/httpd ]; then
			echo 'Unrecognized Web Server: '$webserver' - /usr/sbin/httpd Not Found!'
			exit 0
		fi
		listdomains="/vddos/auto-add/webserver/apache/listdomains.txt"

		if [ ! -f /vddos/auto-add/webserver/apache/md5sum-latest.txt ]; then
			mkdir -p /vddos/auto-add/webserver/apache/
			touch /vddos/auto-add/webserver/apache/md5sum-latest.txt
		fi

		/usr/sbin/httpd -S| grep namevhost | awk '{print $4}'| sed -e 's/default//g'| sed -e 's/alias//g'| sed -e 's/_//g'| sed -e 's/localhost//g' > $listdomains
		/usr/sbin/httpd -S| grep alias | awk '{print $2}'| sed -e 's/default//g'| sed -e 's/alias//g'| sed -e 's/_//g'| sed -e 's/localhost//g' >> $listdomains
		echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

		md5sum_latest=`cat /vddos/auto-add/webserver/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
		md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

		if [ "$md5sum_latest" != "$md5sum_new" ]; then
			echo $md5sum_new > /vddos/auto-add/webserver/apache/md5sum-latest.txt
			/usr/bin/vddos-autoadd list $listdomains
		fi
		exit 0
	fi


	if [ "$webserver" = "nginx" ]; then
		nginxlocation=`which nginx`
		if [ ! -f $nginxlocation ]; then
			echo 'Unrecognized Web Server: '$webserver' - '$nginxlocation' Not Found!'
			exit 0
		fi
		listdomains="/vddos/auto-add/webserver/nginx/listdomains.txt"

		if [ ! -f /vddos/auto-add/webserver/nginx/md5sum-latest.txt ]; then
			mkdir -p /vddos/auto-add/webserver/nginx/
			touch /vddos/auto-add/webserver/nginx/md5sum-latest.txt
		fi

		nginx -T | sed -r -e 's/[ \t]*$//' -e 's/^[ \t]*//' -e 's/^#.*$//' -e 's/[ \t]*#.*$//' -e '/^$/d' | sed -e ':a;N;$!ba;s/\([^;\{\}]\)\n/\1 /g' | grep -P 'server_name[ \t]' | grep -v '\$' | grep '\.' | sed -r -e 's/(\S)[ \t]+(\S)/\1\n\2/g' -e 's/[\t ]//g' -e 's/;//' -e 's/server_name//' | sort | uniq | xargs -L1 > $listdomains

		echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

		md5sum_latest=`cat /vddos/auto-add/webserver/nginx/md5sum-latest.txt | awk 'NR==1 {print $1}'`
		md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

		if [ "$md5sum_latest" != "$md5sum_new" ]; then
			echo $md5sum_new > /vddos/auto-add/webserver/nginx/md5sum-latest.txt
			/usr/bin/vddos-autoadd list $listdomains
		fi
		exit 0
	fi


fi

################################################################################
# Auto get/add domains from Local Hosting Panel:


if [ "$Command" = "panel" ]; then
	hostingpanel="$2"
	hostingpanel_webserver="$3"

	echo "
		[[[[[[[ `date` ]]]]]]]
	" >> /vddos/auto-add/log.txt




	if [ "$hostingpanel" != "vestacp" ] && [ "$hostingpanel" != "plesk" ] && [ "$hostingpanel" != "cpanel" ] && [ "$hostingpanel" != "cyberpanel" ] && [ "$hostingpanel" != "directadmin" ] && [ "$hostingpanel" != "cwp" ] && [ "$hostingpanel" != "kloxo-mr" ]  && [ "$hostingpanel" != "sentora" ] && [ "$hostingpanel" != "virtualmin" ] && [ "$hostingpanel" != "webuzo" ] && [ "$hostingpanel" != "aapanel" ]; then
	showerror
	exit 0
	fi
	if [ "$hostingpanel_webserver" != "" ] && [ "$hostingpanel_webserver" != "apache" ] && [ "$hostingpanel_webserver" != "nginx" ] && [ "$hostingpanel_webserver" != "openlitespeed" ] && [ "$hostingpanel_webserver" != "litespeed" ]; then
	showerror
	exit 0
	fi




	#################################################################################
	# VESTACP
	if [ "$hostingpanel" = "vestacp" ]; then
		if [ ! -f /usr/local/vesta/conf/vesta.conf ]; then
			echo 'Unrecognized Hosting Panel: '$hostingpanel' - /usr/local/vesta/conf/vesta.conf Not Found!'
			exit 0
		fi
		if [ "$hostingpanel_webserver" = "apache" ]; then

			listdomains="/vddos/auto-add/panel/vestacp/apache/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/vestacp/apache/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/vestacp/apache/
				touch /vddos/auto-add/panel/vestacp/apache/md5sum-latest.txt
			fi


			cat /home/*/conf/web/*httpd.conf  |  egrep '^(\s|\t)*ServerName' | awk '{$1 = ""; print $0}'| tr " " "\n" > $listdomains
			cat /home/*/conf/web/*httpd.conf  |  egrep '^(\s|\t)*ServerAlias' | awk '{$1 = ""; print $0}'| tr " " "\n" >> $listdomains
			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/vestacp/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/vestacp/apache/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "nginx" ]; then

			listdomains="/vddos/auto-add/panel/vestacp/nginx/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/vestacp/nginx/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/vestacp/nginx/
				touch /vddos/auto-add/panel/vestacp/nginx/md5sum-latest.txt
			fi


			cat /home/*/conf/web/*nginx.conf | egrep '^(\s|\t)*server_name'| awk '{$1 = ""; print $0}'| tr " " "\n"| sed -e 's/;//g' > $listdomains
			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/vestacp/nginx/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/vestacp/nginx/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

		
		exit 0
	fi



	#################################################################################
	# CYBERPANEL
	if [ "$hostingpanel" = "cyberpanel" ]; then

		if [ ! -f /usr/local/lsws/conf/httpd_config.conf ]; then
			echo 'Unrecognized Hosting Panel: '$hostingpanel' - /usr/local/lsws/conf/httpd_config.conf Not Found!'
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "openlitespeed" ]; then

			listdomains="/vddos/auto-add/panel/cyberpanel/openlitespeed/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/cyberpanel/openlitespeed/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/cyberpanel/openlitespeed/
				touch /vddos/auto-add/panel/cyberpanel/openlitespeed/md5sum-latest.txt
			fi


			cat /usr/local/lsws/conf/httpd_config.conf|grep 'map'| awk '{$1 = ""; print $0}'| tr " " "\n"| sed -e 's/,//g' > $listdomains
			echo "`cat $listdomains | grep .  | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/cyberpanel/openlitespeed/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/cyberpanel/openlitespeed/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi


	fi



	#################################################################################
	# CWP
	if [ "$hostingpanel" = "cwp" ]; then

		if [ "$hostingpanel_webserver" = "apache" ]; then

			if [ ! -f /usr/local/apache/conf.d/vhosts.conf ]; then
				echo 'Unrecognized Hosting Panel: '$hostingpanel' - /usr/local/apache/conf.d/vhosts.conf Not Found!'
				exit 0
			fi

			listdomains="/vddos/auto-add/panel/cwp/apache/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/cwp/apache/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/cwp/apache/
				touch /vddos/auto-add/panel/cwp/apache/md5sum-latest.txt
			fi


			cat /usr/local/apache/conf.d/vhosts.conf| egrep '^(\s|\t)*ServerName'| awk '{$1 = ""; print $0}'| tr " " "\n" > $listdomains
			cat /usr/local/apache/conf.d/vhosts.conf| egrep '^(\s|\t)*ServerAlias'| awk '{$1 = ""; print $0}'| tr " " "\n" >> $listdomains

			echo "`cat $listdomains | grep .  | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/cwp/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/cwp/apache/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "litespeed" ]; then
			echo 'This Features will be available soon!'
		fi

	fi

	#################################################################################
	# WHM/CPANEL
	if [ "$hostingpanel" = "cpanel" ]; then

		if [ ! -f /etc/userdatadomains ]; then
			echo 'Unrecognized Hosting Panel: '$hostingpanel' - /etc/userdatadomains Not Found!'
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "apache" ]; then

			listdomains="/vddos/auto-add/panel/cpanel/apache/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/cpanel/apache/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/cpanel/apache/
				touch /vddos/auto-add/panel/cpanel/apache/md5sum-latest.txt
			fi

			cat /etc/userdatadomains| awk '{print $1}'| sed -e 's/://g' > $listdomains
			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/cpanel/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/cpanel/apache/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "litespeed" ]; then
			echo 'This Features will be available soon!'
		fi


	fi


	#################################################################################
	# PLESK
	if [ "$hostingpanel" = "plesk" ]; then

		if [ ! -f /usr/sbin/plesk ]; then
			echo 'Unrecognized Hosting Panel: '$hostingpanel' - /usr/sbin/plesk Not Found!'
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "apache" ]; then

			listdomains="/vddos/auto-add/panel/plesk/apache/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/plesk/apache/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/plesk/apache/
				touch /vddos/auto-add/panel/plesk/apache/md5sum-latest.txt
			fi


			cat /var/www/vhosts/system/*/conf/httpd.conf | egrep '^(\s|\t)*ServerName' | awk '{$1 = ""; print $0}'| tr " " "\n"| sed -e 's/\"//g' | sed -e 's/:80//g'|sed -e 's/:443//g' > $listdomains
			cat /var/www/vhosts/system/*/conf/httpd.conf | egrep '^(\s|\t)*ServerAlias' | awk '{$1 = ""; print $0}'| tr " " "\n"| sed -e 's/\"//g'| sed -e 's/ipv4/webmail/g' >> $listdomains

			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/plesk/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/plesk/apache/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "litespeed" ]; then
			echo 'This Features will be available soon!'
		fi
	fi


	#################################################################################
	# DIRECTADMIN
	if [ "$hostingpanel" = "directadmin" ]; then

		if [ ! -f /usr/local/directadmin/directadmin ]; then
			echo 'Unrecognized Hosting Panel: '$hostingpanel' - /usr/local/directadmin/directadmin Not Found!'
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "apache" ]; then

			listdomains="/vddos/auto-add/panel/directadmin/apache/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/directadmin/apache/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/directadmin/apache/
				touch /vddos/auto-add/panel/directadmin/apache/md5sum-latest.txt
			fi


			cat /usr/local/directadmin/data/users/*/httpd.conf| egrep '^(\s|\t)*ServerName' | awk '{$1 = ""; print $0}'| tr " " "\n" > $listdomains
			cat /usr/local/directadmin/data/users/*/httpd.conf| egrep '^(\s|\t)*ServerAlias' | awk '{$1 = ""; print $0}'| tr " " "\n" >> $listdomains

			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/directadmin/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/directadmin/apache/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "nginx" ]; then

			listdomains="/vddos/auto-add/panel/directadmin/nginx/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/directadmin/nginx/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/directadmin/nginx/
				touch /vddos/auto-add/panel/directadmin/nginx/md5sum-latest.txt
			fi


			cat /usr/local/directadmin/data/users/*/nginx.conf| egrep '^(\s|\t)*server_name' | awk '{$1 = ""; print $0}'| tr " " "\n"| sed -e 's/;//g' > $listdomains

			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/directadmin/nginx/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/directadmin/nginx/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi


		if [ "$hostingpanel_webserver" = "litespeed" ]; then
			echo 'This Features will be available soon!'
		fi
	fi

	#################################################################################
	# WEBUZO
	if [ "$hostingpanel" = "webuzo" ]; then



		if [ "$hostingpanel_webserver" = "apache" ]; then
			if [ ! -f /usr/local/apps/apache/etc/conf.d/webuzoVH.conf ]; then
				echo 'Unrecognized Hosting Panel: '$hostingpanel' - /usr/local/apps/apache/etc/conf.d/webuzoVH.conf Not Found!'
				exit 0
			fi
			listdomains="/vddos/auto-add/panel/webuzo/apache/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/webuzo/apache/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/webuzo/apache/
				touch /vddos/auto-add/panel/webuzo/apache/md5sum-latest.txt
			fi


			cat /usr/local/apps/apache/etc/conf.d/webuzoVH.conf | egrep '^(\s|\t)*ServerName' | awk '{$1 = ""; print $0}'| tr " " "\n" > $listdomains
			cat /usr/local/apps/apache/etc/conf.d/webuzoVH.conf | egrep '^(\s|\t)*ServerAlias' | awk '{$1 = ""; print $0}'| tr " " "\n" >> $listdomains

			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/webuzo/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/webuzo/apache/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "nginx" ]; then
			echo 'This Features will be available soon!'
		fi
	fi

	# aapanel
	if [ "$hostingpanel" = "aapanel" ]; then

		if [ ! -f /www/server/panel/main.pyc ]; then
			echo 'Unrecognized Hosting Panel: '$hostingpanel' - /www/server/panel/main.pyc Not Found!'
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "apache" ]; then

			listdomains="/vddos/auto-add/panel/aapanel/apache/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/aapanel/apache/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/aapanel/apache/
				touch /vddos/auto-add/panel/aapanel/apache/md5sum-latest.txt
			fi


			cat /www/server/panel/vhost/apache/*.conf | egrep '^(\s|\t)*ServerAlias' | awk '{$1 = ""; print $0}'| tr " " "\n" > $listdomains

			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/aapanel/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/aapanel/apache/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "nginx" ]; then

			listdomains="/vddos/auto-add/panel/aapanel/nginx/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/aapanel/nginx/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/aapanel/nginx/
				touch /vddos/auto-add/panel/aapanel/nginx/md5sum-latest.txt
			fi


			cat /www/server/panel/vhost/nginx/*.conf | egrep '^(\s|\t)*server_name' | awk '{$1 = ""; print $0}'| tr " " "\n"| sed -e 's/;//g' > $listdomains

			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/aapanel/nginx/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/aapanel/nginx/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi
	fi


	# VIRTUALMIN
	if [ "$hostingpanel" = "virtualmin" ]; then

		if [ ! -f /usr/sbin/virtualmin ]; then
			echo 'Unrecognized Hosting Panel: '$hostingpanel' - /usr/sbin/virtualmin Not Found!'
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "apache" ]; then

			listdomains="/vddos/auto-add/panel/virtualmin/apache/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/virtualmin/apache/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/virtualmin/apache/
				touch /vddos/auto-add/panel/virtualmin/apache/md5sum-latest.txt
			fi


			cat /etc/httpd/conf/httpd.conf | egrep '^(\s|\t)*ServerName' | awk '{$1 = ""; print $0}'| tr " " "\n" > $listdomains
			cat /etc/httpd/conf/httpd.conf | egrep '^(\s|\t)*ServerAlias' | awk '{$1 = ""; print $0}'| tr " " "\n" >> $listdomains

			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/virtualmin/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/virtualmin/apache/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "nginx" ]; then
			echo 'This Features will be available soon!'
		fi
	fi

	# SENTORA
	if [ "$hostingpanel" = "sentora" ]; then

		if [ ! -f /etc/sentora/configs/apache/httpd-vhosts.conf ]; then
			echo 'Unrecognized Hosting Panel: '$hostingpanel' - /etc/sentora/configs/apache/httpd-vhosts.conf Not Found!'
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "apache" ]; then

			listdomains="/vddos/auto-add/panel/sentora/apache/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/sentora/apache/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/sentora/apache/
				touch /vddos/auto-add/panel/sentora/apache/md5sum-latest.txt
			fi


			cat /etc/sentora/configs/apache/httpd-vhosts.conf | egrep '^(\s|\t)*ServerName' | awk '{$1 = ""; print $0}'| tr " " "\n" > $listdomains
			cat /etc/sentora/configs/apache/httpd-vhosts.conf | egrep '^(\s|\t)*ServerAlias' | awk '{$1 = ""; print $0}'| tr " " "\n" >> $listdomains

			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/sentora/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/sentora/apache/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

	fi

	# KLOXO-MR
	if [ "$hostingpanel" = "kloxo-mr" ]; then

		if [ ! -d /usr/local/lxlabs/kloxo ]; then
			echo 'Unrecognized Hosting Panel: '$hostingpanel' - /usr/local/lxlabs/kloxo Not Found!'
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "apache" ]; then

			listdomains="/vddos/auto-add/panel/kloxo-mr/apache/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/kloxo-mr/apache/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/kloxo-mr/apache/
				touch /vddos/auto-add/panel/kloxo-mr/apache/md5sum-latest.txt
			fi


			cat /opt/configs/apache/conf/domains/*.conf | egrep '^(\s|\t)*ServerName' | awk '{$1 = ""; print $0}'| tr " " "\n"| sed -e 's/\\//g' > $listdomains
			cat /opt/configs/apache/conf/domains/*.conf | egrep '^(\s|\t)*ServerAlias' | awk '{$1 = ""; print $0}'| tr " " "\n"| sed -e 's/\\//g' >> $listdomains

			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/kloxo-mr/apache/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/kloxo-mr/apache/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

		if [ "$hostingpanel_webserver" = "nginx" ]; then

			listdomains="/vddos/auto-add/panel/kloxo-mr/nginx/listdomains.txt"

			if [ ! -f /vddos/auto-add/panel/kloxo-mr/nginx/md5sum-latest.txt ]; then
				mkdir -p /vddos/auto-add/panel/kloxo-mr/nginx/
				touch /vddos/auto-add/panel/kloxo-mr/nginx/md5sum-latest.txt
			fi


			cat /opt/configs/nginx/conf/domains/*.conf | egrep '^(\s|\t)*server_name' | awk '{$1 = ""; print $0}'| tr " " "\n"| sed -e 's/;//g' > $listdomains

			echo "`cat $listdomains | grep . | awk '!x[$0]++'`" > $listdomains

			md5sum_latest=`cat /vddos/auto-add/panel/kloxo-mr/nginx/md5sum-latest.txt | awk 'NR==1 {print $1}'`
			md5sum_new=`cat $listdomains | md5sum | awk 'NR==1 {print $1}'`

			if [ "$md5sum_latest" != "$md5sum_new" ]; then
				echo $md5sum_new > /vddos/auto-add/panel/kloxo-mr/nginx/md5sum-latest.txt
				/usr/bin/vddos-autoadd list $listdomains
			fi
			exit 0
		fi

	fi




	if [ "$hostingpanel" = "x" ]; then
		exit 0
	fi


fi





#################################################################################
# Auto remove a domain:
# vddos-autoadd [remove] your-domain.com

if [ "$Command" = "remove" ]; then

	md5sum_website_conf_latest=`md5sum /vddos/conf.d/website.conf| awk 'NR==1 {print $1}'`
	
	Website="$2"
	Available=`awk -F: "/^$Website/" /vddos/conf.d/website.conf`
	if [ "$Available" = "" ]; then
		echo '- Remove-check: '$Website' is not available in /vddos/conf.d/website.conf ===> Skip!'|tee -a /vddos/auto-add/log.txt
		exit 0
	fi
	if [ "$Available" != "" ]; then
		sed -i "/^$Website.*/d" /vddos/conf.d/website.conf
		echo '+ Remove-Success: '$Website' auto remove from /vddos/conf.d/website.conf ===> Done!'|tee -a /vddos/auto-add/log.txt
	fi
	md5sum_website_conf_new=`md5sum /vddos/conf.d/website.conf| awk 'NR==1 {print $1}'`
	if [ "$md5sum_website_conf_latest" != "$md5sum_website_conf_new" ]; then
		/usr/bin/vddos reload |tee -a /vddos/auto-add/log.txt
	fi
fi


#############################################################################
# Auto recheck/renew ssl again for all domains:
# vddos-autoadd [ssl-again]

if [ "$Command" = 'ssl-again' ]; then
	listdomains_source="/vddos/conf.d/website.conf"
	listdomains="/vddos/auto-add/ssl-again/listdomains.txt"
	if [ ! -f $listdomains_source ]; then
		showerror
		echo ''$listdomains_source' not found!'
		exit 0
	fi

	if [ ! -d /vddos/auto-add/ssl-again/ ]; then
		mkdir -p /vddos/auto-add/ssl-again/
	fi
		
	md5sum_ssl_conf_latest=`ls -lah /vddos/ssl|md5sum | awk 'NR==1 {print $1}'`

	echo "
		[[[[[[[ `date` ]]]]]]]
	" > /vddos/auto-add/log.txt
	cat /vddos/conf.d/website.conf| grep .| grep "https" |grep "/vddos/ssl" | awk '{print $1}'| awk '!x[$0]++'|grep -v '^#'|grep -v '^*'|grep -v '^default'| awk '!x[$0]++' > $listdomains
	numberlinelistdomains=`cat $listdomains | grep . | wc -l`
	startlinenumber=1

	dong=$startlinenumber
	while [ $dong -le $numberlinelistdomains ]
	do
		Website=$(awk " NR == $dong " $listdomains); echo $Website

		if [ ! -f /vddos/ssl/"$Website".crt ] || [ ! -f /vddos/ssl/"$Website".pri ]; then
			echo '- SSL-check: '$Website' does not use Auto-SSL of vDDoS ===> Skip!'|tee -a /vddos/auto-add/log.txt
		fi

		if [ -f /vddos/ssl/"$Website".crt ] && [ -f /vddos/ssl/"$Website".pri ]; then
			if [ -f /letsencrypt/$Website.crt ] && [ -f /letsencrypt/$Website.pri ]; then
			echo '- SSL-check: '$Website' is already using Auto-SSL Certificates of vDDoS ===> Skip!'|tee -a /vddos/auto-add/log.txt
			fi

			if [ ! -f /letsencrypt/$Website.crt ] || [ ! -f /letsencrypt/$Website.pri ]; then
				echo '- Found: '$Website' is still using Self-signed Certificates ===> Re-request SSL-again!'|tee -a /vddos/auto-add/log.txt

				random=`cat /dev/urandom | tr -cd 'A-Z0-9' | head -c 5`
				echo $random > /vddos/letsencrypt/.well-known/acme-challenge/$Website.txt
				randomchecknonwww=`curl -s -L http://$Website/.well-known/acme-challenge/$Website.txt`

				rm -f /vddos/letsencrypt/.well-known/acme-challenge/$Website.txt
				if [ "$randomchecknonwww" = "$random" ]; then
					mkdir -p /letsencrypt/
					/root/.acme.sh/acme.sh --issue -d $Website -w /vddos/letsencrypt --keylength ec-256 --key-file /letsencrypt/$Website.pri --fullchain-file /letsencrypt/$Website.crt  >>/vddos/auto-add/log.txt 2>&1
					if [ -f /letsencrypt/"$Website".crt ]; then
						rm -rf /vddos/ssl/"$Website".crt
						rm -rf /vddos/ssl/"$Website".pri
						ln -s /letsencrypt/$Website.crt /vddos/ssl/$Website.crt 
						ln -s /letsencrypt/$Website.pri /vddos/ssl/$Website.pri 
					fi

					if [ ! -f /vddos/ssl/$Website.crt ] && [ -f /root/.acme.sh/"$Website"_ecc/fullchain.cer ]; then
						rm -rf /vddos/ssl/"$Website".crt
						rm -rf /vddos/ssl/"$Website".pri
						ln -s /root/.acme.sh/"$Website"_ecc/fullchain.cer /vddos/ssl/$Website.crt 
						ln -s /root/.acme.sh/"$Website"_ecc/"$Website".key /vddos/ssl/$Website.pri
					fi
				fi

				if [ "$randomchecknonwww" != "$random" ] || [ ! -f /vddos/ssl/"$Website".crt ]; then
					openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /vddos/ssl/$Website.pri -out /vddos/ssl/$Website.crt -subj "/C=US/ST=$Website/L=$Website/O=$Website/OU=vddos.voduy.com/CN=$Website" >>/vddos/auto-add/log.txt 2>&1
					chmod -R 750 /vddos/ssl/$Website.*
					echo '+ New-Success: '$Website' is still using self-certificate ===> Unable Re-request SSL-again!'|tee -a /vddos/auto-add/log.txt
				fi

				if [ -f /vddos/ssl/$Website.crt ] && [ -f /root/.acme.sh/"$Website"_ecc/fullchain.cer ]; then
					echo '+ New-Success: '$Website' Re-request SSL-again ===> Done!'|tee -a /vddos/auto-add/log.txt
				fi
			fi
		fi
		dong=$((dong + 1))
	done

	md5sum_ssl_conf_new=`ls -lah /vddos/ssl|md5sum | awk 'NR==1 {print $1}'`
	if [ "$md5sum_ssl_conf_latest" != "$md5sum_ssl_conf_new" ]; then
		/usr/bin/vddos reload |tee -a /vddos/auto-add/log.txt
	fi
	checklog
	exit 0
fi









