import { Eta } from '@eta-dev/eta';
import * as path from '@std/path';
import { copy } from '@std/fs';
import { ok, err, type Result } from './utils.ts';
import {
  type PlatformSchema,
  type Configuration,
  type User,
} from './schemas.ts';
// Build Configurations
enum SystemPlatform {
  Darwin,
  NixOs,
}
const getSystemPlatform = (platform: PlatformSchema): SystemPlatform => {
  switch (platform) {
    case 'aarch64-darwin':
    case 'x86_64-darwin':
      return SystemPlatform.Darwin;
    case 'aarch64-linux':
    case 'x86_64-linux':
      return SystemPlatform.NixOs;
  }
};
type DarwinUser = {
  platform: SystemPlatform.Darwin;
  raw_platform: string;
  username: string;
  homeDirectory: string;
};
type NixOsUser = {
  platform: SystemPlatform.NixOs;
  raw_platform: string;
  username: string;
  homeDirectory: string;
};
type SystemUser = DarwinUser | NixOsUser;
const getUserInfo = (
  platform: SystemPlatform,
  raw_platform: string,
  username: string,
  users: Map<string, User>
): Result<SystemUser, string> => {
  const user = users.get(username);
  if (user == undefined) return err(`User ${username} Not Found`);
  switch (platform) {
    case SystemPlatform.Darwin:
      return ok({
        platform,
        raw_platform,
        username,
        homeDirectory: `/Users/${username}`,
        home_manager: [],
      });
    case SystemPlatform.NixOs:
      return ok({
        platform,
        raw_platform,
        username,
        homeDirectory: `/home/${username}`,
        home_manager: [],
      });
  }
};
const clear_output = async (output_dir: string) => {
  try {
    await Deno.remove(output_dir, { recursive: true });
  } catch (_) {
    // Do Nothing
  }
};
const create_folder = async (out_dir: string, folder: string) => {
  await Deno.mkdir(path.join(out_dir, folder), { recursive: true });
};
const write_output = async (output_dir: string, file: string, data: string) => {
  await Deno.writeTextFile(path.join(output_dir, file), data, { create: true });
};
export const set_configurations = async (
  configurations: Configuration,
  outputPath: string
): Promise<Result<null, string>> => {
  // TODO: Resolve Mappings
  // Read Templates
  if (import.meta.dirname == undefined)
    return err('Cli Error Missing Meta Dirname');
  const eta = new Eta({
    views: path.join(import.meta.dirname, 'templates'),
    tags: ['"%', '%"'],
    useWith: true,
    defaultExtension: '.nix',
  });
  // TODO: Generate Templates
  const systems: Map<
    string,
    { system: string; secrets: string; home: string; platform: SystemPlatform }
  > = new Map();
  for (const system of configurations.systems) {
    const platform = getSystemPlatform(system.platform);
    // Generate System Configuration
    const systemUser = getUserInfo(
      platform,
      system.platform,
      system.user,
      configurations.users
    );
    if (systemUser.isErr) return systemUser;
    switch (platform) {
      case SystemPlatform.Darwin: {
        const darwinConfigurations = await eta.renderAsync(
          'darwin.nix',
          systemUser.ok
        );
        const homeConfiguration = await eta.renderAsync(
          'home.nix',
          systemUser.ok
        );
        const secretsConfiguration = await eta.renderAsync(
          'secrets.nix',
          systemUser.ok
        );
        systems.set(system.name, {
          system: darwinConfigurations,
          home: homeConfiguration,
          secrets: secretsConfiguration,
          platform,
        });
        break;
      }
      case SystemPlatform.NixOs: {
        const nixosConfigurations = await eta.renderAsync(
          'nixos.nix',
          systemUser.ok
        );
        const homeConfiguration = await eta.renderAsync(
          'home.nix',
          systemUser.ok
        );
        const secretsConfiguration = await eta.renderAsync(
          'secrets.nix',
          systemUser.ok
        );
        systems.set(system.name, {
          system: nixosConfigurations,
          home: homeConfiguration,
          secrets: secretsConfiguration,
          platform,
        });
        break;
      }
    }
  }
  const configInput = (name: string) =>
    `${name} = import ./systems/${name}/system.nix { inherit inputs self; };`;
  const darwinConfigurations = systems
    .entries()
    .filter(([_, s]) => s.platform == SystemPlatform.Darwin)
    .map(([n, _]) => configInput(n))
    .toArray()
    .join('\n');
  const nixosConfigurations = systems
    .entries()
    .filter(([_, s]) => s.platform == SystemPlatform.NixOs)
    .map(([n, _]) => configInput(n))
    .toArray()
    .join('\n');
  const flake = await eta.renderAsync('flake.nix', {
    darwinConfigurations: `{ ${darwinConfigurations} }`,
    nixosConfigurations: `{ ${nixosConfigurations} }`,
  });
  // Render Files
  await clear_output(outputPath);
  await Deno.mkdir(outputPath, { recursive: true });
  // Flake
  await write_output(outputPath, 'flake.nix', flake);
  // Templates - Straight Copy
  if (import.meta.dirname == undefined)
    return err('Cli Error Missing Meta Dirname');
  await copy(
    path.join(import.meta.dirname, 'templates', 'templates'),
    path.join(outputPath, 'templates')
  );
  // Modules - Straight Copy
  if (import.meta.dirname == undefined)
    return err('Cli Error Missing Meta Dirname');
  await copy(
    path.join(import.meta.dirname, 'templates', 'modules'),
    path.join(outputPath, 'modules')
  );
  // Overlays - Straight Copy
  if (import.meta.dirname == undefined)
    return err('Cli Error Missing Meta Dirname');
  await copy(
    path.join(import.meta.dirname, 'templates', 'overlays'),
    path.join(outputPath, 'overlays')
  );
  // Systems
  await create_folder(outputPath, 'systems');
  for (const [name, { system, secrets, home }] of systems) {
    await create_folder(path.join(outputPath, 'systems'), name);
    // Create Home Manager File
    await write_output(
      path.join(outputPath, 'systems', name),
      'home.nix',
      home
    );
    // Create Secrets File
    await write_output(
      path.join(outputPath, 'systems', name),
      'secrets.nix',
      secrets
    );
    // Create System File
    await write_output(
      path.join(outputPath, 'systems', name),
      'system.nix',
      system
    );
  }
  return ok(null);
};

// TODO: Look into https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
