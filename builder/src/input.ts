import * as path from '@std/path';
import { ok, err, type Result } from './utils.ts';
import {
  systemsFileSchema,
  userSchema,
  bundleSchema,
  type Systems,
  type User,
  type Bundle,
  type Configuration,
} from './schemas.ts';
import { parse } from '@std/yaml';
// Helpers
const read_file = async (
  file_path: string
): Promise<Result<string, string>> => {
  try {
    const contents = await Deno.readTextFile(file_path);
    return ok(contents);
  } catch (_) {
    return err(`Failed to read file ${file_path}`);
  }
};
const safe_parse = (raw: string): Result<unknown, string> => {
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
const get_system_file_path = (input_directory: string) =>
  path.join(input_directory, 'systems.yaml');
export const read_system_file = async (
  input_directory: string,
  users: Map<string, User>
): Promise<Result<Systems, string>> => {
  // Read The System File
  const file_path = get_system_file_path(input_directory);
  const file_contents = await read_file(file_path);
  if (file_contents.isErr) return err(file_contents.err);
  // Parse The System File
  const parsed = safe_parse(file_contents.ok);
  if (parsed.isErr) return err(parsed.err);
  // Validate The System File
  const { data, error, success } = systemsFileSchema.safeParse(parsed.ok);
  if (success == false) return err(error.message);
  // Ensure User Exists
  if (!data.systems.every(({ user }) => users.has(user))) {
    return data.systems.reduce((acc, { user }) => {
      if (!users.has(user))
        return err(`User ${user} does not exist in ${file_path}`);
      else return acc;
    }, err<Systems, string>('Unknown User'));
  }
  return ok(data.systems);
};
// TODO Configurations/Secrets.yaml
// Configurations/Users/*.yaml
const get_user_directory_path = (input_directory: string) =>
  path.join(input_directory, 'users/');
export const read_user_files = async (
  input_directory: string,
  bundles: Map<string, Bundle>
): Promise<Result<Map<string, User>, string>> => {
  const directory_path = get_user_directory_path(input_directory);
  // Read The Directory
  try {
    const users = new Map();
    const user_directory_files = Deno.readDir(directory_path);
    for await (const user_file_entry of user_directory_files) {
      if (user_file_entry.isFile == false) continue;
      if (path.extname(user_file_entry.name) !== '.yaml') continue;
      // Read The File
      const user_file_path = path.join(directory_path, user_file_entry.name);
      const user_contents = await read_file(user_file_path);
      if (user_contents.isErr) return err(user_contents.err);
      // Parse The File
      const parsed = safe_parse(user_contents.ok);
      if (parsed.isErr) return err(parsed.err);
      // Validate The File
      const { data, error, success } = userSchema.safeParse(parsed.ok);
      if (success == false) return err(error.message);
      // Deduplication
      if (users.has(data.name)) return err(`Duplicate user ${data.name}`);
      // TODO: Ensure Programs exist
      // Ensure Bundles Exist
      if (!data.bundles.every((bundleName) => bundles.has(bundleName))) {
        return data.bundles.reduce((acc, bundleName) => {
          if (!bundles.has(bundleName))
            return err(
              `Bundle ${bundleName} does not exist in ${user_file_path}`
            );
          else return acc;
        }, err<Map<string, User>, string>('Unknown Bundle'));
      }
      // Store The File
      users.set(data.name, data);
    }
    return ok(users);
  } catch {
    return err(`Failed to read directory ${directory_path}`);
  }
};
// Configurations/Bundles/*.yaml
const get_bundle_directory_path = (input_directory: string) =>
  path.join(input_directory, 'bundles/');
export const read_bundle_files = async (
  input_directory: string
): Promise<Result<Map<string, Bundle>, string>> => {
  const directory_path = get_bundle_directory_path(input_directory);
  // Read The Directory
  try {
    const bundles = new Map();
    const bundle_directory_files = Deno.readDir(directory_path);
    for await (const bundle_file_entry of bundle_directory_files) {
      if (bundle_file_entry.isFile == false) continue;
      if (path.extname(bundle_file_entry.name) !== '.yaml') continue;
      // Read The File
      const bundle_file_path = path.join(
        directory_path,
        bundle_file_entry.name
      );
      const bundle_contents = await read_file(bundle_file_path);
      if (bundle_contents.isErr) return err(bundle_contents.err);
      // Parse The File
      const parsed = safe_parse(bundle_contents.ok);
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
    return err(`Failed to read directory ${directory_path}`);
  }
};
// TODO Configurations/Configs/*.yaml
// Configurations
export const get_configurations = async (
  input_directory: string
): Promise<Result<Configuration, string>> => {
  // Get The Inputs
  const bundles = await read_bundle_files(input_directory);
  if (bundles.isErr) return bundles;
  const users = await read_user_files(input_directory, bundles.ok);
  if (users.isErr) return users;
  const systems = await read_system_file(input_directory, users.ok);
  if (systems.isErr) return systems;
  // Validate The Input Strings With Zod
  return ok({
    systems: systems.ok,
    users: users.ok,
    bundles: bundles.ok,
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
