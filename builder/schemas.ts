// TODO: Add an import map
import * as zod from 'https://deno.land/x/zod@v3.24.0/mod.ts';

export const darwinPlatformsSchema = zod.enum([
  'aarch64-darwin',
  'x86_64-darwin',
]);
export const linuxPlatformsSchema = zod.enum(['aarch64-linux', 'x86_64-linux']);
export const platformSchema = zod.union([
  darwinPlatformsSchema,
  linuxPlatformsSchema,
]);
// Configuration Schema
export const configurationSchema = zod.strictObject({
  programs: zod.array(zod.string()),
});
export const darwinConfigurationSchema = configurationSchema.extend({
  // TODO: Add dock settings
  dock: zod.null(),
});
export const nixConfigurationSchema = configurationSchema;
// System Schema
export const systemSchema = zod.strictObject({
  name: zod.string(),
  user: zod.string(),
  platform: platformSchema,
  specs: zod.strictObject({
    cpu: zod.string(),
    memory: zod.number(),
    storage: zod.number(),
  }),
});
export const systemsSchema = zod.array(systemSchema);
export type Systems = zod.infer<typeof systemsSchema>;
export const systemsFileSchema = zod.object({ systems: systemsSchema });
// User Schema
export const userSchema = zod.strictObject({
  name: zod.string(),
  description: zod.string(),
  darwin: darwinConfigurationSchema,
  nix: nixConfigurationSchema,
  shared: configurationSchema,
  bundles: zod.array(zod.string()),
});
export type User = zod.infer<typeof userSchema>;
// Bundles
export const bundleSchema = zod.strictObject({
  name: zod.string(),
  description: zod.string(),
  darwinPrograms: zod.array(zod.string()),
  nixPrograms: zod.array(zod.string()),
  sharedPrograms: zod.array(zod.string()),
});
export type Bundle = zod.infer<typeof bundleSchema>;
