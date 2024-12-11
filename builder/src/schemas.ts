// TODO: Add an import map
import * as zod from '@zod/lib';
// TODO: Use zod to perform as many of these transformations as possible
export const darwinPlatformsSchema = zod.enum([
  'aarch64-darwin',
  'x86_64-darwin',
]);
export const linuxPlatformsSchema = zod.enum(['aarch64-linux', 'x86_64-linux']);
export const platformSchema = zod.union([
  darwinPlatformsSchema,
  linuxPlatformsSchema,
]);
export type PlatformSchema = zod.infer<typeof platformSchema>;
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
// Programs
export const baseProgramSchema = zod.strictObject({
  name: zod.string(),
  description: zod.string(),
  // Properties
  supportsDarwin: zod.boolean(),
  supportsNix: zod.boolean(),
});
export const customProgramSchema = baseProgramSchema.extend({
  defaultScript: zod.string(),
});
// TODO: Begin Adding Specific Program Schemas
export const homebrewConfiguration = zod.object({
  name: zod.string(),
  enable: zod.boolean().default(true),
});
export const yamlProgramSchema = baseProgramSchema.extend({
  supportsDarwin: zod.boolean().default(true),
  supportsLinux: zod.boolean().default(true),
  nix: zod.string().array().default([]),
  homeBrew: zod.string().array().default([]),
  homeManager: homebrewConfiguration,
});
export const programSchema = zod.union([
  customProgramSchema,
  yamlProgramSchema,
]);
export type Program = zod.infer<typeof programSchema>;
// Configurations
export type Configuration = {
  systems: Systems;
  users: Map<string, User>;
  bundles: Map<string, Bundle>;
  programs: Map<string, Program>;
};
