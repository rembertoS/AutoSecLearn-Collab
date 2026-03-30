//
//  ModuleContent.swift
//  AutoSecLearn
//
//  Created by Remberto Silva on 3/30/26.
//

import Foundation

struct ModuleContent {
    static let modules: [LearningModule] = [
        pythonScriptingModule
        // Modules 2–5 will be added in future lessons
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
}
