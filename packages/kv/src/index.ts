import 'server-only';

import { Redis } from '@upstash/redis';

// Mock Redis client for E2E tests and local development
class MockRedis {
  private storage = new Map<string, string>();
  private expirations = new Map<string, NodeJS.Timeout>();

  async get(key: string) {
    const value = this.storage.get(key);
    if (!value) return null;

    try {
      // Parse JSON like real Redis does
      return JSON.parse(value);
    } catch (e) {
      // If not JSON, return as-is (for strings)
      return value;
    }
  }

  async set(key: string, value: any, options?: { ex?: number; nx?: boolean }) {
    // Clear existing expiration timer if any
    const existingTimer = this.expirations.get(key);
    if (existingTimer) {
      clearTimeout(existingTimer);
      this.expirations.delete(key);
    }

    // Handle nx flag (only set if not exists)
    if (options?.nx && this.storage.has(key)) {
      return null;
    }

    // Serialize to JSON like real Redis does
    const serialized = typeof value === 'string' ? value : JSON.stringify(value);
    this.storage.set(key, serialized);

    // Handle expiration
    if (options?.ex) {
      const timer = setTimeout(() => {
        this.storage.delete(key);
        this.expirations.delete(key);
      }, options.ex * 1000);
      this.expirations.set(key, timer);
    }

    return 'OK';
  }

  async del(key: string | string[]) {
    const keys = Array.isArray(key) ? key : [key];
    let count = 0;

    for (const k of keys) {
      if (this.storage.delete(k)) {
        count++;
        // Clear expiration timer
        const timer = this.expirations.get(k);
        if (timer) {
          clearTimeout(timer);
          this.expirations.delete(k);
        }
      }
    }

    return count;
  }

  async exists(key: string | string[]) {
    const keys = Array.isArray(key) ? key : [key];
    return keys.filter(k => this.storage.has(k)).length;
  }

  async keys(pattern: string) {
    const allKeys = Array.from(this.storage.keys());
    if (pattern === '*') return allKeys;

    // Simple pattern matching
    const regex = new RegExp('^' + pattern.replace(/\*/g, '.*').replace(/\?/g, '.') + '$');
    return allKeys.filter((key) => regex.test(key));
  }

  async expire(key: string, seconds: number) {
    if (!this.storage.has(key)) return 0;

    // Clear existing timer
    const existingTimer = this.expirations.get(key);
    if (existingTimer) {
      clearTimeout(existingTimer);
    }

    // Set new timer
    const timer = setTimeout(() => {
      this.storage.delete(key);
      this.expirations.delete(key);
    }, seconds * 1000);
    this.expirations.set(key, timer);

    return 1;
  }

  // Additional methods that might be used
  async ttl(key: string) {
    if (!this.storage.has(key)) return -2; // key doesn't exist
    if (!this.expirations.has(key)) return -1; // key exists but no expiration
    // For simplicity, return a fixed value (we don't track exact TTL)
    return 3600;
  }

  async incr(key: string) {
    const value = await this.get(key);
    const num = value ? parseInt(value, 10) : 0;
    const newValue = num + 1;
    await this.set(key, newValue.toString());
    return newValue;
  }

  async decr(key: string) {
    const value = await this.get(key);
    const num = value ? parseInt(value, 10) : 0;
    const newValue = num - 1;
    await this.set(key, newValue.toString());
    return newValue;
  }

  // Redis Lua script methods for rate limiting
  async eval(script: string, keys: string[], args: any[]) {
    // Simple rate limit simulation for local dev
    // For a real implementation, we'd need to parse and execute Lua
    // For now, just return success
    return 1;
  }

  async evalsha(sha: string, keys: string[], args: any[]) {
    // Rate limiting uses evalsha to execute cached Lua scripts
    // For local dev, simulate allowing the request
    return 1;
  }

  // Additional rate limiting support methods
  async zadd(key: string, score: number, member: string) {
    // Sorted set add - used by some rate limiters
    const data = this.storage.get(key);
    const set = data ? JSON.parse(data) : [];
    set.push({ score, member });
    // Sort by score
    set.sort((a: any, b: any) => a.score - b.score);
    this.storage.set(key, JSON.stringify(set));
    return 1;
  }

  async zremrangebyscore(key: string, min: number, max: number) {
    // Remove items from sorted set by score range
    const data = this.storage.get(key);
    if (!data) return 0;

    const set = JSON.parse(data);
    const filtered = set.filter((item: any) => item.score < min || item.score > max);
    const removed = set.length - filtered.length;

    if (filtered.length === 0) {
      this.storage.delete(key);
    } else {
      this.storage.set(key, JSON.stringify(filtered));
    }

    return removed;
  }

  async zcard(key: string) {
    // Get cardinality (count) of sorted set
    const data = this.storage.get(key);
    if (!data) return 0;
    const set = JSON.parse(data);
    return Array.isArray(set) ? set.length : 0;
  }

  async pexpire(key: string, milliseconds: number) {
    // Set expiration in milliseconds
    return this.expire(key, Math.floor(milliseconds / 1000));
  }
}

// Use mock client for E2E tests in CI or when explicitly mocked
const isE2ETest = process.env.E2E_TEST_MODE === 'true' && process.env.CI === 'true';
const isMockRequired = process.env.MOCK_REDIS === 'true';

export const client =
  isE2ETest || isMockRequired
    ? (new MockRedis() as any as Redis)
    : new Redis({
        url: process.env.UPSTASH_REDIS_REST_URL!,
        token: process.env.UPSTASH_REDIS_REST_TOKEN!,
      });

// Re-export Redis types for convenience
export type { Redis } from '@upstash/redis';
