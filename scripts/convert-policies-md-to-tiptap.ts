#!/usr/bin/env tsx
/**
 * Convert markdown policy files to Tiptap JSON format
 *
 * Usage: npx tsx scripts/convert-policies-md-to-tiptap.ts
 */

import fs from 'fs';
import path from 'path';

// Directory containing markdown policies
const POLICIES_DIR = path.join(process.cwd(), 'temp_policies', 'COMPLIANCE WRITER COMPLETE');
const OUTPUT_FILE = path.join(process.cwd(), 'packages/db/prisma/seed/primitives', 'FrameworkEditorPolicyTemplate_HIPAA_NEW.json');

// Map policy files to their metadata
const POLICY_METADATA = [
  {
    file: '1_third_party_risk_management_baa.md',
    id: 'frk_pt_hipaa_third_party_baa',
    name: 'Third-Party Risk Management & Business Associate Agreements',
    description: 'Ensures appropriate Business Associate Agreements (BAAs) with all vendors who handle ePHI.',
    frequency: 'yearly',
    department: 'admin'
  },
  {
    file: '2_ephi_audit_logging_monitoring.md',
    id: 'frk_pt_hipaa_audit_logging',
    name: 'ePHI Audit Logging & Monitoring',
    description: 'Establishes audit logging and monitoring requirements for ePHI access and system activity.',
    frequency: 'yearly',
    department: 'it'
  },
  {
    file: '3_ephi_technical_safeguards_data_integrity.md',
    id: 'frk_pt_hipaa_technical_safeguards',
    name: 'ePHI Technical Safeguards & Data Integrity',
    description: 'Implements technical safeguards including access controls, encryption, and authentication for ePHI.',
    frequency: 'yearly',
    department: 'it'
  },
  {
    file: '4_HIPAA Security Management Program.md',
    id: 'frk_pt_hipaa_security_program',
    name: 'HIPAA Security Management Program',
    description: 'Establishes the overall HIPAA security management program.',
    frequency: 'yearly',
    department: 'admin'
  },
  {
    file: '5_HIPAA Security Awareness and Workforce Training Program.md',
    id: 'frk_pt_hipaa_awareness_training',
    name: 'HIPAA Security Awareness & Workforce Training',
    description: 'Defines security awareness and training requirements for workforce members.',
    frequency: 'yearly',
    department: 'hr'
  },
  {
    file: '6_Workforce Security, Access Management, and Sanction Policy.md',
    id: 'frk_pt_hipaa_workforce_security',
    name: 'Workforce Security, Access Management, & Sanction',
    description: 'Establishes workforce security procedures and access management.',
    frequency: 'yearly',
    department: 'hr'
  },
  {
    file: '7_Physical and Environmental Security for ePHI.md',
    id: 'frk_pt_hipaa_physical_security',
    name: 'Physical & Environmental Security for ePHI',
    description: 'Defines physical and environmental security safeguards.',
    frequency: 'yearly',
    department: 'it'
  },
  {
    file: '8_ePHI Backup, Recovery, and Media Management.md',
    id: 'frk_pt_hipaa_backup_recovery',
    name: 'ePHI Backup, Recovery, & Media Management',
    description: 'Establishes procedures for backing up ePHI and disaster recovery.',
    frequency: 'yearly',
    department: 'it'
  },
  {
    file: '9_Security Incident Response and HIPAA Breach Notification.md',
    id: 'frk_pt_hipaa_incident_response',
    name: 'Security Incident Response & HIPAA Breach Notification',
    description: 'Defines procedures for security incidents and breach notification.',
    frequency: 'yearly',
    department: 'it'
  },
  {
    file: '10_Group Health Plan ePHI Requirements.md',
    id: 'frk_pt_hipaa_group_health_plan',
    name: 'Group Health Plan ePHI Requirements',
    description: 'Establishes requirements for group health plans as covered entities.',
    frequency: 'yearly',
    department: 'hr'
  }
];

/**
 * Simple markdown to Tiptap JSON converter
 */
function markdownToTiptapJSON(markdown: string): any[] {
  const lines = markdown.split('\n');
  const content: any[] = [];
  let inList = false;
  let listItems: any[] = [];

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    // Skip empty lines at document start
    if (content.length === 0 && line.trim() === '') continue;

    // Heading detection
    if (line.startsWith('####')) {
      if (inList) {
        content.push({ type: 'bulletList', content: listItems });
        listItems = [];
        inList = false;
      }
      content.push({
        type: 'heading',
        attrs: { level: 4, textAlign: null },
        content: [{ type: 'text', text: line.replace(/^####\s*/, '') }]
      });
    } else if (line.startsWith('###')) {
      if (inList) {
        content.push({ type: 'bulletList', content: listItems });
        listItems = [];
        inList = false;
      }
      content.push({
        type: 'heading',
        attrs: { level: 3, textAlign: null },
        content: [{ type: 'text', text: line.replace(/^###\s*/, '') }]
      });
    } else if (line.startsWith('##')) {
      if (inList) {
        content.push({ type: 'bulletList', content: listItems });
        listItems = [];
        inList = false;
      }
      content.push({
        type: 'heading',
        attrs: { level: 2, textAlign: null },
        content: [{ type: 'text', text: line.replace(/^##\s*/, '') }]
      });
    } else if (line.startsWith('#')) {
      if (inList) {
        content.push({ type: 'bulletList', content: listItems });
        listItems = [];
        inList = false;
      }
      content.push({
        type: 'heading',
        attrs: { level: 1, textAlign: null },
        content: [{ type: 'text', text: line.replace(/^#\s*/, '') }]
      });
    }
    // Bullet list item
    else if (line.match(/^[-*]\s/)) {
      const text = line.replace(/^[-*]\s*/, '');
      listItems.push({
        type: 'listItem',
        content: [{
          type: 'paragraph',
          attrs: { textAlign: null },
          content: [{ type: 'text', text }]
        }]
      });
      inList = true;
    }
    // Horizontal rule
    else if (line.match(/^---+$/)) {
      if (inList) {
        content.push({ type: 'bulletList', content: listItems });
        listItems = [];
        inList = false;
      }
      content.push({ type: 'horizontalRule' });
    }
    // Checkbox items
    else if (line.match(/^-\s\[\s\]/)) {
      const text = line.replace(/^-\s\[\s\]\s*/, '');
      if (inList && listItems.length > 0) {
        content.push({ type: 'bulletList', content: listItems });
        listItems = [];
      }
      listItems.push({
        type: 'listItem',
        content: [{
          type: 'paragraph',
          attrs: { textAlign: null },
          content: [{ type: 'text', text: `☐ ${text}` }]
        }]
      });
      inList = true;
    }
    // Regular paragraph
    else if (line.trim() !== '') {
      if (inList) {
        content.push({ type: 'bulletList', content: listItems });
        listItems = [];
        inList = false;
      }

      // Handle bold text
      let textContent = line;
      const boldMatches = textContent.match(/\*\*(.*?)\*\*/g);

      if (boldMatches) {
        const parts: any[] = [];
        let remaining = textContent;

        while (remaining) {
          const boldMatch = remaining.match(/\*\*(.*?)\*\*/);
          if (boldMatch) {
            // Add text before bold
            const before = remaining.substring(0, boldMatch.index);
            if (before) parts.push({ type: 'text', text: before });

            // Add bold text
            parts.push({
              type: 'text',
              text: boldMatch[1],
              marks: [{ type: 'bold' }]
            });

            remaining = remaining.substring(boldMatch.index! + boldMatch[0].length);
          } else {
            // Add remaining text
            if (remaining) parts.push({ type: 'text', text: remaining });
            break;
          }
        }

        content.push({
          type: 'paragraph',
          attrs: { textAlign: null },
          content: parts
        });
      } else {
        content.push({
          type: 'paragraph',
          attrs: { textAlign: null },
          content: [{ type: 'text', text: textContent }]
        });
      }
    }
    // Empty line - close any open list
    else if (line.trim() === '' && inList) {
      content.push({ type: 'bulletList', content: listItems });
      listItems = [];
      inList = false;
    }
  }

  // Close any remaining list
  if (inList && listItems.length > 0) {
    content.push({ type: 'bulletList', content: listItems });
  }

  return content;
}

/**
 * Extract content from markdown file (remove metadata header)
 */
function extractMarkdownContent(markdown: string): string {
  // Remove metadata at top (lines before first ##)
  const lines = markdown.split('\n');
  const firstHeadingIndex = lines.findIndex(line => line.startsWith('##'));

  if (firstHeadingIndex === -1) return markdown;

  return lines.slice(firstHeadingIndex).join('\n');
}

async function convertPolicies() {
  console.log('Converting markdown policies to Tiptap JSON...\n');

  const policies = [];

  for (const policy of POLICY_METADATA) {
    const filePath = path.join(POLICIES_DIR, policy.file);

    console.log(`Converting: ${policy.file}`);

    if (!fs.existsSync(filePath)) {
      console.error(`  ❌ File not found: ${filePath}`);
      continue;
    }

    try {
      // Read markdown file
      const markdown = fs.readFileSync(filePath, 'utf-8');

      // Extract content (remove metadata)
      const content = extractMarkdownContent(markdown);

      // Convert to Tiptap JSON
      const tiptapContent = markdownToTiptapJSON(content);

      // Create policy object
      const policyObject = {
        id: policy.id,
        name: policy.name,
        description: policy.description,
        frequency: policy.frequency,
        department: policy.department,
        content: tiptapContent,
        createdAt: new Date().toISOString().replace('T', ' ').substring(0, 23),
        updatedAt: new Date().toISOString().replace('T', ' ').substring(0, 23)
      };

      policies.push(policyObject);
      console.log(`  ✓ Converted successfully`);
      console.log(`    - ${tiptapContent.length} content nodes`);

    } catch (error: any) {
      console.error(`  ❌ Error converting ${policy.file}:`, error.message);
    }
  }

  // Write to output file
  const outputDir = path.dirname(OUTPUT_FILE);
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(policies, null, 2));

  console.log(`\n✅ Conversion complete!`);
  console.log(`   Converted ${policies.length} policies`);
  console.log(`   Output: ${OUTPUT_FILE}`);
  console.log(`\n📋 Next steps:`);
  console.log(`   1. Review the generated JSON file`);
  console.log(`   2. Merge with existing FrameworkEditorPolicyTemplate.json`);
  console.log(`   3. Run seed: npm run db:seed`);
}

// Run conversion
convertPolicies().catch(console.error);
