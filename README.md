# Active Directory Home Lab — Azure Cloud Environment

![Windows Server 2025](https://img.shields.io/badge/Windows%20Server-2025-blue)
![Azure](https://img.shields.io/badge/Platform-Microsoft%20Azure-0078D4)
![Active Directory](https://img.shields.io/badge/Active%20Directory-Domain%20Services-green)
![Users](https://img.shields.io/badge/Users-51-orange)
![GPOs](https://img.shields.io/badge/GPOs-5%20Custom-purple)

Enterprise Active Directory environment built on **Microsoft Azure** simulating a corporate network with a Windows Server 2025 Domain Controller, domain-joined client, 51 users across 4 departments, 5 Group Policies, and 10 real-world helpdesk scenarios with documented SOPs.

Built to demonstrate hands-on IT administration skills including: Active Directory management, Group Policy configuration, user lifecycle management, PowerShell automation, and Tier 1 helpdesk troubleshooting.

<img src="screenshots/infrastructure/resource-group.png" width="800">

---

## Environment

| Component | Details |
|-----------|---------|
| **Cloud Platform** | Microsoft Azure (Student Subscription) |
| **Domain Controller** | DC01 — Windows Server 2025 Datacenter x64 Gen2 |
| **Client Machine** | CLIENT01 — Windows Server 2025 (domain-joined) |
| **Domain** | corp.local (NetBIOS: CORP) |
| **Network** | AD-Lab-VNet — 10.0.0.0/16, AD-Subnet — 10.0.1.0/24 |
| **Region** | Canada Central |
| **VM Size** | Standard B2als_v2 (2 vCPUs, 4 GB RAM) |
| **DNS** | DC01 (10.0.1.4) |

## Architecture
```
┌──────────────────────────────────────────────────────────┐
│                    Microsoft Azure                       │
│                Resource Group: AD-Lab-RG                 │
│                Region: Canada Central                    │
│                                                          │
│   ┌──────────────────────────────────────────────────┐   │
│   │         VNet: AD-Lab-VNet (10.0.0.0/16)          │   │
│   │         Subnet: AD-Subnet (10.0.1.0/24)          │   │
│   │         DNS Server: 10.0.1.4                     │   │
│   │                                                  │   │
│   │   ┌───────────────┐       ┌───────────────┐      │   │
│   │   │     DC01      │       │   CLIENT01    │      │   │
│   │   │  10.0.1.4     │◄─────►│  10.0.1.5     │      │   │
│   │   │               │       │               │      │   │
│   │   │  AD DS + DNS  │       │ Domain-Joined │      │   │
│   │   │  corp.local   │       │ Workstation   │      │   │
│   │   │  5 GPOs       │       │               │      │   │
│   │   │  51 Users     │       │               │      │   │
│   │   └───────────────┘       └───────────────┘      │   │
│   └──────────────────────────────────────────────────┘   │
│                                                          │
│        RDP Access via Microsoft Remote Desktop           │
└──────────────────────────────────────────────────────────┘
```

### Virtual Network Overview
<img src="screenshots/infrastructure/vnet-overview.png" width="800">

### DC01 — Domain Controller
<img src="screenshots/infrastructure/dc01-overview.png" width="800">

### CLIENT01 — Domain-Joined Workstation
<img src="screenshots/infrastructure/client01-overview.png" width="800">

### DC01 Network Configuration
<img src="screenshots/infrastructure/dc01-ipconfi.png" width="800">

---

## Active Directory Structure
```
corp.local
├── CORP-Users
│   ├── IT (15 users)
│   ├── HR (14 users)
│   ├── Finance (16 users)
│   └── Management (7 users)
├── CORP-Computers
│   └── CLIENT01
├── Domain Controllers
│   └── DC01
├── Builtin
├── Computers
└── Users
```

51 users created across 4 department OUs — 2 manually via GUI, 48 via PowerShell bulk script, and 1 through the new hire onboarding scenario.

| Department | Users | Example Accounts |
|------------|-------|-----------------|
| **IT** | 15 | jsmith, mwilliams, lgarcia, rmartinez |
| **HR** | 14 | sjohnson, ebrown, mrodriguez, dtaylor |
| **Finance** | 16 | djones, jmiller, wanderson, ajackson, arivera |
| **Management** | 7 | jdavis, cwhite, nlee, lyoung |

### Domain Verification
<img src="screenshots/infrastructure/get-addomain.png" width="800">

### OU Tree with CLIENT01
<img src="screenshots/infrastructure/ou-tree-computers.png" width="800">

### IT Department (15 users)
<img src="screenshots/infrastructure/ou-it.png" width="800">

### HR Department (14 users)
<img src="screenshots/infrastructure/ou-hr.png" width="800">

### Finance Department (16 users)
<img src="screenshots/infrastructure/ou-finance.png" width="800">

### Management Department (7 users)
<img src="screenshots/infrastructure/ou-management.png" width="800">

### PowerShell Summary — 51 Users, 7 OUs, CLIENT01
<img src="screenshots/infrastructure/powershell-summary.png" width="800">

---

## Group Policies

5 custom GPOs configured to enforce security baselines, restrict user access, and demonstrate GPO inheritance.

| GPO | Linked To | Purpose |
|-----|-----------|---------|
| **Password & Lockout Policy** | Default Domain Policy | 10-char minimum, complexity required, 90-day max age, 5 password history, lockout after 5 failed attempts (30 min) |
| **CORP-Desktop-Lockdown** | CORP-Users OU | Blocks Control Panel, Command Prompt, and Registry Editor for all regular users |
| **CORP-IT-Exceptions** | IT OU | Overrides lockdown for IT staff — restores access to admin tools |
| **CORP-Desktop-Wallpaper** | CORP-Users OU | Enforces company wallpaper and prevents users from changing desktop background |
| **CORP-Disable-USB** | CORP-Users OU | Blocks all removable storage read/write access — data loss prevention |

### GPO Inheritance

The Desktop Lockdown GPO applies to all users under CORP-Users. The IT-Exceptions GPO is linked to the IT OU (child of CORP-Users) and explicitly **disables** the restrictions, overriding the parent policy. This demonstrates GPO precedence — policies closer to the object win.

**Tested:** HR user blocked from Control Panel ✓ | IT user has full access ✓

### Group Policy Management Tree
<img src="screenshots/gpo/gpo-tree.png" width="800">

### Password Policy
<img src="screenshots/gpo/password-policy.png" width="800">

### Account Lockout Policy
<img src="screenshots/gpo/account-lockout.png" width="800">

### USB Disable Policy (Data Loss Prevention)
<img src="screenshots/gpo/usb-disable.png" width="800">

### Desktop Wallpaper Policy
<img src="screenshots/gpo/wallpaper-policy.png" width="800">

### Prevent Changing Desktop Background
<img src="screenshots/gpo/prevent-wallpaper-change.png" width="800">

---

## Helpdesk Scenarios

10 real-world Tier 1 helpdesk scenarios simulated and documented with step-by-step resolutions.

| # | Scenario | Method | Description |
|---|----------|--------|-------------|
| 1 | [Password Reset](docs/01-password-reset.md) | GUI | User forgot password — reset with temporary password |
| 2 | [Account Lockout & Unlock](docs/02-account-lockout.md) | GUI | Account locked after 5 failed attempts — find and unlock |
| 3 | [Create New User](docs/03-create-user.md) | GUI | New hire onboarding — create account in correct OU |
| 4 | [Disable/Enable Account](docs/04-disable-enable.md) | GUI | Employee termination and rehire |
| 5 | [Add User to Security Group](docs/05-security-group.md) | GUI | Grant resource access via group membership (RBAC) |
| 6 | [Move User Between Departments](docs/06-move-user.md) | GUI | Employee transfer — move OU and update department |
| 7 | [GPO Troubleshooting](docs/07-gpo-troubleshooting.md) | GUI + CLI | Diagnose policy issues with gpresult |
| 8 | [Find Expiring Accounts](docs/08-expiring-accounts.md) | PowerShell | Report accounts expiring within 60 days |
| 9 | [Bulk Password Reset](docs/09-bulk-password-reset.md) | PowerShell | Emergency security response — reset entire department |
| 10 | [Trust Relationship Fix](docs/10-trust-relationship.md) | PowerShell | Workstation loses domain trust — diagnose and repair |

---

## Scripts

| Script | Description |
|--------|-------------|
| [bulk-create-users.ps1](scripts/bulk-create-users.ps1) | Creates 50 users from CSV across 4 department OUs with error handling for duplicates |
| [users.csv](scripts/users.csv) | User data — first name, last name, department, username |

## Tools Used

| Tool | Purpose |
|------|---------|
| **Microsoft Azure** | Cloud infrastructure — VMs, VNet, NSGs |
| **Windows Server 2025** | Domain Controller with AD DS and DNS |
| **Active Directory Users and Computers** | User and OU management (GUI) |
| **Group Policy Management** | GPO creation and troubleshooting |
| **PowerShell** | Automation, bulk operations, diagnostics |
| **Microsoft Remote Desktop** | RDP access from macOS |

---

## Key Takeaways

- **GPO inheritance matters** — policies linked to parent OUs apply to all children unless explicitly overridden. Setting a policy to "Not Configured" doesn't override; it must be set to "Disabled."
- **Azure networking** — VNet DNS must point to the DC's private IP before any client can join the domain. Azure assigns IPs via DHCP; static IPs must be set from the Azure portal, not inside the VM.
- **Account lockout is the #1 helpdesk ticket** — understanding how lockout policies work and how to quickly find and unlock accounts is essential for any IT support role.
- **PowerShell scales** — bulk-creating 50 users or resetting an entire department's passwords takes seconds compared to minutes of manual GUI work.
- **Disable, don't delete** — terminated employee accounts should be disabled first and retained for 30-90 days for legal holds before permanent deletion.

---

## Author

**Sagar Patel**
- MS Computer Science (Cybersecurity) — University of Texas at Dallas (In Progress)
- BS Computer Science (Cybersecurity) — California State University, Fullerton
- [LinkedIn](https://linkedin.com/in/sagar-patel-48612a311) | [GitHub](https://github.com/Sagarpatel9)
