import Foundation

struct CourseContent {
    static let modules: [LearningModule] = [
        switchModule,
        routerModule,
        failoverSwitchModule,
        pythonAutomationModule,
        firewallModule,
        wirelessSecurityModule,
        networkMonitoringModule,
        vpnModule,
        dnsServicesModule,
        zeroTrustModule
    ]

    // MARK: - Module 1: Network Switches

    static let switchModule = LearningModule(
        id: "switch_1",
        title: "Network Switches",
        description: "Learn how Layer 2 switches operate, forward frames by MAC address, and form the backbone of local networks.",
        icon: "arrow.triangle.branch",
        color: "switchBlue",
        lessons: [
            Lesson(
                id: "sw_lesson_1",
                title: "What is a Network Switch?",
                sections: [
                    LessonSection(
                        id: "sw_1_1",
                        heading: "Layer 2 Fundamentals",
                        content: """
                        A network switch operates at Layer 2 (Data Link Layer) of the OSI model. Unlike routers that use IP addresses, switches forward data frames based on MAC addresses.

                        When a device sends a frame, the switch reads the destination MAC address and forwards it only to the port where that device is connected. This is far more efficient than a hub, which broadcasts to every port.

                        Key concepts:
                        - MAC Address Table: The switch maintains a table mapping MAC addresses to physical ports
                        - Frame Forwarding: Frames are sent only to the correct destination port
                        - Full-Duplex Communication: Each port can send and receive simultaneously, eliminating collisions
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "sw_ie_1",
                                type: .multipleChoice,
                                prompt: "At which OSI layer does a network switch primarily operate?",
                                correctAnswer: "Layer 2 - Data Link",
                                options: ["Layer 1 - Physical", "Layer 2 - Data Link", "Layer 3 - Network", "Layer 4 - Transport"],
                                explanation: "Switches operate at Layer 2 and use MAC addresses to forward frames."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "sw_1_2",
                        heading: "How Switches Learn MAC Addresses",
                        content: """
                        Switches dynamically learn MAC addresses through a process called MAC address learning:

                        1. A frame arrives on a port
                        2. The switch reads the source MAC address
                        3. It records the MAC address and the port number in its MAC address table
                        4. It checks the destination MAC address against the table
                        5. If found, it forwards to that specific port; if not, it floods to all ports (except the source)

                        Over time, the switch builds a complete picture of which devices are connected to which ports. This table is stored in Content Addressable Memory (CAM) for fast lookups.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "sw_ie_2",
                                type: .fillInBlank,
                                prompt: "When a switch doesn't know the destination MAC address, it _____ the frame to all ports except the source.",
                                correctAnswer: "floods",
                                options: nil,
                                explanation: "Unknown unicast frames are flooded to all ports except the ingress port so the destination device can respond."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "sw_lesson_2",
                title: "Switch Applications & VLANs",
                sections: [
                    LessonSection(
                        id: "sw_2_1",
                        heading: "Common Switch Applications",
                        content: """
                        Switches serve as the foundation of modern local area networks. Common deployment scenarios include:

                        - Office Connectivity: Connecting PCs, printers, VoIP phones, and other endpoint devices
                        - Data Center Networking: Segmenting workloads and providing high-speed interconnects between servers
                        - Wireless Infrastructure: Providing backhaul connections for wireless access points
                        - IoT Networks: Connecting sensors, cameras, and smart devices
                        - VLAN Segmentation: Creating logical network boundaries for security and traffic management
                        """,
                        interactiveElements: nil
                    ),
                    LessonSection(
                        id: "sw_2_2",
                        heading: "VLANs (Virtual Local Area Networks)",
                        content: """
                        VLANs allow you to create separate broadcast domains on a single physical switch. This is critical for:

                        - Security: Isolating sensitive traffic (e.g., finance dept from guest WiFi)
                        - Performance: Reducing broadcast traffic within each segment
                        - Organization: Grouping devices logically regardless of physical location

                        Example VLAN Configuration:
                        - VLAN 10 (VOICE): Ports Fa0/1-16 with QoS trust for VoIP
                        - VLAN 20 (USERS): Ports Fa0/17-30 for standard workstations
                        - VLAN 30 (SERVERS): Ports Fa0/31-38 for server infrastructure
                        - VLAN 40 (DEV_TEST): Ports Fa0/39-46 for development and testing
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "sw_ie_3",
                                type: .trueFalse,
                                prompt: "VLANs can only separate traffic if devices are on different physical switches.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "VLANs create logical separation on the SAME physical switch. That's their primary advantage."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "sw_lesson_3",
                title: "Switch Security & Misconfigurations",
                sections: [
                    LessonSection(
                        id: "sw_3_1",
                        heading: "Critical Switch Misconfigurations",
                        content: """
                        A single misconfigured switch can bring down an entire building or campus network. Understanding common misconfigurations is essential for any IT professional.

                        1. Default Credentials: Leaving factory usernames and passwords enables unauthorized access. An attacker with switch access can compromise the entire network.

                        2. Improper VLAN Assignments: Misconfigured VLANs can allow unintended cross-department access, bypassing security policies.

                        3. Spanning Tree Protocol (STP) Issues: Disabling or misconfiguring STP creates broadcast storms and network loops that can bring down the entire network.

                        4. No Port Security: Without MAC address limiting, unauthorized devices can connect freely, and MAC spoofing attacks become possible.

                        5. Trunk Port Misconfiguration: Incorrectly configured trunk ports enable VLAN hopping and double-tagging attacks.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "sw_ie_4",
                                type: .multipleChoice,
                                prompt: "Which protocol prevents network loops caused by redundant switch connections?",
                                correctAnswer: "Spanning Tree Protocol (STP)",
                                options: ["VLAN Trunking Protocol (VTP)", "Spanning Tree Protocol (STP)", "Link Aggregation Control Protocol (LACP)", "Rapid Ring Protocol (RRP)"],
                                explanation: "STP prevents broadcast storms by disabling redundant paths and creating a loop-free topology."
                            ),
                            InteractiveElement(
                                id: "sw_ie_5",
                                type: .multipleChoice,
                                prompt: "What attack is possible when trunk ports are misconfigured?",
                                correctAnswer: "VLAN hopping",
                                options: ["DNS spoofing", "VLAN hopping", "ARP poisoning", "Buffer overflow"],
                                explanation: "Misconfigured trunk ports allow attackers to send double-tagged frames to access other VLANs."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "sw_3_2",
                        heading: "Switch Security Best Practices",
                        content: """
                        Protect your switch infrastructure with these practices:

                        - Change all default credentials immediately after deployment
                        - Enable port security to limit MAC addresses per port
                        - Configure STP with root guard and BPDU guard
                        - Use VLAN access control lists (VACLs) for traffic filtering
                        - Disable unused ports and assign them to a quarantine VLAN
                        - Enable SSH for remote management and disable Telnet
                        - Implement 802.1X for port-based network access control
                        - Regularly audit VLAN assignments and trunk configurations
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "sw_ie_6",
                                type: .trueFalse,
                                prompt: "Unused switch ports should be left enabled with default settings for convenience.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Unused ports should be disabled and assigned to a quarantine VLAN to prevent unauthorized access."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "sw_lesson_4",
                title: "Managed vs. Unmanaged Switches",
                sections: [
                    LessonSection(
                        id: "sw_4_1",
                        heading: "Understanding Switch Categories",
                        content: """
                        Not all switches are created equal. The choice between managed and unmanaged switches has major implications for security, performance, and cost.

                        Unmanaged Switches:
                        - Plug-and-play with no configuration interface
                        - Simply forward frames based on MAC addresses
                        - No VLAN support, no port security, no monitoring
                        - Lowest cost, suitable for home networks or small labs
                        - No remote management capability

                        Managed Switches:
                        - Full CLI and/or web-based management interface
                        - Support VLANs, STP, port security, QoS, and SNMP
                        - Allow granular control over every port
                        - Enable remote monitoring and configuration via SSH
                        - Higher cost, essential for enterprise and production networks

                        Smart Managed (Light Managed) Switches:
                        - A middle ground with web-based GUI but limited CLI
                        - Basic VLAN and QoS support
                        - Suitable for small businesses that need some control without full enterprise features
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "sw_ie_7",
                                type: .multipleChoice,
                                prompt: "Which type of switch provides VLAN support, port security, and remote management?",
                                correctAnswer: "Managed switch",
                                options: ["Unmanaged switch", "Managed switch", "Hub", "Repeater"],
                                explanation: "Managed switches provide full control over network features including VLANs, security, QoS, and remote administration."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "sw_4_2",
                        heading: "PoE and Layer 3 Switches",
                        content: """
                        Modern enterprise switches often include advanced features beyond basic Layer 2 forwarding:

                        Power over Ethernet (PoE):
                        - Delivers electrical power over the same Ethernet cable that carries data
                        - Eliminates the need for separate power adapters for connected devices
                        - Common PoE-powered devices: IP phones, wireless access points, security cameras
                        - Standards: 802.3af (15.4W), 802.3at PoE+ (30W), 802.3bt PoE++ (up to 90W)
                        - Power budget must be planned carefully to avoid overloading the switch

                        Layer 3 Switches:
                        - Combine switching (Layer 2) and routing (Layer 3) in a single device
                        - Can route traffic between VLANs without needing a separate router (inter-VLAN routing)
                        - Support static routes and dynamic routing protocols like OSPF
                        - Higher performance than a router for internal VLAN-to-VLAN traffic
                        - Common in enterprise campus networks where fast inter-VLAN communication is critical

                        Choosing the right switch depends on your network size, budget, power requirements, and whether you need routing capabilities at the access layer.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "sw_ie_8",
                                type: .trueFalse,
                                prompt: "A Layer 3 switch can route traffic between VLANs without needing a separate router.",
                                correctAnswer: "True",
                                options: ["True", "False"],
                                explanation: "Layer 3 switches perform inter-VLAN routing internally, which is faster than sending traffic to an external router."
                            ),
                            InteractiveElement(
                                id: "sw_ie_9",
                                type: .fillInBlank,
                                prompt: "_____ delivers both data and electrical power over a single Ethernet cable.",
                                correctAnswer: "PoE",
                                options: nil,
                                explanation: "Power over Ethernet (PoE) eliminates the need for separate power sources for devices like IP phones and access points."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_switch",
            title: "Network Switches Assessment",
            questions: [
                QuizQuestion(id: "sq_1", question: "At which OSI layer do network switches operate?", options: ["Layer 1 - Physical", "Layer 2 - Data Link", "Layer 3 - Network", "Layer 7 - Application"], correctAnswerIndex: 1, explanation: "Switches operate at Layer 2 and forward frames based on MAC addresses.", difficulty: .beginner),
                QuizQuestion(id: "sq_2", question: "What does a switch use to decide where to forward a frame?", options: ["IP address", "MAC address", "Port number", "Hostname"], correctAnswerIndex: 1, explanation: "Switches read the destination MAC address from the frame header to determine the correct output port.", difficulty: .beginner),
                QuizQuestion(id: "sq_3", question: "What happens when a switch receives a frame with an unknown destination MAC?", options: ["It drops the frame", "It sends an error message", "It floods the frame to all ports except the source", "It sends it to the default gateway"], correctAnswerIndex: 2, explanation: "Unknown unicast frames are flooded so the destination can respond and the switch can learn its location.", difficulty: .intermediate),
                QuizQuestion(id: "sq_4", question: "What is the primary purpose of VLANs?", options: ["Increase internet speed", "Create logical broadcast domain separation", "Replace the need for routers", "Encrypt network traffic"], correctAnswerIndex: 1, explanation: "VLANs segment a physical network into separate logical broadcast domains for security and performance.", difficulty: .beginner),
                QuizQuestion(id: "sq_5", question: "Which protocol prevents Layer 2 loops in networks with redundant paths?", options: ["OSPF", "BGP", "STP", "DHCP"], correctAnswerIndex: 2, explanation: "Spanning Tree Protocol (STP) creates a loop-free logical topology by blocking redundant paths.", difficulty: .intermediate),
                QuizQuestion(id: "sq_6", question: "What attack exploits misconfigured trunk ports?", options: ["SQL injection", "VLAN hopping", "Phishing", "Brute force"], correctAnswerIndex: 1, explanation: "VLAN hopping uses double-tagged frames on misconfigured trunks to access other VLANs.", difficulty: .advanced),
                QuizQuestion(id: "sq_7", question: "Where does a switch store its MAC address table for fast lookups?", options: ["RAM", "Content Addressable Memory (CAM)", "Hard disk", "Flash memory"], correctAnswerIndex: 1, explanation: "CAM allows the switch to perform constant-time lookups of MAC addresses for fast frame forwarding.", difficulty: .intermediate),
                QuizQuestion(id: "sq_8", question: "What should you do with unused switch ports?", options: ["Leave them enabled for future use", "Set them to trunk mode", "Disable them and assign to a quarantine VLAN", "Connect them to a hub"], correctAnswerIndex: 2, explanation: "Unused ports should be shut down and placed in an isolated VLAN to prevent unauthorized access.", difficulty: .intermediate),
                QuizQuestion(id: "sq_9", question: "Which feature allows each switch port to send and receive data simultaneously?", options: ["Half-duplex", "Full-duplex", "Simplex", "Multiplexing"], correctAnswerIndex: 1, explanation: "Full-duplex communication eliminates collisions by allowing simultaneous bidirectional data flow.", difficulty: .beginner),
                QuizQuestion(id: "sq_10", question: "What is 802.1X used for in switch security?", options: ["VLAN trunking", "Spanning tree optimization", "Port-based network access control", "Link aggregation"], correctAnswerIndex: 2, explanation: "802.1X authenticates devices before granting them network access through a switch port.", difficulty: .advanced)
            ]
        )
    )

    // MARK: - Module 2: Routers

    static let routerModule = LearningModule(
        id: "router",
        title: "Router Fundamentals",
        description: "Understand how routers direct traffic between networks using IP addresses, DHCP, NAT, and firewall rules.",
        icon: "wifi.router",
        color: "routerGreen",
        lessons: [
            Lesson(
                id: "rt_lesson_1",
                title: "What is a Router?",
                sections: [
                    LessonSection(
                        id: "rt_1_1",
                        heading: "Layer 3 Operations",
                        content: """
                        A router operates at Layer 3 (Network Layer) of the OSI model. While switches forward frames using MAC addresses, routers forward packets using IP addresses to determine the best path across networks.

                        Core router functions:
                        - Inspect incoming data packets and read destination IP addresses
                        - Calculate the most efficient route using routing tables
                        - Assign local IP addresses via DHCP
                        - Manage traffic between internal (LAN) and external (WAN) networks
                        - Implement security through NAT and firewall rules
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "rt_ie_1",
                                type: .multipleChoice,
                                prompt: "What does a router use to determine where to send a packet?",
                                correctAnswer: "IP address",
                                options: ["MAC address", "IP address", "Port number", "SSID"],
                                explanation: "Routers operate at Layer 3 and use destination IP addresses with routing tables to forward packets."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "rt_1_2",
                        heading: "Router vs. Switch",
                        content: """
                        Understanding the difference between routers and switches is fundamental:

                        Switches:
                        - Operate at Layer 2 (Data Link)
                        - Use MAC addresses
                        - Connect devices within the same network (LAN)
                        - Create and manage broadcast domains via VLANs

                        Routers:
                        - Operate at Layer 3 (Network)
                        - Use IP addresses
                        - Connect different networks together (LAN to WAN)
                        - Provide NAT, DHCP, and firewall services
                        - Make path decisions using routing protocols

                        In a typical network, switches handle local traffic while the router connects the local network to the internet or other remote networks.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "rt_ie_2",
                                type: .trueFalse,
                                prompt: "A switch can replace a router for connecting a local network to the internet.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Switches operate at Layer 2 and cannot perform the Layer 3 routing, NAT, or DHCP functions needed for internet connectivity."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "rt_lesson_2",
                title: "Router Use Cases & DHCP",
                sections: [
                    LessonSection(
                        id: "rt_2_1",
                        heading: "Common Router Deployments",
                        content: """
                        Routers are deployed wherever networks need to communicate with each other:

                        - Home/Office Internet: Connecting all local devices to a single ISP connection
                        - LAN Administration: Managing and segmenting internal networks
                        - Guest Network Isolation: Creating separate network segments for visitors
                        - VPN Connectivity: Establishing encrypted tunnels between remote offices
                        - Multi-WAN Failover: Using multiple ISP connections for redundancy
                        """,
                        interactiveElements: nil
                    ),
                    LessonSection(
                        id: "rt_2_2",
                        heading: "DHCP (Dynamic Host Configuration Protocol)",
                        content: """
                        DHCP is one of the most important services a router provides. It automatically assigns IP configurations to devices:

                        The DHCP Process (DORA):
                        1. Discover: Client broadcasts a request for an IP address
                        2. Offer: DHCP server responds with an available IP
                        3. Request: Client formally requests the offered IP
                        4. Acknowledge: Server confirms the assignment

                        DHCP assigns:
                        - IP address
                        - Subnet mask
                        - Default gateway (the router itself)
                        - DNS server addresses
                        - Lease duration
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "rt_ie_3",
                                type: .fillInBlank,
                                prompt: "The four steps of DHCP are Discover, Offer, Request, and _____.",
                                correctAnswer: "Acknowledge",
                                options: nil,
                                explanation: "DORA: Discover, Offer, Request, Acknowledge. The server confirms the IP assignment in the final step."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "rt_lesson_3",
                title: "Router Security & Misconfigurations",
                sections: [
                    LessonSection(
                        id: "rt_3_1",
                        heading: "Critical Router Misconfigurations",
                        content: """
                        Routers are the gateway between your network and the outside world. Misconfigurations here have severe consequences:

                        1. Default Credentials: Factory usernames and passwords are publicly known. Leaving them unchanged gives attackers full control of your network gateway.

                        2. Outdated Firmware: Unpatched routers are vulnerable to known exploits. Attackers actively scan for devices running old firmware versions.

                        3. Firewall Misconfiguration: Overly permissive rules expose internal services to the internet. Overly restrictive rules block legitimate business traffic.

                        4. Weak Access Controls: Open remote management interfaces, weak passwords, and unrestricted admin access create easy entry points for attackers.

                        5. Unnecessary Services Enabled: Features like remote administration, WPS, and UPnP are often enabled by default and expand the attack surface.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "rt_ie_4",
                                type: .multipleChoice,
                                prompt: "Which is the MOST common and dangerous router misconfiguration?",
                                correctAnswer: "Leaving default credentials unchanged",
                                options: ["Using wired connections", "Leaving default credentials unchanged", "Enabling DHCP", "Using a subnet mask"],
                                explanation: "Default credentials are publicly documented and give attackers complete administrative control."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "rt_3_2",
                        heading: "Router Security Best Practices",
                        content: """
                        Secure your router with these essential practices:

                        - Replace factory credentials immediately upon deployment
                        - Keep firmware updated to the latest stable version
                        - Disable all unused services (WPS, UPnP, remote admin)
                        - Restrict administrative access to trusted internal networks only
                        - Configure firewall rules following the principle of least privilege
                        - Enable logging for all administrative access attempts
                        - Test configuration changes in a lab environment before production
                        - Implement access control lists (ACLs) for traffic filtering
                        - Use encrypted protocols (SSH, HTTPS) for management
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "rt_ie_5",
                                type: .trueFalse,
                                prompt: "UPnP should be enabled by default on production routers for device compatibility.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "UPnP automatically opens ports and should be disabled on production routers as it expands the attack surface."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "rt_lesson_4",
                title: "Routing Protocols & Dynamic Routing",
                sections: [
                    LessonSection(
                        id: "rt_4_1",
                        heading: "Static vs. Dynamic Routing",
                        content: """
                        Routers need to know how to reach destination networks. There are two fundamental approaches to building routing tables:

                        Static Routing:
                        - Routes are manually configured by a network administrator
                        - Best for small, stable networks with few paths
                        - No CPU overhead from route calculations
                        - Does not adapt to network changes automatically
                        - A single misconfigured static route can create a black hole

                        Dynamic Routing:
                        - Routers automatically discover and share route information with each other
                        - Adapts to topology changes (link failures, new networks) in real time
                        - Essential for large or complex networks
                        - Consumes some bandwidth and CPU for route advertisements
                        - Uses routing protocols like OSPF, EIGRP, RIP, and BGP

                        Administrative Distance (AD) determines which source of routing information a router trusts most. Lower AD values are preferred. For example:
                        - Directly connected: AD 0
                        - Static route: AD 1
                        - OSPF: AD 110
                        - RIP: AD 120
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "rt_ie_6",
                                type: .multipleChoice,
                                prompt: "When should dynamic routing be used instead of static routing?",
                                correctAnswer: "In large or complex networks that change frequently",
                                options: ["In networks with only two routers", "In large or complex networks that change frequently", "When you want to save CPU resources", "When the network never changes"],
                                explanation: "Dynamic routing automatically adapts to topology changes, making it essential for large, complex networks."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "rt_4_2",
                        heading: "Common Routing Protocols",
                        content: """
                        Several dynamic routing protocols are used in modern networks, each with different characteristics:

                        RIP (Routing Information Protocol):
                        - One of the oldest routing protocols
                        - Uses hop count as its metric (maximum 15 hops)
                        - Simple to configure but slow to converge
                        - Suitable only for very small networks
                        - Sends full routing table updates every 30 seconds

                        OSPF (Open Shortest Path First):
                        - Industry standard link-state protocol
                        - Uses cost (based on bandwidth) as its metric
                        - Fast convergence when network changes occur
                        - Divides networks into areas for scalability
                        - Only sends updates when changes happen, not periodic full tables

                        BGP (Border Gateway Protocol):
                        - The protocol that runs the internet
                        - Used between autonomous systems (ISPs, large enterprises)
                        - Path-vector protocol that considers multiple attributes for route selection
                        - Critical for multi-homed organizations with multiple ISP connections

                        Most enterprise campus networks use OSPF internally, while BGP handles connections to ISPs and the broader internet.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "rt_ie_7",
                                type: .fillInBlank,
                                prompt: "_____ is the routing protocol that powers the internet by routing between autonomous systems.",
                                correctAnswer: "BGP",
                                options: nil,
                                explanation: "BGP (Border Gateway Protocol) is the path-vector protocol used to exchange routing information between ISPs and large networks."
                            ),
                            InteractiveElement(
                                id: "rt_ie_8",
                                type: .trueFalse,
                                prompt: "RIP supports a maximum of 30 hops between source and destination.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "RIP has a maximum hop count of 15. Any destination more than 15 hops away is considered unreachable."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_router",
            title: "Router Fundamentals Assessment",
            questions: [
                QuizQuestion(id: "rq_1", question: "At which OSI layer do routers operate?", options: ["Layer 1", "Layer 2", "Layer 3", "Layer 4"], correctAnswerIndex: 2, explanation: "Routers operate at Layer 3 (Network Layer) and forward packets based on IP addresses.", difficulty: .beginner),
                QuizQuestion(id: "rq_2", question: "What protocol automatically assigns IP addresses to devices?", options: ["DNS", "DHCP", "ARP", "ICMP"], correctAnswerIndex: 1, explanation: "DHCP (Dynamic Host Configuration Protocol) automates IP address assignment using the DORA process.", difficulty: .beginner),
                QuizQuestion(id: "rq_3", question: "What does NAT stand for?", options: ["Network Address Translation", "Network Access Terminal", "Node Assignment Table", "Network Authentication Token"], correctAnswerIndex: 0, explanation: "NAT translates private internal IP addresses to public addresses for internet communication.", difficulty: .beginner),
                QuizQuestion(id: "rq_4", question: "What are the four steps of the DHCP process in order?", options: ["Discover, Offer, Request, Acknowledge", "Detect, Open, Relay, Accept", "Discover, Open, Reply, Accept", "Detect, Offer, Request, Apply"], correctAnswerIndex: 0, explanation: "DORA: Discover, Offer, Request, Acknowledge is the standard DHCP handshake process.", difficulty: .intermediate),
                QuizQuestion(id: "rq_5", question: "Which service should be DISABLED on production routers?", options: ["DHCP", "NAT", "UPnP", "SSH"], correctAnswerIndex: 2, explanation: "UPnP automatically opens firewall ports and creates security vulnerabilities. Disable it in production.", difficulty: .intermediate),
                QuizQuestion(id: "rq_6", question: "What is the primary security risk of outdated router firmware?", options: ["Slower speeds", "Known exploits remain unpatched", "DHCP stops working", "VLANs become unstable"], correctAnswerIndex: 1, explanation: "Old firmware contains publicly known vulnerabilities that attackers actively exploit.", difficulty: .intermediate),
                QuizQuestion(id: "rq_7", question: "What principle should guide firewall rule configuration?", options: ["Maximum convenience", "Least privilege", "Open by default", "Allow all internal traffic"], correctAnswerIndex: 1, explanation: "Least privilege means only allowing the minimum necessary traffic, blocking everything else.", difficulty: .advanced),
                QuizQuestion(id: "rq_8", question: "Which protocol should be used for remote router management instead of Telnet?", options: ["HTTP", "FTP", "SSH", "SNMP v1"], correctAnswerIndex: 2, explanation: "SSH encrypts the management session. Telnet sends credentials in plain text.", difficulty: .intermediate),
                QuizQuestion(id: "rq_9", question: "What does a router's routing table contain?", options: ["MAC addresses of local devices", "Network destinations and next-hop addresses", "DNS records", "DHCP lease information"], correctAnswerIndex: 1, explanation: "The routing table maps destination networks to next-hop addresses and outgoing interfaces.", difficulty: .intermediate),
                QuizQuestion(id: "rq_10", question: "Why should router admin access be restricted to trusted networks?", options: ["To improve speed", "To prevent unauthorized configuration changes", "To save bandwidth", "To reduce power consumption"], correctAnswerIndex: 1, explanation: "Restricting admin access prevents attackers from modifying router configuration even if they gain network access.", difficulty: .advanced)
            ]
        )
    )

    // MARK: - Module 3: Failover & Redundancy (Switch 2)

    static let failoverSwitchModule = LearningModule(
        id: "failover_switch",
        title: "Network Redundancy & Failover",
        description: "Design resilient networks with redundant switches, failover protection, and load balancing strategies.",
        icon: "arrow.triangle.2.circlepath",
        color: "failoverOrange",
        lessons: [
            Lesson(
                id: "fo_lesson_1",
                title: "Why Network Redundancy Matters",
                sections: [
                    LessonSection(
                        id: "fo_1_1",
                        heading: "The Case for Redundancy",
                        content: """
                        In production environments, network downtime costs money and productivity. A second switch (or more) provides:

                        - Expanded Capacity: More ports for additional users and devices
                        - Failover Protection: If Switch 1 fails, Switch 2 maintains connectivity
                        - Load Distribution: Traffic is spread across switches, reducing congestion
                        - Isolated Failure Domains: A failure on one switch doesn't affect users on the other
                        - Easier Maintenance: One switch can be updated while the other handles traffic
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fo_ie_1",
                                type: .multipleChoice,
                                prompt: "What is the primary benefit of having a second switch in the network?",
                                correctAnswer: "Failover protection if the primary switch fails",
                                options: ["Faster internet speed", "Failover protection if the primary switch fails", "Lower electricity costs", "Simpler configuration"],
                                explanation: "Redundant switches ensure network continuity even when hardware fails."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "fo_1_2",
                        heading: "How Failover Works",
                        content: """
                        When the primary switch (Switch 1) fails, the failover switch (Switch 2) takes over through several mechanisms:

                        1. Redundant Trunk Links: Multiple physical connections between switches allow automatic failover
                        2. STP Reconvergence: Spanning Tree Protocol activates previously blocked backup paths
                        3. Traffic Rerouting: Packets are automatically redirected through the surviving switch
                        4. Configuration Backup: Switch 2 maintains identical VLAN and security configurations

                        The failover process should be seamless to end users, with minimal packet loss during the transition.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fo_ie_2",
                                type: .fillInBlank,
                                prompt: "_____ Protocol activates backup paths when the primary switch fails.",
                                correctAnswer: "Spanning Tree",
                                options: nil,
                                explanation: "STP maintains backup paths in a blocked state and activates them when the primary path fails."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "fo_lesson_2",
                title: "Configuring Redundant Switches",
                sections: [
                    LessonSection(
                        id: "fo_2_1",
                        heading: "Essential Configuration Steps",
                        content: """
                        Setting up a redundant switch requires careful configuration to ensure seamless failover:

                        1. Trunk Port Configuration: Set up trunk links between switches to carry all VLAN traffic
                        2. STP Activation: Enable Spanning Tree Protocol to prevent loops while maintaining backup paths
                        3. Consistent VLAN IDs: Both switches must use identical VLAN numbering and naming
                        4. Port Security: Apply MAC address limiting on both switches
                        5. Management IP: Assign a unique static IP to each switch for remote administration

                        The key principle is consistency: both switches should mirror each other's configuration as closely as possible.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fo_ie_3",
                                type: .trueFalse,
                                prompt: "In a redundant switch setup, it's acceptable for Switch 1 and Switch 2 to use different VLAN IDs.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "VLAN IDs must be consistent across all switches for trunk links and failover to work correctly."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "fo_2_2",
                        heading: "Monitoring & Maintenance",
                        content: """
                        Maintaining redundant infrastructure requires ongoing attention:

                        - Document and label all cables and port connections
                        - Maintain configuration backups for both switches
                        - Use SNMP or port mirroring to monitor inter-switch traffic
                        - Track all VLAN assignment changes across both devices
                        - Implement SSH/HTTPS for all management access
                        - Test failover regularly to verify it works as expected
                        - Use separate power circuits for each switch when possible
                        - Keep firmware versions synchronized between switches
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fo_ie_4",
                                type: .multipleChoice,
                                prompt: "Why should redundant switches use separate power circuits?",
                                correctAnswer: "So a single power failure doesn't take down both switches",
                                options: ["To reduce electricity costs", "So a single power failure doesn't take down both switches", "To increase network speed", "It's not necessary"],
                                explanation: "If both switches share a power circuit and it fails, both go down, defeating the purpose of redundancy."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "fo_lesson_3",
                title: "Link Aggregation & High Availability",
                sections: [
                    LessonSection(
                        id: "fo_3_1",
                        heading: "EtherChannel & Link Aggregation",
                        content: """
                        Link Aggregation bundles multiple physical links between switches into a single logical connection. This provides both increased bandwidth and redundancy without the complexity of additional routing or spanning tree changes.

                        EtherChannel combines 2 to 8 physical links into one logical channel. If one link fails, traffic redistributes across the remaining links automatically.

                        Negotiation Protocols:
                        - LACP (Link Aggregation Control Protocol): IEEE 802.3ad standard, works across vendors. Uses active/passive modes to negotiate bundling.
                        - PAgP (Port Aggregation Protocol): Cisco proprietary. Uses desirable/auto modes. Only works between Cisco devices.
                        - Static (On mode): No negotiation, both sides must be manually configured. Riskiest but simplest.

                        Configuration Requirements:
                        - All ports in the bundle must have matching speed, duplex, and VLAN settings
                        - Ports must be on the same switch (or stacked switches)
                        - Mismatched settings cause individual links to be suspended from the bundle
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fo_ie_5",
                                type: .multipleChoice,
                                prompt: "Which link aggregation protocol is an open IEEE standard that works across vendors?",
                                correctAnswer: "LACP",
                                options: ["PAgP", "LACP", "STP", "VTP"],
                                explanation: "LACP (802.3ad) is the industry standard for link aggregation and works across different switch vendors."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "fo_3_2",
                        heading: "Gateway Redundancy with HSRP & VRRP",
                        content: """
                        While link aggregation protects switch-to-switch connections, gateway redundancy protocols protect the default gateway that end devices rely on to reach other networks.

                        HSRP (Hot Standby Router Protocol):
                        - Cisco proprietary protocol for gateway failover
                        - Two or more routers share a virtual IP address
                        - One router is Active (handles traffic), one is Standby (monitors and takes over if Active fails)
                        - Failover typically completes within seconds
                        - Clients point to the virtual IP as their default gateway

                        VRRP (Virtual Router Redundancy Protocol):
                        - Open standard (RFC 5798) alternative to HSRP
                        - Uses Master/Backup terminology instead of Active/Standby
                        - Works across multi-vendor environments
                        - Priority values determine which router becomes Master

                        Both protocols ensure that if the primary gateway router fails, a backup immediately takes over using the same virtual IP address, so end devices never need reconfiguration.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fo_ie_6",
                                type: .trueFalse,
                                prompt: "HSRP is an open standard that works across all router vendors.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "HSRP is Cisco proprietary. VRRP is the open standard equivalent for multi-vendor gateway redundancy."
                            ),
                            InteractiveElement(
                                id: "fo_ie_7",
                                type: .fillInBlank,
                                prompt: "In HSRP, clients use a _____ IP address as their default gateway so failover is seamless.",
                                correctAnswer: "virtual",
                                options: nil,
                                explanation: "HSRP routers share a virtual IP address. The active router responds to traffic for this virtual IP, and the standby takes over if it fails."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_failover",
            title: "Network Redundancy Assessment",
            questions: [
                QuizQuestion(id: "fq_1", question: "What is the primary purpose of a failover switch?", options: ["Increase internet speed", "Maintain connectivity when the primary switch fails", "Replace the router", "Reduce power consumption"], correctAnswerIndex: 1, explanation: "A failover switch provides continuity when the primary switch experiences a hardware failure.", difficulty: .beginner),
                QuizQuestion(id: "fq_2", question: "What protocol activates backup paths during switch failure?", options: ["DHCP", "DNS", "STP", "HTTP"], correctAnswerIndex: 2, explanation: "Spanning Tree Protocol reconverges to activate previously blocked backup paths.", difficulty: .intermediate),
                QuizQuestion(id: "fq_3", question: "What must be identical across redundant switches?", options: ["Physical location", "VLAN IDs and configurations", "Brand and model", "Number of connected devices"], correctAnswerIndex: 1, explanation: "Consistent VLAN configurations are required for trunk links and failover to function correctly.", difficulty: .intermediate),
                QuizQuestion(id: "fq_4", question: "Why should you test failover regularly?", options: ["To increase speed", "To verify the backup switch will actually work when needed", "To reset the MAC address table", "To update firmware"], correctAnswerIndex: 1, explanation: "Without testing, you may discover failover is broken only during an actual emergency.", difficulty: .beginner),
                QuizQuestion(id: "fq_5", question: "What type of link carries VLAN traffic between redundant switches?", options: ["Access link", "Trunk link", "Console link", "Management link"], correctAnswerIndex: 1, explanation: "Trunk links carry tagged VLAN traffic between switches, enabling VLAN consistency.", difficulty: .intermediate),
                QuizQuestion(id: "fq_6", question: "What monitoring protocol can observe inter-switch traffic?", options: ["SNMP", "SMTP", "POP3", "FTP"], correctAnswerIndex: 0, explanation: "SNMP (Simple Network Management Protocol) provides monitoring and management of network devices.", difficulty: .intermediate),
                QuizQuestion(id: "fq_7", question: "What is an isolated failure domain?", options: ["A network with no redundancy", "A section of the network unaffected by failures elsewhere", "A VLAN with no devices", "A disabled switch port"], correctAnswerIndex: 1, explanation: "With redundant switches, users on Switch 2 aren't affected by a Switch 1 failure.", difficulty: .advanced),
                QuizQuestion(id: "fq_8", question: "How should redundant switch firmware be managed?", options: ["Only update one switch", "Keep versions synchronized", "Use different firmware on each", "Never update firmware"], correctAnswerIndex: 1, explanation: "Synchronized firmware ensures consistent behavior during failover and normal operation.", difficulty: .intermediate)
            ]
        )
    )

    // MARK: - Module 4: Python Network Automation

    static let pythonAutomationModule = LearningModule(
        id: "python_automation",
        title: "Python Network Automation",
        description: "Automate switch and router configuration with Python, Netmiko, and serial connections.",
        icon: "chevron.left.forwardslash.chevron.right",
        color: "pythonYellow",
        lessons: [
            Lesson(
                id: "py_lesson_1",
                title: "Why Automate Network Configuration?",
                sections: [
                    LessonSection(
                        id: "py_1_1",
                        heading: "The Problem with Manual Configuration",
                        content: """
                        Manually configuring network devices is error-prone and doesn't scale:

                        - Human Error: Typos in commands can bring down networks
                        - Inconsistency: Different engineers configure devices differently
                        - Time: Configuring 100 switches manually takes days
                        - Audit Trail: Manual changes are hard to track and version control
                        - Repeatability: Lab environments need identical setups every time

                        Python automation solves these problems by codifying configurations into scripts that are consistent, repeatable, and version-controlled.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "py_ie_1",
                                type: .multipleChoice,
                                prompt: "What is the biggest advantage of automating network configuration?",
                                correctAnswer: "Consistency and repeatability across devices",
                                options: ["Faster internet speeds", "Consistency and repeatability across devices", "Eliminating the need for switches", "Reducing the number of VLANs needed"],
                                explanation: "Automation ensures every device gets the exact same configuration, eliminating human error."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "py_1_2",
                        heading: "Tools & Prerequisites",
                        content: """
                        To automate Cisco device configuration, you need:

                        Hardware:
                        - Cisco switch (Catalyst 2950 or similar)
                        - USB-to-serial adapter
                        - Console cable (RJ-45 to DB-9)

                        Software:
                        - Python 3.x
                        - pyserial library (for serial/console connections)
                        - Netmiko library (for SSH connections to network devices)

                        Installation:
                        pip install pyserial
                        pip install netmiko

                        pyserial is used for direct console connections via COM ports, while Netmiko handles SSH-based remote configuration.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "py_ie_2",
                                type: .multipleChoice,
                                prompt: "Which Python library is used for SSH connections to network devices?",
                                correctAnswer: "Netmiko",
                                options: ["pyserial", "Netmiko", "requests", "Flask"],
                                explanation: "Netmiko provides SSH connectivity to multi-vendor network equipment."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "py_lesson_2",
                title: "Automating Switch Configuration",
                sections: [
                    LessonSection(
                        id: "py_2_1",
                        heading: "Script Architecture",
                        content: """
                        A network automation script typically has four core functions:

                        1. Port Detection: Uses serial.tools.list_ports to find the correct USB/serial COM port connected to the switch

                        2. Command Execution: Sends CLI commands over the serial connection, handling prompts and confirmations automatically

                        3. Configuration Application: Applies a predefined set of commands including hostname, VLANs, QoS settings, trunking, and security

                        4. State Verification: Saves the running configuration to NVRAM with 'write memory' to persist through reboots

                        The command sequence follows the same order you'd use manually:
                        enable -> configure terminal -> (configuration commands) -> end -> write memory
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "py_ie_3",
                                type: .fillInBlank,
                                prompt: "To save running configuration to persistent storage, use the _____ command.",
                                correctAnswer: "write memory",
                                options: nil,
                                explanation: "write memory (or 'copy running-config startup-config') saves the current configuration to NVRAM."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "py_2_2",
                        heading: "Example Configuration Template",
                        content: """
                        A typical automated switch deployment configures:

                        Basic Settings:
                        - Hostname: SW1
                        - Management IP: 192.168.1.5/24 on VLAN 1

                        VLAN Structure:
                        - VLAN 10 (VOICE): Ports Fa0/1-16 with QoS trust enabled
                        - VLAN 20 (USERS): Ports Fa0/17-30 for workstations
                        - VLAN 30 (SERVERS): Ports Fa0/31-38 for servers
                        - VLAN 40 (DEV_TEST): Ports Fa0/39-46 for development

                        Trunk Configuration:
                        - Port Fa0/47 as trunk to upstream router
                        - Allowed VLANs: 1, 10, 20, 30, 40

                        Security:
                        - Unused port Fa0/48 shut down
                        - Enable secret configured
                        - Console and VTY passwords set
                        - SSH enabled for remote management

                        Students can customize VLAN IDs, port ranges, hostname, and IP addresses by modifying the script's configuration variables.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "py_ie_4",
                                type: .multipleChoice,
                                prompt: "Why is port Fa0/48 shut down in the example configuration?",
                                correctAnswer: "Security hygiene - unused ports should be disabled",
                                options: ["It's broken", "Security hygiene - unused ports should be disabled", "To save power", "It's reserved for the router"],
                                explanation: "Disabling unused ports prevents unauthorized devices from connecting to the network."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "py_lesson_3",
                title: "Scaling Automation with Netmiko",
                sections: [
                    LessonSection(
                        id: "py_3_1",
                        heading: "Beyond Serial: SSH-Based Automation",
                        content: """
                        While pyserial works for initial console configuration, Netmiko enables remote automation at scale:

                        Key Netmiko Capabilities:
                        - SSH connections to Cisco IOS, Juniper, Arista, and many other vendors
                        - Password-based and key-based authentication
                        - Multi-host batch management: configure dozens of devices from one script
                        - Automatic handling of device prompts and command modes
                        - Built-in error detection and handling

                        Enterprise Integration:
                        - CI/CD pipeline integration for infrastructure-as-code
                        - Scheduled configuration deployments
                        - Secret management via environment variables or encrypted vaults
                        - Centralized command logic reduces errors across large fleets
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "py_ie_5",
                                type: .trueFalse,
                                prompt: "Netmiko can only connect to Cisco devices.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Netmiko supports multi-vendor devices including Cisco, Juniper, Arista, and many others."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "py_3_2",
                        heading: "Security in Automation",
                        content: """
                        Automating network configuration introduces its own security considerations:

                        Credential Management:
                        - Never hardcode passwords in scripts
                        - Use environment variables or encrypted vault systems
                        - Implement role-based access for automation users
                        - Rotate credentials regularly

                        Script Security:
                        - Store scripts in version-controlled repositories
                        - Use code review processes for configuration changes
                        - Test in lab environments before production deployment
                        - Maintain audit logs of all automated changes
                        - Implement rollback procedures for failed deployments

                        Lab vs. Production:
                        - Lab credentials are for testing only (never reuse in production)
                        - Production scripts should pull credentials from secure stores
                        - Separate lab and production environments completely
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "py_ie_6",
                                type: .multipleChoice,
                                prompt: "Where should production automation scripts store device credentials?",
                                correctAnswer: "In environment variables or an encrypted vault",
                                options: ["Hardcoded in the script", "In a text file on the desktop", "In environment variables or an encrypted vault", "In the script comments"],
                                explanation: "Credentials should never be in source code. Use secure stores like environment variables or vault systems."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "py_lesson_4",
                title: "Configuration Backup & Compliance",
                sections: [
                    LessonSection(
                        id: "py_4_1",
                        heading: "Automated Configuration Backup",
                        content: """
                        One of the most valuable automation tasks is regularly backing up device configurations. Manual backups are tedious and often forgotten, leaving organizations unable to recover from failures or misconfigurations.

                        Why Automate Backups:
                        - Disaster recovery: Restore a device to a known-good state in minutes
                        - Change tracking: Compare configurations over time to detect unauthorized changes
                        - Compliance: Maintain an audit trail of all configuration states
                        - Onboarding: Quickly replicate configurations to replacement hardware

                        Backup Strategy with Python:
                        - Use Netmiko to SSH into each device and run 'show running-config'
                        - Save output to timestamped files (e.g., SW1_2026-03-01_config.txt)
                        - Store backups in a Git repository for version control and diff tracking
                        - Schedule scripts with cron (Linux/macOS) or Task Scheduler (Windows)
                        - Send email or Slack alerts if a backup fails or a config change is detected

                        Configuration Diff:
                        - Python's difflib module can compare two configuration files line by line
                        - Highlights added, removed, or modified lines
                        - Helps identify accidental changes or unauthorized modifications
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "py_ie_7",
                                type: .multipleChoice,
                                prompt: "What is the primary benefit of storing configuration backups in a Git repository?",
                                correctAnswer: "Version control and the ability to see exactly what changed over time",
                                options: ["Faster network speeds", "Version control and the ability to see exactly what changed over time", "Reducing the number of devices", "Eliminating the need for passwords"],
                                explanation: "Git provides complete version history, diff capabilities, and the ability to roll back to any previous configuration state."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "py_4_2",
                        heading: "Compliance Auditing with Python",
                        content: """
                        Compliance auditing ensures that every network device meets your organization's security policies. Manually checking each device is impractical at scale, but Python makes it efficient.

                        Common Compliance Checks:
                        - SSH is enabled and Telnet is disabled
                        - Default credentials have been changed
                        - Unused ports are shut down
                        - SNMP community strings are not set to 'public' or 'private'
                        - Logging is enabled and pointed to a syslog server
                        - NTP is configured for consistent timestamps
                        - Banner messages warn against unauthorized access

                        Building a Compliance Script:
                        1. Define your policy rules as a checklist
                        2. Connect to each device via Netmiko
                        3. Pull the running configuration
                        4. Parse the config and check each rule
                        5. Generate a pass/fail report for every device
                        6. Flag non-compliant devices for remediation

                        Advanced Approach:
                        - Use frameworks like Nornir or Ansible for large-scale compliance
                        - Integrate with CI/CD pipelines to check compliance before deploying changes
                        - Generate HTML or PDF reports for management review
                        - Auto-remediate simple violations (like enabling logging) with approval workflows
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "py_ie_8",
                                type: .trueFalse,
                                prompt: "SNMP community strings set to 'public' are considered secure for production environments.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "'public' is the default SNMP community string and is well-known to attackers. Production environments must use unique, complex strings."
                            ),
                            InteractiveElement(
                                id: "py_ie_9",
                                type: .multipleChoice,
                                prompt: "What should a compliance audit script do when it finds a non-compliant device?",
                                correctAnswer: "Flag it in a report for remediation",
                                options: ["Immediately shut down the device", "Flag it in a report for remediation", "Ignore it and move to the next device", "Delete the device configuration"],
                                explanation: "Compliance scripts should report violations so administrators can review and remediate them through proper change management."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_python",
            title: "Python Automation Assessment",
            questions: [
                QuizQuestion(id: "pq_1", question: "Which Python library is used for serial console connections to switches?", options: ["Netmiko", "pyserial", "paramiko", "requests"], correctAnswerIndex: 1, explanation: "pyserial provides serial port access for direct console connections via USB-to-serial adapters.", difficulty: .beginner),
                QuizQuestion(id: "pq_2", question: "What is the correct command sequence for entering configuration mode?", options: ["configure terminal -> enable", "enable -> configure terminal", "login -> configure", "ssh -> enable -> config"], correctAnswerIndex: 1, explanation: "You must first enter privileged EXEC mode (enable) before entering global configuration mode.", difficulty: .beginner),
                QuizQuestion(id: "pq_3", question: "What command saves the running configuration to survive a reboot?", options: ["save config", "write memory", "export settings", "backup now"], correctAnswerIndex: 1, explanation: "write memory (or copy running-config startup-config) saves to NVRAM for persistence.", difficulty: .intermediate),
                QuizQuestion(id: "pq_4", question: "Why should you NEVER hardcode passwords in automation scripts?", options: ["It makes the script slower", "Scripts in version control expose credentials to anyone with repo access", "It causes syntax errors", "Passwords don't work in scripts"], correctAnswerIndex: 1, explanation: "Hardcoded credentials in version control are visible to all contributors and remain in git history.", difficulty: .intermediate),
                QuizQuestion(id: "pq_5", question: "What advantage does Netmiko have over pyserial for automation?", options: ["It's faster at serial connections", "It supports remote SSH connections to multiple devices", "It doesn't require Python", "It only works with Cisco"], correctAnswerIndex: 1, explanation: "Netmiko enables SSH-based remote automation across multiple devices without physical console access.", difficulty: .intermediate),
                QuizQuestion(id: "pq_6", question: "What is infrastructure-as-code?", options: ["Building physical infrastructure with robots", "Managing hardware configuration through version-controlled scripts", "Writing code on physical infrastructure", "Using infrastructure to generate code"], correctAnswerIndex: 1, explanation: "Infrastructure-as-code treats network/system configuration as software, enabling version control and CI/CD.", difficulty: .advanced),
                QuizQuestion(id: "pq_7", question: "What should you do before deploying automation scripts to production?", options: ["Run them directly on production devices", "Test in a lab environment first", "Skip testing to save time", "Only test on weekends"], correctAnswerIndex: 1, explanation: "Always test automation scripts in an isolated lab environment to catch errors before they affect production.", difficulty: .beginner),
                QuizQuestion(id: "pq_8", question: "Which authentication methods does Netmiko support?", options: ["Only password-based", "Only key-based", "Both password and key-based", "No authentication needed"], correctAnswerIndex: 2, explanation: "Netmiko supports both password-based and SSH key-based authentication for flexible deployment.", difficulty: .intermediate)
            ]
        )
    )

    // MARK: - Module 5: Firewalls & Access Control Lists

    static let firewallModule = LearningModule(
        id: "firewall_acl",
        title: "Firewalls & ACLs",
        description: "Understand how firewalls protect networks using rules, zones, and access control lists to filter traffic.",
        icon: "flame.fill",
        color: "firewallRed",
        lessons: [
            Lesson(
                id: "fw_lesson_1",
                title: "What is a Firewall?",
                sections: [
                    LessonSection(
                        id: "fw_1_1",
                        heading: "Types of Firewalls",
                        content: """
                        A firewall is a network security device that monitors and controls incoming and outgoing traffic based on predefined security rules. Firewalls form the first line of defense between trusted internal networks and untrusted external networks like the internet.

                        There are several types of firewalls, each with increasing sophistication:

                        Packet Filtering Firewalls:
                        - The simplest type, operating at Layer 3 and Layer 4
                        - Examine individual packets against a set of rules (source/destination IP, port, protocol)
                        - Fast but cannot inspect packet contents or track connection states
                        - Example: Basic router ACLs

                        Stateful Inspection Firewalls:
                        - Track the state of active connections in a state table
                        - Understand whether a packet is part of an existing, legitimate connection
                        - More secure than packet filtering because they can detect out-of-state packets
                        - Example: Cisco ASA, iptables with conntrack

                        Next-Generation Firewalls (NGFW):
                        - Combine stateful inspection with deep packet inspection (DPI)
                        - Can identify and control applications regardless of port
                        - Include intrusion prevention (IPS), malware detection, and URL filtering
                        - Example: Palo Alto, Fortinet FortiGate, Cisco Firepower
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fw_ie_1",
                                type: .multipleChoice,
                                prompt: "Which type of firewall can identify and control specific applications regardless of port number?",
                                correctAnswer: "Next-Generation Firewall (NGFW)",
                                options: ["Packet filtering firewall", "Stateful inspection firewall", "Next-Generation Firewall (NGFW)", "Proxy firewall"],
                                explanation: "NGFWs use deep packet inspection to identify applications at Layer 7, regardless of the port being used."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "fw_1_2",
                        heading: "How Firewalls Filter Traffic",
                        content: """
                        Firewalls use rules to decide what traffic to allow or block. These rules are processed in order from top to bottom, and the first matching rule wins.

                        Key Concepts:

                        Firewall Rules:
                        - Each rule specifies: source, destination, port, protocol, and action (permit or deny)
                        - Rules are evaluated sequentially; order matters
                        - More specific rules should be placed before general ones

                        Security Zones:
                        - Inside Zone: The trusted internal network (LAN)
                        - Outside Zone: The untrusted external network (internet)
                        - DMZ Zone: A semi-trusted zone for public-facing servers
                        - Traffic between zones is controlled by firewall policies

                        Default Deny:
                        - The most secure approach is to deny all traffic by default
                        - Then explicitly permit only the traffic that is needed
                        - This is called the "implicit deny" or "deny all" rule
                        - Any traffic not matching a permit rule is automatically dropped

                        This principle of least privilege ensures only necessary communications are allowed through the firewall.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fw_ie_2",
                                type: .trueFalse,
                                prompt: "A firewall with a 'default deny' policy blocks all traffic that isn't explicitly permitted by a rule.",
                                correctAnswer: "True",
                                options: ["True", "False"],
                                explanation: "Default deny (implicit deny) means any traffic not matching a specific permit rule is automatically blocked."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "fw_lesson_2",
                title: "Access Control Lists",
                sections: [
                    LessonSection(
                        id: "fw_2_1",
                        heading: "Standard vs Extended ACLs",
                        content: """
                        Access Control Lists (ACLs) are the building blocks of firewall rules on Cisco devices. They define which traffic is permitted or denied based on specific criteria.

                        Standard ACLs (numbered 1-99):
                        - Filter based on source IP address only
                        - Cannot specify destination, port, or protocol
                        - Should be placed close to the destination to avoid blocking unintended traffic
                        - Simpler but less precise

                        Extended ACLs (numbered 100-199):
                        - Filter based on source IP, destination IP, port number, and protocol
                        - Provide granular control over traffic
                        - Should be placed close to the source to block unwanted traffic early
                        - More complex but far more flexible

                        Named ACLs:
                        - Use descriptive names instead of numbers (e.g., "BLOCK_GUEST_TRAFFIC")
                        - Easier to manage and understand
                        - Can be either standard or extended type
                        - Allow insertion and deletion of individual rules without rewriting the entire list
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fw_ie_3",
                                type: .multipleChoice,
                                prompt: "What is the main limitation of a Standard ACL?",
                                correctAnswer: "It can only filter based on source IP address",
                                options: ["It can only filter based on source IP address", "It cannot be applied to interfaces", "It only works on routers", "It blocks all traffic by default"],
                                explanation: "Standard ACLs only examine the source IP address, making them less flexible than Extended ACLs."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "fw_2_2",
                        heading: "Writing & Applying ACL Rules",
                        content: """
                        Writing ACL rules follows a specific syntax and logic:

                        Extended ACL Syntax:
                        access-list [number] [permit/deny] [protocol] [source] [wildcard] [destination] [wildcard] eq [port]

                        Example Rules:
                        - Permit web traffic: access-list 100 permit tcp any any eq 80
                        - Deny Telnet from a subnet: access-list 100 deny tcp 192.168.1.0 0.0.0.255 any eq 23
                        - Permit HTTPS only: access-list 100 permit tcp any any eq 443

                        Wildcard Masks:
                        - The inverse of a subnet mask
                        - 0 means the bit must match, 1 means it can be anything
                        - 0.0.0.0 = match exactly one host
                        - 0.0.0.255 = match any host in the /24 subnet
                        - 255.255.255.255 = match any address (same as "any")

                        Applying ACLs to Interfaces:
                        - Inbound (in): Filters traffic entering the interface
                        - Outbound (out): Filters traffic leaving the interface
                        - Command: ip access-group [ACL number] [in/out]

                        Remember: Every ACL has an implicit "deny all" at the end. If no rule matches, the traffic is dropped.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fw_ie_4",
                                type: .fillInBlank,
                                prompt: "In a wildcard mask, a 0 bit means the corresponding bit must _____, while a 1 bit means it can be anything.",
                                correctAnswer: "match",
                                options: nil,
                                explanation: "Wildcard masks are the inverse of subnet masks. A 0 means the bit must match exactly, and a 1 means any value is accepted."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "fw_lesson_3",
                title: "Firewall Security & DMZ",
                sections: [
                    LessonSection(
                        id: "fw_3_1",
                        heading: "The Demilitarized Zone (DMZ)",
                        content: """
                        A DMZ is a network segment that sits between the trusted internal network and the untrusted internet. It hosts services that need to be accessible from outside without exposing the internal network.

                        Common DMZ Services:
                        - Web servers (HTTP/HTTPS)
                        - Email servers (SMTP)
                        - DNS servers
                        - VPN concentrators
                        - Reverse proxies

                        DMZ Architecture:
                        - Single Firewall: One firewall with three interfaces (inside, outside, DMZ)
                        - Dual Firewall: Two firewalls creating a buffer zone between them
                        - The dual firewall approach is more secure because compromising one firewall doesn't expose the internal network

                        Traffic Flow Rules:
                        - Outside to DMZ: Limited access to specific services (e.g., port 443 to web server)
                        - DMZ to Inside: Highly restricted or denied entirely
                        - Inside to DMZ: Permitted for management and updates
                        - Inside to Outside: Permitted with content filtering
                        - Outside to Inside: Denied (this is the primary protection)
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fw_ie_5",
                                type: .multipleChoice,
                                prompt: "Which traffic flow should typically be DENIED in a DMZ architecture?",
                                correctAnswer: "DMZ to Inside network",
                                options: ["Inside to DMZ", "Outside to DMZ services", "DMZ to Inside network", "Inside to Outside"],
                                explanation: "If a DMZ server is compromised, blocking DMZ-to-Inside traffic prevents the attacker from reaching the internal network."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "fw_3_2",
                        heading: "Firewall Misconfigurations & Best Practices",
                        content: """
                        Common Firewall Misconfigurations:

                        1. Overly Permissive Rules: Using "permit any any" rules defeats the purpose of the firewall entirely.

                        2. Wrong Rule Order: Since rules are processed top-to-bottom, a broad permit rule placed before a specific deny rule will override the denial.

                        3. No Logging: Without logging, you cannot detect attacks or troubleshoot connectivity issues.

                        4. Stale Rules: Old rules for decommissioned servers or services create unnecessary attack surface.

                        5. No Outbound Filtering: Only filtering inbound traffic allows malware to communicate out to command-and-control servers.

                        Best Practices:
                        - Start with default deny and add specific permit rules
                        - Review and audit rules quarterly
                        - Enable logging on all deny rules at minimum
                        - Document the business purpose of every rule
                        - Use time-based rules for temporary access
                        - Implement both inbound and outbound filtering
                        - Test rule changes in a staging environment first
                        - Use named ACLs for readability
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "fw_ie_6",
                                type: .trueFalse,
                                prompt: "In a firewall rule set, the order of rules does not matter because all rules are evaluated.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Firewall rules are processed top-to-bottom, and the FIRST matching rule wins. Order is critical."
                            ),
                            InteractiveElement(
                                id: "fw_ie_7",
                                type: .multipleChoice,
                                prompt: "Why is outbound filtering important on a firewall?",
                                correctAnswer: "To prevent malware from communicating with external command-and-control servers",
                                options: ["To speed up the internet connection", "To prevent malware from communicating with external command-and-control servers", "To block employees from working remotely", "Outbound filtering is not necessary"],
                                explanation: "Outbound filtering prevents compromised devices from sending data to attackers or receiving commands."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_firewall",
            title: "Firewalls & ACLs Assessment",
            questions: [
                QuizQuestion(id: "fwq_1", question: "What is the primary purpose of a firewall?", options: ["Speed up network traffic", "Monitor and control traffic based on security rules", "Assign IP addresses to devices", "Connect wireless devices"], correctAnswerIndex: 1, explanation: "Firewalls monitor incoming and outgoing traffic and enforce security policies through rules.", difficulty: .beginner),
                QuizQuestion(id: "fwq_2", question: "Which type of firewall tracks the state of active connections?", options: ["Packet filtering", "Stateful inspection", "Application proxy", "Circuit-level gateway"], correctAnswerIndex: 1, explanation: "Stateful firewalls maintain a state table to track active connections and detect out-of-state packets.", difficulty: .beginner),
                QuizQuestion(id: "fwq_3", question: "What does a 'default deny' policy mean?", options: ["All traffic is allowed unless specifically blocked", "All traffic is blocked unless specifically permitted", "The firewall is turned off by default", "Only DNS traffic is allowed"], correctAnswerIndex: 1, explanation: "Default deny blocks everything, requiring explicit permit rules for each allowed traffic type.", difficulty: .beginner),
                QuizQuestion(id: "fwq_4", question: "What is the numbered range for Extended ACLs on Cisco devices?", options: ["1-99", "100-199", "200-299", "300-399"], correctAnswerIndex: 1, explanation: "Extended ACLs use numbers 100-199 and can filter by source, destination, protocol, and port.", difficulty: .intermediate),
                QuizQuestion(id: "fwq_5", question: "Where should an Extended ACL be placed?", options: ["Close to the destination", "Close to the source", "On the internet router only", "On every device in the network"], correctAnswerIndex: 1, explanation: "Extended ACLs should be placed close to the source to block unwanted traffic as early as possible.", difficulty: .intermediate),
                QuizQuestion(id: "fwq_6", question: "What is a DMZ in network security?", options: ["A disabled management zone", "A network segment between internal and external networks for public services", "A type of VPN tunnel", "An encryption standard"], correctAnswerIndex: 1, explanation: "A DMZ hosts public-facing services while protecting the internal network from direct external access.", difficulty: .intermediate),
                QuizQuestion(id: "fwq_7", question: "What happens to traffic that doesn't match any ACL rule?", options: ["It is permitted by default", "It is dropped by the implicit deny", "It is logged and forwarded", "It triggers an alert"], correctAnswerIndex: 1, explanation: "Every ACL has an implicit 'deny all' at the end. Unmatched traffic is silently dropped.", difficulty: .intermediate),
                QuizQuestion(id: "fwq_8", question: "In a wildcard mask, what does 0.0.0.255 represent?", options: ["Match exactly one host", "Match any host in a /24 subnet", "Match any address", "Block all traffic"], correctAnswerIndex: 1, explanation: "0.0.0.255 means the first three octets must match and the last octet can be anything (a /24 network).", difficulty: .advanced),
                QuizQuestion(id: "fwq_9", question: "Why should firewall rules be audited regularly?", options: ["To make the firewall faster", "To remove stale rules for decommissioned services", "To reset the firewall", "Auditing is not necessary"], correctAnswerIndex: 1, explanation: "Stale rules create unnecessary attack surface. Regular audits ensure only current, needed rules remain.", difficulty: .intermediate),
                QuizQuestion(id: "fwq_10", question: "What is the most secure DMZ architecture?", options: ["Single firewall with one interface", "No firewall needed", "Dual firewall creating a buffer zone", "Direct connection to internet"], correctAnswerIndex: 2, explanation: "Dual firewall architecture provides defense in depth - compromising one firewall doesn't expose the internal network.", difficulty: .advanced)
            ]
        )
    )

    // MARK: - Module 6: Wireless Network Security

    static let wirelessSecurityModule = LearningModule(
        id: "wireless_security",
        title: "Wireless Network Security",
        description: "Secure wireless networks by understanding Wi-Fi protocols, common attacks, and enterprise security solutions.",
        icon: "wifi.exclamationmark",
        color: "wirelessCyan",
        lessons: [
            Lesson(
                id: "wl_lesson_1",
                title: "Wireless Fundamentals",
                sections: [
                    LessonSection(
                        id: "wl_1_1",
                        heading: "How Wi-Fi Works",
                        content: """
                        Wireless networking (Wi-Fi) uses radio waves to transmit data between devices and access points. Understanding the fundamentals is essential for securing these networks.

                        IEEE 802.11 Standards:
                        - 802.11a: 5 GHz, up to 54 Mbps (older, less interference)
                        - 802.11b/g: 2.4 GHz, up to 11/54 Mbps (longer range, more interference)
                        - 802.11n (Wi-Fi 4): Dual-band, up to 600 Mbps (introduced MIMO)
                        - 802.11ac (Wi-Fi 5): 5 GHz, up to 3.5 Gbps (beamforming, wider channels)
                        - 802.11ax (Wi-Fi 6): Dual-band, up to 9.6 Gbps (OFDMA, improved density handling)

                        Frequency Bands:
                        - 2.4 GHz: Longer range, better wall penetration, only 3 non-overlapping channels (1, 6, 11), more crowded
                        - 5 GHz: Shorter range, less interference, more available channels, faster speeds
                        - 6 GHz (Wi-Fi 6E): Even more channels, lowest interference, newest devices only

                        Key Components:
                        - Access Point (AP): The wireless radio that connects clients to the wired network
                        - SSID: The network name broadcast by the AP
                        - BSSID: The MAC address of the access point radio
                        - Channel: The specific frequency the AP operates on
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "wl_ie_1",
                                type: .multipleChoice,
                                prompt: "Which frequency band has longer range but more interference?",
                                correctAnswer: "2.4 GHz",
                                options: ["2.4 GHz", "5 GHz", "6 GHz", "900 MHz"],
                                explanation: "2.4 GHz has longer range and better wall penetration but is more crowded with only 3 non-overlapping channels."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "wl_1_2",
                        heading: "Authentication & Encryption",
                        content: """
                        Wi-Fi security has evolved significantly over the years. Understanding each generation helps you appreciate why modern standards exist.

                        WEP (Wired Equivalent Privacy) - BROKEN:
                        - The original Wi-Fi security standard from 1997
                        - Uses RC4 encryption with static keys
                        - Can be cracked in minutes with freely available tools
                        - Should NEVER be used under any circumstances

                        WPA (Wi-Fi Protected Access) - DEPRECATED:
                        - Temporary fix for WEP using TKIP encryption
                        - Improved key management but still has vulnerabilities
                        - No longer considered secure

                        WPA2 (Wi-Fi Protected Access 2) - CURRENT STANDARD:
                        - Uses AES-CCMP encryption (much stronger than TKIP)
                        - Personal mode (PSK): Uses a shared passphrase for home and small office
                        - Enterprise mode (802.1X): Uses individual credentials via RADIUS server
                        - Vulnerable to offline dictionary attacks against weak passphrases

                        WPA3 (Wi-Fi Protected Access 3) - LATEST:
                        - Uses SAE (Simultaneous Authentication of Equals) replacing PSK
                        - Resistant to offline dictionary attacks
                        - Forward secrecy: Past traffic cannot be decrypted even if key is later compromised
                        - Required on all new Wi-Fi certified devices since 2020
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "wl_ie_2",
                                type: .multipleChoice,
                                prompt: "Which Wi-Fi security protocol is considered broken and should never be used?",
                                correctAnswer: "WEP",
                                options: ["WEP", "WPA2", "WPA3", "AES"],
                                explanation: "WEP uses weak RC4 encryption with static keys and can be cracked in minutes. Never use WEP."
                            ),
                            InteractiveElement(
                                id: "wl_ie_3",
                                type: .fillInBlank,
                                prompt: "WPA2 uses _____ encryption, which is much stronger than the older TKIP used by WPA.",
                                correctAnswer: "AES",
                                options: nil,
                                explanation: "AES (Advanced Encryption Standard) with CCMP provides strong encryption for WPA2 wireless networks."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "wl_lesson_2",
                title: "Wireless Threats & Attacks",
                sections: [
                    LessonSection(
                        id: "wl_2_1",
                        heading: "Common Wireless Attacks",
                        content: """
                        Wireless networks are uniquely vulnerable because the signal travels through the air and can be intercepted by anyone within range.

                        Evil Twin Attack:
                        - An attacker creates a fake access point with the same SSID as a legitimate network
                        - Victims connect to the fake AP thinking it is the real one
                        - All traffic passes through the attacker, who can capture credentials, inject malware, or modify data
                        - Defense: Use 802.1X authentication and verify certificates

                        Deauthentication Attack:
                        - The attacker sends forged deauthentication frames to disconnect clients from the real AP
                        - Clients then reconnect, potentially to an evil twin
                        - Can also be used as a denial-of-service attack
                        - Defense: Use 802.11w (Management Frame Protection)

                        WPS Cracking:
                        - Wi-Fi Protected Setup (WPS) uses an 8-digit PIN for easy device connection
                        - The PIN can be brute-forced in hours because it is checked in two halves
                        - Gives the attacker the full WPA2 passphrase
                        - Defense: Disable WPS entirely on all access points

                        Packet Sniffing:
                        - Wireless traffic can be captured by any device in range using monitor mode
                        - Unencrypted traffic (HTTP, Telnet) is readable in plain text
                        - Even encrypted traffic metadata (who is talking to whom) is visible
                        - Defense: Use WPA2/WPA3 encryption and HTTPS for all web traffic
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "wl_ie_4",
                                type: .multipleChoice,
                                prompt: "In an Evil Twin attack, what does the attacker create?",
                                correctAnswer: "A fake access point with the same SSID as a legitimate network",
                                options: ["A copy of the victim's device", "A fake access point with the same SSID as a legitimate network", "A wired network tap", "A rogue DHCP server"],
                                explanation: "Evil Twin attacks use a fake AP with a matching SSID to trick victims into connecting through the attacker."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "wl_2_2",
                        heading: "Rogue Access Points & MITM",
                        content: """
                        Rogue access points are unauthorized wireless devices connected to your network. They represent one of the most dangerous threats to enterprise wireless security.

                        Rogue Access Points:
                        - An employee plugs a personal Wi-Fi router into a network jack for convenience
                        - This creates an uncontrolled entry point that bypasses all firewall and security policies
                        - Attackers can also plant rogue APs to gain persistent network access
                        - Even well-meaning rogue APs often have no encryption or weak passwords

                        Man-in-the-Middle (MITM):
                        - The attacker positions themselves between the victim and the network
                        - All traffic flows through the attacker's device
                        - They can read, modify, or inject data into the communication
                        - Common techniques: ARP poisoning combined with evil twin, SSL stripping

                        Detection and Prevention:
                        - Wireless Intrusion Prevention Systems (WIPS) scan for unauthorized APs
                        - 802.1X port authentication prevents unauthorized devices from connecting to wired ports
                        - Regular wireless surveys identify unknown access points
                        - Network Access Control (NAC) solutions verify device compliance before granting access
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "wl_ie_5",
                                type: .trueFalse,
                                prompt: "A rogue access point is only dangerous if it was planted by an attacker intentionally.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Even well-meaning rogue APs (like an employee's personal router) bypass security controls and create vulnerabilities."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "wl_lesson_3",
                title: "Securing Wireless Networks",
                sections: [
                    LessonSection(
                        id: "wl_3_1",
                        heading: "Enterprise Wi-Fi (802.1X/RADIUS)",
                        content: """
                        Enterprise wireless security goes beyond simple passphrases by using individual authentication for every user.

                        802.1X Authentication:
                        - Each user authenticates with unique credentials (username/password, certificate, or smart card)
                        - The access point acts as an authenticator, forwarding credentials to a RADIUS server
                        - The RADIUS server verifies credentials against a directory (Active Directory, LDAP)
                        - Upon successful authentication, the user receives a unique encryption key

                        Components:
                        - Supplicant: The client device requesting access
                        - Authenticator: The access point that controls access
                        - Authentication Server: The RADIUS server that verifies credentials

                        EAP Methods (Extensible Authentication Protocol):
                        - EAP-TLS: Certificate-based, most secure, requires certificates on both client and server
                        - PEAP: Password-based, wraps authentication in a TLS tunnel, easier to deploy
                        - EAP-TTLS: Similar to PEAP, supports more inner authentication methods

                        Benefits over PSK:
                        - Individual accountability (every connection is tied to a user)
                        - Unique encryption keys per session
                        - Instant revocation when an employee leaves
                        - No shared password that could be leaked
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "wl_ie_6",
                                type: .fillInBlank,
                                prompt: "In enterprise Wi-Fi, the _____ server verifies user credentials before granting network access.",
                                correctAnswer: "RADIUS",
                                options: nil,
                                explanation: "RADIUS (Remote Authentication Dial-In User Service) centralizes authentication for enterprise wireless networks."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "wl_3_2",
                        heading: "Wireless Security Best Practices",
                        content: """
                        Implement these best practices to secure your wireless infrastructure:

                        Encryption & Authentication:
                        - Use WPA3 where supported, WPA2-Enterprise as minimum
                        - Never use WEP or open (unencrypted) networks
                        - Implement 802.1X for enterprise environments
                        - Use strong, unique passphrases (20+ characters) for PSK networks

                        Access Point Configuration:
                        - Change default admin credentials on all APs
                        - Disable WPS on every access point
                        - Enable Management Frame Protection (802.11w)
                        - Use separate SSIDs for corporate and guest traffic
                        - Place guest networks in an isolated VLAN with internet-only access

                        Monitoring & Maintenance:
                        - Deploy Wireless IPS to detect rogue APs and attacks
                        - Conduct regular wireless security assessments
                        - Keep AP firmware updated
                        - Monitor for deauthentication floods and unusual client behavior
                        - Use channel planning to minimize interference and maximize coverage

                        Physical Security:
                        - Mount APs in secure locations to prevent tampering
                        - Limit signal strength to reduce coverage outside your building
                        - Use directional antennas where appropriate
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "wl_ie_7",
                                type: .multipleChoice,
                                prompt: "What should be done with guest wireless traffic?",
                                correctAnswer: "Isolate it in a separate VLAN with internet-only access",
                                options: ["Allow it on the same network as corporate devices", "Block all guest access entirely", "Isolate it in a separate VLAN with internet-only access", "Give guests the corporate Wi-Fi password"],
                                explanation: "Guest traffic should be isolated to prevent unauthorized access to internal resources while still providing internet connectivity."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_wireless",
            title: "Wireless Security Assessment",
            questions: [
                QuizQuestion(id: "wq_1", question: "Which Wi-Fi security protocol should never be used?", options: ["WPA2", "WPA3", "WEP", "AES"], correctAnswerIndex: 2, explanation: "WEP is fundamentally broken and can be cracked in minutes. It should never be used.", difficulty: .beginner),
                QuizQuestion(id: "wq_2", question: "What does SSID stand for?", options: ["Secure Signal Identification Device", "Service Set Identifier", "System Security ID", "Standard Signal Interface Data"], correctAnswerIndex: 1, explanation: "SSID (Service Set Identifier) is the human-readable name of a wireless network.", difficulty: .beginner),
                QuizQuestion(id: "wq_3", question: "Which frequency band offers more channels and less interference?", options: ["2.4 GHz", "5 GHz", "900 MHz", "Both bands are equal"], correctAnswerIndex: 1, explanation: "The 5 GHz band has more non-overlapping channels and is less crowded than 2.4 GHz.", difficulty: .beginner),
                QuizQuestion(id: "wq_4", question: "What is an Evil Twin attack?", options: ["A virus that duplicates itself", "A fake AP mimicking a legitimate network", "A brute force password attack", "A physical device clone"], correctAnswerIndex: 1, explanation: "Evil Twin attacks use a fake access point with the same SSID to intercept victim traffic.", difficulty: .intermediate),
                QuizQuestion(id: "wq_5", question: "Why should WPS be disabled on all access points?", options: ["It slows down the network", "Its PIN can be brute-forced to reveal the Wi-Fi password", "It uses too much power", "It conflicts with DHCP"], correctAnswerIndex: 1, explanation: "WPS uses an 8-digit PIN checked in halves, making it vulnerable to brute-force attacks in hours.", difficulty: .intermediate),
                QuizQuestion(id: "wq_6", question: "What authentication server is used in enterprise Wi-Fi (802.1X)?", options: ["DNS server", "DHCP server", "RADIUS server", "Web server"], correctAnswerIndex: 2, explanation: "RADIUS servers centralize authentication for 802.1X, verifying credentials against a user directory.", difficulty: .intermediate),
                QuizQuestion(id: "wq_7", question: "What is the main advantage of WPA3 over WPA2?", options: ["Faster speeds", "Resistance to offline dictionary attacks", "Longer range", "More device compatibility"], correctAnswerIndex: 1, explanation: "WPA3 uses SAE which prevents offline dictionary attacks and provides forward secrecy.", difficulty: .intermediate),
                QuizQuestion(id: "wq_8", question: "What is a rogue access point?", options: ["An AP with a strong signal", "An unauthorized AP connected to the network", "A mobile hotspot", "An AP running WPA3"], correctAnswerIndex: 1, explanation: "Rogue APs are unauthorized wireless devices that bypass security controls, whether planted maliciously or by employees.", difficulty: .intermediate),
                QuizQuestion(id: "wq_9", question: "Which EAP method is considered the most secure for enterprise Wi-Fi?", options: ["EAP-MD5", "EAP-TLS", "PEAP", "LEAP"], correctAnswerIndex: 1, explanation: "EAP-TLS uses certificate-based authentication on both client and server, providing the strongest security.", difficulty: .advanced),
                QuizQuestion(id: "wq_10", question: "What does 802.11w protect against?", options: ["Slow internet speeds", "Deauthentication and management frame attacks", "DNS poisoning", "Buffer overflow"], correctAnswerIndex: 1, explanation: "802.11w (Management Frame Protection) prevents attackers from forging deauthentication and disassociation frames.", difficulty: .advanced)
            ]
        )
    )

    // MARK: - Module 7: Network Monitoring & Troubleshooting

    static let networkMonitoringModule = LearningModule(
        id: "network_monitoring",
        title: "Network Monitoring & Troubleshooting",
        description: "Monitor network health, analyze traffic with industry tools, and systematically troubleshoot common issues.",
        icon: "chart.line.uptrend.xyaxis",
        color: "monitorTeal",
        lessons: [
            Lesson(
                id: "nm_lesson_1",
                title: "Why Monitor Your Network?",
                sections: [
                    LessonSection(
                        id: "nm_1_1",
                        heading: "The Need for Visibility",
                        content: """
                        You cannot secure or fix what you cannot see. Network monitoring provides the visibility needed to maintain performance, detect threats, and plan capacity.

                        Why Monitoring Matters:
                        - Performance Management: Identify bottlenecks before users complain
                        - Security Detection: Spot unusual traffic patterns that indicate attacks or breaches
                        - Capacity Planning: Track growth trends to plan upgrades proactively
                        - Compliance: Many regulations require network activity logging and monitoring
                        - Troubleshooting: Historical data helps pinpoint when and where problems started

                        Without Monitoring:
                        - Problems are only discovered when users report them
                        - Security breaches may go undetected for months
                        - Capacity issues cause sudden, unexpected outages
                        - Troubleshooting becomes guesswork without baseline data
                        - No evidence for compliance audits

                        The goal is to shift from reactive (fixing problems after they happen) to proactive (preventing problems before they impact users).
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "nm_ie_1",
                                type: .multipleChoice,
                                prompt: "What is the main goal of network monitoring?",
                                correctAnswer: "Shift from reactive to proactive network management",
                                options: ["Increase internet speed", "Shift from reactive to proactive network management", "Replace the need for firewalls", "Eliminate the need for backups"],
                                explanation: "Monitoring enables proactive management by providing visibility into network health before problems impact users."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "nm_1_2",
                        heading: "Key Network Metrics",
                        content: """
                        Effective monitoring tracks several critical metrics that indicate network health:

                        Bandwidth Utilization:
                        - The percentage of available network capacity being used
                        - Consistently above 70% indicates a need for upgrades
                        - Sudden spikes may indicate attacks or misconfigured devices

                        Latency:
                        - The time it takes for a packet to travel from source to destination
                        - Measured in milliseconds (ms)
                        - Acceptable latency varies by application: web browsing tolerates 100ms, VoIP needs under 150ms, real-time gaming needs under 50ms

                        Jitter:
                        - The variation in latency over time
                        - High jitter causes choppy voice calls and video stuttering
                        - Should be under 30ms for acceptable voice quality

                        Packet Loss:
                        - The percentage of packets that fail to reach their destination
                        - Even 1% packet loss can cause noticeable quality degradation
                        - Caused by congestion, hardware failures, or misconfiguration
                        - TCP retransmits lost packets (adding delay); UDP just loses them

                        Uptime/Availability:
                        - The percentage of time a device or service is operational
                        - "Five nines" (99.999%) means only 5.26 minutes of downtime per year
                        - Track per-device and per-service availability
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "nm_ie_2",
                                type: .fillInBlank,
                                prompt: "The variation in latency over time is called _____.",
                                correctAnswer: "jitter",
                                options: nil,
                                explanation: "Jitter measures how much latency fluctuates. High jitter is especially problematic for real-time applications like VoIP."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "nm_lesson_2",
                title: "Monitoring Tools & Protocols",
                sections: [
                    LessonSection(
                        id: "nm_2_1",
                        heading: "SNMP & Syslog",
                        content: """
                        Two foundational protocols power most network monitoring systems:

                        SNMP (Simple Network Management Protocol):
                        - Allows monitoring tools to query devices for status information
                        - Uses a manager-agent model: the monitoring server (manager) polls network devices (agents)
                        - MIBs (Management Information Bases) define what data is available on each device
                        - Versions: SNMPv1/v2c use community strings (essentially passwords in plain text); SNMPv3 adds encryption and authentication
                        - Always use SNMPv3 in production for security

                        SNMP Operations:
                        - GET: Retrieve a specific value from a device
                        - SET: Change a configuration value on a device
                        - TRAP: Device proactively sends an alert to the manager when something happens
                        - WALK: Retrieve a range of values from a device's MIB

                        Syslog:
                        - A standard protocol for sending log messages to a central server
                        - Devices send logs about events: logins, configuration changes, errors, warnings
                        - Severity levels from 0 (Emergency) to 7 (Debug)
                        - Critical for security auditing and troubleshooting
                        - Use TLS-encrypted syslog (TCP/6514) to protect log data in transit
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "nm_ie_3",
                                type: .multipleChoice,
                                prompt: "Which SNMP version should be used in production environments?",
                                correctAnswer: "SNMPv3",
                                options: ["SNMPv1", "SNMPv2c", "SNMPv3", "Any version is equally secure"],
                                explanation: "SNMPv3 is the only version that provides encryption and strong authentication. v1/v2c send data in plain text."
                            ),
                            InteractiveElement(
                                id: "nm_ie_4",
                                type: .trueFalse,
                                prompt: "An SNMP TRAP is sent from the monitoring server to the network device.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "A TRAP is sent FROM the network device TO the monitoring server to alert about an event, like an interface going down."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "nm_2_2",
                        heading: "Packet Capture & Analysis",
                        content: """
                        When monitoring tools show a problem, packet capture lets you see exactly what is happening on the wire.

                        Wireshark:
                        - The most widely used network protocol analyzer
                        - Captures packets in real-time and displays them in a human-readable format
                        - Powerful display filters: filter by IP, protocol, port, or content
                        - Can follow TCP streams to reconstruct entire conversations
                        - Exports captures in pcap format for sharing and analysis

                        Common Wireshark Use Cases:
                        - Diagnosing slow application performance
                        - Identifying unauthorized or suspicious traffic
                        - Verifying firewall rules are working correctly
                        - Analyzing protocol behavior for troubleshooting
                        - Capturing evidence of security incidents

                        tcpdump:
                        - Command-line packet capture tool available on Linux and macOS
                        - Lightweight and available on most servers and network devices
                        - Can capture traffic and save to pcap files for Wireshark analysis
                        - Example: tcpdump -i eth0 -w capture.pcap port 80

                        NetFlow/sFlow:
                        - Summarizes traffic flows rather than capturing every packet
                        - Shows who is talking to whom, on what ports, and how much data
                        - Ideal for bandwidth analysis and detecting anomalies
                        - Less resource-intensive than full packet capture
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "nm_ie_5",
                                type: .multipleChoice,
                                prompt: "What is the main advantage of NetFlow over full packet capture?",
                                correctAnswer: "It summarizes traffic patterns with less resource usage",
                                options: ["It captures more data", "It summarizes traffic patterns with less resource usage", "It works without a network connection", "It replaces the need for firewalls"],
                                explanation: "NetFlow summarizes traffic flows (source, destination, ports, bytes) without storing every packet, making it efficient for analysis."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "nm_lesson_3",
                title: "Troubleshooting Methodology",
                sections: [
                    LessonSection(
                        id: "nm_3_1",
                        heading: "Systematic Troubleshooting",
                        content: """
                        Effective network troubleshooting follows a systematic approach rather than random guessing. The OSI model provides an excellent framework.

                        Bottom-Up Approach (Physical to Application):
                        - Layer 1 (Physical): Check cables, link lights, power. Is the device physically connected?
                        - Layer 2 (Data Link): Check MAC address tables, VLAN assignments, STP status. Can the device communicate locally?
                        - Layer 3 (Network): Check IP configuration, routing tables, ping tests. Can the device reach other networks?
                        - Layer 4 (Transport): Check port connectivity with telnet/netcat. Are the right ports open?
                        - Layer 7 (Application): Check service configuration, DNS resolution, application logs. Is the application working?

                        Troubleshooting Steps:
                        1. Identify the problem: Gather symptoms, determine scope (one user or many?)
                        2. Establish a theory: What could cause these symptoms?
                        3. Test the theory: Use tools to verify or disprove
                        4. Create an action plan: Determine the fix and assess impact
                        5. Implement the fix: Make the change with a rollback plan
                        6. Verify full functionality: Confirm the problem is resolved
                        7. Document the solution: Record what happened and how it was fixed

                        Essential Commands:
                        - ping: Test Layer 3 connectivity
                        - traceroute/tracert: Show the path packets take to a destination
                        - nslookup/dig: Test DNS resolution
                        - ipconfig/ifconfig: View local IP configuration
                        - arp -a: View the local ARP cache (IP-to-MAC mappings)
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "nm_ie_6",
                                type: .multipleChoice,
                                prompt: "Which OSI layer should you check FIRST when troubleshooting?",
                                correctAnswer: "Layer 1 - Physical",
                                options: ["Layer 7 - Application", "Layer 4 - Transport", "Layer 3 - Network", "Layer 1 - Physical"],
                                explanation: "The bottom-up approach starts at Layer 1 (Physical) - check cables, power, and link lights before anything else."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "nm_3_2",
                        heading: "Common Network Issues & Fixes",
                        content: """
                        Here are the most common network problems you will encounter and how to resolve them:

                        IP Address Conflicts:
                        - Symptom: Intermittent connectivity, duplicate IP warnings
                        - Cause: Two devices assigned the same IP address (often manual/static conflicts with DHCP)
                        - Fix: Use DHCP for automatic assignment, reserve static IPs outside the DHCP range

                        DNS Resolution Failures:
                        - Symptom: Cannot reach websites by name, but can ping by IP
                        - Cause: DNS server misconfiguration, DNS server down, or incorrect client DNS settings
                        - Fix: Verify DNS server settings, test with nslookup, try alternate DNS (8.8.8.8)

                        Duplex Mismatch:
                        - Symptom: Slow performance, high collision counts, CRC errors on interface
                        - Cause: One end set to full-duplex and the other to half-duplex
                        - Fix: Set both ends to auto-negotiate or manually match duplex settings

                        Broadcast Storms:
                        - Symptom: Network completely unresponsive, high CPU on switches
                        - Cause: Layer 2 loop due to STP failure or misconfiguration
                        - Fix: Enable STP, add storm control, check for unauthorized switch connections

                        VLAN Mismatch:
                        - Symptom: Devices on the same switch cannot communicate
                        - Cause: Devices assigned to different VLANs or trunk link not carrying the needed VLAN
                        - Fix: Verify VLAN assignments with show vlan brief, check trunk allowed VLANs
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "nm_ie_7",
                                type: .trueFalse,
                                prompt: "If you can ping an IP address but cannot access a website by name, the issue is likely at Layer 1 (Physical).",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "If ping works but name resolution fails, the issue is DNS (a higher-layer service), not the physical connection."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_monitoring",
            title: "Network Monitoring Assessment",
            questions: [
                QuizQuestion(id: "nmq_1", question: "What metric measures the variation in network latency?", options: ["Bandwidth", "Jitter", "Packet loss", "Throughput"], correctAnswerIndex: 1, explanation: "Jitter is the variation in latency. High jitter causes quality problems for real-time applications.", difficulty: .beginner),
                QuizQuestion(id: "nmq_2", question: "What does SNMP stand for?", options: ["Simple Network Management Protocol", "Secure Network Monitoring Platform", "System Node Management Process", "Standard Network Metric Protocol"], correctAnswerIndex: 0, explanation: "SNMP (Simple Network Management Protocol) enables monitoring tools to query and manage network devices.", difficulty: .beginner),
                QuizQuestion(id: "nmq_3", question: "What tool is most commonly used for packet capture and analysis?", options: ["Microsoft Excel", "Wireshark", "Notepad", "Calculator"], correctAnswerIndex: 1, explanation: "Wireshark is the industry-standard network protocol analyzer for capturing and inspecting network traffic.", difficulty: .beginner),
                QuizQuestion(id: "nmq_4", question: "Which SNMP operation allows a device to proactively alert the monitoring server?", options: ["GET", "SET", "TRAP", "WALK"], correctAnswerIndex: 2, explanation: "SNMP TRAPs are sent from devices to the monitoring server to report events like interface failures.", difficulty: .intermediate),
                QuizQuestion(id: "nmq_5", question: "If you can ping an IP but can't access the website by name, what is likely failing?", options: ["Physical cable", "Switch port", "DNS resolution", "Firewall"], correctAnswerIndex: 2, explanation: "Successful ping means connectivity works. Failure by name indicates DNS is not resolving the hostname.", difficulty: .intermediate),
                QuizQuestion(id: "nmq_6", question: "What causes a broadcast storm?", options: ["Too many DNS queries", "A Layer 2 loop without STP", "High bandwidth usage", "Slow DNS server"], correctAnswerIndex: 1, explanation: "Without STP, redundant paths create loops where broadcast frames circulate endlessly, overwhelming the network.", difficulty: .intermediate),
                QuizQuestion(id: "nmq_7", question: "When troubleshooting with the OSI model, which layer should you check first?", options: ["Application", "Transport", "Network", "Physical"], correctAnswerIndex: 3, explanation: "The bottom-up approach starts at the Physical layer - verify cables, power, and link lights first.", difficulty: .intermediate),
                QuizQuestion(id: "nmq_8", question: "What is the advantage of NetFlow over full packet capture?", options: ["More detailed data", "Lower resource usage while summarizing traffic patterns", "Works without network devices", "Captures encrypted data"], correctAnswerIndex: 1, explanation: "NetFlow summarizes traffic metadata (source, destination, ports, bytes) without the overhead of storing every packet.", difficulty: .advanced)
            ]
        )
    )

    // MARK: - Module 8: VPNs & Secure Remote Access

    static let vpnModule = LearningModule(
        id: "vpn_remote",
        title: "VPNs & Secure Remote Access",
        description: "Understand how VPNs create encrypted tunnels to protect data in transit and enable secure remote connectivity.",
        icon: "lock.shield.fill",
        color: "vpnIndigo",
        lessons: [
            Lesson(
                id: "vpn_lesson_1",
                title: "What is a VPN?",
                sections: [
                    LessonSection(
                        id: "vpn_1_1",
                        heading: "How VPNs Work",
                        content: """
                        A Virtual Private Network (VPN) creates a secure, encrypted connection over a public network such as the internet. It allows users and offices to communicate as if they were on the same private network, even when separated by thousands of miles.

                        Core VPN Concepts:

                        Tunneling: VPN data is encapsulated inside another protocol for transport. The original packet is wrapped in a new header, encrypted, and sent through the tunnel. At the other end, the outer header is removed and the original packet is decrypted.

                        Encryption: Data traveling through the VPN tunnel is encrypted, making it unreadable to anyone who intercepts it. Common encryption algorithms include AES-128, AES-256, and ChaCha20.

                        Authentication: Both endpoints must verify each other's identity before establishing the tunnel. This can use pre-shared keys, digital certificates, or username/password with multi-factor authentication.

                        Without a VPN, data sent over public Wi-Fi or the internet can be intercepted by attackers using packet sniffing tools. VPNs eliminate this risk by encrypting everything inside the tunnel.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "vpn_ie_1",
                                type: .multipleChoice,
                                prompt: "What does tunneling do in a VPN?",
                                correctAnswer: "Encapsulates and encrypts data inside another protocol for secure transport",
                                options: ["Increases internet speed by compressing data", "Encapsulates and encrypts data inside another protocol for secure transport", "Creates a physical cable between two locations", "Blocks all incoming traffic"],
                                explanation: "VPN tunneling wraps original packets in encrypted outer packets, creating a secure path through untrusted networks."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "vpn_1_2",
                        heading: "Types of VPNs",
                        content: """
                        Different VPN types serve different use cases:

                        Site-to-Site VPN:
                        - Connects two entire networks (e.g., headquarters to branch office)
                        - Runs between routers or firewalls at each location
                        - Always-on connection that's transparent to end users
                        - All traffic between sites is automatically encrypted
                        - Common in enterprises with multiple office locations

                        Remote Access VPN:
                        - Connects individual users to a corporate network from anywhere
                        - Requires VPN client software on the user's device
                        - User initiates the connection when needed
                        - Essential for remote workers, traveling employees, and contractors
                        - Examples: Cisco AnyConnect, GlobalProtect, OpenVPN

                        Client-to-Site VPN:
                        - A subset of remote access where the client connects to a VPN gateway
                        - The gateway provides access to resources behind the corporate firewall
                        - Can enforce policies like MFA, device compliance, and split tunneling

                        Cloud VPN:
                        - Connects on-premises networks to cloud providers (AWS, Azure, GCP)
                        - Uses the cloud provider's VPN gateway service
                        - Enables hybrid cloud architectures securely
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "vpn_ie_2",
                                type: .trueFalse,
                                prompt: "A site-to-site VPN requires each individual user to install VPN client software.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Site-to-site VPNs run between network devices (routers/firewalls) and are transparent to end users. No client software is needed."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "vpn_lesson_2",
                title: "VPN Protocols & Technologies",
                sections: [
                    LessonSection(
                        id: "vpn_2_1",
                        heading: "IPsec VPN",
                        content: """
                        IPsec (Internet Protocol Security) is the most widely deployed VPN protocol suite for site-to-site connections. It operates at Layer 3 and provides both encryption and authentication.

                        IPsec Components:

                        AH (Authentication Header):
                        - Provides data integrity and authentication
                        - Does NOT encrypt the payload
                        - Verifies that packets haven't been tampered with
                        - Rarely used alone in modern deployments

                        ESP (Encapsulating Security Payload):
                        - Provides encryption, authentication, and integrity
                        - The most commonly used IPsec protocol
                        - Can operate in Transport Mode (encrypts payload only) or Tunnel Mode (encrypts entire original packet)

                        IKE (Internet Key Exchange):
                        - Negotiates the security parameters between VPN endpoints
                        - Phase 1: Establishes a secure management channel (ISAKMP SA)
                        - Phase 2: Negotiates the actual IPsec tunnel parameters (IPsec SA)
                        - IKEv2 is the current standard, faster and more reliable than IKEv1

                        IPsec is considered the gold standard for site-to-site VPNs due to its strong security, broad vendor support, and proven track record.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "vpn_ie_3",
                                type: .fillInBlank,
                                prompt: "IPsec uses _____ to negotiate security parameters and establish the VPN tunnel.",
                                correctAnswer: "IKE",
                                options: nil,
                                explanation: "IKE (Internet Key Exchange) handles the negotiation of encryption algorithms, keys, and tunnel parameters between VPN endpoints."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "vpn_2_2",
                        heading: "SSL/TLS VPNs & WireGuard",
                        content: """
                        While IPsec dominates site-to-site VPNs, SSL/TLS VPNs and WireGuard are popular for remote access:

                        SSL/TLS VPN:
                        - Uses the same encryption that secures HTTPS websites
                        - Works through web browsers or lightweight clients
                        - Easier to deploy than IPsec for remote users
                        - Traverses firewalls and NAT easily (uses port 443)
                        - Can provide full tunnel or clientless web portal access
                        - Examples: Cisco AnyConnect, Palo Alto GlobalProtect, OpenVPN

                        WireGuard:
                        - A modern, lightweight VPN protocol
                        - Significantly faster than IPsec and OpenVPN
                        - Uses state-of-the-art cryptography (ChaCha20, Curve25519)
                        - Only about 4,000 lines of code vs. 600,000+ for OpenVPN
                        - Smaller codebase means fewer potential security bugs
                        - Built into the Linux kernel since version 5.6
                        - Growing adoption in enterprise and consumer VPN services

                        Protocol Comparison:
                        - IPsec: Best for site-to-site, strongest enterprise support
                        - SSL/TLS: Best for remote access through firewalls
                        - WireGuard: Best for speed and simplicity, rapidly maturing
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "vpn_ie_4",
                                type: .multipleChoice,
                                prompt: "Which VPN protocol is known for its extremely small codebase and high performance?",
                                correctAnswer: "WireGuard",
                                options: ["IPsec", "PPTP", "WireGuard", "L2TP"],
                                explanation: "WireGuard has only ~4,000 lines of code and uses modern cryptography, making it faster and easier to audit than older protocols."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "vpn_lesson_3",
                title: "Securing Remote Access",
                sections: [
                    LessonSection(
                        id: "vpn_3_1",
                        heading: "Multi-Factor Authentication & Endpoint Security",
                        content: """
                        A VPN is only as secure as its authentication mechanism. Stolen credentials are one of the most common ways attackers gain VPN access, making multi-factor authentication essential.

                        Multi-Factor Authentication (MFA):
                        - Requires two or more verification factors: something you know (password), something you have (phone/token), something you are (biometrics)
                        - Even if credentials are stolen, the attacker can't connect without the second factor
                        - Common MFA methods: push notifications (Duo, Okta), TOTP codes (Google Authenticator), hardware tokens (YubiKey)
                        - MFA should be mandatory for all VPN access, no exceptions

                        Endpoint Security:
                        - The VPN gateway should check the connecting device's security posture
                        - Posture checks may include: antivirus status, OS patch level, disk encryption, firewall status
                        - Non-compliant devices can be quarantined or given limited access
                        - Company-managed devices should be required for access to sensitive resources
                        - Mobile Device Management (MDM) ensures remote devices meet security standards
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "vpn_ie_5",
                                type: .multipleChoice,
                                prompt: "Why is MFA critical for VPN access?",
                                correctAnswer: "It prevents attackers from connecting with just stolen credentials",
                                options: ["It makes the VPN connection faster", "It prevents attackers from connecting with just stolen credentials", "It eliminates the need for encryption", "It reduces bandwidth usage"],
                                explanation: "MFA ensures that even if a password is compromised, the attacker still cannot establish a VPN connection without the additional factor."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "vpn_3_2",
                        heading: "Split Tunneling & VPN Best Practices",
                        content: """
                        Split Tunneling is a VPN configuration that determines which traffic goes through the VPN tunnel and which goes directly to the internet:

                        Full Tunnel:
                        - ALL traffic is routed through the VPN, including personal browsing
                        - Maximum security: all traffic is encrypted and inspected by corporate security tools
                        - Higher latency for non-work traffic
                        - Higher bandwidth consumption on the corporate VPN gateway

                        Split Tunnel:
                        - Only corporate-destined traffic goes through the VPN
                        - Personal browsing, streaming, and other traffic goes directly to the internet
                        - Better performance for the user
                        - Reduces load on the corporate VPN infrastructure
                        - Security risk: the user's device is simultaneously on two networks

                        VPN Best Practices:
                        - Enforce MFA for all VPN connections
                        - Use the strongest available encryption (AES-256, ChaCha20)
                        - Implement always-on VPN for company-managed devices
                        - Monitor VPN logs for unusual connection patterns (time, location, duration)
                        - Limit VPN access to only the resources each user needs (least privilege)
                        - Automatically disconnect idle sessions after a timeout period
                        - Regularly update VPN client and gateway software
                        - Consider Zero Trust Network Access (ZTNA) as a VPN complement or replacement
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "vpn_ie_6",
                                type: .trueFalse,
                                prompt: "Split tunneling routes ALL user traffic through the VPN tunnel for maximum security.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Split tunneling sends only corporate traffic through the VPN. Full tunneling sends all traffic through the VPN for maximum security."
                            ),
                            InteractiveElement(
                                id: "vpn_ie_7",
                                type: .fillInBlank,
                                prompt: "_____ tunnel VPN mode routes all traffic through the corporate VPN for maximum security.",
                                correctAnswer: "Full",
                                options: nil,
                                explanation: "Full tunnel mode sends 100% of traffic through the VPN, ensuring all data is encrypted and can be inspected by corporate security."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_vpn",
            title: "VPN & Remote Access Assessment",
            questions: [
                QuizQuestion(id: "vpnq_1", question: "What does a VPN primarily protect against?", options: ["Hardware failure", "Data interception during transit over public networks", "Power outages", "Disk corruption"], correctAnswerIndex: 1, explanation: "VPNs encrypt data in transit, preventing eavesdropping on public or untrusted networks.", difficulty: .beginner),
                QuizQuestion(id: "vpnq_2", question: "Which VPN type connects two entire office networks together?", options: ["Remote access VPN", "Site-to-site VPN", "Client VPN", "Cloud VPN"], correctAnswerIndex: 1, explanation: "Site-to-site VPNs create a permanent encrypted tunnel between two network locations.", difficulty: .beginner),
                QuizQuestion(id: "vpnq_3", question: "What does IPsec ESP provide?", options: ["Only authentication", "Only encryption", "Encryption, authentication, and integrity", "Only data compression"], correctAnswerIndex: 2, explanation: "ESP (Encapsulating Security Payload) provides all three: encryption, authentication, and data integrity.", difficulty: .intermediate),
                QuizQuestion(id: "vpnq_4", question: "How many phases does IKE use to establish an IPsec tunnel?", options: ["1", "2", "3", "4"], correctAnswerIndex: 1, explanation: "IKE Phase 1 creates a secure management channel, and Phase 2 negotiates the IPsec tunnel parameters.", difficulty: .intermediate),
                QuizQuestion(id: "vpnq_5", question: "Why do SSL/TLS VPNs traverse firewalls more easily than IPsec?", options: ["They use stronger encryption", "They use port 443 which is typically allowed", "They don't require authentication", "They are unencrypted"], correctAnswerIndex: 1, explanation: "SSL/TLS VPNs use port 443 (HTTPS), which is almost always permitted through firewalls.", difficulty: .intermediate),
                QuizQuestion(id: "vpnq_6", question: "What makes WireGuard different from traditional VPN protocols?", options: ["It doesn't encrypt data", "Its extremely small codebase and modern cryptography", "It only works on Windows", "It requires dedicated hardware"], correctAnswerIndex: 1, explanation: "WireGuard has only ~4,000 lines of code with state-of-the-art cryptography, making it faster and more auditable.", difficulty: .intermediate),
                QuizQuestion(id: "vpnq_7", question: "What is the security risk of split tunneling?", options: ["It makes encryption weaker", "The device is on two networks simultaneously, potentially exposing the corporate network", "It prevents MFA from working", "It causes data loss"], correctAnswerIndex: 1, explanation: "Split tunneling means the user's device bridges corporate and public networks, which could allow attacks to traverse the bridge.", difficulty: .advanced),
                QuizQuestion(id: "vpnq_8", question: "Why is MFA essential for VPN access?", options: ["It speeds up the connection", "It prevents access with stolen credentials alone", "It replaces encryption", "It reduces bandwidth"], correctAnswerIndex: 1, explanation: "MFA adds a second verification factor so that stolen passwords alone cannot grant VPN access.", difficulty: .beginner),
                QuizQuestion(id: "vpnq_9", question: "What should a VPN gateway check before allowing a device to connect?", options: ["Screen resolution", "Device security posture (antivirus, patches, encryption)", "Battery level", "Number of installed apps"], correctAnswerIndex: 1, explanation: "Endpoint posture checks ensure connecting devices meet minimum security requirements before granting access.", difficulty: .intermediate),
                QuizQuestion(id: "vpnq_10", question: "Which IPsec mode encrypts the entire original IP packet including headers?", options: ["Transport mode", "Tunnel mode", "Aggressive mode", "Main mode"], correctAnswerIndex: 1, explanation: "Tunnel mode encrypts the entire original packet and adds a new IP header, used for site-to-site VPNs.", difficulty: .advanced)
            ]
        )
    )

    // MARK: - Module 9: DNS, DHCP & Network Services Security

    static let dnsServicesModule = LearningModule(
        id: "dns_services",
        title: "DNS & Network Services Security",
        description: "Learn how DNS, DHCP, and ARP work, how attackers exploit them, and how to defend these critical network services.",
        icon: "globe.badge.chevron.backward",
        color: "dnsAmber",
        lessons: [
            Lesson(
                id: "dns_lesson_1",
                title: "How DNS Works",
                sections: [
                    LessonSection(
                        id: "dns_1_1",
                        heading: "DNS Resolution Process",
                        content: """
                        The Domain Name System (DNS) translates human-readable domain names (like google.com) into IP addresses (like 142.250.80.46) that computers use to communicate. Without DNS, you would need to memorize IP addresses for every website.

                        DNS Resolution Steps:
                        1. A user types "example.com" in their browser
                        2. The device checks its local DNS cache first
                        3. If not cached, it sends a query to the configured DNS resolver (usually the ISP's or a public resolver like 8.8.8.8)
                        4. The resolver checks its own cache
                        5. If not cached, the resolver starts a recursive query:
                           - Asks a Root Server: "Who handles .com?"
                           - Asks the TLD Server: "Who handles example.com?"
                           - Asks the Authoritative Server: "What is the IP for example.com?"
                        6. The resolver caches the answer and returns it to the client
                        7. The client connects to the IP address

                        Query Types:
                        - Recursive: The resolver does all the work and returns the final answer
                        - Iterative: Each server responds with a referral to the next server in the chain
                        - Most client-to-resolver queries are recursive; resolver-to-server queries are iterative
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "dns_ie_1",
                                type: .multipleChoice,
                                prompt: "In DNS resolution, which server provides the final authoritative answer for a domain?",
                                correctAnswer: "The Authoritative DNS Server for that domain",
                                options: ["The Root Server", "The TLD Server", "The Authoritative DNS Server for that domain", "The client's local cache"],
                                explanation: "The authoritative server hosts the actual DNS records for the domain and provides the definitive answer."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "dns_1_2",
                        heading: "DNS Record Types",
                        content: """
                        DNS servers store different types of records, each serving a specific purpose:

                        A Record (Address):
                        - Maps a domain name to an IPv4 address
                        - Example: example.com → 93.184.216.34
                        - The most common DNS record type

                        AAAA Record:
                        - Maps a domain name to an IPv6 address
                        - Example: example.com → 2606:2800:220:1:248:1893:25c8:1946

                        CNAME Record (Canonical Name):
                        - Creates an alias that points to another domain name
                        - Example: www.example.com → example.com
                        - Useful for pointing multiple subdomains to the same server

                        MX Record (Mail Exchange):
                        - Specifies the mail server responsible for receiving email
                        - Includes a priority value (lower number = higher priority)
                        - Example: example.com MX 10 mail.example.com

                        TXT Record:
                        - Holds arbitrary text data
                        - Used for email security (SPF, DKIM, DMARC)
                        - Also used for domain ownership verification

                        NS Record (Name Server):
                        - Identifies the authoritative DNS servers for a domain
                        - Points to the servers that hold the actual DNS records

                        TTL (Time to Live):
                        - Specifies how long a DNS record should be cached
                        - Measured in seconds (e.g., 3600 = 1 hour)
                        - Lower TTL = more frequent lookups but faster propagation of changes
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "dns_ie_2",
                                type: .fillInBlank,
                                prompt: "An _____ record maps a domain name to an IPv4 address.",
                                correctAnswer: "A",
                                options: nil,
                                explanation: "The A (Address) record is the most fundamental DNS record type, mapping domain names to IPv4 addresses."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "dns_lesson_2",
                title: "DNS & DHCP Attacks",
                sections: [
                    LessonSection(
                        id: "dns_2_1",
                        heading: "DNS Poisoning & Spoofing",
                        content: """
                        DNS attacks exploit the trust that systems place in DNS responses. Since DNS was designed without security in mind, it's vulnerable to several attack types:

                        DNS Cache Poisoning:
                        - The attacker injects forged DNS records into a resolver's cache
                        - All users of that resolver are then directed to the attacker's server
                        - Can redirect banking, email, or any website traffic to malicious servers
                        - The Kaminsky Attack (2008) demonstrated how fundamental this vulnerability is

                        DNS Spoofing:
                        - The attacker intercepts DNS queries and responds with fake answers before the real server
                        - Often combined with ARP spoofing to intercept traffic on the local network
                        - The victim's computer caches the fake response and connects to the wrong server

                        DNS Tunneling:
                        - Encodes data inside DNS queries and responses
                        - Used to bypass firewalls and exfiltrate data because DNS traffic is rarely blocked
                        - Difficult to detect without specialized DNS monitoring

                        DNS Amplification (DDoS):
                        - The attacker sends small DNS queries with a spoofed source IP (the victim's IP)
                        - Open DNS resolvers send large responses to the victim
                        - Can amplify attack traffic by 50-100x
                        - Used in some of the largest DDoS attacks ever recorded
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "dns_ie_3",
                                type: .trueFalse,
                                prompt: "DNS cache poisoning only affects the single user whose query was intercepted.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Cache poisoning affects the DNS resolver's cache, meaning ALL users of that resolver receive the poisoned/false records."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "dns_2_2",
                        heading: "DHCP Starvation & Rogue Servers",
                        content: """
                        DHCP attacks target the automatic IP address assignment process that most networks rely on:

                        DHCP Starvation Attack:
                        - The attacker sends thousands of DHCP Discover messages with spoofed MAC addresses
                        - Each request leases an IP address from the DHCP pool
                        - Eventually, the legitimate DHCP server runs out of addresses
                        - New legitimate devices cannot obtain IP configurations
                        - This is a denial-of-service attack against network connectivity

                        Rogue DHCP Server:
                        - Often used as a follow-up to DHCP starvation
                        - After exhausting the legitimate server's pool, the attacker runs their own DHCP server
                        - The rogue server provides addresses but sets the default gateway to the attacker's machine
                        - All traffic from victims now flows through the attacker (man-in-the-middle)
                        - The attacker can intercept, modify, or redirect all network traffic

                        ARP Spoofing:
                        - ARP (Address Resolution Protocol) maps IP addresses to MAC addresses
                        - Attackers send fake ARP replies to associate their MAC with another device's IP
                        - Allows man-in-the-middle attacks on the local network
                        - Can intercept traffic between any two devices on the same subnet
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "dns_ie_4",
                                type: .multipleChoice,
                                prompt: "What is the goal of a DHCP starvation attack?",
                                correctAnswer: "Exhaust all available IP addresses so legitimate devices cannot connect",
                                options: ["Increase network speed", "Exhaust all available IP addresses so legitimate devices cannot connect", "Upgrade the DHCP server firmware", "Create a backup DHCP server"],
                                explanation: "DHCP starvation floods the server with fake requests, consuming all available IP leases and preventing legitimate devices from joining the network."
                            ),
                            InteractiveElement(
                                id: "dns_ie_5",
                                type: .fillInBlank,
                                prompt: "_____ spoofing sends fake replies to associate an attacker's MAC address with another device's IP address.",
                                correctAnswer: "ARP",
                                options: nil,
                                explanation: "ARP spoofing exploits the stateless nature of ARP to redirect network traffic through the attacker's machine."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "dns_lesson_3",
                title: "Securing Network Services",
                sections: [
                    LessonSection(
                        id: "dns_3_1",
                        heading: "DNSSEC & Encrypted DNS",
                        content: """
                        Several technologies have been developed to address DNS's inherent lack of security:

                        DNSSEC (DNS Security Extensions):
                        - Adds digital signatures to DNS records
                        - The resolver can verify that records haven't been tampered with
                        - Uses a chain of trust from root servers down to individual domains
                        - Does NOT encrypt DNS queries, only authenticates responses
                        - Protects against cache poisoning and spoofing attacks
                        - Requires support from domain registrars and DNS providers

                        DNS over HTTPS (DoH):
                        - Encrypts DNS queries inside HTTPS (port 443)
                        - Prevents ISPs and network operators from seeing DNS queries
                        - Supported by major browsers (Chrome, Firefox, Edge)
                        - Makes DNS traffic indistinguishable from regular web traffic

                        DNS over TLS (DoT):
                        - Encrypts DNS queries using TLS (port 853)
                        - Similar privacy benefits to DoH
                        - Easier for network administrators to identify and manage
                        - Uses a dedicated port, making it easier to monitor and filter

                        The combination of DNSSEC (authentication) with DoH/DoT (encryption) provides the strongest DNS security, but adoption is still growing.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "dns_ie_6",
                                type: .multipleChoice,
                                prompt: "What does DNSSEC add to DNS responses?",
                                correctAnswer: "Digital signatures to verify record authenticity",
                                options: ["Encryption of all DNS traffic", "Digital signatures to verify record authenticity", "Faster query resolution", "Automatic failover to backup servers"],
                                explanation: "DNSSEC adds cryptographic signatures to DNS records, allowing resolvers to verify they haven't been tampered with. It does not encrypt queries."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "dns_3_2",
                        heading: "DHCP Snooping & Dynamic ARP Inspection",
                        content: """
                        Switch-level defenses can prevent DHCP and ARP attacks before they cause damage:

                        DHCP Snooping:
                        - A Layer 2 security feature built into managed switches
                        - Divides switch ports into trusted and untrusted categories
                        - Trusted ports: Connected to legitimate DHCP servers
                        - Untrusted ports: Connected to end devices (clients)
                        - Only allows DHCP server responses (Offer, ACK) from trusted ports
                        - Blocks rogue DHCP servers on untrusted ports
                        - Builds a binding table mapping IP addresses to MAC addresses and ports
                        - This binding table is used by Dynamic ARP Inspection

                        Dynamic ARP Inspection (DAI):
                        - Validates ARP packets against the DHCP snooping binding table
                        - If an ARP reply claims a different MAC-to-IP mapping than the binding table, it's dropped
                        - Prevents ARP spoofing and man-in-the-middle attacks
                        - Requires DHCP snooping to be enabled first
                        - Can also validate ARP packets against manually configured static entries

                        IP Source Guard:
                        - Works alongside DHCP snooping to prevent IP address spoofing
                        - Only allows traffic from IP addresses found in the binding table
                        - Blocks devices that manually configure unauthorized IP addresses
                        - Provides an additional layer of access control at Layer 2
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "dns_ie_7",
                                type: .trueFalse,
                                prompt: "DHCP snooping marks all switch ports as trusted by default.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "By default, all ports are untrusted. Administrators must explicitly configure trusted ports (where legitimate DHCP servers are connected)."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_dns",
            title: "DNS & Network Services Assessment",
            questions: [
                QuizQuestion(id: "dnsq_1", question: "What does DNS translate?", options: ["MAC addresses to IP addresses", "Domain names to IP addresses", "IP addresses to port numbers", "Usernames to passwords"], correctAnswerIndex: 1, explanation: "DNS converts human-readable domain names (like google.com) into machine-readable IP addresses.", difficulty: .beginner),
                QuizQuestion(id: "dnsq_2", question: "Which DNS record type maps a domain to an IPv4 address?", options: ["CNAME", "MX", "A", "TXT"], correctAnswerIndex: 2, explanation: "The A (Address) record maps a domain name to its corresponding IPv4 address.", difficulty: .beginner),
                QuizQuestion(id: "dnsq_3", question: "What is DNS cache poisoning?", options: ["Deleting DNS records", "Injecting forged records into a resolver's cache", "Encrypting DNS traffic", "Backing up DNS servers"], correctAnswerIndex: 1, explanation: "Cache poisoning inserts fake DNS records so users are redirected to malicious servers.", difficulty: .intermediate),
                QuizQuestion(id: "dnsq_4", question: "What type of DNS query asks the resolver to find the complete answer?", options: ["Iterative", "Recursive", "Reverse", "Forward"], correctAnswerIndex: 1, explanation: "Recursive queries require the resolver to do all the work and return the final answer to the client.", difficulty: .intermediate),
                QuizQuestion(id: "dnsq_5", question: "What does a DHCP starvation attack target?", options: ["DNS servers", "Available IP addresses in the DHCP pool", "Switch firmware", "Router passwords"], correctAnswerIndex: 1, explanation: "DHCP starvation exhausts all available IP addresses, preventing legitimate devices from obtaining network configuration.", difficulty: .intermediate),
                QuizQuestion(id: "dnsq_6", question: "How does ARP spoofing enable a man-in-the-middle attack?", options: ["By blocking all DNS queries", "By associating the attacker's MAC with a victim's IP address", "By disabling encryption", "By flooding the network with traffic"], correctAnswerIndex: 1, explanation: "ARP spoofing tricks devices into sending traffic to the attacker by falsely claiming their MAC address corresponds to another device's IP.", difficulty: .intermediate),
                QuizQuestion(id: "dnsq_7", question: "What does DNSSEC provide?", options: ["Encryption of DNS traffic", "Authentication of DNS records via digital signatures", "Faster DNS resolution", "Automatic DNS failover"], correctAnswerIndex: 1, explanation: "DNSSEC adds digital signatures to verify DNS record authenticity but does not encrypt the queries.", difficulty: .intermediate),
                QuizQuestion(id: "dnsq_8", question: "What feature on a switch prevents rogue DHCP servers?", options: ["Port security", "DHCP snooping", "STP", "VLAN trunking"], correctAnswerIndex: 1, explanation: "DHCP snooping blocks DHCP server responses from untrusted ports, preventing rogue servers from assigning addresses.", difficulty: .intermediate),
                QuizQuestion(id: "dnsq_9", question: "What does DNS over HTTPS (DoH) protect against?", options: ["DDoS attacks", "SQL injection", "Eavesdropping on DNS queries", "Hardware failures"], correctAnswerIndex: 2, explanation: "DoH encrypts DNS queries inside HTTPS, preventing ISPs and network operators from seeing what domains you're resolving.", difficulty: .advanced),
                QuizQuestion(id: "dnsq_10", question: "Dynamic ARP Inspection validates ARP packets against which table?", options: ["MAC address table", "Routing table", "DHCP snooping binding table", "VLAN table"], correctAnswerIndex: 2, explanation: "DAI checks ARP replies against the DHCP snooping binding table to verify legitimate IP-to-MAC mappings.", difficulty: .advanced)
            ]
        )
    )

    // MARK: - Module 10: Network Segmentation & Zero Trust

    static let zeroTrustModule = LearningModule(
        id: "zero_trust",
        title: "Segmentation & Zero Trust",
        description: "Master modern security architecture with defense in depth, microsegmentation, and Zero Trust principles.",
        icon: "shield.checkered",
        color: "ztPurple",
        lessons: [
            Lesson(
                id: "zt_lesson_1",
                title: "Defense in Depth",
                sections: [
                    LessonSection(
                        id: "zt_1_1",
                        heading: "Layered Security Model",
                        content: """
                        Defense in depth is a security strategy that uses multiple layers of protection so that if one layer fails, others continue to protect the network. No single security measure is perfect, so layering them creates resilience.

                        The Layers:

                        Physical Layer: Locked server rooms, security cameras, badge access, cable locks. Prevents unauthorized physical access to network equipment.

                        Perimeter Layer: Firewalls, DMZ, intrusion prevention systems. The first line of defense against external threats.

                        Network Layer: Network segmentation, VLANs, ACLs, VPNs. Controls traffic flow within and between network segments.

                        Endpoint Layer: Antivirus, host firewalls, disk encryption, patch management. Protects individual devices.

                        Application Layer: Secure coding, input validation, web application firewalls. Protects applications from exploitation.

                        Data Layer: Encryption at rest, access controls, data loss prevention (DLP). Protects the actual information.

                        Human Layer: Security awareness training, phishing simulations, incident reporting procedures. Addresses the human element.

                        Each layer operates independently. An attacker who bypasses the firewall still faces network segmentation, endpoint security, application controls, and data encryption.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "zt_ie_1",
                                type: .multipleChoice,
                                prompt: "What is the core principle of defense in depth?",
                                correctAnswer: "Multiple independent security layers so a single failure doesn't compromise everything",
                                options: ["Using the most expensive firewall available", "Multiple independent security layers so a single failure doesn't compromise everything", "Focusing all security budget on endpoint protection", "Relying on a single strong perimeter"],
                                explanation: "Defense in depth ensures that if one security control fails, other layers continue to protect the network."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "zt_1_2",
                        heading: "Network Segmentation Strategies",
                        content: """
                        Network segmentation divides a network into smaller, isolated segments to limit the blast radius of a security breach. An attacker who compromises one segment cannot easily move to others.

                        VLAN-Based Segmentation:
                        - Uses VLANs to create logical segments on the same physical infrastructure
                        - Traffic between VLANs must pass through a router or firewall with ACLs
                        - Common approach: separate VLANs for users, servers, management, guests, and IoT
                        - Relatively simple to implement on managed switches

                        Subnet-Based Segmentation:
                        - Uses different IP subnets with routing and firewall rules between them
                        - Provides Layer 3 separation in addition to Layer 2 VLANs
                        - Enables granular traffic filtering at subnet boundaries

                        Microsegmentation:
                        - Takes segmentation to the individual workload or application level
                        - Each server or container can have its own security policy
                        - Implemented through software-defined networking (SDN) or host-based firewalls
                        - Dramatically reduces the attack surface compared to traditional flat networks
                        - Essential for data centers and cloud environments

                        A flat network (no segmentation) is the most dangerous architecture because an attacker who gains access to any device can reach every other device on the network.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "zt_ie_2",
                                type: .trueFalse,
                                prompt: "A flat network with no segmentation is more secure because it has fewer rules to manage.",
                                correctAnswer: "False",
                                options: ["True", "False"],
                                explanation: "Flat networks are the LEAST secure because an attacker who compromises any device can reach every other device without restriction."
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "zt_lesson_2",
                title: "Zero Trust Architecture",
                sections: [
                    LessonSection(
                        id: "zt_2_1",
                        heading: "Never Trust, Always Verify",
                        content: """
                        Traditional network security uses a "castle and moat" approach: strong perimeter defenses (the moat) protect the internal network (the castle), and once inside, everything is trusted. This model fails because:

                        - Remote work means users connect from outside the perimeter
                        - Cloud services move resources outside the corporate network
                        - Attackers who breach the perimeter have free movement inside
                        - Insider threats are invisible to perimeter-only security

                        Zero Trust eliminates the concept of a trusted internal network. Its core principles:

                        1. Never Trust, Always Verify: Every access request is fully authenticated and authorized, regardless of where it originates.

                        2. Least Privilege Access: Users and devices get the minimum permissions needed for their task, nothing more.

                        3. Assume Breach: Design systems as if the network is already compromised. Limit blast radius through segmentation.

                        4. Verify Explicitly: Use all available data points to verify: user identity, device health, location, behavior patterns, time of access.

                        5. Continuous Verification: Trust is not a one-time event. Sessions are continuously monitored and re-evaluated.

                        Zero Trust is not a product you buy - it's an architecture and mindset that changes how you approach network security.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "zt_ie_3",
                                type: .fillInBlank,
                                prompt: "The core Zero Trust principle is: \"Never _____, always verify.\"",
                                correctAnswer: "trust",
                                options: nil,
                                explanation: "Zero Trust assumes no user, device, or network segment should be implicitly trusted, regardless of location."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "zt_2_2",
                        heading: "Implementing Zero Trust",
                        content: """
                        Implementing Zero Trust is a journey, not a single project. Key components include:

                        Identity and Access Management (IAM):
                        - Strong authentication (MFA everywhere, passwordless where possible)
                        - Single Sign-On (SSO) with centralized identity providers
                        - Conditional access policies based on user, device, location, and risk
                        - Just-in-time and just-enough access (JIT/JEA)

                        Device Trust:
                        - Every device must be registered, managed, or assessed before access
                        - Endpoint Detection and Response (EDR) monitors device health
                        - Non-compliant devices are quarantined or given limited access
                        - Company-managed vs. personal device (BYOD) policies

                        Network Controls:
                        - Microsegmentation limits lateral movement
                        - Software-Defined Perimeter (SDP) hides resources until authenticated
                        - Encrypted connections for all internal communication
                        - No implicit trust based on network location (internal vs. external)

                        Monitoring and Analytics:
                        - Log everything: authentication attempts, access patterns, data flows
                        - Use SIEM and UEBA to detect anomalous behavior
                        - Automated response to suspicious activity
                        - Regular access reviews and privilege audits

                        Google's BeyondCorp is one of the most well-known Zero Trust implementations, replacing their traditional VPN with identity-aware access controls.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "zt_ie_4",
                                type: .multipleChoice,
                                prompt: "What replaces perimeter-based trust in a Zero Trust architecture?",
                                correctAnswer: "Identity-based verification for every access request",
                                options: ["A stronger firewall", "Identity-based verification for every access request", "Faster internet connections", "More VPN tunnels"],
                                explanation: "Zero Trust shifts from 'trust based on network location' to 'verify identity and context for every single access request.'"
                            )
                        ]
                    )
                ]
            ),
            Lesson(
                id: "zt_lesson_3",
                title: "Network Access Control",
                sections: [
                    LessonSection(
                        id: "zt_3_1",
                        heading: "802.1X & RADIUS Authentication",
                        content: """
                        802.1X is a port-based network access control standard that prevents unauthorized devices from connecting to the network. It works at the switch level, blocking all traffic from a port until the connected device authenticates.

                        Three Components of 802.1X:

                        Supplicant: The client device seeking network access. It runs software that communicates with the authenticator. Built into Windows, macOS, Linux, and mobile devices.

                        Authenticator: The network switch or wireless access point. It acts as a gatekeeper, blocking traffic from the port until the supplicant authenticates. It relays authentication messages between the supplicant and the authentication server.

                        Authentication Server: A RADIUS (Remote Authentication Dial-In User Service) server that validates credentials. It checks the supplicant's identity against a database (Active Directory, LDAP) and returns an accept or reject decision.

                        Authentication Flow:
                        1. Device connects to a switch port
                        2. Port starts in unauthorized state (no traffic allowed except 802.1X)
                        3. Switch sends an EAP (Extensible Authentication Protocol) identity request
                        4. Device responds with credentials
                        5. Switch forwards credentials to the RADIUS server
                        6. RADIUS validates and returns accept/reject
                        7. If accepted, the port transitions to authorized state
                        8. The switch can also assign the device to a specific VLAN based on authentication result
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "zt_ie_5",
                                type: .multipleChoice,
                                prompt: "In 802.1X, what role does the switch play?",
                                correctAnswer: "Authenticator - it blocks traffic until the device proves its identity",
                                options: ["Supplicant - it requests access", "Authenticator - it blocks traffic until the device proves its identity", "Authentication server - it stores credentials", "It has no role in 802.1X"],
                                explanation: "The switch acts as the authenticator, gatekeeping the port and relaying authentication between the device and RADIUS server."
                            )
                        ]
                    ),
                    LessonSection(
                        id: "zt_3_2",
                        heading: "NAC Policies & Posture Assessment",
                        content: """
                        Network Access Control (NAC) goes beyond 802.1X authentication by evaluating the security posture of connecting devices and enforcing compliance policies.

                        Posture Assessment Checks:
                        - Is the operating system fully patched and up to date?
                        - Is antivirus software installed, running, and updated?
                        - Is the host firewall enabled?
                        - Is disk encryption active?
                        - Is the device managed by the organization's MDM?
                        - Are any prohibited applications installed?

                        NAC Actions Based on Posture:
                        - Compliant: Full network access granted to the appropriate VLAN
                        - Non-Compliant: Device is placed in a quarantine VLAN with limited access
                        - Remediation: The quarantine VLAN may provide access to update servers so the device can become compliant
                        - Guest: Unknown or personal devices are placed in a restricted guest network

                        Benefits of NAC:
                        - Prevents compromised or vulnerable devices from accessing sensitive resources
                        - Enforces minimum security standards across all connected devices
                        - Provides visibility into every device on the network
                        - Automatically segments devices based on identity and compliance
                        - Supports regulatory compliance (HIPAA, PCI-DSS, SOX)

                        NAC is a cornerstone of Zero Trust architecture because it ensures that every device meeting the organization's security requirements before granting access.
                        """,
                        interactiveElements: [
                            InteractiveElement(
                                id: "zt_ie_6",
                                type: .trueFalse,
                                prompt: "A NAC system can quarantine devices that fail security posture checks.",
                                correctAnswer: "True",
                                options: ["True", "False"],
                                explanation: "NAC places non-compliant devices in a quarantine VLAN where they have limited access and can be remediated."
                            ),
                            InteractiveElement(
                                id: "zt_ie_7",
                                type: .multipleChoice,
                                prompt: "What happens to a device that fails NAC posture assessment?",
                                correctAnswer: "It is placed in a quarantine VLAN with limited access for remediation",
                                options: ["It receives full network access anyway", "It is placed in a quarantine VLAN with limited access for remediation", "It is permanently banned from the network", "The switch port is physically disabled"],
                                explanation: "Quarantine VLANs provide limited access (often just to update servers) so the device can be brought into compliance."
                            )
                        ]
                    )
                ]
            )
        ],
        quiz: Quiz(
            id: "quiz_zerotrust",
            title: "Segmentation & Zero Trust Assessment",
            questions: [
                QuizQuestion(id: "ztq_1", question: "What is the goal of defense in depth?", options: ["Use one very strong security measure", "Layer multiple independent security controls", "Focus all security on the perimeter", "Eliminate the need for firewalls"], correctAnswerIndex: 1, explanation: "Defense in depth layers multiple security controls so that if one fails, others continue to protect the network.", difficulty: .beginner),
                QuizQuestion(id: "ztq_2", question: "Why is a flat network dangerous?", options: ["It's too expensive", "An attacker who compromises one device can reach every other device", "It requires too many VLANs", "It doesn't support Wi-Fi"], correctAnswerIndex: 1, explanation: "Without segmentation, there are no barriers to lateral movement, so a single compromised device threatens the entire network.", difficulty: .beginner),
                QuizQuestion(id: "ztq_3", question: "What is the core Zero Trust principle?", options: ["Trust but verify", "Never trust, always verify", "Trust internal networks only", "Verify once, trust forever"], correctAnswerIndex: 1, explanation: "Zero Trust eliminates implicit trust. Every access request must be authenticated and authorized, regardless of origin.", difficulty: .beginner),
                QuizQuestion(id: "ztq_4", question: "What does microsegmentation protect against?", options: ["Power outages", "Lateral movement by attackers within the network", "Email spam", "Physical theft"], correctAnswerIndex: 1, explanation: "Microsegmentation isolates individual workloads, preventing attackers who compromise one system from moving to others.", difficulty: .intermediate),
                QuizQuestion(id: "ztq_5", question: "In 802.1X, what is the role of the RADIUS server?", options: ["It acts as the network switch", "It validates credentials and returns accept/reject decisions", "It assigns IP addresses via DHCP", "It encrypts all network traffic"], correctAnswerIndex: 1, explanation: "The RADIUS server is the authentication server that checks credentials against a user database and authorizes or denies access.", difficulty: .intermediate),
                QuizQuestion(id: "ztq_6", question: "What does NAC posture assessment check?", options: ["Network speed and bandwidth", "Device security status like OS patches and antivirus", "The physical location of the device", "The device's screen resolution"], correctAnswerIndex: 1, explanation: "NAC posture assessment evaluates device security (patches, antivirus, encryption, firewall) before granting network access.", difficulty: .intermediate),
                QuizQuestion(id: "ztq_7", question: "What happens in Zero Trust when a device connects from inside the corporate network?", options: ["It is automatically trusted", "It must still authenticate and verify, the same as external devices", "It receives admin access", "It bypasses all security controls"], correctAnswerIndex: 1, explanation: "Zero Trust treats all connections equally. Network location (internal vs external) does not grant trust.", difficulty: .intermediate),
                QuizQuestion(id: "ztq_8", question: "Which company's BeyondCorp initiative is a well-known Zero Trust implementation?", options: ["Microsoft", "Amazon", "Google", "Apple"], correctAnswerIndex: 2, explanation: "Google's BeyondCorp replaced their traditional VPN-based security with identity-aware Zero Trust access controls.", difficulty: .advanced)
            ]
        )
    )
}
