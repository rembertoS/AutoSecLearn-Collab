//
//  Questions.swift
//  AutoSecLearn
//
//  Created by meagan alfaro on 3/31/26.
//

import Foundation

struct QuestionStorage {
    static let allModules: [Module] = [
        
        Module(name: "Module 1: Python Automation Scripting", questions: [
            Questions(text: "Which Python library is commonly used to connect to network devices via SSH?", options: [
                AnswerOption(answer: "Netmiko", isCorrect: true),
                AnswerOption(answer: "NumPy", isCorrect: false),
                AnswerOption(answer: "Pandas", isCorrect: false),
                AnswerOption(answer: "Flask", isCorrect: false)
            ]),
            Questions(text: "Which Python library is used to connect to a Cisco switch through a serial console?", options: [
                AnswerOption(answer: "pyserial", isCorrect: true),
                AnswerOption(answer: "socket", isCorrect: false),
                AnswerOption(answer: "paramiko", isCorrect: false),
                AnswerOption(answer: "requests", isCorrect: false)
            ]),
            Questions(text: "What does the `detect_com_port()` function do in the AutoSec script?", options: [
                AnswerOption(answer: "Finds the first available USB/serial adapter port automatically", isCorrect: true),
                AnswerOption(answer: "Detects open ports on the network using a port scanner", isCorrect: false),
                AnswerOption(answer: "Configures the COM port settings on the switch", isCorrect: false),
                AnswerOption(answer: "Lists all VLANs configured on the switch", isCorrect: false)
            ]),
            Questions(text: "What is the main advantage of using Python scripts to send config commands to network devices?", options: [
                AnswerOption(answer: "It allows programmatic and repeatable configuration", isCorrect: true),
                AnswerOption(answer: "It requires no knowledge of networking", isCorrect: false),
                AnswerOption(answer: "It replaces the need for SSH entirely", isCorrect: false),
                AnswerOption(answer: "It only works on Windows devices", isCorrect: false)
            ]),
            Questions(text: "Which Python modules are imported in the AutoSec core script?", options: [
                AnswerOption(answer: "serial, serial.tools.list_ports, time, and re", isCorrect: true),
                AnswerOption(answer: "os, sys, json, and math", isCorrect: false),
                AnswerOption(answer: "flask, requests, pandas, and numpy", isCorrect: false),
                AnswerOption(answer: "netmiko, paramiko, socket, and logging", isCorrect: false)
            ]),
            Questions(text: "What does the `send_and_confirm()` function handle automatically?", options: [
                AnswerOption(answer: "Pressing Enter for [confirm] prompts during command execution", isCorrect: true),
                AnswerOption(answer: "Rebooting the switch after each command", isCorrect: false),
                AnswerOption(answer: "Saving the config to a local text file", isCorrect: false),
                AnswerOption(answer: "Opening a new SSH session per command", isCorrect: false)
            ]),
            Questions(text: "Where does the AutoSec script save the running configuration after setup?", options: [
                AnswerOption(answer: "NVRAM", isCorrect: true),
                AnswerOption(answer: "A local CSV file on the PC", isCorrect: false),
                AnswerOption(answer: "A cloud storage bucket", isCorrect: false),
                AnswerOption(answer: "The switch's flash drive only", isCorrect: false)
            ]),
            Questions(text: "Which Python version is required to run the AutoSec script?", options: [
                AnswerOption(answer: "Python 3.x", isCorrect: true),
                AnswerOption(answer: "Python 1.x", isCorrect: false),
                AnswerOption(answer: "Python 2.7 only", isCorrect: false),
                AnswerOption(answer: "Any version works equally", isCorrect: false)
            ]),
            Questions(text: "What is the benefit of integrating automation scripts into a CI/CD pipeline?", options: [
                AnswerOption(answer: "Automated and consistent deployment of configurations", isCorrect: true),
                AnswerOption(answer: "Manual review of every command before execution", isCorrect: false),
                AnswerOption(answer: "Eliminating the need for version control", isCorrect: false),
                AnswerOption(answer: "Reducing the number of network devices needed", isCorrect: false)
            ]),
            Questions(text: "What command would you run on macOS or Linux to execute the AutoSec script?", options: [
                AnswerOption(answer: "python3 configure_switch.py", isCorrect: true),
                AnswerOption(answer: "run configure_switch.py", isCorrect: false),
                AnswerOption(answer: "exec configure_switch.py", isCorrect: false),
                AnswerOption(answer: "./configure_switch.sh", isCorrect: false)
            ])
        ]),
        
        Module(name: "Module 2: Authentication", questions: [
            Questions(text: "What is the difference between password-based and key-based authentication?", options: [
                AnswerOption(answer: "Key-based uses cryptographic key pairs instead of a password", isCorrect: true),
                AnswerOption(answer: "Password-based is always more secure than key-based", isCorrect: false),
                AnswerOption(answer: "Key-based authentication requires no setup", isCorrect: false),
                AnswerOption(answer: "They are functionally identical", isCorrect: false)
            ]),
            Questions(text: "Why should you avoid hardcoding credentials in automation scripts?", options: [
                AnswerOption(answer: "Hardcoded secrets can be exposed if the script is shared or committed to version control", isCorrect: true),
                AnswerOption(answer: "Hardcoded credentials run slower than environment variables", isCorrect: false),
                AnswerOption(answer: "It makes the script harder to read", isCorrect: false),
                AnswerOption(answer: "Python does not support hardcoded strings", isCorrect: false)
            ]),
            Questions(text: "Which of the following is a secure way to manage credentials in a Python automation script?", options: [
                AnswerOption(answer: "Using environment variables or a secrets vault", isCorrect: true),
                AnswerOption(answer: "Storing them in a public GitHub repository", isCorrect: false),
                AnswerOption(answer: "Hardcoding them directly into the script", isCorrect: false),
                AnswerOption(answer: "Emailing them to the team before each run", isCorrect: false)
            ]),
            Questions(text: "What is a secrets vault used for in automation?", options: [
                AnswerOption(answer: "Securely storing and retrieving sensitive credentials at runtime", isCorrect: true),
                AnswerOption(answer: "Storing log files from network devices", isCorrect: false),
                AnswerOption(answer: "Encrypting the Python script itself", isCorrect: false),
                AnswerOption(answer: "Managing Python package dependencies", isCorrect: false)
            ]),
            Questions(text: "In the AutoSec lab script, what privilege level is assigned to the local admin user?", options: [
                AnswerOption(answer: "Privilege 15", isCorrect: true),
                AnswerOption(answer: "Privilege 1", isCorrect: false),
                AnswerOption(answer: "Privilege 7", isCorrect: false),
                AnswerOption(answer: "Privilege 10", isCorrect: false)
            ]),
            Questions(text: "According to the AutoSec security notice, when must demo credentials always be changed?", options: [
                AnswerOption(answer: "Before using the script on any real network", isCorrect: true),
                AnswerOption(answer: "Only when the network is publicly accessible", isCorrect: false),
                AnswerOption(answer: "After running the script three times", isCorrect: false),
                AnswerOption(answer: "They never need to be changed in a lab", isCorrect: false)
            ]),
            Questions(text: "What does 'console and VTY protection' refer to in network security?", options: [
                AnswerOption(answer: "Securing physical and remote access lines to the device with passwords", isCorrect: true),
                AnswerOption(answer: "Encrypting all VLAN traffic on the switch", isCorrect: false),
                AnswerOption(answer: "Blocking all incoming SSH connections", isCorrect: false),
                AnswerOption(answer: "Disabling unused switch ports", isCorrect: false)
            ]),
            Questions(text: "What is the risk of committing real credentials to version control?", options: [
                AnswerOption(answer: "They can be seen by anyone with access to the repository", isCorrect: true),
                AnswerOption(answer: "It causes merge conflicts in the codebase", isCorrect: false),
                AnswerOption(answer: "It slows down the CI/CD pipeline", isCorrect: false),
                AnswerOption(answer: "It corrupts the switch configuration", isCorrect: false)
            ]),
            Questions(text: "What are 'secure defaults' as implemented in the AutoSec script?", options: [
                AnswerOption(answer: "Console/VTY protections, local user accounts, and encrypted secrets", isCorrect: true),
                AnswerOption(answer: "Disabling all switch ports by default", isCorrect: false),
                AnswerOption(answer: "Using factory default passwords for convenience", isCorrect: false),
                AnswerOption(answer: "Blocking all traffic until manually approved", isCorrect: false)
            ]),
            Questions(text: "Which of the following best describes the purpose of an 'enable secret' on a Cisco device?", options: [
                AnswerOption(answer: "It protects privileged EXEC mode with an encrypted password", isCorrect: true),
                AnswerOption(answer: "It enables SSH access to the device", isCorrect: false),
                AnswerOption(answer: "It sets the VLAN management password", isCorrect: false),
                AnswerOption(answer: "It activates the serial console port", isCorrect: false)
            ])
        ]),
        
        Module(name: "Module 3: Multi-Host Management", questions: [
            Questions(text: "What data structure is commonly used in Python to loop through multiple network devices?", options: [
                AnswerOption(answer: "A list or inventory file", isCorrect: true),
                AnswerOption(answer: "A binary tree", isCorrect: false),
                AnswerOption(answer: "A SQL database query", isCorrect: false),
                AnswerOption(answer: "A stack data structure", isCorrect: false)
            ]),
            Questions(text: "What is the benefit of targeting dev, staging, and production from one script?", options: [
                AnswerOption(answer: "It ensures consistent logic is applied across all environments", isCorrect: true),
                AnswerOption(answer: "It eliminates the need for testing", isCorrect: false),
                AnswerOption(answer: "It merges all environments into one", isCorrect: false),
                AnswerOption(answer: "It reduces the number of Python files needed", isCorrect: false)
            ]),
            Questions(text: "What does 'applying the same configuration logic to different environments' help prevent?", options: [
                AnswerOption(answer: "Configuration drift and inconsistency between environments", isCorrect: true),
                AnswerOption(answer: "Python syntax errors in scripts", isCorrect: false),
                AnswerOption(answer: "SSH timeouts on network devices", isCorrect: false),
                AnswerOption(answer: "Overloading the CI/CD pipeline", isCorrect: false)
            ]),
            Questions(text: "When managing multiple hosts, what is the advantage of using an inventory file?", options: [
                AnswerOption(answer: "It centralizes device information so scripts don't need to be rewritten per device", isCorrect: true),
                AnswerOption(answer: "It stores the output of each command automatically", isCorrect: false),
                AnswerOption(answer: "It prevents SSH connections from timing out", isCorrect: false),
                AnswerOption(answer: "It generates reports in PDF format", isCorrect: false)
            ]),
            Questions(text: "In the AutoSec script, how is the correct serial port identified when multiple ports exist?", options: [
                AnswerOption(answer: "serial.tools.list_ports scans and finds the first USB/serial adapter", isCorrect: true),
                AnswerOption(answer: "The user manually enters the COM port number each time", isCorrect: false),
                AnswerOption(answer: "The script defaults to COM1 always", isCorrect: false),
                AnswerOption(answer: "A config file hardcodes the port number", isCorrect: false)
            ]),
            Questions(text: "What is the purpose of wrapping the main() call in a try/except block?", options: [
                AnswerOption(answer: "To catch errors and display a friendly message instead of crashing", isCorrect: true),
                AnswerOption(answer: "To run the script twice in case of failure", isCorrect: false),
                AnswerOption(answer: "To skip any device that doesn't respond", isCorrect: false),
                AnswerOption(answer: "To log all commands to a database", isCorrect: false)
            ]),
            Questions(text: "What does 'repeatable labs' mean in the context of AutoSec?", options: [
                AnswerOption(answer: "Quickly resetting and standardizing multiple switches without retyping CLI commands", isCorrect: true),
                AnswerOption(answer: "Running the same quiz questions multiple times", isCorrect: false),
                AnswerOption(answer: "Restarting the Python script after every device", isCorrect: false),
                AnswerOption(answer: "Repeating the SSH handshake on each connection", isCorrect: false)
            ]),
            Questions(text: "How can you verify the switch configuration after running the AutoSec script?", options: [
                AnswerOption(answer: "Using show vlan brief or show running-config in the terminal", isCorrect: true),
                AnswerOption(answer: "Checking the Python console output only", isCorrect: false),
                AnswerOption(answer: "Pinging all VLANs from the script", isCorrect: false),
                AnswerOption(answer: "Looking at the switch's LED indicators", isCorrect: false)
            ]),
            Questions(text: "Which terminal applications can be used to connect and verify switch configuration?", options: [
                AnswerOption(answer: "PuTTY or Tera Term", isCorrect: true),
                AnswerOption(answer: "Microsoft Word or Excel", isCorrect: false),
                AnswerOption(answer: "Wireshark or Nmap", isCorrect: false),
                AnswerOption(answer: "VS Code or PyCharm", isCorrect: false)
            ]),
            Questions(text: "What is the best practice before deploying a modified AutoSec commands list to production?", options: [
                AnswerOption(answer: "Re-run the script on a test switch first and verify with show running-config", isCorrect: true),
                AnswerOption(answer: "Deploy directly to all devices simultaneously", isCorrect: false),
                AnswerOption(answer: "Email the changes to the team for approval", isCorrect: false),
                AnswerOption(answer: "Delete the old script and start from scratch", isCorrect: false)
            ])
        ]),
        
        Module(name: "Module 4: Consistent Configurations", questions: [
            Questions(text: "What types of devices can standardized automation commands be sent to?", options: [
                AnswerOption(answer: "Switches, routers, and servers", isCorrect: true),
                AnswerOption(answer: "Only desktop computers", isCorrect: false),
                AnswerOption(answer: "Only cloud-based virtual machines", isCorrect: false),
                AnswerOption(answer: "Only devices running Windows Server", isCorrect: false)
            ]),
            Questions(text: "What does 'configuration drift' refer to in network management?", options: [
                AnswerOption(answer: "Gradual inconsistencies between devices that diverge from the intended state", isCorrect: true),
                AnswerOption(answer: "A scheduled migration to new hardware", isCorrect: false),
                AnswerOption(answer: "Automatically updating firmware on all devices", isCorrect: false),
                AnswerOption(answer: "The process of backing up device configurations", isCorrect: false)
            ]),
            Questions(text: "In the AutoSec script, what is the hostname assigned to the switch?", options: [
                AnswerOption(answer: "SW1", isCorrect: true),
                AnswerOption(answer: "SWITCH1", isCorrect: false),
                AnswerOption(answer: "FIU-SW", isCorrect: false),
                AnswerOption(answer: "AutoSec-01", isCorrect: false)
            ]),
            Questions(text: "What management IP address does the AutoSec script assign to the switch?", options: [
                AnswerOption(answer: "192.168.1.5", isCorrect: true),
                AnswerOption(answer: "10.0.0.1", isCorrect: false),
                AnswerOption(answer: "172.16.0.5", isCorrect: false),
                AnswerOption(answer: "192.168.0.1", isCorrect: false)
            ]),
            Questions(text: "Which VLAN is assigned to voice traffic in the AutoSec configuration?", options: [
                AnswerOption(answer: "VLAN 10", isCorrect: true),
                AnswerOption(answer: "VLAN 20", isCorrect: false),
                AnswerOption(answer: "VLAN 30", isCorrect: false),
                AnswerOption(answer: "VLAN 1", isCorrect: false)
            ]),
            Questions(text: "Which ports are assigned to the SERVERS VLAN in the AutoSec port layout?", options: [
                AnswerOption(answer: "Fa0/31–38", isCorrect: true),
                AnswerOption(answer: "Fa0/1–16", isCorrect: false),
                AnswerOption(answer: "Fa0/17–30", isCorrect: false),
                AnswerOption(answer: "Fa0/39–46", isCorrect: false)
            ]),
            Questions(text: "What is the purpose of the trunk port Fa0/47 in the AutoSec configuration?", options: [
                AnswerOption(answer: "It carries traffic for VLANs 1, 10, 20, 30, and 40 to the router", isCorrect: true),
                AnswerOption(answer: "It connects to a management workstation", isCorrect: false),
                AnswerOption(answer: "It is reserved for future VLAN expansion", isCorrect: false),
                AnswerOption(answer: "It provides internet access to VLAN 40 only", isCorrect: false)
            ]),
            Questions(text: "Why is keeping network behavior 'documented in code' important?", options: [
                AnswerOption(answer: "It makes configurations version-controlled, repeatable, and auditable", isCorrect: true),
                AnswerOption(answer: "It prevents the need for network engineers", isCorrect: false),
                AnswerOption(answer: "It automatically fixes misconfigurations", isCorrect: false),
                AnswerOption(answer: "It compresses configuration files to save storage", isCorrect: false)
            ]),
            Questions(text: "What QoS command is applied to voice ports in the AutoSec script?", options: [
                AnswerOption(answer: "mls qos trust cos", isCorrect: true),
                AnswerOption(answer: "qos enable voice", isCorrect: false),
                AnswerOption(answer: "set dscp ef", isCorrect: false),
                AnswerOption(answer: "priority-queue out", isCorrect: false)
            ]),
            Questions(text: "What happens to port Fa0/48 in the AutoSec configuration?", options: [
                AnswerOption(answer: "It is disabled and labeled UNUSED_PORT", isCorrect: true),
                AnswerOption(answer: "It is assigned to VLAN 40 for testing", isCorrect: false),
                AnswerOption(answer: "It is configured as a second trunk port", isCorrect: false),
                AnswerOption(answer: "It is assigned to the management VLAN", isCorrect: false)
            ])
        ]),
        
        Module(name: "Module 5: Rapid Deployment", questions: [
            Questions(text: "What is a key benefit of using automation scripts for rapid deployment?", options: [
                AnswerOption(answer: "Pushing updates to dozens of devices in minutes instead of hours", isCorrect: true),
                AnswerOption(answer: "Requiring only one device to be updated at a time", isCorrect: false),
                AnswerOption(answer: "Eliminating the need for network monitoring", isCorrect: false),
                AnswerOption(answer: "Automatically purchasing new hardware when needed", isCorrect: false)
            ]),
            Questions(text: "What does rapid deployment replace in traditional network management?", options: [
                AnswerOption(answer: "Hours of manual CLI work", isCorrect: true),
                AnswerOption(answer: "The need for IP addressing", isCorrect: false),
                AnswerOption(answer: "Version control systems", isCorrect: false),
                AnswerOption(answer: "Physical cabling between devices", isCorrect: false)
            ]),
            Questions(text: "Why is it valuable to easily re-run deployment scripts when changes are needed?", options: [
                AnswerOption(answer: "It ensures updates are applied consistently without repeating manual steps", isCorrect: true),
                AnswerOption(answer: "It creates a new script file each time", isCorrect: false),
                AnswerOption(answer: "It reboots all network devices automatically", isCorrect: false),
                AnswerOption(answer: "It archives old configurations to a cloud drive", isCorrect: false)
            ]),
            Questions(text: "Which of the following best describes what AutoSec's automation engine does?", options: [
                AnswerOption(answer: "Orchestrates SSH and serial connectivity with batch configuration across network infrastructure", isCorrect: true),
                AnswerOption(answer: "Manages software licenses across desktop computers", isCorrect: false),
                AnswerOption(answer: "Provides a GUI for manually configuring routers", isCorrect: false),
                AnswerOption(answer: "Monitors social media traffic on the network", isCorrect: false)
            ]),
            Questions(text: "What hardware is required to run the AutoSec script on a Cisco switch?", options: [
                AnswerOption(answer: "A USB-to-serial adapter, console cable, and a powered-on Cisco switch", isCorrect: true),
                AnswerOption(answer: "An ethernet patch cable and a Wi-Fi router", isCorrect: false),
                AnswerOption(answer: "A dedicated server rack and fiber optic cables", isCorrect: false),
                AnswerOption(answer: "A Raspberry Pi and a crossover cable", isCorrect: false)
            ]),
            Questions(text: "How do you install the pyserial library needed for the AutoSec script?", options: [
                AnswerOption(answer: "pip install pyserial", isCorrect: true),
                AnswerOption(answer: "brew install pyserial", isCorrect: false),
                AnswerOption(answer: "apt-get install pyserial", isCorrect: false),
                AnswerOption(answer: "import install pyserial", isCorrect: false)
            ]),
            Questions(text: "What does 'end-to-end setup' mean in the context of the AutoSec script?", options: [
                AnswerOption(answer: "Applying hostname, VLANs, port roles, QoS, and saving config in one pass", isCorrect: true),
                AnswerOption(answer: "Configuring only the first and last ports on the switch", isCorrect: false),
                AnswerOption(answer: "Running the script on both ends of a network cable", isCorrect: false),
                AnswerOption(answer: "Setting up both the switch and router simultaneously", isCorrect: false)
            ]),
            Questions(text: "What is the default gateway assigned by the AutoSec script?", options: [
                AnswerOption(answer: "192.168.1.1", isCorrect: true),
                AnswerOption(answer: "10.0.0.1", isCorrect: false),
                AnswerOption(answer: "172.16.0.1", isCorrect: false),
                AnswerOption(answer: "192.168.1.254", isCorrect: false)
            ]),
            Questions(text: "What does MOTD stand for in the AutoSec switch configuration?", options: [
                AnswerOption(answer: "Message of the Day", isCorrect: true),
                AnswerOption(answer: "Mode of Transfer Data", isCorrect: false),
                AnswerOption(answer: "Management of Terminal Devices", isCorrect: false),
                AnswerOption(answer: "Monitor Output Trigger Definition", isCorrect: false)
            ]),
            Questions(text: "Which VLAN covers ports Fa0/39–46 in the AutoSec port layout?", options: [
                AnswerOption(answer: "VLAN 40 — DEV_TEST", isCorrect: true),
                AnswerOption(answer: "VLAN 10 — VOICE", isCorrect: false),
                AnswerOption(answer: "VLAN 20 — USERS", isCorrect: false),
                AnswerOption(answer: "VLAN 30 — SERVERS", isCorrect: false)
            ])
        ])
    ]
}
