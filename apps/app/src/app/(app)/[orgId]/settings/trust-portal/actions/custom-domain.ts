// custom-domain-action.ts

'use server';

import { authActionClient } from '@/actions/safe-action';
import { db } from '@db';
import { Vercel } from '@vercel/sdk';
import { revalidatePath, revalidateTag } from 'next/cache';
import { env } from 'node:process';
import { z } from 'zod';

const customDomainSchema = z.object({
  domain: z.string().min(1),
});

// Check if Vercel credentials are configured
const isVercelConfigured = !!(
  env.VERCEL_ACCESS_TOKEN &&
  env.TRUST_PORTAL_PROJECT_ID &&
  env.VERCEL_TEAM_ID
);

// Only initialize Vercel client if credentials are available
const vercel = isVercelConfigured
  ? new Vercel({
      bearerToken: env.VERCEL_ACCESS_TOKEN,
    })
  : null;

export const customDomainAction = authActionClient
  .inputSchema(customDomainSchema)
  .metadata({
    name: 'custom-domain',
    track: {
      event: 'add-custom-domain',
      channel: 'server',
    },
  })
  .action(async ({ parsedInput, ctx }) => {
    const { domain } = parsedInput;
    const { activeOrganizationId } = ctx.session;

    if (!activeOrganizationId) {
      throw new Error('No active organization');
    }

    try {
      const currentDomain = await db.trust.findUnique({
        where: { organizationId: activeOrganizationId },
      });

      const domainVerified =
        currentDomain?.domain === domain ? currentDomain.domainVerified : false;

      // Skip Vercel integration if not configured (local development)
      if (!vercel) {
        console.warn('Vercel credentials not configured, skipping Vercel domain setup');

        // Just store the domain in the database for local development
        await db.trust.upsert({
          where: { organizationId: activeOrganizationId },
          update: {
            domain,
            domainVerified: false, // Can't verify without Vercel in local dev
            isVercelDomain: false,
            vercelVerification: null,
          },
          create: {
            organizationId: activeOrganizationId,
            domain,
            domainVerified: false,
            isVercelDomain: false,
            vercelVerification: null,
          },
        });

        revalidatePath(`/${activeOrganizationId}/settings/trust-portal`);
        revalidateTag(`organization_${activeOrganizationId}`);

        return {
          success: true,
          needsVerification: true,
          localDevMode: true,
        };
      }

      const isExistingRecord = await vercel.projects.getProjectDomains({
        idOrName: env.TRUST_PORTAL_PROJECT_ID!,
        teamId: env.VERCEL_TEAM_ID!,
      });

      if (isExistingRecord.domains.some((record) => record.name === domain)) {
        const domainOwner = await db.trust.findUnique({
          where: {
            organizationId: activeOrganizationId,
            domain: domain,
          },
        });

        if (!domainOwner || domainOwner.organizationId === activeOrganizationId) {
          await vercel.projects.removeProjectDomain({
            idOrName: env.TRUST_PORTAL_PROJECT_ID!,
            teamId: env.VERCEL_TEAM_ID!,
            domain,
          });
        } else {
          return {
            success: false,
            error: 'Domain is already in use by another organization',
          };
        }
      }

      const addDomainToProject = await vercel.projects.addProjectDomain({
        idOrName: env.TRUST_PORTAL_PROJECT_ID!,
        teamId: env.VERCEL_TEAM_ID!,
        slug: env.TRUST_PORTAL_PROJECT_ID!,
        requestBody: {
          name: domain,
        },
      });

      const isVercelDomain = addDomainToProject.verified === false;

      // Store the verification details from Vercel if available
      const vercelVerification = addDomainToProject.verification?.[0]?.value || null;

      await db.trust.upsert({
        where: { organizationId: activeOrganizationId },
        update: {
          domain,
          domainVerified,
          isVercelDomain,
          vercelVerification,
        },
        create: {
          organizationId: activeOrganizationId,
          domain,
          domainVerified: false,
          isVercelDomain,
          vercelVerification,
        },
      });

      revalidatePath(`/${activeOrganizationId}/settings/trust-portal`);
      revalidateTag(`organization_${activeOrganizationId}`);

      return {
        success: true,
        needsVerification: !domainVerified,
      };
    } catch (error) {
      console.error(error);
      throw new Error('Failed to update custom domain');
    }
  });
