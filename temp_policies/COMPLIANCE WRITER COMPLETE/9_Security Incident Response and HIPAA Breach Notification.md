# **Security Incident Response and HIPAA Breach Notification**

Policy Type: HIPAA Security Policy  
Frequency: Yearly Review  
Department: IT/Legal  
Status: ✅ COMPLETE

## **Coverage**

This policy consolidates requirements for the following HIPAA Security Rule controls:

* **Control 10**: Security Incident Response & HIPAA Breach Notification  
* Elements of Security Incident Management

## **Purpose**

To establish formal procedures for identifying, responding to, and documenting security incidents, and to ensure timely and compliant determination and notification in the event of an Electronic Protected Health Information (ePHI) **Breach**, in accordance with the HIPAA Breach Notification Rule.

## **Scope**

This policy applies to:

* All **security incidents** (successful or attempted) affecting the confidentiality, integrity, or availability of ePHI systems.  
* All **suspected or confirmed breaches** of unsecured ePHI.  
* All workforce members, who are required to report incidents.  
* The **Incident Response Team (IRT)** and the processes for **Breach Determination** and notification (to individuals, HHS, and media).  
* Business associates, as their incident reporting obligations are managed through their BAA.

## **Policy Statements**

### **1\. Security Incident Definition**

A security incident is the attempted or successful unauthorized access, use, disclosure, modification, or destruction of ePHI, or interference with system operations in an information system. Examples include:

* Successful hacking or malware/ransomware infection.  
* Lost or stolen devices containing unencrypted ePHI.  
* Unauthorized viewing or access to ePHI by a workforce member.  
* Failure of system integrity checks or audit controls.  
* Improper disposal or transfer of ePHI.

### **2\. Incident Reporting Requirements**

All workforce members must report any suspected or actual security incident **immediately**.

* **Timing**: Critical incidents (e.g., active ransomware, system down) must be reported within **1 hour** of discovery. All other incidents must be reported within **4 hours**.  
* **Channels**: Reporting must utilize established channels (e.g., IT Security hotline, service desk, or the Security Incident Portal).  
* **No Retaliation**: Workforce members who report incidents in good faith shall not face retaliation or disciplinary action.  
* **Business Associates**: Business associates must report incidents involving {{COMPANY}} ePHI within **30 days** of discovery, per the BAA.

### **3\. Incident Response Team**

{{COMPANY}} shall maintain a cross-functional **Incident Response Team (IRT)** to manage all security incidents.

* **Core Team**: HIPAA Security Officer (Lead), Privacy Officer, IT Security Team (Technical Lead), Legal Counsel.  
* **Extended Team**: HR, Communications/PR, and Executive Leadership (for high-severity incidents).  
* **Training**: The IRT shall participate in incident response drills or tabletop exercises at least **annually**.

### **4\. Incident Response Process**

All incidents shall follow a formal response lifecycle:

* **Detection & Triage**: Log the incident, classify its severity (see Section 7), and assign IRT members.  
* **Containment**: Immediate actions to limit the scope and impact (e.g., isolate systems, revoke access, suspend credentials).  
* **Investigation**: Determine the root cause, timeline, and scope of affected data/systems (forensics).  
* **Eradication & Recovery**: Eliminate the threat, patch vulnerabilities, and restore systems from a clean backup.  
* **Post-Incident Review**: Conduct a **"Lessons Learned"** session to identify gaps and develop corrective actions.

### **5\. ePHI Breach Determination (4-Part Test)**

If an incident involves an impermissible use or disclosure of ePHI, the Privacy Officer and Legal Counsel must apply the **4-Part Breach Determination Test** to assess the risk of compromise:

1. **Nature and Extent**: What ePHI was involved (e.g., SSN, clinical notes, name/address)?  
2. **Unauthorized Person**: Who accessed the ePHI (external hacker vs. internal employee)?  
3. **Acquisition/Viewing**: Was the ePHI actually acquired or viewed?  
4. **Mitigation**: Extent to which risk has been mitigated (e.g., encryption, immediate recovery).  
* **Low Probability Exception**: An incident is **not a breach** only if a detailed risk assessment demonstrates a **low probability** that the ePHI has been compromised. The decision and supporting evidence must be fully documented.

### **6\. Breach Notification to Individuals**

If an incident is determined to be a Breach of Unsecured PHI, notification must follow strict timelines.

* **Timeline**: Notification must be sent to all affected individuals without unreasonable delay and in no case later than **60 calendar days** from the date of discovery.  
* **Method**: First-class mail to the last known address or by agreed-upon electronic means (e.g., secure email).  
* **Content**: The notice must include a brief description of what happened, the types of information involved, steps the individual should take to protect themselves, and contact information (toll-free number).

### **7\. Breach Notification to HHS (Office for Civil Rights)**

Notification to the Secretary of HHS (OCR) is mandatory.

* **Breaches Affecting 500+ Individuals**: Must be reported to HHS concurrently with notification to individuals (within **60 calendar days** of discovery).  
* **Breaches Affecting \<500 Individuals**: Must be reported annually, no later than **60 days** after the end of the calendar year in which the breach was discovered.  
* **Submission**: All reports must be submitted electronically via the HHS Breach Portal.

### **8\. Breach Notification to Media (if applicable)**

If a breach affects **500 or more residents in a single State or jurisdiction**, notice must be provided to the media serving that area.

* **Timeline**: Concurrently with notification to individuals (within **60 calendar days** of discovery).  
* **Method**: Prominent media outlets (e.g., major newspaper, television station).

### **9\. Incident Documentation**

All security incidents (breach and non-breach) must be documented in the incident management system.

* **Retention**: All documentation related to incidents, investigations, breach determination, and notifications must be retained for a minimum of **6 years** (Required §164.316(b) and §164.530(j)).

## **Responsibilities**

| Role | Responsibility |
| :---- | :---- |
| **HIPAA Security Officer** | Leads the IRT, manages the incident response process, and co-signs the official Breach Determination Document. |
| **Privacy Officer** | Leads the **Breach Determination Analysis** (4-part test), drafts notification language, and handles communication with individuals/HHS. |
| **IT Security Team** | Responsible for technical investigation, containment (forensics), eradication of threats, and system recovery. |
| **Legal Counsel** | Provides guidance on breach determination risk assessment, reviews all notification language, and advises on regulatory compliance. |
| **Public Relations** | Manages all external communication and media notifications for breaches involving 500+ individuals. |
| **All Workforce Members** | Promptly reporting all suspected security incidents via official channels. |

## **Procedures**

### **Security Incident Reporting and Initial Response**

1. **Report**: Workforce member reports incident to the IT Security hotline/portal.  
2. **Triage**: IT Security logs the incident, classifies severity (Critical/High/Medium/Low), and notifies the HSO if ePHI is potentially involved.  
3. **Containment**: IT Security implements immediate containment actions (e.g., isolating a compromised network segment).  
4. **Escalation**: If classified as Critical or High, the IRT (Security, Privacy, Legal) is convened immediately.

### **ePHI Breach Investigation and Determination**

1. **Investigation**: IRT Technical Lead conducts forensic analysis to determine the scope (affected systems, users, and ePHI data types).  
2. **4-Part Test**: Privacy Officer and Legal Counsel apply the 4-part risk assessment criteria (Section 5\) to the findings.  
3. **Determination**: A formal **Breach Determination Document** is created, justifying the final decision (Breach or Low Probability of Compromise).  
4. **Sign-off**: HSO and Privacy Officer sign the document. If a breach is confirmed, proceed to notification procedures.

### **Breach Notification to Individuals (500+ individuals)**

1. **Drafting**: Privacy Officer and Legal draft the notification letter, ensuring all required elements (45 CFR 164.404) are included.  
2. **Approval**: Executive Leadership and Legal Counsel approve the final notification content.  
3. **Distribution**: Notification is mailed via first-class mail within the **60-day deadline**.  
4. **HHS/Media**: PR and Privacy Officer ensure concurrent notification to HHS and the Media (if applicable).

### **Post-Incident Review**

1. **Meeting**: The IRT holds a review meeting within **7 days** of incident closure.  
2. **Analysis**: Review the incident timeline, identify root causes, and assess the effectiveness of the response.  
3. **Corrective Action**: Develop a detailed Corrective Action Plan (CAP) with owners and deadlines to prevent recurrence.  
4. **Update**: HSO updates the Incident Response Plan and relevant security policies based on lessons learned.

## **Incident Severity Classification**

| Severity | Description | Response SLA | Breach Notification |
| :---- | :---- | :---- | :---- |
| **Critical** | Active cyberattack (ransomware), loss of major ePHI system, or confirmed breach of **500+** individuals. | **1 Hour** | Immediate Breach Procedures |
| **High** | Lost/stolen unencrypted ePHI device, unauthorized privileged access, or confirmed breach of **100-499** individuals. | **4 Hours** | Immediate Breach Procedures |
| **Medium** | Minor policy violation involving ePHI, suspected unauthorized internal access, or breach of **10-99** individuals. | 24 Hours | Immediate Breach Procedures |
| **Low** | Failed login attempts, minor policy violation (non-ePHI), or breach of **\<10** individuals. | 72 Hours | Log for Annual HHS Report |

## **Breach Notification Content Template**

Breach notification letters must include the following information:

1. **Description of What Happened**: Date of the breach and discovery date.  
2. **Types of PHI Involved**: Specific data elements exposed (e.g., Name, DOB, SSN, Diagnosis, Financial Account Number).  
3. **Steps Individuals Should Take**: Guidance on credit monitoring, password resets, or contact with healthcare providers.  
4. **Organization Actions**: Description of the investigation, mitigation, and corrective actions taken to prevent future breaches.  
5. **Contact Information**: Clear contact details (toll-free number, email, website) for individuals to ask questions.

## **Related Policies**

{{\#if hipaa}}

* HIPAA Security Management Program  
* ePHI Audit Logging and Monitoring  
* HIPAA Privacy Policies (coordinate with Privacy Officer)  
* Third-Party Risk Management & Business Associate Agreements  
  {{/if}}

{{\#if soc2}}

* Incident Response & Breach Notification  
* Security Monitoring & Detection  
  {{/if}}

## **References**

* 45 CFR § 164.308(a)(6) \- Security Incident Procedures (Required)  
* 45 CFR § 164.308(a)(6)(ii) \- Response and Reporting (Required)  
* HIPAA Breach Notification Rule \- 45 CFR §§ 164.400-414  
* 45 CFR § 164.404 \- Notification to Individuals  
* 45 CFR § 164.408 \- Notification to the Secretary (HHS)  
* 45 CFR § 164.410 \- Notification by a Business Associate  
* 45 CFR § 164.530(j) \- Documentation Retention (Privacy Rule \- related requirement)

## **Document Control**

* **Policy Owner**: HIPAA Security Officer / Chief Privacy Officer  
* **Review Frequency**: Annually or after significant breaches  
* **Next Review Date**: \[To be set upon adoption\]  
* **Content Status**: **✅ COMPLETE**  
* **Revision History**:  
  * v0.1 \- Template structure created  
  * v1.0 \- Content completed by Compliance Writer (2025-11-07)  
  * v1.1 \- Added explicit reference to Privacy Rule documentation retention requirement (§164.530(j)).

## **Approval**

$$TO BE COMPLETED AFTER CONTENT FINALIZATION$$

* \[ \] HIPAA Security Officer  
* \[ \] Chief Privacy Officer  
* \[ \] Chief Information Security Officer  
* \[ \] Legal Counsel  
* \[ \] Chief Executive Officer

**Effective Date**: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

**Last Updated**: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_