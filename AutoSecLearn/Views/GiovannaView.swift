import SwiftUI

// MARK: - Models
struct Flashcard: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FlashcardSet: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: String
    let description: String
    let cards: [Flashcard]
}

// MARK: - All Flashcard Sets
extension FlashcardSet {
    static let allSets: [FlashcardSet] = [
        .pythonAutomation,
        .authentication,
        .multiHostManagement,
        .consistentConfigurations,
        .rapidDeployment
    ]

    // MARK: - Module 1: Python Automation Scripting
    static let pythonAutomation = FlashcardSet(
        title: "Python Automation Scripting",
        icon: "terminal.fill",
        color: "ffbe0b",
        description: "Use Python and Netmiko to automate network device configuration.",
        cards: [
            Flashcard(
                question: "What is Netmiko and why is it used in network automation?",
                answer: "Netmiko is an open-source Python library that simplifies SSH connections to multi-vendor network devices."
            ),
            Flashcard(
                question: "How do you connect to a network device using Netmiko?",
                answer: "You create a dictionary with the device type, IP, username, and password, then pass it to ConnectHandler() from the netmiko library to open an SSH session."
            ),
            Flashcard(
                question: "What method do you use in Netmiko to send configuration commands?",
                answer: "send_config_set() — it accepts a list of commands and applies them in config mode on the device automatically."
            ),
            Flashcard(
                question: "How do you save configuration changes on a device after sending commands?",
                answer: "Use send_command('write memory') or send_command('copy running-config startup-config') to save the running config to NVRAM so changes persist after reboot."
            ),
            Flashcard(
                question: "What is a CI/CD pipeline and how does automation scripting integrate with it?",
                answer: "A CI/CD pipeline automates testing and deployment. Network scripts can be triggered automatically when code changes are pushed, ensuring device configs are always up to date without manual intervention."
            ),
            Flashcard(
                question: "What is a scheduled task and how is it used with automation scripts?",
                answer: "A scheduled task runs a script automatically at set intervals using tools like cron (Linux) or Task Scheduler (Windows), allowing regular config checks or backups without human action."
            ),
            Flashcard(
                question: "What is the difference between send_command() and send_config_set() in Netmiko?",
                answer: "send_command() runs a single exec-mode command (like 'show vlan brief'), while send_config_set() enters config mode and applies a list of configuration commands."
            ),
            Flashcard(
                question: "Why is Python automation preferred over manual CLI configuration?",
                answer: "It eliminates repetitive manual entry, reduces human error, enforces consistent templates, and allows the same logic to be applied to many devices quickly and repeatably."
            )
        ]
    )

    // MARK: - Module 2: Authentication
    static let authentication = FlashcardSet(
        title: "Authentication",
        icon: "lock.shield.fill",
        color: "e94560",
        description: "Secure access methods and credential management for network automation.",
        cards: [
            Flashcard(
                question: "What is the difference between password-based and key-based authentication?",
                answer: "Password-based auth requires a username/password on each connection. Key-based auth uses a cryptographic key pair — the private key stays on your machine and the public key is placed on the device."
            ),
            Flashcard(
                question: "Why is key-based authentication more secure than password-based?",
                answer: "Keys are much harder to brute force than passwords, they are never transmitted over the network, and they can be revoked individually without changing shared passwords."
            ),
            Flashcard(
                question: "What is a hardcoded secret and why is it dangerous?",
                answer: "A hardcoded secret is a password or API key written directly in source code. It's dangerous because anyone who reads the code — including via version control history — can see and use those credentials."
            ),
            Flashcard(
                question: "What is an environment variable and how does it help secure credentials?",
                answer: "An environment variable stores sensitive values like passwords outside the code, in the operating system. Scripts read them at runtime using os.environ.get('VAR_NAME'), keeping secrets out of the source code."
            ),
            Flashcard(
                question: "What is a secrets vault?",
                answer: "A vault (like HashiCorp Vault or AWS Secrets Manager) is a dedicated secure system for storing, rotating, and auditing access to credentials. Scripts request secrets from the vault at runtime instead of storing them locally."
            ),
            Flashcard(
                question: "How does Netmiko handle credentials securely in a script?",
                answer: "Instead of hardcoding passwords, you pass credentials from environment variables or a vault into the ConnectHandler() dictionary at runtime, so no secrets appear in the source file."
            ),
            Flashcard(
                question: "What does it mean to avoid committing secrets to version control?",
                answer: "Never include passwords, API keys, or private keys in files pushed to Git. Use .gitignore to exclude config files with secrets, and use environment variables or vaults instead."
            ),
            Flashcard(
                question: "What is the principle of least privilege in authentication?",
                answer: "Each account or script should only have the minimum permissions needed to do its job — a script that only reads configs shouldn't have admin write access to devices."
            )
        ]
    )

    // MARK: - Module 3: Multi-Host Management
    static let multiHostManagement = FlashcardSet(
        title: "Multi-Host Management",
        icon: "server.rack",
        color: "3a86ff",
        description: "Apply configuration logic to multiple devices across different environments.",
        cards: [
            Flashcard(
                question: "How do you manage multiple devices in a Python automation script?",
                answer: "Store device connection details in a Python list or dictionary, then loop through each device using a for loop, connecting and applying commands to each one in sequence."
            ),
            Flashcard(
                question: "What is an inventory file in network automation?",
                answer: "A file (often JSON, YAML, or CSV) that lists all devices with their IPs, types, and credentials. Scripts read from this file to know which devices to target, making it easy to update without changing the script itself."
            ),
            Flashcard(
                question: "What is the advantage of looping through devices instead of hardcoding each one?",
                answer: "It makes the script scalable — adding a new device just means adding an entry to the inventory, not rewriting the script logic. The same code applies to 5 or 500 devices."
            ),
            Flashcard(
                question: "What are dev, staging, and production environments?",
                answer: "Dev is where developers test changes. Staging mirrors production for final testing. Production is the live environment used by real users. Good automation scripts can target any environment from one codebase."
            ),
            Flashcard(
                question: "How can one script target different environments?",
                answer: "By using environment variables or command-line arguments to specify which inventory file or device group to use, so the same script logic runs against dev, staging, or production without code changes."
            ),
            Flashcard(
                question: "What is the risk of applying the same config to all devices without checking environment differences?",
                answer: "Settings like IP addresses, VLANs, or credentials differ between environments. Applying prod configs to dev devices can cause outages or expose production credentials."
            ),
            Flashcard(
                question: "What Python data structure is commonly used to store a device inventory?",
                answer: "A list of dictionaries — each dictionary holds one device's details like device_type, host, username, and password, matching what Netmiko's ConnectHandler() expects."
            ),
            Flashcard(
                question: "How do you handle a failed connection to one device without stopping the whole script?",
                answer: "Wrap each device's connection block in a try/except statement — if one device fails, the exception is caught, an error is logged, and the loop continues to the next device."
            )
        ]
    )

    // MARK: - Module 4: Consistent Configurations
    static let consistentConfigurations = FlashcardSet(
        title: "Consistent Configurations",
        icon: "checklist",
        color: "06d6a0",
        description: "Standardize commands across switches, routers, and servers to prevent drift.",
        cards: [
            Flashcard(
                question: "What is configuration drift?",
                answer: "Configuration drift occurs when devices gradually differ from their intended standard state due to manual changes, updates, or human error — making the network unpredictable and harder to troubleshoot."
            ),
            Flashcard(
                question: "How does automation prevent configuration drift?",
                answer: "By re-applying standardized configuration scripts regularly, automation ensures every device matches the documented baseline and any manual changes are overwritten or flagged."
            ),
            Flashcard(
                question: "What is a configuration template?",
                answer: "A reusable set of commands that defines the standard configuration for a device type. Templates ensure every switch or router is set up identically, reducing inconsistencies."
            ),
            Flashcard(
                question: "Why is it important to document network configuration in code?",
                answer: "Code serves as a living record of intended configuration. It can be version-controlled in Git, reviewed, and audited — making it clear what every device should look like at any point in time."
            ),
            Flashcard(
                question: "What does 'infrastructure as code' mean?",
                answer: "Managing and provisioning infrastructure through machine-readable scripts instead of manual processes — treating network configs the same way developers treat application code, with versioning and automation."
            ),
            Flashcard(
                question: "How do standardized configs improve security?",
                answer: "They ensure security settings like strong passwords, disabled unused ports, and proper VLAN assignments are applied to every device without relying on individual admins remembering each step."
            ),
            Flashcard(
                question: "What is the benefit of sending the same commands to switches, routers, and servers?",
                answer: "It makes network behavior predictable — admins know exactly what settings are on each device, troubleshooting is faster, and compliance audits are easier to pass."
            ),
            Flashcard(
                question: "How does version control help with consistent configurations?",
                answer: "Storing config scripts in Git lets teams track every change, revert to a known good state, and see who changed what and when — providing accountability and a safety net."
            )
        ]
    )

    // MARK: - Module 5: Rapid Deployment
    static let rapidDeployment = FlashcardSet(
        title: "Rapid Deployment",
        icon: "bolt.fill",
        color: "8338ec",
        description: "Push updates to dozens of devices in minutes instead of hours of manual work.",
        cards: [
            Flashcard(
                question: "What is rapid deployment in network automation?",
                answer: "The ability to push configuration updates or new settings to many devices simultaneously using a script, reducing what would take hours of manual CLI work to just minutes."
            ),
            Flashcard(
                question: "How does automation replace manual CLI work?",
                answer: "Instead of an admin SSH-ing into each device individually and typing commands, a script connects to all devices in a loop and applies the same commands automatically and consistently."
            ),
            Flashcard(
                question: "What is the time advantage of scripted deployment over manual configuration?",
                answer: "A script can configure dozens of devices in the time it takes to manually configure one — because it runs commands at machine speed without human delays between each step."
            ),
            Flashcard(
                question: "Why is it easy to re-run automation scripts when changes are needed?",
                answer: "You update the command list or template once, then re-run the script and every device gets the new configuration applied uniformly."
            ),
            Flashcard(
                question: "What is idempotency in the context of network automation?",
                answer: "An idempotent script produces the same result no matter how many times it runs. Running it once or ten times leaves the device in the same correct state, making re-runs safe."
            ),
            Flashcard(
                question: "How does rapid deployment support emergency response?",
                answer: "When a vulnerability is discovered or a misconfiguration causes an outage, a script can push a fix to all affected devices in minutes instead of hours of manual remediation."
            ),
            Flashcard(
                question: "What is the role of testing before rapid deployment to production?",
                answer: "Always test scripts on a dev or staging environment first — a bug in a script running on 50 switches simultaneously can cause a major outage."
            ),
            Flashcard(
                question: "How does rapid deployment support scalability?",
                answer: "As a network grows from 10 to 100 devices, just add entries to the inventory file. Manual CLI work scales linearly with device count; automation does not."
            )
        ]
    )
}

// MARK: - Main View
struct GiovannaView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0f0f1a").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(FlashcardSet.allSets) { set in
                            NavigationLink(destination: FlashcardDeckView(set: set)) {
                                FlashcardSetRow(set: set)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Flashcard Sets")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Set Row
struct FlashcardSetRow: View {
    let set: FlashcardSet

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: set.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color(hex: set.color))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(set.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(set.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(1)
                Text("\(set.cards.count) cards")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.35))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.3))
        }
        .padding(16)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Deck View
struct FlashcardDeckView: View {
    let set: FlashcardSet
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack {
            Color(hex: "0f0f1a").ignoresSafeArea()

            VStack(spacing: 24) {

                Text("\(currentIndex + 1) of \(set.cards.count)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))

                ProgressView(value: Double(currentIndex + 1), total: Double(set.cards.count))
                    .tint(Color(hex: set.color))
                    .padding(.horizontal)

                ZStack {
                    CardFace(
                        text: set.cards[currentIndex].answer,
                        label: "ANSWER",
                        color: set.color,
                        isFront: false
                    )
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -90), axis: (x: 0, y: 1, z: 0))
                    .opacity(isFlipped ? 1 : 0)

                    CardFace(
                        text: set.cards[currentIndex].question,
                        label: "QUESTION",
                        color: set.color,
                        isFront: true
                    )
                    .rotation3DEffect(.degrees(isFlipped ? 90 : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(isFlipped ? 0 : 1)
                }
                .frame(height: 300)
                .padding(.horizontal)
                .offset(x: offset)
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isFlipped.toggle()
                    }
                }

                Text(isFlipped ? "Tap to see question" : "Tap to reveal answer")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.4))

                HStack(spacing: 32) {
                    Button {
                        navigate(forward: false)
                    } label: {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(currentIndex == 0 ? .white.opacity(0.2) : Color(hex: set.color))
                    }
                    .disabled(currentIndex == 0)

                    Button {
                        navigate(forward: true)
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(currentIndex == set.cards.count - 1 ? .white.opacity(0.2) : Color(hex: set.color))
                    }
                    .disabled(currentIndex == set.cards.count - 1)
                }

                Spacer()
            }
            .padding(.top, 16)
        }
        .navigationTitle(set.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func navigate(forward: Bool) {
        let slideOut: CGFloat = forward ? -400 : 400
        let slideIn: CGFloat = forward ? 400 : -400

        withAnimation(.easeIn(duration: 0.15)) {
            offset = slideOut
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            currentIndex += forward ? 1 : -1
            isFlipped = false
            offset = slideIn
            withAnimation(.easeOut(duration: 0.15)) {
                offset = 0
            }
        }
    }
}

// MARK: - Card Face
struct CardFace: View {
    let text: String
    let label: String
    let color: String
    let isFront: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundColor(Color(hex: color))
                .tracking(2)

            Spacer()

            Text(text)
                .font(.body.weight(.medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.07))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color(hex: color).opacity(0.4), lineWidth: 1.5)
                )
        )
    }
}
