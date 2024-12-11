import { Eta, type Eta as EtaInstance } from '@eta-dev/eta';
import * as path from '@std/path';
import { copy } from '@std/fs';
import { ok, err, type Result } from './utils.ts';
import {
  type PlatformSchema,
  type Configuration,
  type User,
  type Bundle,
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
  rawPlatform: string;
  username: string;
  homeDirectory: string;
  programs: string[];
};
type NixOsUser = {
  platform: SystemPlatform.NixOs;
  rawPlatform: string;
  username: string;
  homeDirectory: string;
  programs: string[];
};
type SystemUser = DarwinUser | NixOsUser;
const getUserInfo = (
  platform: SystemPlatform,
  rawPlatform: string,
  username: string,
  users: Map<string, User>,
  bundles: Map<string, Bundle>
): Result<SystemUser, string> => {
  const user = users.get(username);
  if (user == undefined) return err(`User ${username} Not Found`);
  switch (platform) {
    case SystemPlatform.Darwin: {
      const programs = new Set<string>();
      user.darwin.programs.forEach((p) => programs.add(p));
      user.shared.programs.forEach((p) => programs.add(p));
      for (const bundle of user.bundles) {
        const bundleContent = bundles.get(bundle);
        if (bundleContent == undefined)
          return err(`Bundle ${bundle} Not Found`);
        bundleContent.darwinPrograms.forEach((p) => programs.add(p));
        bundleContent.sharedPrograms.forEach((p) => programs.add(p));
      }
      return ok({
        platform,
        rawPlatform,
        username,
        programs: [...programs.keys()],
        homeDirectory: `/Users/${username}`,
      });
    }
    case SystemPlatform.NixOs: {
      const programs = new Set<string>();
      user.nix.programs.forEach((p) => programs.add(p));
      user.shared.programs.forEach((p) => programs.add(p));
      for (const bundle of user.bundles) {
        const bundleContent = bundles.get(bundle);
        if (bundleContent == undefined)
          return err(`Bundle ${bundle} Not Found`);
        bundleContent.nixPrograms.forEach((p) => programs.add(p));
        bundleContent.sharedPrograms.forEach((p) => programs.add(p));
      }
      return ok({
        platform,
        rawPlatform,
        username,
        programs: [...programs.keys()],
        homeDirectory: `/home/${username}`,
      });
    }
  }
};
const clearOutput = async (outputDir: string) => {
  try {
    await Deno.remove(outputDir, { recursive: true });
  } catch (_) {
    // Do Nothing
  }
};
const createFolder = async (outDir: string, folder: string) => {
  await Deno.mkdir(path.join(outDir, folder), { recursive: true });
};
const writeOutput = async (outputDir: string, file: string, data: string) => {
  await Deno.writeTextFile(path.join(outputDir, file), data, { create: true });
};
const getPlatformConfigurations = async (
  eta: EtaInstance,
  platform: SystemPlatform,
  systemUser: SystemUser
) => {
  switch (platform) {
    case SystemPlatform.Darwin: {
      return await eta.renderAsync('darwin.nix', systemUser);
    }
    case SystemPlatform.NixOs: {
      return await eta.renderAsync('nixos.nix', systemUser);
    }
  }
};
export const setConfigurations = async (
  configurations: Configuration,
  programsSourcePath: string,
  outputPath: string
): Promise<Result<null, string>> => {
  // Read Templates
  if (import.meta.dirname == undefined)
    return err('Cli Error Missing Meta Dirname');
  const eta = new Eta({
    views: path.join(import.meta.dirname, 'templates'),
    tags: ['"%', '%"'],
    useWith: true,
    defaultExtension: '.nix',
  });
  // Generate Templates
  const systems: Map<
    string,
    { system: string; secrets: string; home: string; platform: SystemPlatform }
  > = new Map();
  const programs: Map<
    string,
    { defaultScript: string } | { defaultScriptPath: string }
  > = new Map();
  for (const systemConfig of configurations.systems) {
    const platform = getSystemPlatform(systemConfig.platform);
    // Generate System Configuration
    const systemUser = getUserInfo(
      platform,
      systemConfig.platform,
      systemConfig.user,
      configurations.users,
      configurations.bundles
    );
    if (systemUser.isErr) return systemUser;
    const system = await getPlatformConfigurations(
      eta,
      platform,
      systemUser.ok
    );
    // Build Home Configuration
    const home = await eta.renderAsync('home.nix', systemUser.ok);
    // Build Secrets Configuration
    const secrets = await eta.renderAsync('secrets.nix', systemUser.ok);
    systems.set(systemConfig.name, {
      system,
      home,
      secrets,
      platform,
    });
    // Generate Program Configurations
    const systemUserName = systemUser.ok.username;
    for (const [programName, programContent] of configurations.programs) {
      if (!systemUser.ok.programs.includes(programName)) continue;
      // Check If Program Is Supported
      if (!programContent.supportsDarwin && platform == SystemPlatform.Darwin)
        return err(
          `Program ${programName} Not Supported On Darwin, but Used By Darwin System ${systemUserName}`
        );
      if (!programContent.supportsNix && platform == SystemPlatform.NixOs)
        return err(
          `Program ${programName} Not Supported On NixOs, but Used By NixOs System ${systemUserName}`
        );
      // Check If Program Is Used
      if (programs.has(programName)) break;
      // If we do not have it already build new program
      if ('defaultScript' in programContent) {
        programs.set(programName, {
          defaultScriptPath: programContent.defaultScript,
        });
      } else {
        // TODO: Generate the DefaultScript
        return err("Custom Script's are Not Supported Yet");
      }
    }
  }
  // Render Files
  await clearOutput(outputPath);
  await Deno.mkdir(outputPath, { recursive: true });
  // Flake
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
  await writeOutput(outputPath, 'flake.nix', flake);
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
  // Parts - Straight Copy
  if (import.meta.dirname == undefined)
    return err('Cli Error Missing Meta Dirname');
  await copy(
    path.join(import.meta.dirname, 'templates', 'parts'),
    path.join(outputPath, 'parts')
  );
  // Programs
  await createFolder(outputPath, 'programs');
  await copy(
    path.join(import.meta.dirname, 'templates', 'programs', 'default.nix'),
    path.join(outputPath, 'programs', 'default.nix')
  );
  for (const [name, program] of programs) {
    const programPath = path.join(outputPath, 'programs', name);
    await copy(
      path.join(programsSourcePath, name),
      path.join(outputPath, 'programs', name)
    );
    if ('defaultScript' in program) {
      await writeOutput(programPath, 'default.nix', program.defaultScript);
    }
    if ('defaultScriptPath' in program) {
      // TODO: What if the file doesn't exist?
      await copy(
        path.join(programsSourcePath, name, program.defaultScriptPath),
        path.join(outputPath, 'programs', name, 'default.nix'),
        { overwrite: true }
      );
    }
  }
  // Systems
  await createFolder(outputPath, 'systems');
  for (const [name, { system, secrets, home }] of systems) {
    await createFolder(path.join(outputPath, 'systems'), name);
    // Create Home Manager File
    await writeOutput(path.join(outputPath, 'systems', name), 'home.nix', home);
    // Create Secrets File
    await writeOutput(
      path.join(outputPath, 'systems', name),
      'secrets.nix',
      secrets
    );
    // Create System File
    await writeOutput(
      path.join(outputPath, 'systems', name),
      'system.nix',
      system
    );
  }
  return ok(null);
};

// TODO: Look into https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
