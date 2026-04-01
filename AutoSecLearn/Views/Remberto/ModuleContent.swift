//
//  ModuleContent.swift
//  AutoSecLearn
//
//  Created by Remberto Silva on 3/30/26.
//

import Foundation

struct ModuleContent {
    static let modules: [LearningModule] = [
        pythonScriptingModule,
        multipleAuthModule,
        multiHostModule,
        consistentConfigModule,
        rapidDeployModule
    ]

    // MARK: - Module 1: Python Automation Scripting

    static let pythonScriptingModule = LearningModule(
        id: "r_python_scripting",
        title: "Python Automation Scripting",
        description: "Use Python and Netmiko to automate network device configuration and integrate scripts into CI/CD pipelines.",
        icon: "chevron.left.forwardslash.chevron.right",
        color: "pythonOrange",
        lessons: [
            Lesson(
                id: "r_py_lesson_1",
                title: "Getting Started with Netmiko",
                sections: [
                    LessonSection(
                        id: "r_py_1_1",
                        heading: "What is Netmiko?",
                        content: """
                        Netmiko is an open-source Python library that simplifies SSH connections to multi-vendor network devices. It was created by Kirk Byers and builds on top of Paramiko to handle the quirks of network device CLIs automatically.

                        Why Netmiko?
                        - Vendor-agnostic: Supports Cisco IOS, NX-OS, Juniper, Arista, and dozens of others
                        - Automatic prompt handling: Detects device prompts without manual timing
                        - Built-in mode switching: Handles enable mode, config mode, and privilege levels
                        - Error detection: Raises exceptions when commands fail or return unexpected output

                        Installation:
                        pip install netmiko

                        Common device_type values:
                        - cisco_ios — Cisco IOS routers and switches
                        - cisco_nxos — Cisco Nexus data center switches
                        - cisco_asa — Cisco ASA firewalls
                        - juniper_junos — Juniper routers
                        - arista_eos — Arista switches

                        Always verify the exact device_type for your hardware in the Netmiko documentation before deploying automation scripts.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_py_ie_1",
                                type: .multipleChoice,
                                prompt: "Which pip package provides SSH automation for network devices?",
                                correctAnswer: "netmiko",
                                options: ["pyserial", "netmiko", "paramiko", "requests"],
                                explanation: "Netmiko is the go-to library for automating SSH connections to multi-vendor network devices."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_py_1_2",
                        heading: "Your First Connection",
                        content: """
                        The core of Netmiko is the ConnectHandler class. You pass a dictionary of device parameters and it establishes and manages the SSH session for you.

                        Basic connection example:
                        from netmiko import ConnectHandler

                        device = {
                            'device_type': 'cisco_ios',
                            'host': '192.168.1.1',
                            'username': 'admin',
                            'password': 'mypassword',
                            'secret': 'enablepassword',
                        }

                        connection = ConnectHandler(**device)
                        output = connection.send_command('show version')
                        print(output)
                        connection.disconnect()

                        Key ConnectHandler parameters:
                        - device_type: Identifies the OS/vendor for correct prompt parsing
                        - host: IP address or hostname of the device
                        - username / password: SSH login credentials
                        - secret: The enable password for devices that require privileged mode

                        send_command() is for read-only show commands. For configuration changes, you will use send_config_set() which is covered in the next lesson.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_py_ie_2",
                                type: .fillInBlank,
                                prompt: "ConnectHandler requires a _____ parameter that identifies the vendor and OS type.",
                                correctAnswer: "device_type",
                                options: nil,
                                explanation: "device_type tells Netmiko which vendor and OS the device is running so it can parse prompts and commands correctly."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_py_lesson_2",
                title: "Sending Configuration Commands",
                sections: [
                    LessonSection(
                        id: "r_py_2_1",
                        heading: "Using send_config_set()",
                        content: """
                        While send_command() handles read-only operations, send_config_set() puts the device into global configuration mode and sends a list of commands automatically.

                        Example — configuring hostname and a banner:
                        connection.enable()  # Enter privileged EXEC mode

                        config_commands = [
                            'hostname SW-CORE-01',
                            'banner motd # Authorized access only #',
                            'ip domain-name corp.local',
                        ]

                        output = connection.send_config_set(config_commands)
                        print(output)

                        How it works:
                        1. Netmiko automatically runs 'configure terminal' before your commands
                        2. It sends each command in the list sequentially
                        3. It runs 'end' after the last command to exit config mode
                        4. It returns the full terminal output as a string

                        Tip: Verify changes immediately after by calling send_command('show running-config') and checking the output.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_py_ie_3",
                                type: .multipleChoice,
                                prompt: "Which Netmiko method sends a list of configuration commands to a device?",
                                correctAnswer: "send_config_set()",
                                options: ["send_command()", "send_config_set()", "push_config()", "configure()"],
                                explanation: "send_config_set() automatically handles entering and exiting global configuration mode."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_py_2_2",
                        heading: "Saving Changes Programmatically",
                        content: """
                        After configuring a device, changes exist only in running-config. If the device reboots before saving, all changes are lost. Automation scripts must always save configuration to NVRAM.

                        Two equivalent commands save the running configuration:
                        - write memory (shorthand: wr)
                        - copy running-config startup-config

                        In Netmiko:
                        connection.save_config()  # Recommended — sends the correct save command for the device type

                        # Or explicitly:
                        connection.send_command('write memory')

                        Best practices for saving:
                        - Always call save_config() at the end of any script that makes changes
                        - Log the output of the save command for audit purposes
                        - In critical environments, read back startup-config after saving to verify it matches running-config
                        - Avoid saving during peak traffic hours for very large configurations

                        Never assume changes are persisted — always save explicitly.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_py_ie_4",
                                type: .trueFalse,
                                prompt: "Configuration changes made via Netmiko are automatically saved when you disconnect.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Changes only apply to running-config. You must explicitly call save_config() or 'write memory' to persist them across reboots."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_py_lesson_3",
                title: "Managing Multiple Devices",
                sections: [
                    LessonSection(
                        id: "r_py_3_1",
                        heading: "Looping Through an Inventory",
                        content: """
                        One of Python's biggest advantages over manual CLI work is the ability to apply the same configuration to dozens of devices in a single script run.

                        Simple in-script inventory using a list of dictionaries:
                        devices = [
                            {'device_type': 'cisco_ios', 'host': '10.0.0.1', 'username': 'admin', 'password': 'pass1'},
                            {'device_type': 'cisco_ios', 'host': '10.0.0.2', 'username': 'admin', 'password': 'pass1'},
                            {'device_type': 'cisco_ios', 'host': '10.0.0.3', 'username': 'admin', 'password': 'pass1'},
                        ]

                        config_commands = [
                            'ntp server 10.0.0.100',
                            'logging 10.0.0.200',
                        ]

                        for device in devices:
                            connection = ConnectHandler(**device)
                            connection.send_config_set(config_commands)
                            connection.save_config()
                            connection.disconnect()
                            print(f"Configured {device['host']}")

                        This loop connects to each device, applies the same NTP and logging commands, saves, and moves to the next. What would take hours manually now runs in minutes.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_py_ie_5",
                                type: .multipleChoice,
                                prompt: "What Python data structure is best for storing a list of device connection parameters?",
                                correctAnswer: "A list of dictionaries",
                                options: ["A tuple of tuples", "A list of dictionaries", "A set of strings", "A single dictionary"],
                                explanation: "A list of dictionaries lets you iterate with a for loop while storing each device's unique parameters (host, credentials, type)."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_py_3_2",
                        heading: "Using an Inventory File",
                        content: """
                        Hard-coding device lists inside scripts becomes unmanageable as networks grow. Best practice is to store your inventory in an external file — JSON or YAML are both popular choices.

                        Example inventory.json:
                        {
                          "devices": [
                            {"host": "10.0.1.1", "device_type": "cisco_ios", "environment": "dev"},
                            {"host": "10.0.2.1", "device_type": "cisco_ios", "environment": "staging"},
                            {"host": "10.0.3.1", "device_type": "cisco_ios", "environment": "production"}
                          ]
                        }

                        Loading and filtering by environment:
                        import json

                        with open('inventory.json') as f:
                            inventory = json.load(f)

                        target_env = 'staging'
                        targets = [d for d in inventory['devices'] if d['environment'] == target_env]

                        for device in targets:
                            # connect and configure...

                        This pattern lets one script target dev, staging, or production by just changing target_env. It also keeps device lists out of version control when using separate inventory files with .gitignore.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_py_ie_6",
                                type: .fillInBlank,
                                prompt: "To load a JSON inventory file in Python, you import the _____ module.",
                                correctAnswer: "json",
                                options: nil,
                                explanation: "Python's built-in json module provides json.load() to parse JSON files into Python dictionaries and lists."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_py_lesson_4",
                title: "CI/CD and Scheduled Automation",
                sections: [
                    LessonSection(
                        id: "r_py_4_1",
                        heading: "Integrating into CI/CD Pipelines",
                        content: """
                        Infrastructure-as-code means treating your network configuration scripts the same way software teams treat application code — version-controlled, reviewed, and deployed through automated pipelines.

                        How a CI/CD pipeline works for network automation:
                        1. Engineer commits a change to the automation script or config template in Git
                        2. Pipeline triggers automatically (GitHub Actions, Jenkins, GitLab CI)
                        3. Pipeline runs tests against a lab device or network simulation
                        4. On passing tests, the pipeline deploys to production devices
                        5. Pipeline logs results and sends notifications

                        Example GitHub Actions workflow step:
                        - name: Deploy network config
                          run: python deploy_config.py --env production
                          env:
                            NET_PASSWORD: ${{ secrets.NET_PASSWORD }}

                        Benefits:
                        - Every change is reviewed before reaching production
                        - Credentials stored as pipeline secrets, not in source code
                        - Full audit trail of who changed what and when
                        - Rollback is as simple as reverting the Git commit
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_py_ie_7",
                                type: .trueFalse,
                                prompt: "Python automation scripts can run inside CI/CD pipeline workflows like GitHub Actions.",
                                correctAnswer: "True",
                                options: ["True", "False"],
                                explanation: "CI/CD platforms like GitHub Actions, Jenkins, and GitLab CI all support running Python scripts as pipeline steps."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_py_4_2",
                        heading: "Scheduled Tasks",
                        content: """
                        Not all automation needs to be triggered by a code commit. Many operations — backups, compliance checks, health polls — should run on a schedule automatically.

                        macOS and Linux: cron
                        Cron runs scripts at specified times using a simple syntax:

                        # Run backup script every day at 2:00 AM
                        0 2 * * * /usr/bin/python3 /opt/scripts/backup_configs.py

                        # Run compliance check every Monday at 6:00 AM
                        0 6 * * 1 /usr/bin/python3 /opt/scripts/compliance_check.py

                        Edit your crontab with: crontab -e

                        Windows: Task Scheduler
                        - Open Task Scheduler → Create Basic Task
                        - Set trigger (daily, weekly, on startup)
                        - Set action to run python.exe with your script path as the argument

                        Best practices for scheduled scripts:
                        - Log all output to a timestamped file for debugging
                        - Send email or Slack alerts on failure
                        - Use absolute file paths, not relative paths, inside scheduled scripts
                        - Always test the script manually before scheduling it
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_py_ie_8",
                                type: .multipleChoice,
                                prompt: "Which tool is used to schedule automated scripts on macOS and Linux?",
                                correctAnswer: "cron",
                                options: ["Task Scheduler", "cron", "launchd only", "Ansible"],
                                explanation: "cron is the standard scheduling utility on macOS and Linux. Edit your scheduled jobs with 'crontab -e'."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_r_python",
            title: "Python Automation Scripting Assessment",
            questions: [
                QuizQuestion(
                    id: "r_pq_1",
                    question: "Which Python library provides SSH automation to multi-vendor network devices?",
                    options: ["pyserial", "Netmiko", "paramiko", "socket"],
                    correctAnswerIndex: 1,
                    explanation: "Netmiko builds on Paramiko to handle vendor-specific CLI quirks automatically.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_pq_2",
                    question: "What Netmiko method is used to send configuration commands?",
                    options: ["send_command()", "send_config_set()", "push_config()", "configure_terminal()"],
                    correctAnswerIndex: 1,
                    explanation: "send_config_set() automatically enters and exits global configuration mode.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_pq_3",
                    question: "How do you save the running configuration so it persists across a reboot?",
                    options: ["Auto-saved on disconnect", "connection.save_config() or 'write memory'", "send_command('save')", "It cannot be done via Python"],
                    correctAnswerIndex: 1,
                    explanation: "save_config() or 'write memory' copies running-config to NVRAM (startup-config).",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_pq_4",
                    question: "What file format is commonly used for storing device inventories externally?",
                    options: ["CSV only", "JSON or YAML", "XML only", "Plain text"],
                    correctAnswerIndex: 1,
                    explanation: "JSON and YAML are both popular for inventory files due to their readability and native Python support.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_pq_5",
                    question: "What ConnectHandler parameter tells Netmiko which vendor/OS the device runs?",
                    options: ["host", "device_type", "vendor", "platform"],
                    correctAnswerIndex: 1,
                    explanation: "device_type selects the correct driver for prompt detection and command handling.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_pq_6",
                    question: "What is 'infrastructure-as-code'?",
                    options: ["Building physical hardware from code", "Managing configuration through version-controlled scripts", "Writing code on physical servers", "Using infrastructure to generate apps"],
                    correctAnswerIndex: 1,
                    explanation: "Infrastructure-as-code applies software development practices — version control, CI/CD, code review — to infrastructure configuration.",
                    difficulty: .advanced
                ),
                QuizQuestion(
                    id: "r_pq_7",
                    question: "Which cron expression runs a script every day at 2:00 AM?",
                    options: ["2 0 * * *", "0 2 * * *", "* * 2 0 *", "0 0 2 * *"],
                    correctAnswerIndex: 1,
                    explanation: "Cron format is: minute hour day month weekday. '0 2 * * *' means minute 0, hour 2, every day.",
                    difficulty: .advanced
                ),
                QuizQuestion(
                    id: "r_pq_8",
                    question: "Why should device credentials NOT be hardcoded in automation scripts?",
                    options: ["It makes scripts run slower", "Scripts in version control expose credentials to anyone with repo access", "Python doesn't support string variables", "Devices reject hardcoded passwords"],
                    correctAnswerIndex: 1,
                    explanation: "Hardcoded credentials in source code are visible to all contributors and persist in git history even after removal.",
                    difficulty: .intermediate
                )
            ]
        )
    )

    // MARK: - Module 2: Multiple Authentication

    static let multipleAuthModule = LearningModule(
        id: "r_multi_auth",
        title: "Multiple Authentication",
        description: "Compare password-based and key-based access methods and learn to handle credentials securely in automation scripts.",
        icon: "key.fill",
        color: "authPurple",
        lessons: [
            Lesson(
                id: "r_auth_lesson_1",
                title: "Password vs. Key-Based Authentication",
                sections: [
                    LessonSection(
                        id: "r_auth_1_1",
                        heading: "Password-Based Authentication",
                        content: """
                        Password-based authentication is the most common method for accessing network devices. The user provides a username and password over an encrypted SSH session.

                        How it works with Netmiko:
                        device = {
                            'device_type': 'cisco_ios',
                            'host': '10.0.0.1',
                            'username': 'admin',
                            'password': 'SecurePass123!',
                        }
                        connection = ConnectHandler(**device)

                        Advantages:
                        - Simple to set up — no key generation required
                        - Familiar to all network engineers
                        - Works on every SSH-enabled device out of the box

                        Disadvantages:
                        - Passwords can be guessed, phished, or leaked
                        - Hard to rotate across hundreds of devices at once
                        - Risk of hardcoding passwords in scripts (a serious security issue)
                        - Weaker against brute-force attacks compared to key-based auth
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_auth_ie_1",
                                type: .multipleChoice,
                                prompt: "What is a major disadvantage of password-based authentication in automation?",
                                correctAnswer: "Passwords can be accidentally hardcoded in scripts and leaked",
                                options: ["It requires generating key pairs", "Passwords can be accidentally hardcoded in scripts and leaked", "It only works on Cisco devices", "It requires a RADIUS server"],
                                explanation: "Hardcoded passwords in automation scripts are a common security mistake — they end up in version control and are visible to anyone with repo access."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_auth_1_2",
                        heading: "Key-Based Authentication",
                        content: """
                        SSH key-based authentication uses a cryptographic key pair instead of a password. The private key stays on your machine; the public key is installed on the network device.

                        Generating a key pair:
                        ssh-keygen -t rsa -b 4096 -f ~/.ssh/network_automation_key

                        Using keys with Netmiko:
                        device = {
                            'device_type': 'cisco_ios',
                            'host': '10.0.0.1',
                            'username': 'admin',
                            'use_keys': True,
                            'key_file': '~/.ssh/network_automation_key',
                        }
                        connection = ConnectHandler(**device)

                        Advantages:
                        - No password to steal, guess, or hardcode
                        - Private key never leaves your machine
                        - Easy to revoke access by removing the public key from a device
                        - Can be protected with an additional passphrase

                        Disadvantages:
                        - More initial setup required
                        - Key files must be kept secure (wrong permissions = security risk)
                        - Not all older network devices support key-based auth
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_auth_ie_2",
                                type: .trueFalse,
                                prompt: "In key-based authentication, the private key is installed on the network device.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "The PUBLIC key goes on the device. The PRIVATE key stays on your local machine and is never shared."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_auth_lesson_2",
                title: "Handling Credentials Securely",
                sections: [
                    LessonSection(
                        id: "r_auth_2_1",
                        heading: "Environment Variables",
                        content: """
                        The simplest way to avoid hardcoding credentials is to load them from environment variables at runtime. The script never contains the actual secret.

                        Setting environment variables:
                        export NET_USERNAME=admin
                        export NET_PASSWORD=SecurePass123!

                        Reading them in Python:
                        import os

                        device = {
                            'device_type': 'cisco_ios',
                            'host': '10.0.0.1',
                            'username': os.environ['NET_USERNAME'],
                            'password': os.environ['NET_PASSWORD'],
                        }

                        In CI/CD pipelines (GitHub Actions example):
                        env:
                          NET_PASSWORD: ${{ secrets.NET_PASSWORD }}

                        Best practices:
                        - Never print environment variables in logs
                        - Use a .env file locally with python-dotenv, and add .env to .gitignore
                        - In production, inject secrets through the deployment system (Kubernetes secrets, pipeline secrets)
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_auth_ie_3",
                                type: .fillInBlank,
                                prompt: "In Python, use os.environ['KEY'] or os.___('KEY') to safely read environment variables.",
                                correctAnswer: "getenv",
                                options: nil,
                                explanation: "os.getenv('KEY') reads an environment variable and returns None if it's not set, which is safer than os.environ['KEY'] which raises a KeyError."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_auth_2_2",
                        heading: "Secrets Vaults",
                        content: """
                        For enterprise environments, secrets vaults provide centralized, audited, and rotatable credential storage. Scripts fetch credentials at runtime without ever storing them locally.

                        Popular vault solutions:
                        - HashiCorp Vault — industry standard, self-hosted or cloud
                        - AWS Secrets Manager — native AWS integration
                        - Azure Key Vault — native Azure integration
                        - CyberArk — common in large enterprises

                        Python example with HashiCorp Vault:
                        import hvac

                        client = hvac.Client(url='https://vault.corp.local')
                        client.auth.approle.login(role_id=ROLE_ID, secret_id=SECRET_ID)

                        secret = client.secrets.kv.read_secret_version(path='network/cisco')
                        password = secret['data']['data']['password']

                        Why vaults over environment variables:
                        - Centralized rotation — change a password once, all scripts pick it up automatically
                        - Full audit log of who accessed which secret and when
                        - Fine-grained access control — script A can only access its own credentials
                        - Automatic expiry and lease management
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_auth_ie_4",
                                type: .multipleChoice,
                                prompt: "What is the main advantage of a secrets vault over environment variables?",
                                correctAnswer: "Centralized rotation and audit logging of credential access",
                                options: ["Vaults are free and open source", "Centralized rotation and audit logging of credential access", "Environment variables require a paid license", "Vaults work without internet access"],
                                explanation: "Vaults provide centralized management — credentials can be rotated once and all scripts automatically use the new value, with a full audit trail."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_auth_lesson_3",
                title: "Role-Based Access Control",
                sections: [
                    LessonSection(
                        id: "r_auth_3_1",
                        heading: "Privilege Levels on Cisco Devices",
                        content: """
                        Cisco IOS supports 16 privilege levels (0–15) that control what commands a user can run. Automation accounts should only have the minimum privilege needed.

                        Common privilege levels:
                        - Level 1: User EXEC — basic show commands only
                        - Level 15: Privileged EXEC — full access (equivalent to root)
                        - Custom levels: Define exactly which commands are allowed

                        Configuring a limited automation account:
                        username netscript privilege 5 secret AutoPass99
                        privilege exec level 5 show running-config
                        privilege exec level 5 configure terminal
                        privilege exec level 5 write memory

                        In Netmiko, specify the privilege level:
                        device = {
                            'device_type': 'cisco_ios',
                            'host': '10.0.0.1',
                            'username': 'netscript',
                            'password': 'AutoPass99',
                            'global_delay_factor': 2,
                        }

                        Principle of least privilege:
                        Automation scripts should only have access to commands they actually need. A script that only reads configs should never have write access.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_auth_ie_5",
                                type: .multipleChoice,
                                prompt: "What Cisco privilege level grants full administrative access?",
                                correctAnswer: "Level 15",
                                options: ["Level 0", "Level 5", "Level 15", "Level 7"],
                                explanation: "Privilege level 15 is full privileged EXEC mode — the highest access level, equivalent to root on Linux systems."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_auth_3_2",
                        heading: "AAA and TACACS+",
                        content: """
                        Enterprise networks use AAA (Authentication, Authorization, Accounting) frameworks to centralize access control across all devices.

                        AAA components:
                        - Authentication: Who are you? (username/password or certificate)
                        - Authorization: What are you allowed to do? (command restrictions)
                        - Accounting: What did you do? (full audit log of every command)

                        TACACS+ vs RADIUS:
                        - TACACS+ (Cisco standard): Separates authentication, authorization, and accounting. Encrypts the entire packet. Best for network device access control.
                        - RADIUS: Commonly used for network access (VPN, Wi-Fi). Encrypts only the password field.

                        Automation with AAA:
                        - Create a dedicated service account for automation in your AAA server (Cisco ISE, FreeRADIUS)
                        - Restrict that account to only the commands your scripts need
                        - Review accounting logs regularly to audit what the automation account did

                        This gives you a centralized record of every command your automation scripts executed, on every device, at every timestamp.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_auth_ie_6",
                                type: .trueFalse,
                                prompt: "TACACS+ encrypts only the password field, while RADIUS encrypts the entire packet.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "It is the opposite — TACACS+ encrypts the entire packet, while RADIUS only encrypts the password field. This makes TACACS+ more secure for device management."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_auth_lesson_4",
                title: "Credential Rotation and Auditing",
                sections: [
                    LessonSection(
                        id: "r_auth_4_1",
                        heading: "Automating Password Rotation",
                        content: """
                        Manually rotating passwords across dozens of devices is tedious and error-prone. Python can automate the entire rotation process.

                        Basic rotation script pattern:
                        import os
                        from netmiko import ConnectHandler

                        new_password = os.environ['NEW_NET_PASSWORD']
                        old_password = os.environ['OLD_NET_PASSWORD']

                        for device_ip in device_inventory:
                            device = {
                                'device_type': 'cisco_ios',
                                'host': device_ip,
                                'username': 'admin',
                                'password': old_password,
                            }
                            connection = ConnectHandler(**device)
                            connection.send_config_set([
                                f'username admin secret {new_password}'
                            ])
                            connection.save_config()
                            connection.disconnect()

                        Rotation best practices:
                        - Always test the new password before disconnecting (try a new connection with the new password)
                        - Run rotation during a maintenance window
                        - Update your vault immediately after successful rotation
                        - Keep the old password available for rollback until all devices are confirmed
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_auth_ie_7",
                                type: .multipleChoice,
                                prompt: "What should you do immediately after successfully rotating a password on all devices?",
                                correctAnswer: "Update the credential in your secrets vault",
                                options: ["Delete the old password from all records", "Update the credential in your secrets vault", "Reboot all devices to apply the change", "Email the new password to the team"],
                                explanation: "The vault must be updated immediately so all scripts and team members use the new credential. Email distribution of passwords is a security risk."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_auth_4_2",
                        heading: "Auditing Access Logs",
                        content: """
                        Knowing who accessed what device and when is critical for security and compliance. Both the device and your automation scripts should maintain logs.

                        Device-side logging (Cisco IOS):
                        logging buffered 16384
                        logging host 10.0.0.50
                        login on-success log
                        login on-failure log

                        This sends all login events to a syslog server at 10.0.0.50.

                        Script-side logging in Python:
                        import logging
                        from datetime import datetime

                        logging.basicConfig(
                            filename=f'audit_{datetime.now().strftime("%Y%m%d")}.log',
                            level=logging.INFO,
                            format='%(asctime)s %(levelname)s %(message)s'
                        )

                        logging.info(f'Connected to {device_ip} as {username}')
                        logging.info(f'Executed config change: {commands}')

                        What to log:
                        - Timestamp of every connection attempt
                        - Username and source IP used
                        - Every configuration command sent
                        - Success or failure of the operation
                        - Disconnect time
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_auth_ie_8",
                                type: .fillInBlank,
                                prompt: "Python's built-in _____ module is used to write structured audit logs with timestamps.",
                                correctAnswer: "logging",
                                options: nil,
                                explanation: "Python's logging module provides flexible logging with configurable levels, formats, and output destinations (file, console, remote syslog)."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_r_auth",
            title: "Multiple Authentication Assessment",
            questions: [
                QuizQuestion(
                    id: "r_aq_1",
                    question: "Which authentication method uses a cryptographic key pair instead of a password?",
                    options: ["Password-based", "Key-based", "Token-based", "Certificate-based"],
                    correctAnswerIndex: 1,
                    explanation: "Key-based authentication uses a public/private key pair. The public key is on the device; the private key stays on your machine.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_aq_2",
                    question: "Where does the PUBLIC key go in SSH key-based authentication?",
                    options: ["On your local machine only", "On the network device", "In the secrets vault", "In the Python script"],
                    correctAnswerIndex: 1,
                    explanation: "The public key is installed on the network device. The private key stays on your machine and is never shared.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_aq_3",
                    question: "What Python module reads environment variables at runtime?",
                    options: ["sys", "os", "env", "secrets"],
                    correctAnswerIndex: 1,
                    explanation: "The os module provides os.environ and os.getenv() to read environment variables securely at runtime.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_aq_4",
                    question: "What does AAA stand for in network security?",
                    options: ["Authentication, Authorization, Accounting", "Access, Admin, Audit", "Authentication, Access, Accounting", "Authorization, Access, Auditing"],
                    correctAnswerIndex: 0,
                    explanation: "AAA stands for Authentication (who are you), Authorization (what can you do), and Accounting (what did you do).",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_aq_5",
                    question: "Which protocol encrypts the entire AAA packet and is preferred for network device management?",
                    options: ["RADIUS", "TACACS+", "LDAP", "Kerberos"],
                    correctAnswerIndex: 1,
                    explanation: "TACACS+ encrypts the entire packet, while RADIUS only encrypts the password field — making TACACS+ more secure for network device management.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_aq_6",
                    question: "What is the principle of least privilege?",
                    options: ["Giving all users admin access for efficiency", "Giving accounts only the minimum access needed for their task", "Using the lowest encryption standard available", "Removing all passwords from devices"],
                    correctAnswerIndex: 1,
                    explanation: "Least privilege means accounts only have access to exactly what they need — nothing more. This limits damage if credentials are compromised.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_aq_7",
                    question: "What is the main benefit of a secrets vault over environment variables?",
                    options: ["Vaults are always free", "Centralized rotation with audit logging", "Vaults work offline without a server", "Environment variables expire automatically"],
                    correctAnswerIndex: 1,
                    explanation: "Vaults provide centralized credential rotation and a full audit trail of who accessed which secret and when.",
                    difficulty: .advanced
                ),
                QuizQuestion(
                    id: "r_aq_8",
                    question: "What should a password rotation script do before fully disconnecting from a device?",
                    options: ["Immediately delete the old password", "Test the new password with a fresh connection", "Reboot the device", "Disable all other user accounts"],
                    correctAnswerIndex: 1,
                    explanation: "Always verify the new password works by opening a new connection before closing the old one — otherwise you can lock yourself out.",
                    difficulty: .advanced
                )
            ]
        )
    )

    // MARK: - Module 3: Multi-Host Management

    static let multiHostModule = LearningModule(
        id: "r_multi_host",
        title: "Multi-Host Management",
        description: "Loop through multiple devices from a Python list or inventory file and apply consistent configurations across dev, staging, and production.",
        icon: "server.rack",
        color: "hostGreen",
        lessons: [
            Lesson(
                id: "r_mh_lesson_1",
                title: "Building a Device Inventory",
                sections: [
                    LessonSection(
                        id: "r_mh_1_1",
                        heading: "In-Script Inventory",
                        content: """
                        The simplest inventory is a Python list of dictionaries defined directly in your script. Each dictionary holds the connection parameters for one device.

                        Example:
                        devices = [
                            {
                                'name': 'Core-SW-01',
                                'device_type': 'cisco_ios',
                                'host': '10.1.0.1',
                                'username': 'admin',
                                'password': os.environ['NET_PASS'],
                            },
                            {
                                'name': 'Core-SW-02',
                                'device_type': 'cisco_ios',
                                'host': '10.1.0.2',
                                'username': 'admin',
                                'password': os.environ['NET_PASS'],
                            },
                            {
                                'name': 'Edge-RTR-01',
                                'device_type': 'cisco_ios',
                                'host': '10.1.1.1',
                                'username': 'admin',
                                'password': os.environ['NET_PASS'],
                            },
                        ]

                        This works well for small, static environments. For larger or changing networks, external inventory files are better.

                        Tip: Add a 'name' or 'role' key to each device so your logs and output are human-readable rather than just showing IP addresses.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_mh_ie_1",
                                type: .multipleChoice,
                                prompt: "What Python data type is each device represented as in an in-script inventory?",
                                correctAnswer: "Dictionary",
                                options: ["List", "Dictionary", "Tuple", "Set"],
                                explanation: "Each device is a dictionary mapping parameter names (device_type, host, username, password) to their values."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_mh_1_2",
                        heading: "File-Based Inventory with JSON",
                        content: """
                        External inventory files separate device data from script logic. This makes scripts reusable across different environments without code changes.

                        devices.json:
                        {
                          "devices": [
                            {
                              "name": "Core-SW-01",
                              "device_type": "cisco_ios",
                              "host": "10.1.0.1",
                              "environment": "production",
                              "role": "switch"
                            },
                            {
                              "name": "Dev-SW-01",
                              "device_type": "cisco_ios",
                              "host": "192.168.100.1",
                              "environment": "dev",
                              "role": "switch"
                            }
                          ]
                        }

                        Loading the inventory:
                        import json, os

                        with open('devices.json') as f:
                            inventory = json.load(f)

                        # Add credentials at runtime (never store in the JSON file)
                        for device in inventory['devices']:
                            device['username'] = os.environ['NET_USERNAME']
                            device['password'] = os.environ['NET_PASSWORD']

                        Important: Never store passwords in inventory files. Always inject credentials from environment variables or a vault at runtime.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_mh_ie_2",
                                type: .trueFalse,
                                prompt: "It is acceptable to store device passwords directly inside a JSON inventory file.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Passwords should never be stored in inventory files. Inject credentials from environment variables or a vault at runtime to avoid leaking secrets."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_mh_lesson_2",
                title: "Applying Config to Multiple Devices",
                sections: [
                    LessonSection(
                        id: "r_mh_2_1",
                        heading: "The Basic Loop Pattern",
                        content: """
                        The core of multi-host management is a for loop that connects to each device, applies configuration, saves, and disconnects before moving to the next.

                        Full working example:
                        from netmiko import ConnectHandler
                        import os, json, logging

                        logging.basicConfig(level=logging.INFO)

                        with open('devices.json') as f:
                            inventory = json.load(f)

                        config_commands = [
                            'ntp server 10.0.0.100',
                            'ip name-server 8.8.8.8',
                            'logging host 10.0.0.200',
                        ]

                        for device in inventory['devices']:
                            device['username'] = os.environ['NET_USERNAME']
                            device['password'] = os.environ['NET_PASSWORD']
                            try:
                                conn = ConnectHandler(**device)
                                conn.send_config_set(config_commands)
                                conn.save_config()
                                conn.disconnect()
                                logging.info(f"SUCCESS: {device['name']} ({device['host']})")
                            except Exception as e:
                                logging.error(f"FAILED: {device['name']} ({device['host']}) — {e}")

                        The try/except block is critical — if one device fails (unreachable, wrong password), the script logs the error and continues to the next device instead of crashing.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_mh_ie_3",
                                type: .multipleChoice,
                                prompt: "Why is a try/except block important in a multi-device loop?",
                                correctAnswer: "So one failed device doesn't stop the script from configuring the remaining devices",
                                options: [
                                    "It makes the script run faster",
                                    "So one failed device doesn't stop the script from configuring the remaining devices",
                                    "It automatically retries failed devices",
                                    "It prevents SSH connections from timing out"
                                ],
                                explanation: "Without try/except, a single unreachable or misconfigured device crashes the entire script — leaving the rest unconfigured."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_mh_2_2",
                        heading: "Parallel Connections",
                        content: """
                        Connecting to devices one-by-one (serially) works but is slow — 100 devices at 5 seconds each is over 8 minutes. Parallel execution dramatically reduces this time.

                        Using Python's concurrent.futures:
                        from concurrent.futures import ThreadPoolExecutor, as_completed
                        from netmiko import ConnectHandler

                        def configure_device(device):
                            try:
                                conn = ConnectHandler(**device)
                                conn.send_config_set(config_commands)
                                conn.save_config()
                                conn.disconnect()
                                return f"SUCCESS: {device['name']}"
                            except Exception as e:
                                return f"FAILED: {device['name']} — {e}"

                        with ThreadPoolExecutor(max_workers=10) as executor:
                            futures = {executor.submit(configure_device, d): d for d in devices}
                            for future in as_completed(futures):
                                print(future.result())

                        max_workers controls how many simultaneous SSH sessions are open. Too many can overwhelm your network or the devices — 10–20 is a safe starting point for most environments.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_mh_ie_4",
                                type: .fillInBlank,
                                prompt: "Python's concurrent.futures._____ is used to run device connections in parallel.",
                                correctAnswer: "ThreadPoolExecutor",
                                options: nil,
                                explanation: "ThreadPoolExecutor manages a pool of threads, allowing multiple SSH connections to run simultaneously and dramatically reducing total script runtime."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_mh_lesson_3",
                title: "Targeting Environments",
                sections: [
                    LessonSection(
                        id: "r_mh_3_1",
                        heading: "Dev, Staging, and Production",
                        content: """
                        A well-structured inventory separates devices by environment. This lets one script safely target dev for testing, staging for validation, or production for deployment — just by changing one variable.

                        Inventory with environments (devices.json):
                        {
                          "devices": [
                            {"name": "Dev-SW-01",  "host": "192.168.10.1", "environment": "dev"},
                            {"name": "Dev-SW-02",  "host": "192.168.10.2", "environment": "dev"},
                            {"name": "STG-SW-01",  "host": "10.50.0.1",   "environment": "staging"},
                            {"name": "PROD-SW-01", "host": "10.100.0.1",  "environment": "production"},
                            {"name": "PROD-SW-02", "host": "10.100.0.2",  "environment": "production"}
                          ]
                        }

                        Filtering by environment:
                        import sys
                        target_env = sys.argv[1]  # Pass environment as CLI argument: python deploy.py staging

                        targets = [d for d in inventory['devices'] if d['environment'] == target_env]
                        print(f"Targeting {len(targets)} devices in {target_env}")

                        Workflow:
                        1. Test in dev → verify behavior on non-critical devices
                        2. Validate in staging → environment mirrors production
                        3. Deploy to production → only after staging passes
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_mh_ie_5",
                                type: .multipleChoice,
                                prompt: "What is the correct order for deploying changes across environments?",
                                correctAnswer: "Dev → Staging → Production",
                                options: [
                                    "Production → Staging → Dev",
                                    "Dev → Production → Staging",
                                    "Dev → Staging → Production",
                                    "Staging → Dev → Production"
                                ],
                                explanation: "Always test in dev first, validate in staging (which mirrors production), then deploy to production. Never skip stages."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_mh_3_2",
                        heading: "Generating Reports",
                        content: """
                        After running a multi-host script, you need a clear record of what succeeded and what failed. A simple report captures this.

                        Building a results report:
                        results = {'success': [], 'failed': []}

                        for device in targets:
                            try:
                                # ... connect and configure ...
                                results['success'].append(device['name'])
                            except Exception as e:
                                results['failed'].append({'device': device['name'], 'error': str(e)})

                        # Print summary
                        print(f"\\nDeployment Summary ({target_env})")
                        print(f"Success: {len(results['success'])}/{len(targets)}")
                        print(f"Failed:  {len(results['failed'])}")

                        for fail in results['failed']:
                            print(f"  - {fail['device']}: {fail['error']}")

                        # Save to file
                        with open(f'report_{target_env}.json', 'w') as f:
                            json.dump(results, f, indent=2)

                        Always save the report to a file — terminal output disappears, but a report file gives you a permanent record for auditing and troubleshooting.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_mh_ie_6",
                                type: .trueFalse,
                                prompt: "Saving deployment results to a file is important because terminal output provides a permanent audit record.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Terminal output is NOT permanent — it disappears when the window closes. Saving to a file (JSON, log, CSV) provides the permanent audit record."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_mh_lesson_4",
                title: "Error Handling and Rollback",
                sections: [
                    LessonSection(
                        id: "r_mh_4_1",
                        heading: "Handling Common Errors",
                        content: """
                        Multi-host scripts encounter predictable errors. Handling them gracefully prevents partial deployments and data loss.

                        Common errors and how to handle them:
                        from netmiko.exceptions import (
                            NetmikoTimeoutException,
                            NetmikoAuthenticationException
                        )

                        try:
                            conn = ConnectHandler(**device)
                        except NetmikoTimeoutException:
                            logging.error(f"{device['host']}: Connection timed out — device may be unreachable")
                            continue  # Skip to next device
                        except NetmikoAuthenticationException:
                            logging.error(f"{device['host']}: Authentication failed — check credentials")
                            continue
                        except Exception as e:
                            logging.error(f"{device['host']}: Unexpected error — {e}")
                            continue

                        Key exception types:
                        - NetmikoTimeoutException: Device unreachable or SSH port closed
                        - NetmikoAuthenticationException: Wrong username or password
                        - ReadTimeout: Device responded but took too long (increase timeout)
                        - Exception: Catch-all for unexpected errors
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_mh_ie_7",
                                type: .multipleChoice,
                                prompt: "Which Netmiko exception is raised when a device is unreachable?",
                                correctAnswer: "NetmikoTimeoutException",
                                options: ["NetmikoAuthenticationException", "NetmikoTimeoutException", "ConnectionRefusedError", "SSHException"],
                                explanation: "NetmikoTimeoutException is raised when Netmiko cannot establish a connection within the timeout period — usually meaning the device is unreachable."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_mh_4_2",
                        heading: "Configuration Backup Before Changes",
                        content: """
                        Before applying any configuration changes, always back up the current running configuration. This makes rollback simple if something goes wrong.

                        Backup-before-change pattern:
                        import os
                        from datetime import datetime

                        def backup_and_configure(device, commands):
                            conn = ConnectHandler(**device)

                            # Step 1: Back up current config
                            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
                            backup_file = f"backups/{device['name']}_{timestamp}.txt"
                            os.makedirs('backups', exist_ok=True)

                            running_config = conn.send_command('show running-config')
                            with open(backup_file, 'w') as f:
                                f.write(running_config)

                            # Step 2: Apply changes
                            conn.send_config_set(commands)
                            conn.save_config()
                            conn.disconnect()
                            return backup_file

                        Rolling back from a backup:
                        If something goes wrong, use the backup file to restore:
                        with open(backup_file) as f:
                            restore_commands = f.read().splitlines()

                        conn.send_config_set(restore_commands)
                        conn.save_config()
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_mh_ie_8",
                                type: .multipleChoice,
                                prompt: "When should you back up a device's running configuration?",
                                correctAnswer: "Before applying any configuration changes",
                                options: [
                                    "Only after changes are applied",
                                    "Before applying any configuration changes",
                                    "Once a year during maintenance",
                                    "Only when the device is rebooted"
                                ],
                                explanation: "Backing up before changes gives you a known-good configuration to roll back to if the new changes cause problems."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_r_multi_host",
            title: "Multi-Host Management Assessment",
            questions: [
                QuizQuestion(
                    id: "r_mhq_1",
                    question: "What Python data structure represents a single device in an inventory list?",
                    options: ["List", "Tuple", "Dictionary", "Set"],
                    correctAnswerIndex: 2,
                    explanation: "Each device is a dictionary mapping parameter names to values — device_type, host, username, password, etc.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_mhq_2",
                    question: "Where should device passwords be stored in a JSON inventory file?",
                    options: ["In the 'password' field", "In an encrypted section", "They should NOT be stored in the file", "In a comments section"],
                    correctAnswerIndex: 2,
                    explanation: "Passwords should never be stored in inventory files. Inject them from environment variables or a vault at runtime.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_mhq_3",
                    question: "Why is a try/except block important in a multi-device loop?",
                    options: ["It makes SSH connections faster", "It retries failed devices automatically", "It prevents one failure from stopping the rest of the script", "It encrypts the connection"],
                    correctAnswerIndex: 2,
                    explanation: "Without error handling, a single failed device crashes the entire script — leaving all remaining devices unconfigured.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_mhq_4",
                    question: "What Python class enables parallel SSH connections to multiple devices?",
                    options: ["MultiThreader", "ThreadPoolExecutor", "ParallelConnector", "AsyncHandler"],
                    correctAnswerIndex: 1,
                    explanation: "ThreadPoolExecutor from concurrent.futures manages a pool of threads for parallel SSH connections.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_mhq_5",
                    question: "What is the correct deployment order for network changes?",
                    options: ["Production first, then staging", "Dev → Staging → Production", "Staging → Production → Dev", "All environments simultaneously"],
                    correctAnswerIndex: 1,
                    explanation: "Always test in dev, validate in staging, then deploy to production. Never skip stages or go to production first.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_mhq_6",
                    question: "Which Netmiko exception indicates wrong credentials?",
                    options: ["NetmikoTimeoutException", "SSHException", "NetmikoAuthenticationException", "ConnectionRefusedError"],
                    correctAnswerIndex: 2,
                    explanation: "NetmikoAuthenticationException is raised when the username or password is incorrect.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_mhq_7",
                    question: "When should a configuration backup be taken?",
                    options: ["After applying changes", "Before applying any changes", "Once a month", "Only when rebooting"],
                    correctAnswerIndex: 1,
                    explanation: "Always back up before changes — this gives you a known-good state to roll back to if something goes wrong.",
                    difficulty: .advanced
                ),
                QuizQuestion(
                    id: "r_mhq_8",
                    question: "What max_workers value is a safe starting point for parallel SSH connections?",
                    options: ["1–2", "10–20", "50–100", "Unlimited"],
                    correctAnswerIndex: 1,
                    explanation: "10–20 parallel workers is a safe range — too many simultaneous SSH sessions can overwhelm devices or network infrastructure.",
                    difficulty: .advanced
                )
            ]
        )
    )

    // MARK: - Module 4: Consistent Configurations

    static let consistentConfigModule = LearningModule(
        id: "r_consistent_config",
        title: "Consistent Configurations",
        description: "Send standardized commands to switches, routers, and servers to keep network behavior predictable and reduce configuration drift.",
        icon: "equal.square.fill",
        color: "configPink",
        lessons: [
            Lesson(
                id: "r_cc_lesson_1",
                title: "What is Configuration Drift?",
                sections: [
                    LessonSection(
                        id: "r_cc_1_1",
                        heading: "Understanding Config Drift",
                        content: """
                        Configuration drift occurs when devices that should be identical gradually diverge due to manual changes, one-off fixes, or undocumented modifications. Over time, no two devices are configured the same way.

                        How drift happens:
                        - Engineer logs into SW-01 and adds a route for a quick fix but forgets to update SW-02
                        - A security patch is applied to some devices during a maintenance window but not all
                        - Different engineers have different habits — one always enables SNMP, another never does
                        - A vendor update changes default settings on new devices but not existing ones

                        Why drift is dangerous:
                        - Unpredictable behavior: traffic may route differently on seemingly identical devices
                        - Security gaps: some devices have hardening applied, others don't
                        - Troubleshooting nightmares: you can't assume SW-01 and SW-02 behave the same
                        - Compliance failures: audit finds devices don't match the required baseline
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_cc_ie_1",
                                type: .multipleChoice,
                                prompt: "What is configuration drift?",
                                correctAnswer: "When devices that should be identical gradually diverge due to untracked manual changes",
                                options: [
                                    "When a device loses its configuration after a reboot",
                                    "When devices that should be identical gradually diverge due to untracked manual changes",
                                    "When a routing protocol changes paths automatically",
                                    "When firmware versions become outdated"
                                ],
                                explanation: "Configuration drift happens silently over time — manual changes accumulate until no two devices are truly identical, causing unpredictable behavior."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_cc_1_2",
                        heading: "Detecting Drift with Python",
                        content: """
                        Python can compare a device's current running configuration against a known-good baseline and flag any differences.

                        Drift detection pattern:
                        import difflib
                        from netmiko import ConnectHandler

                        def check_drift(device, baseline_file):
                            with open(baseline_file) as f:
                                baseline = f.read().splitlines()

                            conn = ConnectHandler(**device)
                            current = conn.send_command('show running-config').splitlines()
                            conn.disconnect()

                            diff = list(difflib.unified_diff(
                                baseline, current,
                                fromfile='baseline',
                                tofile='current',
                                lineterm=''
                            ))

                            if diff:
                                print(f"DRIFT DETECTED on {device['name']}:")
                                for line in diff:
                                    print(line)
                            else:
                                print(f"No drift on {device['name']}")

                        Lines starting with '+' were added (not in baseline).
                        Lines starting with '-' were removed (in baseline but missing now).
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_cc_ie_2",
                                type: .fillInBlank,
                                prompt: "Python's _____ module is used to compare two configuration files and find differences.",
                                correctAnswer: "difflib",
                                options: nil,
                                explanation: "Python's built-in difflib module provides utilities to compare sequences line-by-line and generate human-readable diffs."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_cc_lesson_2",
                title: "Configuration Templates",
                sections: [
                    LessonSection(
                        id: "r_cc_2_1",
                        heading: "Building a Standard Template",
                        content: """
                        A configuration template is a reusable set of standardized commands that defines the baseline for a device type. All switches get the same template, all routers get another.

                        Python dictionary template for access switches:
                        SWITCH_BASELINE = [
                            # Security
                            'service password-encryption',
                            'no cdp run',
                            'no ip http server',
                            'no ip http secure-server',
                            # NTP
                            'ntp server 10.0.0.100',
                            'clock timezone EST -5 0',
                            # Logging
                            'logging buffered 16384',
                            'logging host 10.0.0.200',
                            'logging trap informational',
                            # SNMP (secure community string from env var)
                            f'snmp-server community {os.environ["SNMP_RO"]} RO',
                            # Banner
                            'banner motd # Authorized access only. All activity is monitored. #',
                        ]

                        Using Jinja2 for variable templates:
                        from jinja2 import Template

                        template = Template("hostname {{ hostname }}")
                        result = template.render(hostname="SW-CORE-01")
                        # Result: "hostname SW-CORE-01"

                        Jinja2 allows device-specific values (hostname, IP) to be injected into a standard template.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_cc_ie_3",
                                type: .multipleChoice,
                                prompt: "What Python library is commonly used to create configuration templates with variable substitution?",
                                correctAnswer: "Jinja2",
                                options: ["difflib", "Jinja2", "configparser", "yaml"],
                                explanation: "Jinja2 is a templating engine that lets you insert device-specific variables (hostname, IP, VLAN IDs) into a standardized configuration template."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_cc_2_2",
                        heading: "Applying Templates at Scale",
                        content: """
                        Once you have a template, applying it consistently across all devices ensures they all start from the same baseline.

                        Template deployment workflow:
                        1. Define baseline template in a Python list or Jinja2 file
                        2. Load device inventory from JSON
                        3. For each device, render the template with device-specific variables
                        4. Connect via Netmiko and apply the rendered commands
                        5. Save config and log the result

                        Example combining Jinja2 with Netmiko:
                        from jinja2 import Environment, FileSystemLoader
                        import json, os
                        from netmiko import ConnectHandler

                        env = Environment(loader=FileSystemLoader('templates/'))
                        template = env.get_template('switch_baseline.j2')

                        for device in inventory['devices']:
                            rendered = template.render(
                                hostname=device['name'],
                                mgmt_ip=device['host'],
                                snmp_community=os.environ['SNMP_RO']
                            )
                            commands = rendered.strip().splitlines()

                            conn = ConnectHandler(**device)
                            conn.send_config_set(commands)
                            conn.save_config()
                            conn.disconnect()

                        This guarantees every device receives exactly the same baseline with only the appropriate variables substituted.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_cc_ie_4",
                                type: .trueFalse,
                                prompt: "Using a Jinja2 template guarantees every device receives the exact same baseline configuration.",
                                correctAnswer: "True",
                                options: ["True", "False"],
                                explanation: "True — a template ensures structural consistency. Device-specific values are injected as variables, but the overall structure and security baseline is identical across all devices."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_cc_lesson_3",
                title: "Documenting Configurations in Code",
                sections: [
                    LessonSection(
                        id: "r_cc_3_1",
                        heading: "Version Control for Config Templates",
                        content: """
                        Storing configuration templates in Git provides a full history of every change, who made it, and why. This is the foundation of network infrastructure-as-code.

                        Repository structure for network automation:
                        network-automation/
                        ├── templates/
                        │   ├── switch_baseline.j2
                        │   ├── router_baseline.j2
                        │   └── firewall_baseline.j2
                        ├── inventory/
                        │   ├── production.json
                        │   ├── staging.json
                        │   └── dev.json
                        ├── scripts/
                        │   ├── deploy.py
                        │   └── audit.py
                        └── backups/
                            └── (auto-generated per device)

                        Git workflow for changes:
                        1. Create a branch: git checkout -b add-ntp-servers
                        2. Edit the template
                        3. Test in dev environment
                        4. Open a pull request for peer review
                        5. Merge to main and deploy to staging/production via CI/CD

                        Every change to the template is reviewed before it reaches a device. This is the same process software engineers use for application code.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_cc_ie_5",
                                type: .multipleChoice,
                                prompt: "What Git feature allows a teammate to review config template changes before they are deployed?",
                                correctAnswer: "Pull request",
                                options: ["git push", "Pull request", "git commit", "git merge"],
                                explanation: "A pull request lets teammates review, comment on, and approve changes before they are merged to the main branch and deployed to devices."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_cc_3_2",
                        heading: "Self-Documenting Scripts",
                        content: """
                        Well-written automation scripts document themselves — readable code, meaningful variable names, and clear comments reduce the need for external documentation.

                        Good practices for readable network scripts:
                        # Bad — what does this do?
                        c = CH(**d)
                        c.scs(cmds)
                        c.sc()

                        # Good — self-documenting
                        connection = ConnectHandler(**device_params)
                        connection.send_config_set(ntp_commands)
                        connection.save_config()

                        Use constants for repeated values:
                        NTP_SERVER = '10.0.0.100'
                        SYSLOG_SERVER = '10.0.0.200'
                        MGMT_VLAN = 10

                        ntp_commands = [
                            f'ntp server {NTP_SERVER}',
                            f'logging host {SYSLOG_SERVER}',
                        ]

                        Group related commands with comments:
                        security_hardening = [
                            # Disable unneeded services
                            'no ip http server',
                            'no cdp run',
                            # Enable login security
                            'login block-for 60 attempts 5 within 30',
                            'service password-encryption',
                        ]
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_cc_ie_6",
                                type: .trueFalse,
                                prompt: "Using full variable names like 'connection' instead of abbreviations like 'c' makes scripts harder to read.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Full, descriptive names make code EASIER to read and maintain. Abbreviations save typing once but cost understanding every time someone (including future you) reads the code."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_cc_lesson_4",
                title: "Compliance Checking",
                sections: [
                    LessonSection(
                        id: "r_cc_4_1",
                        heading: "Building a Compliance Checklist",
                        content: """
                        A compliance check script verifies that every device meets your organization's security and operational baseline. It reads the running configuration and checks each rule.

                        Example compliance rules:
                        COMPLIANCE_RULES = {
                            'ssh_enabled':     'ip ssh version 2',
                            'telnet_disabled':  'no service telnet',  # Should NOT be present
                            'ntp_configured':   f'ntp server {NTP_SERVER}',
                            'logging_enabled':  f'logging host {SYSLOG_SERVER}',
                            'password_encrypt': 'service password-encryption',
                            'banner_set':       'banner motd',
                            'snmp_secure':      'snmp-server community public',  # Should NOT be present
                        }

                        Checking a device:
                        def check_compliance(device):
                            conn = ConnectHandler(**device)
                            config = conn.send_command('show running-config')
                            conn.disconnect()

                            results = {}
                            for rule, pattern in COMPLIANCE_RULES.items():
                                present = pattern in config
                                # Some rules check that something is ABSENT (telnet, public SNMP)
                                if rule in ('telnet_disabled', 'snmp_secure'):
                                    results[rule] = 'PASS' if not present else 'FAIL'
                                else:
                                    results[rule] = 'PASS' if present else 'FAIL'
                            return results
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_cc_ie_7",
                                type: .multipleChoice,
                                prompt: "For a rule that checks 'telnet should be disabled', a compliance check should PASS when the telnet config line is:",
                                correctAnswer: "Absent from the running configuration",
                                options: [
                                    "Present in the running configuration",
                                    "Absent from the running configuration",
                                    "Present in startup-config only",
                                    "Found in the VLAN database"
                                ],
                                explanation: "If the rule is that telnet must be disabled, the check passes when the telnet configuration line is NOT present in the running config."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_cc_4_2",
                        heading: "Remediation Automation",
                        content: """
                        After identifying non-compliant devices, a remediation script can automatically fix the violations rather than requiring manual intervention.

                        Auto-remediation pattern:
                        REMEDIATION_COMMANDS = {
                            'ssh_enabled':      ['ip ssh version 2', 'crypto key generate rsa modulus 2048'],
                            'password_encrypt':  ['service password-encryption'],
                            'logging_enabled':   [f'logging host {SYSLOG_SERVER}'],
                            'ntp_configured':    [f'ntp server {NTP_SERVER}'],
                        }

                        def remediate(device, failures):
                            commands_to_apply = []
                            for rule in failures:
                                if rule in REMEDIATION_COMMANDS:
                                    commands_to_apply.extend(REMEDIATION_COMMANDS[rule])

                            if commands_to_apply:
                                conn = ConnectHandler(**device)
                                conn.send_config_set(commands_to_apply)
                                conn.save_config()
                                conn.disconnect()
                                print(f"Remediated {len(failures)} issues on {device['name']}")

                        Important caution: Auto-remediation should run in a test environment first and be reviewed by a network engineer before production use. Some fixes (like generating RSA keys) require careful consideration.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_cc_ie_8",
                                type: .trueFalse,
                                prompt: "Auto-remediation scripts can be safely deployed directly to production devices without any review.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Auto-remediation should always be tested in dev/staging first and reviewed by a network engineer. Some fixes can cause unintended side effects on production devices."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_r_consistent_config",
            title: "Consistent Configurations Assessment",
            questions: [
                QuizQuestion(
                    id: "r_ccq_1",
                    question: "What is configuration drift?",
                    options: ["A routing protocol change", "Devices gradually diverging from their intended baseline due to untracked changes", "A scheduled config backup", "A firmware version mismatch"],
                    correctAnswerIndex: 1,
                    explanation: "Configuration drift happens when manual changes accumulate over time, causing devices to silently diverge from the intended standard.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_ccq_2",
                    question: "Which Python module compares two configuration files to detect differences?",
                    options: ["configparser", "difflib", "filecmp", "os"],
                    correctAnswerIndex: 1,
                    explanation: "Python's difflib module compares sequences line-by-line and generates unified diffs showing added and removed lines.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_ccq_3",
                    question: "What does a '+' line in a unified diff output mean?",
                    options: ["Line exists in both files", "Line was added (present in current but not in baseline)", "Line was removed", "Line is a comment"],
                    correctAnswerIndex: 1,
                    explanation: "In unified diff format, '+' means a line was added (in the current version but not the baseline), and '-' means a line was removed.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_ccq_4",
                    question: "Which library enables variable substitution in configuration templates?",
                    options: ["difflib", "os", "Jinja2", "json"],
                    correctAnswerIndex: 2,
                    explanation: "Jinja2 is a templating engine that allows variables like {{ hostname }} to be substituted with device-specific values.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_ccq_5",
                    question: "What Git workflow step allows a teammate to review config changes before deployment?",
                    options: ["git commit", "git push", "Pull request", "git merge"],
                    correctAnswerIndex: 2,
                    explanation: "A pull request requires peer review and approval before changes are merged and deployed, preventing untested configurations from reaching devices.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_ccq_6",
                    question: "A compliance rule checks that SNMP 'public' community string is absent. When should it PASS?",
                    options: ["When 'public' is found in the config", "When 'public' is NOT found in the config", "When SNMP is fully disabled", "When the device has no SNMP config"],
                    correctAnswerIndex: 1,
                    explanation: "The rule checks for absence — it passes when the insecure 'public' string is not found in the running configuration.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_ccq_7",
                    question: "Why should auto-remediation be tested in dev/staging before production?",
                    options: ["Dev devices are faster", "Some fixes can cause unintended side effects on production devices", "Production devices don't support Python", "Auto-remediation only works in dev"],
                    correctAnswerIndex: 1,
                    explanation: "Automated fixes can have unintended side effects. Always validate in non-production environments before running remediation on live infrastructure.",
                    difficulty: .advanced
                ),
                QuizQuestion(
                    id: "r_ccq_8",
                    question: "What is the main benefit of storing config templates in Git?",
                    options: ["Faster deployment", "Complete history of every change with who made it and why", "Automatic device configuration", "Reduced network latency"],
                    correctAnswerIndex: 1,
                    explanation: "Git provides a complete audit trail — every change to a template is recorded with author, timestamp, and commit message, enabling review and rollback.",
                    difficulty: .advanced
                )
            ]
        )
    )

    // MARK: - Module 5: Rapid Deployment

    static let rapidDeployModule = LearningModule(
        id: "r_rapid_deploy",
        title: "Rapid Deployment",
        description: "Push updates or new settings to dozens of devices in minutes, replacing hours of manual CLI work with easily re-runnable scripts.",
        icon: "bolt.fill",
        color: "deployRed",
        lessons: [
            Lesson(
                id: "r_rd_lesson_1",
                title: "Why Rapid Deployment Matters",
                sections: [
                    LessonSection(
                        id: "r_rd_1_1",
                        heading: "The Cost of Manual Deployment",
                        content: """
                        Before automation, deploying a change to 50 switches meant logging into each one manually. This is slow, error-prone, and inconsistent.

                        Real-world manual deployment scenario:
                        - Task: Add a new NTP server to all 50 switches
                        - Time per device: ~3 minutes (login, type commands, verify, save, logout)
                        - Total time: 50 × 3 = 150 minutes (2.5 hours)
                        - Human errors: At least 2–3 devices will have a typo or be missed
                        - Audit trail: None, unless the engineer documents each device manually
                        - Repeatability: The next engineer does it differently

                        With Python automation:
                        - Same task: ~2 minutes total for all 50 devices
                        - Zero typos: Commands are defined once and sent identically
                        - Complete log: Every device, every command, timestamped automatically
                        - Repeatability: Run the same script next week, next month, any time

                        This difference scales dramatically — 500 devices, 5000 devices. Manual simply doesn't work at scale.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_rd_ie_1",
                                type: .multipleChoice,
                                prompt: "What is the biggest advantage of automated deployment over manual CLI work at scale?",
                                correctAnswer: "Speed and consistency — the same correct commands reach every device every time",
                                options: [
                                    "Automation requires no network access",
                                    "Speed and consistency — the same correct commands reach every device every time",
                                    "Manual work is more secure than automation",
                                    "Automation works without credentials"
                                ],
                                explanation: "Automation eliminates human error, ensures identical configuration across all devices, and reduces deployment time from hours to minutes."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_rd_1_2",
                        heading: "Deployment Script Structure",
                        content: """
                        A production-ready deployment script follows a consistent structure that handles inventory, credentials, execution, logging, and reporting.

                        Recommended script structure:
                        #!/usr/bin/env python3
                        \"\"\"
                        deploy_ntp.py — Deploys NTP server config to all switches
                        Usage: python deploy_ntp.py [dev|staging|production]
                        \"\"\"
                        import os, sys, json, logging
                        from datetime import datetime
                        from netmiko import ConnectHandler

                        # 1. Configuration
                        NTP_SERVER = '10.0.0.100'
                        TARGET_ENV = sys.argv[1] if len(sys.argv) > 1 else 'dev'

                        # 2. Logging setup
                        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
                        logging.basicConfig(
                            filename=f'logs/deploy_{TARGET_ENV}_{timestamp}.log',
                            level=logging.INFO,
                            format='%(asctime)s %(levelname)s %(message)s'
                        )

                        # 3. Load inventory
                        with open(f'inventory/{TARGET_ENV}.json') as f:
                            devices = json.load(f)['devices']

                        # 4. Define commands
                        commands = [f'ntp server {NTP_SERVER}']

                        # 5. Execute
                        # 6. Report
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_rd_ie_2",
                                type: .trueFalse,
                                prompt: "A deployment script should accept the target environment (dev/staging/production) as a command-line argument.",
                                correctAnswer: "True",
                                options: ["True", "False"],
                                explanation: "Accepting the environment as a CLI argument (sys.argv[1]) makes the same script reusable across all environments without code changes."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_rd_lesson_2",
                title: "Zero-Downtime Deployments",
                sections: [
                    LessonSection(
                        id: "r_rd_2_1",
                        heading: "Staged Rollouts",
                        content: """
                        A staged rollout deploys changes to a small subset of devices first, verifies success, then continues to the rest. This catches problems before they affect the entire network.

                        Canary deployment pattern:
                        import time

                        # Deploy to 10% of devices first (canary group)
                        canary_devices = devices[:len(devices) // 10]
                        remaining_devices = devices[len(devices) // 10:]

                        print(f"Canary deployment to {len(canary_devices)} devices...")
                        canary_results = deploy(canary_devices, commands)

                        canary_failures = [r for r in canary_results if r['status'] == 'FAILED']
                        if canary_failures:
                            print(f"Canary FAILED — aborting full rollout. Failures: {canary_failures}")
                            sys.exit(1)

                        print(f"Canary SUCCESS — proceeding to remaining {len(remaining_devices)} devices...")
                        time.sleep(30)  # Brief pause to observe canary devices
                        full_results = deploy(remaining_devices, commands)

                        Staged rollout benefits:
                        - Limits blast radius — a bad change only affects 10% initially
                        - Gives time to observe behavior before full rollout
                        - Automatic abort if canary fails
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_rd_ie_3",
                                type: .multipleChoice,
                                prompt: "What is the purpose of a canary deployment?",
                                correctAnswer: "To deploy to a small subset first and verify success before rolling out to all devices",
                                options: [
                                    "To deploy to all devices simultaneously for speed",
                                    "To test scripts in a virtual environment",
                                    "To deploy to a small subset first and verify success before rolling out to all devices",
                                    "To run compliance checks before deployment"
                                ],
                                explanation: "A canary deployment limits the blast radius of a bad change — if 10% of devices show problems, you abort before the other 90% are affected."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_rd_2_2",
                        heading: "Maintenance Windows",
                        content: """
                        Some changes must happen during scheduled maintenance windows when traffic is minimal and a team is available to respond to issues.

                        Enforcing maintenance windows in scripts:
                        from datetime import datetime

                        def is_maintenance_window():
                            now = datetime.now()
                            # Maintenance: Tuesday and Thursday 2:00 AM - 4:00 AM
                            is_maintenance_day = now.weekday() in (1, 3)  # 1=Tuesday, 3=Thursday
                            is_maintenance_hour = 2 <= now.hour < 4
                            return is_maintenance_day and is_maintenance_hour

                        if not is_maintenance_window():
                            print("ERROR: This script must run during a maintenance window (Tue/Thu 2-4 AM)")
                            print(f"Current time: {datetime.now().strftime('%A %H:%M')}")
                            sys.exit(1)

                        When to use maintenance windows:
                        - Any change that requires a device reload or brief traffic interruption
                        - Major software upgrades
                        - Routing protocol changes
                        - Firewall rule modifications

                        Not every change needs a window — adding an NTP server or a log host is non-disruptive and can run anytime.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_rd_ie_4",
                                type: .fillInBlank,
                                prompt: "In Python's datetime, weekday() returns 0 for Monday. Tuesday is weekday _____.",
                                correctAnswer: "1",
                                options: nil,
                                explanation: "Python's weekday() returns 0=Monday, 1=Tuesday, 2=Wednesday, 3=Thursday, 4=Friday, 5=Saturday, 6=Sunday."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_rd_lesson_3",
                title: "Re-Runnable Scripts",
                sections: [
                    LessonSection(
                        id: "r_rd_3_1",
                        heading: "Idempotent Deployments",
                        content: """
                        An idempotent script produces the same result no matter how many times you run it. Running it twice doesn't double-configure a device or cause errors.

                        Why idempotency matters:
                        - Automation is often re-run: after failures, after adding new devices, for verification
                        - If running twice breaks something, the script is dangerous to automate
                        - CI/CD pipelines may run scripts on every commit

                        Making scripts idempotent:
                        Most Cisco IOS commands are naturally idempotent:
                        - 'ntp server 10.0.0.100' — running it twice just confirms the same server
                        - 'hostname SW-01' — sets the hostname, running again has no effect
                        - 'logging host 10.0.0.200' — duplicate entries are ignored

                        Watch out for non-idempotent commands:
                        - 'username admin secret password123' — safe, just updates
                        - 'crypto key generate rsa modulus 2048' — generates NEW keys each time (use 'crypto key generate rsa general-keys modulus 2048' and check first)

                        Check-before-apply pattern:
                        current = conn.send_command('show run | include ntp server')
                        if '10.0.0.100' not in current:
                            conn.send_config_set(['ntp server 10.0.0.100'])
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_rd_ie_5",
                                type: .multipleChoice,
                                prompt: "What does 'idempotent' mean in the context of deployment scripts?",
                                correctAnswer: "Running the script multiple times produces the same result as running it once",
                                options: [
                                    "The script runs faster each time it is executed",
                                    "Running the script multiple times produces the same result as running it once",
                                    "The script can only run once before requiring re-authorization",
                                    "The script automatically rolls back if it fails"
                                ],
                                explanation: "An idempotent script is safe to run multiple times — the second run simply confirms the correct state rather than causing duplicate or conflicting configurations."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_rd_3_2",
                        heading: "Pre and Post Deployment Checks",
                        content: """
                        A well-built deployment script verifies the state of the network before and after changes. This catches issues early and confirms the change had the intended effect.

                        Pre-deployment checks:
                        def pre_check(connection, device_name):
                            checks = {}
                            # Verify device is reachable and responsive
                            version = connection.send_command('show version')
                            checks['reachable'] = 'Cisco' in version

                            # Capture baseline metrics
                            checks['interface_count'] = version.count('FastEthernet')
                            return checks

                        Post-deployment checks:
                        def post_check(connection, expected_ntp):
                            checks = {}
                            ntp_status = connection.send_command('show ntp status')
                            checks['ntp_synced'] = 'synchronized' in ntp_status.lower()

                            ntp_assoc = connection.send_command('show ntp associations')
                            checks['ntp_server_present'] = expected_ntp in ntp_assoc
                            return checks

                        Deployment flow with checks:
                        pre = pre_check(conn, device['name'])
                        if not pre['reachable']:
                            raise Exception(f"{device['name']}: Pre-check failed")

                        conn.send_config_set(commands)
                        conn.save_config()

                        post = post_check(conn, NTP_SERVER)
                        if not post['ntp_synced']:
                            print(f"WARNING: {device['name']} NTP not yet synchronized")
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_rd_ie_6",
                                type: .trueFalse,
                                prompt: "Post-deployment checks should verify that the change had the intended effect on the device.",
                                correctAnswer: "True",
                                options: ["True", "False"],
                                explanation: "Post-checks confirm that the applied configuration is actually working as intended — for example, verifying NTP is synchronized after adding the NTP server config."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "r_rd_lesson_4",
                title: "Rollback Strategies",
                sections: [
                    LessonSection(
                        id: "r_rd_4_1",
                        heading: "Automated Rollback",
                        content: """
                        A robust deployment script includes an automatic rollback mechanism that restores the previous configuration if post-deployment checks fail.

                        Full deploy-with-rollback pattern:
                        def deploy_with_rollback(device, commands):
                            conn = ConnectHandler(**device)

                            # 1. Capture pre-deployment state
                            backup = conn.send_command('show running-config')

                            try:
                                # 2. Apply changes
                                conn.send_config_set(commands)
                                conn.save_config()

                                # 3. Run post-checks
                                if not post_checks_pass(conn):
                                    raise Exception("Post-check validation failed")

                                logging.info(f"SUCCESS: {device['name']}")

                            except Exception as e:
                                logging.error(f"ROLLING BACK {device['name']}: {e}")

                                # 4. Restore from backup
                                restore_cmds = [
                                    line for line in backup.splitlines()
                                    if line and not line.startswith('!')
                                ]
                                conn.send_config_set(restore_cmds)
                                conn.save_config()
                                logging.info(f"ROLLBACK COMPLETE: {device['name']}")

                            finally:
                                conn.disconnect()

                        The finally block ensures the connection is always closed, even if rollback fails.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_rd_ie_7",
                                type: .multipleChoice,
                                prompt: "What does a Python 'finally' block guarantee in a deploy-with-rollback function?",
                                correctAnswer: "The connection is always closed, even if an error occurs",
                                options: [
                                    "The deployment always succeeds",
                                    "The connection is always closed, even if an error occurs",
                                    "The rollback always runs",
                                    "Post-checks are always skipped"
                                ],
                                explanation: "A finally block runs regardless of whether an exception occurred — ensuring resources like SSH connections are always cleaned up."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "r_rd_4_2",
                        heading: "Change Management Integration",
                        content: """
                        In enterprise environments, deployments are tracked through change management systems. Automation scripts can integrate with these systems to create and close tickets automatically.

                        What change management provides:
                        - Approval workflow: Changes require sign-off before deployment
                        - Risk assessment: Classify the impact of the change
                        - Rollback plan: Document what to do if the change fails
                        - Post-implementation review: Was the change successful?

                        Script integration (example with a REST API):
                        import requests

                        def open_change_ticket(description, devices_affected):
                            response = requests.post(
                                'https://servicenow.corp.local/api/now/table/change_request',
                                json={
                                    'short_description': description,
                                    'description': f'Automated deployment to {len(devices_affected)} devices',
                                    'type': 'automated',
                                    'assignment_group': 'Network Engineering'
                                },
                                auth=(os.environ['SNOW_USER'], os.environ['SNOW_PASS'])
                            )
                            return response.json()['result']['number']  # e.g., CHG0012345

                        Full automation lifecycle:
                        1. Script opens a change ticket before starting
                        2. Deployment runs with full logging
                        3. Script closes the ticket with pass/fail status and log attachment
                        4. Team has a complete record of every automated change
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "r_rd_ie_8",
                                type: .multipleChoice,
                                prompt: "What is the purpose of a change management ticket for automated deployments?",
                                correctAnswer: "To document, approve, and provide an audit trail for the change",
                                options: [
                                    "To slow down the deployment process",
                                    "To document, approve, and provide an audit trail for the change",
                                    "To automatically roll back failed deployments",
                                    "To replace the need for deployment scripts"
                                ],
                                explanation: "Change tickets ensure every deployment is approved, documented, and traceable — critical for compliance and post-incident investigation."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_r_rapid_deploy",
            title: "Rapid Deployment Assessment",
            questions: [
                QuizQuestion(
                    id: "r_rdq_1",
                    question: "How much faster is automated deployment compared to manual CLI work for 50 devices?",
                    options: ["About the same", "2–3x faster", "Potentially 75x faster or more", "Automation is actually slower"],
                    correctAnswerIndex: 2,
                    explanation: "50 devices × 3 minutes manually = 150 minutes. Automated deployment of all 50 takes roughly 2 minutes — about 75x faster.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_rdq_2",
                    question: "What does accepting the environment as a sys.argv command-line argument allow?",
                    options: ["Faster script execution", "The same script to be reused across dev, staging, and production", "Automatic rollback on failure", "Parallel device connections"],
                    correctAnswerIndex: 1,
                    explanation: "A CLI argument makes the script environment-agnostic — one script runs in all environments without code changes.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_rdq_3",
                    question: "What is a canary deployment?",
                    options: ["Deploying to all devices at once", "Deploying to a small subset first to catch problems before full rollout", "A backup strategy for config files", "A type of network monitoring"],
                    correctAnswerIndex: 1,
                    explanation: "A canary deployment limits blast radius — deploy to 10% of devices first, verify, then proceed to the rest only if the canary succeeds.",
                    difficulty: .beginner
                ),
                QuizQuestion(
                    id: "r_rdq_4",
                    question: "What does 'idempotent' mean for a deployment script?",
                    options: ["It runs exactly once and cannot be re-run", "Running it multiple times produces the same result as running it once", "It automatically generates documentation", "It requires no credentials"],
                    correctAnswerIndex: 1,
                    explanation: "An idempotent script is safe to re-run — the second run just confirms the correct state without causing duplicate configurations.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_rdq_5",
                    question: "Which Python block runs regardless of whether an exception was raised?",
                    options: ["except", "else", "finally", "with"],
                    correctAnswerIndex: 2,
                    explanation: "A finally block always executes — even if an exception occurred — making it ideal for cleanup tasks like closing SSH connections.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_rdq_6",
                    question: "What should a post-deployment check verify?",
                    options: ["That the script ran without Python errors", "That the configuration change had the intended operational effect", "That the device was rebooted", "That all interfaces are up"],
                    correctAnswerIndex: 1,
                    explanation: "Post-checks verify actual network behavior — for example, confirming NTP is synchronized after adding an NTP server, not just that the command was sent.",
                    difficulty: .intermediate
                ),
                QuizQuestion(
                    id: "r_rdq_7",
                    question: "In a deploy-with-rollback pattern, when is the pre-deployment backup used?",
                    options: ["Before the deployment starts as a health check", "To restore the device if post-checks fail", "As the template for other devices", "To verify the credentials are correct"],
                    correctAnswerIndex: 1,
                    explanation: "The pre-deployment backup is the restore point — if post-checks fail or an exception occurs, the script sends the backed-up config to return the device to its previous state.",
                    difficulty: .advanced
                ),
                QuizQuestion(
                    id: "r_rdq_8",
                    question: "What does integrating with a change management API allow an automation script to do?",
                    options: ["Run faster by skipping approvals", "Automatically open, update, and close change tickets with deployment results", "Bypass maintenance window restrictions", "Generate SSH keys automatically"],
                    correctAnswerIndex: 1,
                    explanation: "Change management integration creates a complete audit trail — every automated deployment is tracked, approved, and closed with pass/fail results automatically.",
                    difficulty: .advanced
                )
            ]
        )
    )
}
