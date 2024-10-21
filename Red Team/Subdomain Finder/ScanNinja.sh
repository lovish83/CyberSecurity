#!/bin/bash

# Colors for pretty output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No color

# Domain to discover subdomains for
DOMAIN=$1

# Scan mode: basic or high
SCAN_MODE=$2

# Ensure a domain was provided
if [ -z "$DOMAIN" ]; then
  echo -e "${RED}Usage: $0 <domain> <scan_mode (basic/high)>${NC}"
  exit 1
fi

# Ensure a scan mode was provided
if [ -z "$SCAN_MODE" ]; then
  echo -e "${RED}Please specify the scan mode: basic or high${NC}"
  exit 1
fi

# Create a directory for the results
mkdir -p $DOMAIN && cd $DOMAIN

##############################################
# Step 1: Subdomain Enumeration (Multiple Tools)
##############################################
echo -e "${YELLOW}[*] Finding subdomains for ${DOMAIN} with multiple tools...${NC}"

# Run subfinder, amass, assetfinder, findomain, waybackurls, shuffledns, and crt.sh scraping in parallel
subfinder -d $DOMAIN -o subfinder_subdomains.txt &
amass enum -passive -d $DOMAIN -o amass_subdomains.txt &
assetfinder --subs-only $DOMAIN > assetfinder_subdomains.txt &
findomain -t $DOMAIN -u findomain_subdomains.txt &
waybackurls $DOMAIN > waybackurls.txt &
shuffledns -d $DOMAIN -w /path/to/wordlist.txt -r /path/to/resolvers.txt -o shuffledns_subdomains.txt &
# CRT.SH scraping using curl
curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > crtsh_subdomains.txt &

# Wait for all background jobs to finish
wait

# Combine subdomain results from all tools and remove duplicates
cat subfinder_subdomains.txt amass_subdomains.txt assetfinder_subdomains.txt findomain_subdomains.txt waybackurls.txt shuffledns_subdomains.txt crtsh_subdomains.txt | sort -u > all_subdomains.txt
echo -e "${GREEN}[+] Subdomain discovery completed. $(wc -l all_subdomains.txt | cut -d ' ' -f 1) subdomains found.${NC}"

##########################################
# Step 2: DNS Resolution (MassDNS & DNSx)
##########################################
echo -e "${YELLOW}[*] Resolving subdomains with MassDNS and DNSx...${NC}"
massdns -r /path/to/resolvers.txt -o S all_subdomains.txt > massdns_resolved.txt
cat all_subdomains.txt | dnsx -silent -resp-only -a -o dnsx_resolved.txt
cat massdns_resolved.txt dnsx_resolved.txt | sort -u > resolved_subdomains.txt
echo -e "${GREEN}[+] DNS resolution completed. $(wc -l resolved_subdomains.txt | cut -d ' ' -f 1) valid subdomains found.${NC}"

##############################################
# Step 3: Probing for Live Hosts (Httprobe, Naabu)
##############################################
echo -e "${YELLOW}[*] Probing for live hosts with Httprobe and Naabu...${NC}"
cat resolved_subdomains.txt | httprobe > live_hosts_http.txt &
naabu -silent -iL resolved_subdomains.txt -o live_ports.txt &
wait

# Combine live hosts from Httprobe and Naabu results
cat live_hosts_http.txt live_ports.txt | sort -u > live_subdomains.txt
echo -e "${GREEN}[+] Live host detection completed. $(wc -l live_subdomains.txt | cut -d ' ' -f 1) live hosts found.${NC}"

##################################################
# Step 4: Taking Screenshots with Aquatone/Gowitness
##################################################
echo -e "${YELLOW}[*] Taking screenshots of live hosts...${NC}"
mkdir -p screenshots
cat live_subdomains.txt | aquatone -out aquatone_screenshots &
gowitness file -f live_subdomains.txt --destination gowitness_screenshots --log-level error &
wait
echo -e "${GREEN}[+] Screenshots captured.${NC}"

################################################
# Step 5: Nmap Scanning - Basic or High
################################################
echo -e "${YELLOW}[*] Running Nmap scans on live subdomains (${SCAN_MODE} scan)...${NC}"
mkdir -p nmap_results

for domain in $(cat live_subdomains.txt); do
  echo -e "${YELLOW}[*] Scanning $domain with Nmap (${SCAN_MODE})...${NC}"

  if [ "$SCAN_MODE" == "basic" ]; then
    # Basic Nmap scan - Top 1000 ports
    nmap -p- -T4 --top-ports 1000 -oN nmap_results/${domain}_basic.txt $domain &
  elif [ "$SCAN_MODE" == "high" ]; then
    # High Nmap scan - Full port scan, service detection, OS detection
    nmap -p 1-65535 -T4 -A -oN nmap_results/${domain}_high.txt $domain &
  else
    echo -e "${RED}[-] Invalid scan mode: $SCAN_MODE. Please choose 'basic' or 'high'.${NC}"
    exit 1
  fi
done
wait
echo -e "${GREEN}[+] Nmap scanning completed. Results saved in nmap_results directory.${NC}"

#######################################################
# Step 6: Vulnerability Scanning (Nuclei, Nikto, Gf, ffuf)
#######################################################
echo -e "${YELLOW}[*] Running vulnerability scans...${NC}"

# Nuclei scanning
nuclei -l live_subdomains.txt -o nuclei_vulnerabilities.txt &
# Nikto web server vulnerability scan
for domain in $(cat live_subdomains.txt); do
  nikto -h $domain -output nikto_results/${domain}_nikto.txt &
done
# Gf to detect vulnerable patterns from responses
cat live_subdomains.txt | gf xss | tee -a gf_xss_vulnerable.txt &
# Ffuf for directory fuzzing
ffuf -w /path/to/wordlist.txt -u https://FUZZ.$DOMAIN -o ffuf_directory_fuzz.txt &
wait

echo -e "${GREEN}[+] Vulnerability scanning completed. Results saved in the current directory.${NC}"

#######################################
# Final Report
#######################################
echo -e "${GREEN}[+] All tasks completed successfully.${NC}"
echo -e "${YELLOW}Results are in the $(pwd) directory:${NC}"
echo -e "${YELLOW}- Subdomains: all_subdomains.txt${NC}"
echo -e "${YELLOW}- Resolved Subdomains: resolved_subdomains.txt${NC}"
echo -e "${YELLOW}- Live Hosts: live_subdomains.txt${NC}"
echo -e "${YELLOW}- Nmap Scans: nmap_results/${NC}"
echo -e "${YELLOW}- Vulnerabilities: nuclei_vulnerabilities.txt, nikto_results/, gf_xss_vulnerable.txt, ffuf_directory_fuzz.txt${NC}"
echo -e "${YELLOW}- Screenshots: aquatone_screenshots/ and gowitness_screenshots/${NC}"
