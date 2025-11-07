# **Group Health Plan ePHI Requirements**

Policy Type: HIPAA Security Policy (Specific to Group Health Plans)  
Frequency: Yearly Review  
Department: HR/Benefits  
Status: ✅ COMPLETE

## **Coverage**

This policy addresses requirements for the following HIPAA Security Rule controls:

* **Control 17**: Group Health Plan ePHI Safeguards

## **Applicability**

**⚠️ IMPORTANT APPLICABILITY NOTE:**

This policy applies ONLY to organizations that are Group Health Plans as defined by HIPAA. If {{COMPANY}} is NOT a Group Health Plan, this policy is NOT APPLICABLE and should be removed from the policy set.

### **Group Health Plan Definition**

A Group Health Plan is:

* An employee welfare benefit plan under ERISA that provides medical care  
* Includes self-insured health plans  
* Includes employer-sponsored health insurance plans with 50+ participants  
* Does NOT include fully-insured small group plans (\<50 participants)

### **Common Scenarios**

**This policy APPLIES if:**

* {{COMPANY}} sponsors a self-insured health plan  
* {{COMPANY}} has a large group health plan (50+ participants) where the plan sponsor has access to ePHI

**This policy DOES NOT APPLY if:**

* {{COMPANY}} offers fully-insured health insurance (insurance carrier is the covered entity)  
* {{COMPANY}} has a small group plan (\<50 participants)  
* {{COMPANY}} does not offer health benefits  
* {{COMPANY}} is a healthcare provider or health plan (different HIPAA rules apply)

**\[COMPLIANCE WRITER: Verify applicability before completing this policy\]**

## **Purpose**

To establish safeguards for the Group Health Plan sponsored by {{COMPANY}} by ensuring that the Plan documents mandate appropriate protection for ePHI, that there is **adequate separation** between the Plan and Plan Sponsor functions, and that the Plan Sponsor personnel with access to ePHI implement all required HIPAA Security Rule controls. This policy protects the confidentiality and integrity of Plan ePHI and ensures compliance with 45 CFR § 164.314(b).

## **Scope**

This policy applies to:

* The Group Health Plan (the Covered Entity) administered by {{COMPANY}}.  
* All **Plan Sponsor personnel** designated as part of the "Limited Class of Employees" who have access to ePHI for plan administration functions.  
* All **Plan documents** (including summary plan descriptions) and required amendments.  
* ePHI transmitted, received, or maintained by the Plan Sponsor from the Health Plan, Third-Party Administrators (TPAs), or other Business Associates.

## **Policy Statements**

### **1\. Plan Document Amendment Requirements**

The Group Health Plan documents must be formally amended to incorporate provisions ensuring the Plan Sponsor agrees to:

* Implement reasonable administrative, physical, and technical safeguards to protect ePHI.  
* Guarantee that ePHI is **not used for employment-related decisions** (e.g., hiring, termination, promotions).  
* Ensure adequate functional and physical separation is maintained between Plan and Plan Sponsor functions.  
* Report any security incident involving the Plan's ePHI to the Health Plan promptly.  
* Provide for the return or destruction of ePHI upon termination of the Plan.

#### **2\. Adequate Separation**

{{COMPANY}} shall maintain a mandatory "Chinese Wall" between health plan functions (Plan Administration) and general employer functions (Plan Sponsor).

* **Designation**: Only a **Limited Class of Employees**, as documented in the Plan documents, shall access ePHI for **plan administration functions only**.  
* **Prohibited Uses**: Workforce members are strictly prohibited from using or disclosing Plan ePHI for employment-related actions (e.g., performance evaluations, disciplinary actions, compensation decisions).  
* **Access Control**: Logical access controls and physical controls must be used to restrict access to Plan ePHI only to the designated Limited Class of Employees.

#### **3\. Plan Sponsor Safeguards**

The Plan Sponsor must apply all three types of HIPAA Security Rule safeguards to ePHI received from the Group Health Plan:

* **Administrative Safeguards**: Formal policies, risk assessments, sanction policies, and mandatory training for the Limited Class of Employees.  
* **Physical Safeguards**: Secure storage of any physical media, clean desk policy, and controlled facility access to areas where Plan ePHI is accessed or stored.  
* **Technical Safeguards**: Unique user IDs, authentication, audit logging, and **encryption** for ePHI at rest and in transit.  
* **Documentation**: All safeguards must be documented and retained for **6 years**.

#### **4\. Certification Requirement**

The Plan Sponsor must provide an annual written certification to the Health Plan (or its designated official) confirming that the Plan documents have been amended and that the Plan Sponsor is complying with all obligations outlined in those amendments and this policy.

#### **5\. Security Incident Reporting**

The Plan Sponsor must report all security incidents, attempted or successful, involving the Plan's ePHI.

* **Timeline**: The Plan Sponsor shall notify the Plan Administrator and HIPAA Privacy Official within **30 days** of discovering the incident, or sooner if required by the Plan document's specific terms.  
* **Cooperation**: The Plan Sponsor must cooperate fully with the Health Plan's breach determination and notification processes, providing all necessary incident details.

#### **6\. Third-Party Administrators (TPAs)**

If using TPAs or other Business Associates for plan administration:

* A compliant **Business Associate Agreement (BAA)** must be executed before ePHI is shared.  
* The TPA must comply with the HIPAA Security Rule and the BAA's terms regarding the safeguarding of Plan ePHI.  
* The Plan Sponsor shall conduct oversight of the TPA's security practices as part of the Third-Party Risk Management Policy.

## **Responsibilities**

| Role | Responsibility |
| :---- | :---- |
| **Group Health Plan Administrator** | Overall compliance and oversight of the Plan; initiating Plan document amendments; receiving and acting upon Plan Sponsor certification and incident reports. |
| **HR Benefits Team** | Managing the **Limited Class of Employees** list; verifying ePHI access is only used for plan administration; coordinating mandatory training. |
| **HR Operations Team** | Ensuring **NO** access to Plan ePHI for general employment functions; enforcing the separation of HR functions. |
| **HIPAA Security Officer** | Implementing and auditing the Administrative, Physical, and Technical Safeguards applied by the Plan Sponsor to Plan ePHI. |
| **Legal Counsel** | Drafting and reviewing the legal Plan document amendments (ERISA/HIPAA specialist); advising on Plan Sponsor liability. |

## **Procedures**

### **Plan Document Amendment Process**

1. Engage legal counsel specializing in ERISA and HIPAA to draft required amendment language, incorporating all 45 CFR § 164.504(f) requirements.  
2. Review the amendment with the Plan Administrator and the HIPAA Privacy/Security Officials.  
3. Obtain formal approval from the Board of Directors or Plan Committee.  
4. Distribute the amended Plan documents to all participants.  
5. Maintain all amendment records per the **6-year** HIPAA retention requirement.

### **Designating Limited Class of Employees**

1. The Group Health Plan Administrator identifies all specific job titles that require ePHI access solely for plan administration (e.g., benefits enrollment, claims appeals).  
2. The list of these specific job titles is documented and formally incorporated into the Plan documents via amendment.  
3. All employees in this designated class must complete specialized HIPAA training covering the separation of duties.  
4. The list is reviewed and updated annually or upon any significant organizational change.

### **Plan ePHI Access Request**

1. Manager submits an access request to the HSO/IAM team, verifying the employee belongs to the **Limited Class of Employees**.  
2. HSO confirms the request aligns only with Plan Administration duties (minimum necessary).  
3. Access is granted with granular role-based permissions and subject to audit logging.

### **Security Incident Reporting (Plan Sponsor to Health Plan)**

1. A security incident involving Plan ePHI is discovered by the Plan Sponsor workforce.  
2. The HSO and Privacy Official investigate the incident and assess the scope of the affected data.  
3. The Plan Sponsor provides a formal, written incident report to the Plan Administrator and the Plan's Privacy Official within the timeline established by the Plan documents (maximum **30 days**).  
4. The Plan Sponsor cooperates with the Plan's Breach Determination process, providing all necessary forensics and investigation details.

## **Plan Document Amendment Template Language**

Example language to be incorporated into Group Health Plan documents:

*"The Plan Sponsor agrees to:*

* *Implement administrative, physical, and technical safeguards that reasonably and appropriately protect the confidentiality, integrity, and availability of the electronic Protected Health Information that it creates, receives, maintains, or transmits on behalf of the Group Health Plan;*  
* *Ensure that adequate separation required by 45 CFR § 164.504(f)(2)(iii) is supported by reasonable and appropriate security measures;*  
* *Ensure that any agent, including a subcontractor, to whom it provides this information agrees to implement reasonable and appropriate security measures to protect the information;*  
* *Report to the Plan any security incident of which it becomes aware; and*  
* *Comply with the applicable requirements of Subpart C of 45 CFR Part 164 with respect to electronic Protected Health Information, to the extent that the Plan Sponsor carries out an obligation of the Plan under such Subpart."*

*"Limited Class of Employees: Only the following classes of employees shall have access to ePHI:*

* *\[Benefits Manager\]*  
* *\[HIPAA Privacy Official\]*  
* *\[Benefits Coordinator\]*  
* *\[As updated by Plan Administrator from time to time\]"*

## **Related Policies**

{{\#if hipaa}}

* HIPAA Security Management Program  
* Third-Party Risk Management & Business Associate Agreements  
* ePHI Technical Safeguards and Data Integrity  
* HIPAA Privacy Policies  
  {{/if}}

## **References**

* 45 CFR § 164.314(b) \- Requirements for Group Health Plans  
* 45 CFR § 164.314(b)(1) \- Implementation Specifications (Required)  
* 45 CFR § 164.314(b)(2)(i) \- Plan Documents  
* 45 CFR § 164.504(f) \- Group Health Plans (Privacy Rule \- related requirement)  
* HHS Guidance on Group Health Plan Compliance  
* ERISA Section 3(1) \- Employee Welfare Benefit Plan Definition

## **Document Control**

* **Policy Owner**: VP of Human Resources / HIPAA Security Officer  
* **Review Frequency**: Annually  
* **Next Review Date**: \[To be set upon adoption\]  
* **Content Status**: **✅ COMPLETE**  
* **Revision History**:  
  * v0.1 \- Template structure created  
  * v1.0 \- Content completed by Compliance Writer (2025-11-07)

## **Approval**

$$TO BE COMPLETED AFTER APPLICABILITY DETERMINED AND CONTENT FINALIZED$$

* \[ \] Vice President of Human Resources  
* \[ \] Group Health Plan Administrator  
* \[ \] HIPAA Security Officer  
* \[ \] HIPAA Privacy Official  
* \[ \] Legal Counsel (ERISA/benefits specialist)  
* \[ \] Chief Executive Officer

**Effective Date**: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

**Last Updated**: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_