import SwiftUI

// MARK: - Certification Model
// This struct represents a single cybersecurity certification.
// Each certification has details about the exam format, cost, and prerequisites.
// Conforms to Identifiable so SwiftUI can use it in ForEach loops.
struct Certification: Identifiable {
    let id: String            // Unique identifier for the cert (e.g. "network_plus")
    let name: String          // Display name (e.g. "CompTIA Network+")
    let vendor: String        // Organization that issues the cert (e.g. "CompTIA")
    let icon: String          // SF Symbol name for the cert's icon
    let description: String   // 2-3 sentence overview of what the cert covers
    let examCode: String      // Official exam code (e.g. "N10-009")
    let numberOfQuestions: String  // How many questions on the exam
    let timeLimit: String     // How long you have to complete the exam
    let passingScore: String  // Minimum score needed to pass
    let cost: String          // Approximate exam fee in USD
    let prerequisites: String // Any required or recommended prior certs
    let gradientHex: (String, String)  // Two hex color strings for the card's gradient background
}

// MARK: - Static Certification Data
// This struct holds all the certification data as static properties.
// Using static data keeps things simple — no database or API needed.
struct CertData {

    // Array of all certifications, used by the list view to display cards
    static let certifications: [Certification] = [
        networkPlus,
        securityPlus,
        ccna,
        cyberOps
    ]

    // MARK: CompTIA Network+
    // Entry-level networking certification — great starting point for beginners.
    // Covers networking fundamentals like TCP/IP, DNS, routing, and switching.
    static let networkPlus = Certification(
        id: "network_plus",
        name: "CompTIA Network+",
        vendor: "CompTIA",
        icon: "network",                          // SF Symbol: network icon
        description: "CompTIA Network+ validates your ability to design, configure, manage, and troubleshoot wired and wireless network devices. It covers networking fundamentals including TCP/IP, DNS, DHCP, routing, and switching. This is one of the best starting points for anyone entering IT or cybersecurity.",
        examCode: "N10-009",
        numberOfQuestions: "Up to 90",
        timeLimit: "90 minutes",
        passingScore: "720 out of 900",
        cost: "$369 USD",
        prerequisites: "None required. CompTIA recommends 9-12 months of networking experience.",
        gradientHex: ("667eea", "764ba2")         // Indigo-to-purple gradient
    )

    // MARK: CompTIA Security+
    // Baseline cybersecurity certification — widely recognized across the industry.
    // Covers threats, vulnerabilities, cryptography, and identity management.
    static let securityPlus = Certification(
        id: "security_plus",
        name: "CompTIA Security+",
        vendor: "CompTIA",
        icon: "lock.shield.fill",                 // SF Symbol: shield with lock
        description: "CompTIA Security+ is a globally recognized certification that establishes baseline cybersecurity skills. It covers threats, attacks, vulnerabilities, cryptography, identity management, and security operations. Many government and enterprise jobs require or prefer this certification.",
        examCode: "SY0-701",
        numberOfQuestions: "Up to 90",
        timeLimit: "90 minutes",
        passingScore: "750 out of 900",
        cost: "$404 USD",
        prerequisites: "None required. CompTIA recommends having Network+ and 2 years of IT experience.",
        gradientHex: ("e53935", "d32f2f")         // Red gradient
    )

    // MARK: Cisco CCNA
    // Industry-standard networking cert from Cisco — focuses on Cisco technologies.
    // Covers network access, IP connectivity, security fundamentals, and automation.
    static let ccna = Certification(
        id: "ccna",
        name: "Cisco CCNA",
        vendor: "Cisco",
        icon: "server.rack",                      // SF Symbol: server rack
        description: "The Cisco Certified Network Associate (CCNA) certification validates your knowledge of network access, IP connectivity, IP services, security fundamentals, and automation. It is one of the most respected networking certifications and is often required for network engineering roles.",
        examCode: "200-301",
        numberOfQuestions: "100-120",
        timeLimit: "120 minutes",
        passingScore: "Approximately 825 out of 1000",
        cost: "$330 USD",
        prerequisites: "None required. Cisco recommends one or more years of experience implementing Cisco solutions.",
        gradientHex: ("11998e", "38ef7d")         // Teal-to-green gradient
    )

    // MARK: Cisco CyberOps Associate
    // Security operations certification — focuses on SOC analyst skills.
    // Covers security monitoring, host-based analysis, and incident response.
    static let cyberOps = Certification(
        id: "cyberops",
        name: "Cisco CyberOps Associate",
        vendor: "Cisco",
        icon: "eye.trianglebadge.exclamationmark", // SF Symbol: monitoring/alert eye
        description: "The Cisco CyberOps Associate certification prepares you for a career as a Security Operations Center (SOC) analyst. It covers security concepts, security monitoring, host-based analysis, network intrusion analysis, and incident response. This cert is ideal if you're interested in threat detection and defense.",
        examCode: "200-201",
        numberOfQuestions: "95-105",
        timeLimit: "120 minutes",
        passingScore: "Approximately 825 out of 1000",
        cost: "$330 USD",
        prerequisites: "None required. Understanding of networking fundamentals is recommended.",
        gradientHex: ("f7971e", "ffd200")         // Orange-to-gold gradient
    )
}
