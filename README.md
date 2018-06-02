<div alt="vDDoS-Auto-Add Logo" class="separator" style="clear: both; text-align: center;">
<a href="#" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img align="right" border="0" src="https://lh4.googleusercontent.com/-hzC-sbcsyr4/WxIK_92IHtI/AAAAAAAAB6k/Cydhyyoii_sUdjzXVkfl1SGZBvjlgwvBgCLcBGAs/s333/vDDoS-Auto-Add-vDDoS-Proxy-Protection-Icon-Logo-voduy.com-trang-crop.png" /></a></div>

vDDoS Auto Add
===================


vDDoS Auto Add is a addon support for vDDoS Proxy Protection - Monitor **Domains/Aliasdomains/Subdomains** in Panel Hosting, Web Server, List Domain, Virtual Host... and automatically add them into the **website.conf** file.

----------

1/ Install vDDoS Proxy Protection:
-------------
To install vDDoS Proxy Protection please visit this site: http://vddos.voduy.com

----------


2/ Install vDDoS Auto Add:
-------------
```
curl -L https://github.com/duy13/vDDoS-Auto-Add/archive/master.zip -o vddos-auto-add.zip ; unzip vddos-auto-add.zip ; rm -f vddos-auto-add.zip
mv vDDoS-Auto-Add-master /vddos/auto-add
chmod 700 /vddos/auto-add/cron.sh; chmod 700 /vddos/auto-add/vddos-add.sh
ln -s /vddos/auto-add/vddos-add.sh /usr/bin/vddos-add
ln -s /vddos/auto-add/cron.sh /usr/bin/vddos-autoadd
```
Configure Default Setting:
-------------
```
nano /vddos/auto-add/setting.conf

Default Setting for vddos-add command:

SSL		Auto
Cache		no
Security	no
HTTP_Listen	http://0.0.0.0:80
HTTPS_Listen	https://0.0.0.0:443
HTTP_Backend	http://127.0.0.1:8080
HTTPS_Backend	https://127.0.0.1:8443

```

----------

3/ Using vDDoS Auto Add:
-------------

*/usr/bin/vddos-autoadd* automatically requests an Let's Encrypt SSL Certificate for the domain (if the domain is pointing to the IP address of the server) and adds them to */vddos/conf.d/website.conf*:

**WARNING: Please remove [...] in all the below commands!**

Add a domain:
-------------
Use the default information in *setting.conf*:
```
/usr/bin/vddos-autoadd [domain] your-domain.com

```
Or specify custom information:
```
/usr/bin/vddos-autoadd [domain] Website="your-domain.com" Cache="no" Security="no" HTTP_Listen="http://0.0.0.0:80" HTTPS_Listen="https://0.0.0.0:443" HTTP_Backend="http://127.0.0.1:8080" HTTPS_Backend="https://127.0.0.1:8443"

```

Add a list domains:
-------------
Auto get/add domains from a **list file domains** in Local Disk:
```
/usr/bin/vddos-autoadd [list] /etc/listdomains.txt
```

Auto get/add domains from a **list file domains** on **HTTP server public**:
```
/usr/bin/vddos-autoadd [http] http://private.domain.com/add-this/listdomains.txt
```

Auto get/add domains from **Local Web Server**:
```
/usr/bin/vddos-autoadd [webserver] [apache/nginx]
```

Auto get/add domains from **Local Hosting Panel**:
```
/usr/bin/vddos-autoadd [panel] [plesk] [apache/litespeed]
/usr/bin/vddos-autoadd [panel] [cpanel] [apache/litespeed]
/usr/bin/vddos-autoadd [panel] [directadmin] [apache/nginx/litespeed]
/usr/bin/vddos-autoadd [panel] [cwp] [apache/litespeed]
/usr/bin/vddos-autoadd [panel] [vestacp] [apache/nginx]
/usr/bin/vddos-autoadd [panel] [cyberpanel] [openlitespeed]
/usr/bin/vddos-autoadd [panel] [webuzo] [apache/nginx]
/usr/bin/vddos-autoadd [panel] [aapanel] [apache/nginx]
/usr/bin/vddos-autoadd [panel] [virtualmin] [apache/nginx]
/usr/bin/vddos-autoadd [panel] [kloxo-mr] [apache/nginx]
/usr/bin/vddos-autoadd [panel] [sentora] [apache]

```

4/ Crontab vDDoS Auto Add:
-------------

You can configure vDDoS Auto Add to automatically detect new **Domains/Aliasdomains/Subdomains** added to the server and add it to the *website.conf* file. 

Example in VestaCP:
```
echo '*/15  *  *  *  * root /usr/bin/vddos-autoadd panel vestacp apache' >> /etc/crontab
```

Or for example get domains list in Apache:
```
echo '*/5  *  *  *  * root /usr/bin/vddos-autoadd webserver apache' >> /etc/crontab
```

5/ More Config:
---------------
Document: http://vddos.voduy.com
```
Still in beta, use at your own risk! It is provided without any warranty!
```