import * as zod from '@zod/lib';
import * as path from '@std/path';
import { parse } from '@std/yaml';
import { some, none, ok, err, type Option, type Result } from './utils.ts';
// Helpers
const getFileContent = async (
  filePath: string
): Promise<Result<string, string>> => {
  try {
    return ok(await Deno.readTextFile(filePath));
  } catch (_) {
    return err(`Failed to read file ${filePath}`);
  }
};
const getFileYaml = async (
  filePath: string
): Promise<Result<unknown, string>> => {
  const rawFileContent = await getFileContent(filePath);
  if (rawFileContent.isErr) return rawFileContent;
  try {
    return { ok: parse(rawFileContent.ok), isErr: false };
  } catch (err: unknown) {
    if (err instanceof SyntaxError) {
      return { err: err.message, isErr: true };
    } else {
      return { err: `Failed to parse ${filePath}`, isErr: true };
    }
  }
};
// Program Schema
const baseProgramSchema = zod.strictObject({
  name: zod.string(),
  description: zod.string(),
  // Properties
  supportsDarwin: zod.boolean(),
  supportsNix: zod.boolean(),
});
const customProgramSchema = baseProgramSchema.extend({
  defaultScript: zod.string(),
});
// TODO: Build custom program schema capabilities
const yamlProgramSchema = baseProgramSchema.extend({
  // TODO: Begin Adding Specific Program Schemas
  notYetImplemented: zod.null().default(null),
});
const programSchema = zod.union([customProgramSchema, yamlProgramSchema]);
export type Program = zod.infer<typeof programSchema> & {
  sourceDirectory: string;
};
const getPrograms = async (
  inputDir: string
): Promise<Result<Map<string, Program>, string>> => {
  const programs: Map<string, Program> = new Map();
  const programConfigDir = path.join(inputDir, 'programs');
  try {
    const programConfigFiles = Deno.readDir(programConfigDir);
    for await (const programDirectoryEntry of programConfigFiles) {
      // TODO: Support top level program.yaml
      if (!programDirectoryEntry.isDirectory) continue;
      const sourceDirectory = path.join(
        programConfigDir,
        programDirectoryEntry.name
      );
      const programFile = await getFileYaml(
        path.join(sourceDirectory, 'program.yaml')
      );
      if (programFile.isErr) return programFile;
      const { data, error, success } = programSchema.safeParse(programFile.ok);
      if (success == false) return err(error.message);
      programs.set(data.name, {
        ...data,
        sourceDirectory,
      });
    }
    return ok(programs);
  } catch {
    return err(`Failed to read directory ${inputDir}/programs`);
  }
};

// Regular Schemas
const programConfigurationSchema = zod.object({
  name: zod.string(),
  enable: zod.boolean().default(true),
  // TODO: Validate these later based off program options
});
type ProgramConfiguration = zod.infer<typeof programConfigurationSchema>;

const bundleSchema = zod.strictObject({
  name: zod.string(),
  description: zod.string(),
  darwin: programConfigurationSchema.array(),
  nix: programConfigurationSchema.array(),
  shared: programConfigurationSchema.array(),
});
export type Bundle = zod.infer<typeof bundleSchema>;
const getBundles = async (
  inputDir: string
): Promise<Result<Map<string, Bundle>, string>> => {
  const bundles: Map<string, Bundle> = new Map();
  const bundleConfigDir = path.join(inputDir, 'bundles');
  try {
    const bundleConfigFiles = Deno.readDir(bundleConfigDir);
    for await (const bundleDirectoryEntry of bundleConfigFiles) {
      if (!bundleDirectoryEntry.isFile) continue;
      const bundleFile = await getFileYaml(
        path.join(bundleConfigDir, bundleDirectoryEntry.name)
      );
      if (bundleFile.isErr) return bundleFile;
      const { data, error, success } = bundleSchema.safeParse(bundleFile.ok);
      if (success == false) return err(error.message);
      bundles.set(data.name, data);
    }
    return ok(bundles);
  } catch {
    return err(`Failed to read directory ${inputDir}/bundles`);
  }
};

const platformConfigSchema = zod.strictObject({
  programs: programConfigurationSchema.array(),
});
const userSchema = zod.strictObject({
  name: zod.string(),
  description: zod.string(),
  darwin: platformConfigSchema.extend({
    // TODO: Add dock settings
    dock: zod.null(),
  }),
  nix: platformConfigSchema,
  shared: platformConfigSchema,
  bundles: zod.string().array(),
});
export type User = zod.infer<typeof userSchema>;
const getUsers = async (
  inputDir: string
): Promise<Result<Map<string, User>, string>> => {
  const users: Map<string, User> = new Map();
  const userConfigDir = path.join(inputDir, 'users');
  try {
    const userConfigFiles = Deno.readDir(userConfigDir);
    for await (const userDirectoryEntry of userConfigFiles) {
      if (!userDirectoryEntry.isFile) continue;
      const userFile = await getFileYaml(
        path.join(userConfigDir, userDirectoryEntry.name)
      );
      if (userFile.isErr) return userFile;
      const { data, error, success } = userSchema.safeParse(userFile.ok);
      if (success == false) return err(error.message);
      users.set(data.name, data);
    }
    return ok(users);
  } catch {
    return err(`Failed to read directory ${inputDir}/users`);
  }
};

const systemSchema = zod.strictObject({
  name: zod.string(),
  user: zod.string(),
  platform: zod.union([
    zod.enum(['aarch64-darwin', 'x86_64-darwin']),
    zod.enum(['aarch64-linux', 'x86_64-linux']),
  ]),
  specs: zod.strictObject({
    cpu: zod.string(),
    memory: zod.number(),
    storage: zod.number(),
  }),
});
export type System = zod.infer<typeof systemSchema>;
const systemFileSchema = zod.object({ systems: zod.array(systemSchema) });
const getSystems = async (
  inputDir: string
): Promise<Result<Map<string, System>, string>> => {
  const rawSystemFile = await getFileYaml(path.join(inputDir, 'systems.yaml'));
  if (rawSystemFile.isErr) return rawSystemFile;
  const { data, error, success } = systemFileSchema.safeParse(rawSystemFile.ok);
  if (success == false) return err(error.message);
  return ok(new Map(data.systems.map((system) => [system.name, system])));
};
// Reader
export type Configuration = {
  programs: Map<string, Program>;
  bundles: Map<string, Bundle>;
  users: Map<string, User>;
  systems: Map<string, System>;
};
export const getConfiguration = async (
  inputDir: string
): Promise<Result<Configuration, string>> => {
  const programs = await getPrograms(inputDir);
  if (programs.isErr) return programs;
  const bundles = await getBundles(inputDir);
  if (bundles.isErr) return bundles;
  const users = await getUsers(inputDir);
  if (users.isErr) return users;
  const systems = await getSystems(inputDir);
  if (systems.isErr) return systems;
  return ok({
    programs: programs.ok,
    bundles: bundles.ok,
    users: users.ok,
    systems: systems.ok,
  });
};

export const isValidProgramList = (
  darwinPrograms: ProgramConfiguration[],
  nixPrograms: ProgramConfiguration[],
  sharedPrograms: ProgramConfiguration[],
  configuration: Configuration,
  errSource: string
): Option<string> => {
  const darwin = darwinPrograms
    .filter((p) => p.enable)
    .map((program) => program.name);
  const nix = nixPrograms
    .filter((p) => p.enable)
    .map((program) => program.name);
  const shared = sharedPrograms
    .filter((p) => p.enable)
    .map((program) => program.name);
  // Validate Program Exists
  for (const program of [...darwin, ...nix, ...shared]) {
    if (!configuration.programs.has(program))
      return some(
        `Program ${program} does not exist, but used by ${errSource}`
      );
  }
  // Validate Proper Support
  for (const program of darwin) {
    const programConfig = configuration.programs.get(program);
    if (programConfig == undefined) return some('Program does not exist');
    if (!programConfig.supportsDarwin)
      return some(
        `Program ${program} does not support darwin, but used by ${errSource}`
      );
  }
  for (const program of nix) {
    const programConfig = configuration.programs.get(program);
    if (programConfig == undefined) return some('Program does not exist');
    if (!programConfig.supportsNix)
      return some(
        `Program ${program} does not support nix, but used by ${errSource}`
      );
  }
  for (const program of shared) {
    const programConfig = configuration.programs.get(program);
    if (programConfig == undefined) return some('Program does not exist');
    if (!programConfig.supportsDarwin)
      return some(
        `Program ${program} does not support darwin, but used by ${errSource}`
      );
    if (!programConfig.supportsNix)
      return some(
        `Program ${program} does not support nix, but used by ${errSource}`
      );
  }
  return none();
};
export const isValidConfiguration = (
  configuration: Configuration
): Option<string> => {
  // TODO: Validate all programs fully
  // Validate Bundles
  for (const [_, bundle] of configuration.bundles) {
    const validProgramList = isValidProgramList(
      bundle.darwin,
      bundle.nix,
      bundle.shared,
      configuration,
      `bundle: ${bundle.name}`
    );
    if (validProgramList.isSome) return validProgramList;
  }
  // Validate Users
  for (const [_, user] of configuration.users) {
    const validProgramList = isValidProgramList(
      user.darwin.programs,
      user.nix.programs,
      user.shared.programs,
      configuration,
      `user: ${user.name}`
    );
    if (validProgramList.isSome) return validProgramList;
    // Validate Bundles Exist
    for (const bundle of user.bundles) {
      if (!configuration.bundles.has(bundle))
        return some(
          `Bundle ${bundle} does not exist but used by user: ${user.name}`
        );
    }
  }
  // Validate Systems
  for (const [_, system] of configuration.systems) {
    if (!configuration.users.has(system.user))
      return some(
        `User ${system.user} does not exist, but used by system: ${system.name}`
      );
  }
  return none();
};
