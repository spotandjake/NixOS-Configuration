import * as path from '@std/path';
import { ok, err, type Result } from './utils.ts';
import {
  systemsFileSchema,
  userSchema,
  bundleSchema,
  programSchema,
  type Systems,
  type User,
  type Bundle,
  type Configuration,
  type Program,
} from './schemas.ts';
import { parse } from '@std/yaml';
// Helpers
const readFile = async (filePath: string): Promise<Result<string, string>> => {
  try {
    const contents = await Deno.readTextFile(filePath);
    return ok(contents);
  } catch (_) {
    return err(`Failed to read file ${filePath}`);
  }
};
const safeParse = (raw: string): Result<unknown, string> => {
  try {
    return { ok: parse(raw), isErr: false };
  } catch (err: unknown) {
    if (err instanceof SyntaxError) {
      return { err: err.message, isErr: true };
    } else {
      return { err: 'Failed to parse yaml', isErr: true };
    }
  }
};
// Configurations/System.yaml
export const readSystemFile = async (
  inputDirectory: string,
  users: Map<string, User>
): Promise<Result<Systems, string>> => {
  // Read The System File
  const filePath = path.join(inputDirectory, 'systems.yaml');
  const fileContents = await readFile(filePath);
  if (fileContents.isErr) return err(fileContents.err);
  // Parse The System File
  const parsed = safeParse(fileContents.ok);
  if (parsed.isErr) return err(parsed.err);
  // Validate The System File
  const { data, error, success } = systemsFileSchema.safeParse(parsed.ok);
  if (success == false) return err(error.message);
  // Ensure User Exists
  if (!data.systems.every(({ user }) => users.has(user))) {
    return data.systems.reduce((acc, { user }) => {
      if (!users.has(user))
        return err(`User ${user} does not exist in ${filePath}`);
      else return acc;
    }, err<Systems, string>('Unknown User'));
  }
  return ok(data.systems);
};
// TODO Configurations/Secrets.yaml
// Configurations/Users/*.yaml
export const readUserFiles = async (
  inputDirectory: string,
  bundles: Map<string, Bundle>
): Promise<Result<Map<string, User>, string>> => {
  const directoryPath = path.join(inputDirectory, 'users/');
  // Read The Directory
  try {
    const users = new Map();
    const userConfigs = Deno.readDir(directoryPath);
    for await (const userConfigFile of userConfigs) {
      if (userConfigFile.isFile == false) continue;
      if (path.extname(userConfigFile.name) !== '.yaml') continue;
      // Read The File
      const userConfigFilePath = path.join(directoryPath, userConfigFile.name);
      const userConfig = await readFile(userConfigFilePath);
      if (userConfig.isErr) return err(userConfig.err);
      // Parse The File
      const parsedUserConfig = safeParse(userConfig.ok);
      if (parsedUserConfig.isErr) return err(parsedUserConfig.err);
      // Validate The File
      const { data, error, success } = userSchema.safeParse(
        parsedUserConfig.ok
      );
      if (success == false) return err(error.message);
      // Deduplication
      if (users.has(data.name)) return err(`Duplicate user ${data.name}`);
      // TODO: Ensure Programs exist
      // Ensure Bundles Exist
      if (!data.bundles.every((bundleName) => bundles.has(bundleName))) {
        return data.bundles.reduce((acc, bundleName) => {
          if (!bundles.has(bundleName))
            return err(
              `Bundle ${bundleName} does not exist in ${userConfigFile}`
            );
          else return acc;
        }, err<Map<string, User>, string>('Unknown Bundle'));
      }
      // Store The File
      users.set(data.name, data);
    }
    return ok(users);
  } catch {
    return err(`Failed to read directory ${directoryPath}`);
  }
};
// Configurations/Bundles/*.yaml
export const readBundleFiles = async (
  inputDirectory: string
): Promise<Result<Map<string, Bundle>, string>> => {
  const bundleDirectory = path.join(inputDirectory, 'bundles/');
  // Read The Directory
  try {
    const bundles = new Map();
    const bundleFiles = Deno.readDir(bundleDirectory);
    for await (const bundleFile of bundleFiles) {
      if (bundleFile.isFile == false) continue;
      if (path.extname(bundleFile.name) !== '.yaml') continue;
      // Read The File
      const bundleFilePath = path.join(bundleDirectory, bundleFile.name);
      const bundleContents = await readFile(bundleFilePath);
      if (bundleContents.isErr) return err(bundleContents.err);
      // Parse The File
      const parsed = safeParse(bundleContents.ok);
      if (parsed.isErr) return err(parsed.err);
      // Validate The File
      const { data, error, success } = bundleSchema.safeParse(parsed.ok);
      if (success == false) return err(error.message);
      // Deduplication
      if (bundles.has(data.name)) return err(`Duplicate bundle ${data.name}`);
      // TODO: Ensure Programs exist
      // Store The File
      bundles.set(data.name, data);
    }
    return ok(bundles);
  } catch {
    return err(`Failed to read directory ${bundleDirectory}`);
  }
};
// Configurations/Programs/*.yaml
export const readProgramFiles = async (
  inputDirectory: string
): Promise<Result<Map<string, Program>, string>> => {
  const programDirectory = path.join(inputDirectory, 'programs/');
  // Read The Directory
  try {
    const programs = new Map();
    const programFiles = Deno.readDir(programDirectory);
    for await (const programFile of programFiles) {
      if (programFile.isDirectory == false) continue;
      const programPath = path.join(programDirectory, programFile.name);
      // Read The File
      const programContents = await readFile(
        path.join(programPath, 'program.yaml')
      );
      if (programContents.isErr) return err(programContents.err);
      // Parse The File
      const parsed = safeParse(programContents.ok);
      if (parsed.isErr) return err(parsed.err);
      // Validate The File
      const { data, error, success } = programSchema.safeParse(parsed.ok);
      if (success == false) return err(error.message);
      // Deduplication
      if (programs.has(data.name)) return err(`Duplicate program ${data.name}`);
      // Store The File
      programs.set(data.name, data);
    }
    return ok(programs);
  } catch {
    return err(`Failed to read directory ${programDirectory}`);
  }
};
// Configurations
export const getConfigurations = async (
  inputDirectory: string
): Promise<Result<Configuration, string>> => {
  // Get The Inputs
  const bundles = await readBundleFiles(inputDirectory);
  if (bundles.isErr) return bundles;
  const users = await readUserFiles(inputDirectory, bundles.ok);
  if (users.isErr) return users;
  const systems = await readSystemFile(inputDirectory, users.ok);
  if (systems.isErr) return systems;
  const programs = await readProgramFiles(inputDirectory);
  if (programs.isErr) return programs;
  // Validate The Input Strings With Zod
  return ok({
    systems: systems.ok,
    users: users.ok,
    bundles: bundles.ok,
    programs: programs.ok,
  });
};
// Add impermanence to user
// I want to either be able to write configs in nix or yaml
// nix module
// I don't know yet
// yaml configs
// The yaml configs will be converted into one of the nix module configs
// - name: string
// - descriptions: string
// - required_secrets: unknown, I don't know yet needs to be declarative
// - home-brew-packages?: string[]
// - nix-packages?: string[]
// - home-manager: unknown, from home-manager
// - configuration_mappings: unknown, needs to be dynamic
// - nix-settings: unknown, from nix
