# **ePHI Backup, Recovery, and Media Management**

Policy Type: HIPAA Security Policy  
Frequency: Yearly Review  
Department: IT  
Status: ✅ COMPLETE

## **Coverage**

This policy consolidates requirements for the following HIPAA Security Rule controls:

* **Control 8**: ePHI Data Backup & Media Management  
* **Control 9**: Emergency Mode Operations & ePHI Availability  
* **Control 11**: Disaster Recovery Planning  
* **Control 16**: Contingency Plan Testing & Revision

## **Purpose**

To establish and execute a formal Contingency Plan, including Data Backup, Disaster Recovery, and Emergency Mode Operations, ensuring that retrievable exact copies of Electronic Protected Health Information (ePHI) are available and recoverable after an emergency, system failure, or disaster, thereby maintaining the **availability** and **integrity** of ePHI.

## **Scope**

This policy applies to:

* All information systems, applications, and databases that create, receive, maintain, or transmit ePHI.  
* All backup media, storage systems, and off-site/cloud repositories used for ePHI.  
* The **Contingency Plan** encompassing Business Impact Analysis (BIA), Disaster Recovery (DR), and Business Continuity (BC) planning.  
* All media used to store, transport, or dispose of ePHI throughout its lifecycle.

## **Policy Statements**

### **1\. ePHI Data Backup Requirements**

{{COMPANY}} shall create and maintain retrievable exact copies of ePHI.

* **Frequency**: Critical ePHI databases shall be backed up at least **daily**, with more frequent snapshots/replication where required to meet RPO targets (see Section 7).  
* **Retention**: Backup data shall be retained for a minimum of **6 years** in alignment with HIPAA documentation requirements.  
* **3-2-1 Rule**: Backups must adhere to the 3-2-1 rule (3 copies of data, 2 different media types, 1 copy off-site or air-gapped).  
* **Encryption**: All backup data must be **encrypted at rest** using AES-256 or higher, and the encryption keys must be managed separately from the backup data itself.  
* **Off-Site Storage**: At least one full copy of ePHI backups must be stored in a secured, geographically separate location or cloud region to protect against regional disasters.

### **2\. Backup Testing and Restoration**

Regular testing of backups is mandatory to validate data integrity and recovery capability.

* **Monthly Verification**: Automated verification (checksums/hashes) shall confirm backup integrity monthly.  
* **Quarterly Restoration Test**: IT Operations shall perform sample restoration tests on a quarterly basis to a secure, isolated test environment.  
* **Annual DR Test**: A comprehensive, full **Disaster Recovery (DR) test** shall be performed annually, simulating a failure scenario and measuring actual Recovery Time Objectives (RTO) and Recovery Point Objectives (RPO).  
* **Documentation**: All test results, including RTO/RPO metrics and deficiencies, must be documented and reviewed by the HSO.

### **3\. Disaster Recovery Planning**

A formal, documented Disaster Recovery Plan (DRP) must be maintained to restore ePHI access after a disaster.

* **RTO/RPO Targets**: RTO (time to recovery) and RPO (maximum acceptable data loss) targets must be defined based on the criticality of each ePHI system (See Section 7).  
* **Runbooks**: Detailed, step-by-step procedures (runbooks) must be maintained for system restoration and failover procedures.  
* **Scenario Planning**: The DRP shall account for common disaster scenarios, including regional disasters, cyberattacks (e.g., ransomware), and major system failures.

### **4\. Emergency Mode Operations**

Procedures must be in place to enable continued, critical operations in the event of a system failure.

* **Criticality Analysis**: Systems and data required for **essential patient care and business functions** must be identified (Business Impact Analysis).  
* **Downtime Procedures**: Documented manual or temporary processes must be available for use when critical ePHI systems are unavailable.  
* **Emergency Access**: Procedures for accessing the minimum necessary ePHI during emergency mode (e.g., printouts, emergency local databases) must be documented, tested, and all **usage must be logged and audited**.

### **5\. Business Continuity Planning**

The Business Continuity Plan (BCP) ensures essential business functions continue during and after a disaster.

* **Staffing**: Procedures for identifying and notifying essential personnel and communicating during a disaster.  
* **Alternate Locations**: Identification and preparation of alternate physical work locations or virtualized environments to maintain operations.

### **6\. Contingency Plan Testing and Revision**

The Contingency Plan (BCP/DRP) must be actively managed and tested.

* **Testing Frequency**: **Quarterly restoration tests** and annual disaster recovery exercises (via tabletop or live exercise) must be conducted.  
* **Revision**: The plan must be updated immediately following any significant changes to the ePHI environment, or upon identification of gaps during testing or an actual incident.  
* **Lessons Learned**: A post-test or post-incident review must be conducted to identify weaknesses and generate documented corrective actions.

### **7\. Media Management**

All media used for ePHI storage or transport must be controlled.

* **Inventory**: All backup tapes and portable storage media containing ePHI must be tracked and inventoried (accountability).  
* **Transportation**: Media containing ePHI must be **encrypted** and transported via a secure, verifiable method (e.g., bonded courier) with a clear chain of custody.  
* **Secure Disposal**: All media must be securely disposed of using sanitization methods defined below.

## **Responsibilities**

| Role | Responsibility |
| :---- | :---- |
| **IT Operations Team** | Executing, monitoring, and verifying daily backup procedures, managing backup media, and performing regular restoration tests. |
| **HIPAA Security Officer** | Overall oversight of the Contingency Plan, coordinating annual DR testing, reviewing test results, and approving plan revisions. |
| **Business Continuity Manager** | Leading Business Impact Analysis (BIA), maintaining the Disaster Recovery Plan (DRP) and Business Continuity Plan (BCP), and declaring a disaster event. |
| **System Administrators** | Configuring backup software, ensuring encryption is enabled, and managing the secure storage and rotation of backup keys. |
| **Executive Leadership** | Formally approving the Contingency Plan, authorizing necessary resources, and formally declaring the move into or out of emergency mode operations. |

## **Procedures**

### **Daily Backup Procedure**

1. **Execution**: Automated full or incremental backups of all ePHI systems run nightly.  
2. **Verification**: Backup completion and integrity are verified by IT Operations each morning.  
3. **Off-Site Copy**: Verified backups are automatically replicated to the secure, geo-redundant off-site or cloud storage location.  
4. **Failure Response**: Any backup failures trigger a **{{CRITICAL}}** alert requiring investigation and resolution within 4 hours.

### **Annual Disaster Recovery Test**

1. **Scenario Definition**: The BCM and HSO define a realistic, challenging disaster scenario (e.g., primary data center failure).  
2. **Activation**: The DR team activates documented DR procedures.  
3. **Restoration**: Systems are restored or failed over to the alternate site according to the DRP Runbook.  
4. **Validation**: Key ePHI system owners validate data integrity and functionality.  
5. **Metrics**: Actual RTO/RPO achieved is compared to targets.  
6. **Review**: HSO leads the post-test "Lessons Learned" review and updates the DRP.

### **Disaster Declaration and Activation**

1. **Incident Assessment**: BCM assesses the scope and severity of a disruptive event.  
2. **Declaration**: Executive Leadership formally declares a disaster.  
3. **Communication**: BCM initiates the Emergency Communication Plan for workforce, key partners, and patients.  
4. **Execution**: The DR Team executes the DRP to restore or failover critical ePHI systems.

### **Media Disposal Procedure**

1. **Identification**: Media for disposal (e.g., end-of-life hard drives, expired backup tapes) is identified.  
2. **Sanitization**: Media is sanitized using **DoD 5220.22-M (7-pass wipe)** or a cryptographically secure erase utility, rendering data unrecoverable.  
3. **Destruction**: If sanitization fails or is not feasible (e.g., SSDs), the media must be **physically destroyed** (shredded, crushed, or incinerated).  
4. **Certification**: For third-party destruction, a **Certificate of Destruction** must be obtained and retained for **6 years**.  
5. **Inventory Update**: The asset inventory is updated to record the disposal.

## **Recovery Objectives**

| System Criticality | RTO (Recovery Time Objective) | RPO (Recovery Point Objective) | Backup Frequency |
| :---- | :---- | :---- | :---- |
| **Critical** (EHR, Core ePHI DBs) | **4 hours** | **1 hour** | Continuous replication \+ hourly snapshots |
| **High** (Billing, Scheduling) | 24 hours | 4 hours | Hourly snapshots |
| **Medium** (Reporting, Analytics) | 72 hours | 24 hours | Daily backups |

## **Related Policies**

{{\#if hipaa}}

* HIPAA Security Management Program  
* ePHI Technical Safeguards and Data Integrity  
* Security Incident Response & HIPAA Breach Notification  
* Physical and Environmental Security for ePHI (environmental controls)  
  {{/if}}

{{\#if soc2}}

* Backup, Business Continuity & Disaster Recovery  
* Retention & Secure Disposal  
  {{/if}}

## **References**

* 45 CFR § 164.308(a)(7)(i) \- Contingency Plan (Required)  
* 45 CFR § 164.308(a)(7)(ii)(A) \- Data Backup Plan (Required)  
* 45 CFR § 164.308(a)(7)(ii)(B) \- Disaster Recovery Plan (Required)  
* 45 CFR § 164.308(a)(7)(ii)(C) \- Emergency Mode Operation Plan (Required)  
* 45 CFR § 164.308(a)(7)(ii)(D) \- Testing and Revision Procedures (Addressable)  
* 45 CFR § 164.310(d)(2)(iv) \- Data Backup and Storage (Addressable)  
* NIST SP 800-34 \- Contingency Planning Guide for Federal Information Systems

## **Document Control**

* **Policy Owner**: Chief Technology Officer / HIPAA Security Officer  
* **Review Frequency**: Annually or after significant incidents  
* **Next Review Date**: \[To be set upon adoption\]  
* **Content Status**: **✅ COMPLETE**  
* **Revision History**:  
  * v0.1 \- Template structure created  
  * v1.0 \- Content completed by Compliance Writer (2025-11-07)  
  * v1.1 \- Added "log all use" to Emergency Mode Operations and formalized "Quarterly Restoration Tests" requirement.

## **Approval**

$$TO BE COMPLETED AFTER CONTENT FINALIZATION$$

* \[ \] Chief Technology Officer  
* \[ \] HIPAA Security Officer  
* \[ \] Business Continuity Manager  
* \[ \] Chief Information Security Officer  
* \[ \] Chief Executive Officer

**Effective Date**: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

**Last Updated**: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_