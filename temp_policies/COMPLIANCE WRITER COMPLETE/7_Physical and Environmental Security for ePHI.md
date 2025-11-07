# **Physical and Environmental Security for ePHI**

Policy Type: HIPAA Security Policy  
Frequency: Yearly Review  
Department: IT/Facilities  
Status: ✅ COMPLETE

## **Coverage**

This policy consolidates requirements for the following HIPAA Security Rule controls:

* **Control 12**: Physical Facility Access Controls for ePHI  
* Elements of **Control 13**: Workstation Use and Security  
* Elements of **Control 14**: Device and Media Controls

## **Purpose**

To establish physical and environmental safeguards that protect Electronic Protected Health Information (ePHI) and the systems that create, receive, maintain, or transmit it from unauthorized physical access, theft, environmental damage (fire, water), and power outages.

## **Scope**

This policy applies to:

* All facilities and areas where ePHI systems or physical media are housed, including **server rooms, data centers, network closets, and administrative offices**.  
* All **workstations and mobile devices** used to access ePHI.  
* All **physical media** (hard drives, backup tapes, paper records) containing ePHI.  
* **Visitor access** and escort procedures within ePHI areas.

## **Policy Statements**

### **1\. Facility Access Controls**

Access to physical facilities and restricted areas housing ePHI systems (e.g., server rooms) shall be controlled and monitored 24 hours a day, 7 days a week.

* **Access System**: Access must be managed via an electronic badge access system or a functional equivalent that records access attempts (both successful and failed).  
* **Authorization**: Access levels must be granted on a **role-based, minimum necessary** standard, authorized by the employee's manager and the Director of Facilities/HSO.  
* **Review**: Access logs for restricted ePHI areas must be reviewed quarterly for anomalies.  
* **Termination**: Access badges must be deactivated immediately upon termination.

### **2\. Server Room and Data Center Security**

Server rooms and data centers must have the highest level of physical and environmental protection.

* **Access Restrictions**: Access shall be limited to designated, authorized personnel only and require at least **two-factor physical authentication** (e.g., badge \+ PIN or biometric).  
* **Video Surveillance**: **Video surveillance** must be maintained at all entry/exit points with a retention period of at least **90 days**.  
* **Secure Equipment**: Server racks must be secured (locked) to prevent unauthorized internal access, and cable management must maintain a secure environment.

### **3\. Workstation Physical Security**

Workstations accessing ePHI must be physically secured to prevent unauthorized viewing or access.

* **Placement**: Workstations should be physically positioned to prevent viewing of ePHI by unauthorized persons (e.g., away from high-traffic public areas or windows).  
* **Privacy Screens**: **Privacy screens** are required for all workstations situated in shared workspaces or areas visible to the public.  
* **Automatic Lock**: All workstations must be configured to automatically lock the screen after **15 minutes** or less of inactivity, requiring user re-authentication.  
* **Clean Desk Policy**: Workforce members must ensure all physical ePHI records and documents are secured in locked cabinets when not in use, and at the end of the business day.

### **4\. Device and Media Controls**

Physical media and devices containing ePHI must be inventoried, tracked, and securely managed throughout their lifecycle.

* **Accountability**: An accurate **inventory** of all portable devices (laptops, USB drives, backup media) containing ePHI must be maintained (Addressable §164.310(d)(2)(iii)).  
* **Encryption**: All portable media and mobile devices containing ePHI **must be encrypted** using approved standards (e.g., AES-256).  
* **Secure Storage**: Backup tapes, external drives, and other portable media must be stored securely in a locked, environmentally controlled facility or vault.  
* **Disposal**: All media must be securely disposed of using approved sanitization methods (Required §164.310(d)(2)(i)).  
* **Media Re-use**: Procedures must ensure that all ePHI is purged from media before it is reused (Required §164.310(d)(2)(ii)).  
* **Data Backup & Storage**: Storage, access, and security of backup data are governed by the ePHI Backup, Recovery, and Media Management Policy (Addressable §164.310(d)(2)(iv)).

### **5\. Visitor Access and Escort Procedures**

All visitors to areas containing ePHI systems must follow strict access procedures.

* **Sign-In/Out**: Visitors must sign a physical or electronic **Visitor Log**, provide photo identification, and be issued a temporary badge.  
* **Escort**: Visitors must be **continuously escorted** by an authorized workforce member at all times when within restricted ePHI areas.  
* **Log Retention**: Visitor Logs must be retained for a minimum of **6 years** per HIPAA documentation requirements.

### **6\. Physical Security Monitoring**

Physical security systems must be actively monitored.

* **Alarms**: Alarm systems and intrusion detection mechanisms must be in place for all secure facilities.  
* **Surveillance Review**: Video surveillance footage must be reviewed periodically and immediately following any physical security incident.  
* **Badge Audit**: Facility access badge logs shall be audited quarterly for anomalies, unauthorized access attempts, and activity by terminated personnel.

### **7\. Environmental Controls**

Critical ePHI systems must be protected from natural and environmental hazards.

* **Power**: **Uninterruptible Power Supplies (UPS)** and backup generators must be implemented and regularly tested to ensure continuity of operations during power outages.  
* **Fire Suppression**: Fire detection and suppression systems (e.g., non-water-based) must be installed in server rooms and data centers and inspected semi-annually.  
* **Water/Temperature**: Water detection sensors and temperature/humidity monitoring must be active in all server environments with alerts configured for out-of-tolerance conditions.

## **Responsibilities**

| Role | Responsibility |
| :---- | :---- |
| **Facilities Management** | Maintaining and testing physical security systems (badges, alarms, surveillance) and environmental controls (HVAC, power, fire suppression). |
| **IT Security Team** | Setting technical standards for workstation security (lock timeouts, encryption), managing badge access authorization, and performing access log reviews. |
| **HIPAA Security Officer** | Policy oversight, coordinating physical risk assessments, and ensuring compliance with all facility access controls. |
| **Physical Security Team** | Monitoring physical security systems, managing visitor access and escorts, and responding to physical security incidents. |
| **Individual Workforce Members** | Protecting their access badges, adhering to the Clean Desk Policy, and immediately reporting lost devices or security risks. |

## **Procedures**

### **Provisioning Facility Access**

1. **Request**: Manager submits a request to Facilities/Security for badge access to a restricted ePHI area, including business justification.  
2. **Authorization**: IT Security verifies the role justifies the access; the Director of Facilities approves the request.  
3. **Issuance**: Facilities issues the badge with the appropriate access level, and the access grant is documented.  
4. **Recertification**: Access is subject to the **quarterly access review** procedure.

### **Quarterly Facility Access Review**

1. **Log Pull**: IT Security pulls the access log data for all restricted ePHI areas.  
2. **Review**: HSO and IT Security review logs for after-hours access, excessive failed attempts, and non-role-related access.  
3. **Verification**: Managers are required to re-verify the continued need for their team's access.  
4. **Remediation**: Inappropriate or unnecessary access is immediately revoked.

### **Visitor Access Procedure**

1. **Arrival**: Visitor checks in at the front desk, presents photo ID, and signs the Visitor Log.  
2. **Badge**: Visitor is issued a temporary, clearly labeled visitor badge.  
3. **Escort**: The host workforce member is notified and must remain with the visitor for the entire duration of the visit, ensuring they do not access unauthorized areas or view ePHI.  
4. **Departure**: Visitor returns the badge and signs out upon departure. The Visitor Log is retained for **6 years**.

### **Physical Security Incident Response**

1. **Detection**: Incident (e.g., unauthorized entry, fire alarm) is detected by personnel or security system.  
2. **Security Team Notification**: Security/Facilities team is notified immediately to secure the area and investigate.  
3. **ePHI Impact Assessment**: The HSO is notified to assess the potential impact on ePHI and related systems.  
4. **Documentation**: Incident is logged, and corrective actions (e.g., repairing a broken door) are documented and tracked.

## **Physical Security Standards**

### **Badge Access System Requirements**

* Real-time logging of all badge events (access granted, access denied, time, user ID, location).  
* Integration with the HR system to facilitate **immediate termination of access**.  
* Audit trail retention of access logs for a minimum of **6 years**.

### **Video Surveillance Requirements**

* Cameras must cover all entry points, critical facility areas, and server rooms.  
* Footage quality must be sufficient for positive identification.  
* Retention: Video footage must be securely stored for a minimum of **90 days**.

### **Environmental Standards**

* Server room temperature: Must be maintained between **64-80°F (18-27°C)**.  
* UPS runtime: UPS systems must provide a minimum of **30 minutes** of run-time at full load to allow for safe shutdown.  
* Generator testing: Backup generators must be tested monthly and maintained annually.

## **Related Policies**

{{\#if hipaa}}

* ePHI Technical Safeguards and Data Integrity (device controls)  
* Workforce Security, Access Management, and Sanction Policy  
* HIPAA Security Management Program  
  {{/if}}

{{\#if soc2}}

* Physical Security & Environmental Controls  
* Asset Inventory and Management  
  {{/if}}

## **References**

* 45 CFR § 164.310 \- Physical Safeguards  
* 45 CFR § 164.310(a)(1) \- Facility Access Controls (Required)  
* 45 CFR § 164.310(a)(2)(i) \- Contingency Operations (Addressable)  
* 45 CFR § 164.310(b) \- Workstation Use (Required)  
* 45 CFR § 164.310(c) \- Workstation Security (Required)  
* 45 CFR § 164.310(d)(1) \- Device and Media Controls (Required)  
* 45 CFR § 164.310(d)(2)(i) \- Disposal (Addressable)  
* 45 CFR § 164.310(d)(2)(iv) \- Data Backup and Storage (Addressable)

## **Document Control**

* **Policy Owner**: Director of Facilities / HIPAA Security Officer  
* **Review Frequency**: Annually  
* **Next Review Date**:$$To be set upon adoption$$  
* **Content Status**: **✅ COMPLETE**  
* **Revision History**:  
  * v0.1 \- Template structure created  
  * v1.0 \- Content completed by Compliance Writer (2025-11-07)  
  * v1.1 \- Clarified Device and Media Controls to explicitly list all four required/addressable specifications.

## **Approval**

$$TO BE COMPLETED AFTER CONTENT FINALIZATION$$

* $$ $$  
  Director of Facilities  
* $$ $$  
  HIPAA Security Officer  
* $$ $$  
  Chief Information Security Officer  
* $$ $$  
  Chief Operations Officer  
* $$ $$  
  Chief Executive Officer

**Effective Date**: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

**Last Updated**: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_