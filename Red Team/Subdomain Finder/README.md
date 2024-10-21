# 🔍 Subdomain Enumeration and Vulnerability Scanning Script

This is a comprehensive bash script designed for subdomain enumeration, DNS resolution, live host detection, and vulnerability scanning. It integrates several popular tools to automate recon tasks and streamline the discovery of potentially vulnerable targets in a domain.

## ⚙️ Features
- **Subdomain Enumeration** using multiple tools: `subfinder`, `amass`, `assetfinder`, `findomain`, `waybackurls`, `shuffledns`, and CRT.SH scraping.
- **DNS Resolution** with `MassDNS` and `DNSx`.
- **Live Host Detection** using `httprobe` and `naabu`.
- **Screenshot Capture** with `Aquatone` and `Gowitness`.
- **Port Scanning** with `Nmap` (Basic and High modes).
- **Vulnerability Scanning** with `Nuclei`, `Nikto`, `Gf`, and `ffuf`.

## 🚀 How to Use

### 📥 Installation
Ensure you have the required tools installed on your system:
- `subfinder`, `amass`, `assetfinder`, `findomain`, `waybackurls`, `shuffledns`, `curl`, `jq`
- `MassDNS`, `DNSx`, `httprobe`, `naabu`, `Aquatone`, `Gowitness`
- `Nmap`, `Nuclei`, `Nikto`, `Gf`, `ffuf`

### 📜 Usage
Run the script with the domain and scan mode as arguments:

```bash
./ScanNinja.sh <domain> <scan_mode>
```
### 🔧 Parameters
Parameter	Description__
- Domains:	The target domain to discover subdomains for.
- scan_mode:	Choose between basic (Top 1000 ports scan) or high (Full port scan with OS and service detection).

### ✍️ Example 

```bash
./ScanNinja.sh example.com <low or high>
```

### 📝 Output

### All results will be stored in a directory named after the target domain. The main output files include:

- all_subdomains.txt: All discovered subdomains.
- resolved_subdomains.txt: DNS-resolved subdomains.
- live_subdomains.txt: Live subdomains.
- nmap_results/: Nmap scan results.
- nuclei_vulnerabilities.txt: Vulnerability scan results.
- nikto_results/: Nikto scan results.
- gf_xss_vulnerable.txt: XSS vulnerability detection.
- ffuf_directory_fuzz.txt: Directory fuzzing results.
- aquatone_screenshots/ and gowitness_screenshots/: Captured screenshots of live hosts.
  
### 🎉 Example Output Structure

📂 example.com

 ├── 📄 all_subdomains.txt 
 
 ├── 📄 resolved_subdomains.txt
 
 ├── 📄 live_subdomains.txt
 
 ├── 📂 nmap_results
 
 ├── 📂 nikto_results
 
 ├── 📄 nuclei_vulnerabilities.txt
 
 ├── 📄 gf_xss_vulnerable.txt
 
 ├── 📄 ffuf_directory_fuzz.txt
 
 ├── 📂 aquatone_screenshots
 
 |── 📂 gowitness_screenshots

 
 ### 🛠️ Tools Integrated

This script integrates a range of powerful tools for subdomain enumeration, DNS resolution, live host detection, port scanning, and vulnerability assessment. Below is a list of each tool used, along with its purpose in the scanning process:

| Tool              | Emoji  | Description                                                                                          |
|-------------------|--------|------------------------------------------------------------------------------------------------------|
| **Subfinder**      | 🔍     | Fast passive subdomain discovery tool to identify subdomains of a target domain.                      |
| **Amass**          | 🕵️‍♂️    | Comprehensive subdomain enumeration tool that gathers subdomains using passive reconnaissance.       |
| **Assetfinder**    | 🗂️     | Discovers subdomains by scraping public sources and third-party APIs.                                |
| **Findomain**      | 🌐     | Efficient subdomain discovery tool leveraging multiple sources including DNS and certificate transparency logs. |
| **Waybackurls**    | 🕰️     | Fetches historical URLs from the Wayback Machine to find potential subdomains and resources.          |
| **Shuffledns**     | 🔄     | High-speed DNS resolution tool that uses wordlists and resolvers to find valid subdomains.            |
| **MassDNS**        | 📡     | A powerful DNS resolution tool that performs bulk DNS queries using a list of resolvers.             |
| **DNSx**           | ⚡     | DNS resolution and probe tool that checks the validity of subdomains by resolving and probing services. |
| **Httprobe**       | 🖥️     | Probes for live HTTP/HTTPS services on discovered subdomains to check if they are accessible.         |
| **Naabu**          | 🚀     | A fast and customizable port scanning tool designed to identify open ports on target subdomains.      |
| **Aquatone**       | 📸     | A subdomain takeover and screenshot capture tool that helps visualize and report on live services.   |
| **Gowitness**      | 🎯     | A tool to capture screenshots of web pages based on a list of URLs, useful for web reconnaissance.   |
| **Nmap**           | 🛠️     | A widely-used network scanner for host discovery, port scanning, OS detection, and vulnerability analysis. |
| **Nuclei**         | 🧬     | Vulnerability scanning tool that runs templated scans for various known CVEs and vulnerabilities.    |
| **Nikto**          | 🕸️     | A web server scanner that identifies common vulnerabilities like misconfigurations and outdated software. |
| **Gf**             | 📝     | A tool that helps identify and extract potentially vulnerable parameters from web responses (e.g., XSS, SQLi). |
| **Ffuf**           | 🏗️     | A fast web fuzzer used to brute force directories, files, and parameters on discovered subdomains.   |

### 🔑 Key Roles:
- **Subdomain Enumeration**: Tools like Subfinder, Amass, Assetfinder, Findomain, Waybackurls, and CRT.SH scraping are used to discover potential subdomains.
- **DNS Resolution**: Tools like Shuffledns, MassDNS, and DNSx help identify live subdomains and IPs by resolving DNS records.
- **Live Host Detection**: Tools like Httprobe and Naabu ensure that only live subdomains are targeted for further analysis by checking for active services and open ports.
- **Port Scanning**: Nmap scans subdomains for open ports, service detection, and potential vulnerabilities.
- **Vulnerability Scanning**: Nuclei, Nikto, Gf, and Ffuf help identify known vulnerabilities, misconfigurations, and perform brute-force attacks for directories and parameters.
- **Visualization**: Aquatone and Gowitness capture visual representations of live services, helping to spot misconfigurations or subdomain takeovers quickly.

Each of these tools plays a vital role in automating reconnaissance and vulnerability scanning, providing a comprehensive security assessment of a target domain.



### 📊 Results

The script automates the complete process from subdomain discovery to vulnerability scanning, saving time and effort during reconnaissance

### ⚠️ Disclaimer
This script is intended for educational purposes and authorized security assessments only. Do not use it for malicious activities. Always obtain permission before scanning a target.

### ✨ Contribution

Feel free to contribute by submitting issues or pull requests. If you have any feature requests, let us know!

#### Contributors
- [Smyle](https://github.com/vishuchauhan27)
- [lovish](https://github.com/lovish83)
