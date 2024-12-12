import * as path from '@std/path';
import { copy } from '@std/fs';
import { Eta, type Eta as EtaInstance } from '@eta-dev/eta';
import { some, none, type Option } from './utils.ts';
import {
  getConfiguration,
  isValidConfiguration,
  type Configuration,
} from './configuration.ts';

const safeWriteFile = async (
  filePath: string,
  content: string
): Promise<void> => {
  await Deno.writeTextFile(filePath, content, { create: true });
};
const getSystemType = (platform: string): 'darwin' | 'nix' => {
  if (platform == 'aarch64-darwin' || platform == 'x86_64-darwin') {
    return 'darwin';
  } else {
    return 'nix';
  }
};

export const buildConfiguration = async (
  config: Configuration,
  outputDir: string
): Promise<Option<string>> => {
  // Template
  if (import.meta.dirname == undefined)
    return some('Unknown Import Meta Not Found');
  const scaffoldPath = path.join(import.meta.dirname, 'scaffold');
  const templatePath = path.join(import.meta.dirname, 'templates');
  const eta = new Eta({
    views: templatePath,
    tags: ['"%', '%"'],
    useWith: true,
    defaultExtension: '.nix',
  });
  // Clean Output Directory
  try {
    await Deno.remove(outputDir, { recursive: true });
  } catch (_) {
    // Folder does not exist so we can ignore it
  }
  // Copy Scaffold
  await copy(scaffoldPath, outputDir);
  // Build Flake
  const flakeFile = path.join(outputDir, 'flake.nix');
  const flakeContent = await eta.renderAsync('flake.nix', {
    darwinSystems: config.systems
      .entries()
      .filter(([_, s]) => getSystemType(s.platform) == 'darwin')
      .map(([k, _]) => k),
    nixSystems: config.systems
      .entries()
      .filter(([_, s]) => getSystemType(s.platform) == 'nix')
      .map(([k, _]) => k),
  });
  await safeWriteFile(flakeFile, flakeContent);
  // Build Programs - for each program and will link to each program
  const programsDirectory = path.join(outputDir, 'programs');
  for (const [programName, program] of config.programs) {
    const programDirectory = path.join(programsDirectory, programName);
    if ('defaultScript' in program) {
      await copy(program.sourceDirectory, programDirectory);
    } else {
      // TODO: Custom Program Support
      throw new Error('Not Yet Supported Custom Program');
      // const programFile = path.join(programDirectory, 'default.nix');
      // const programContent = await eta.renderAsync('program.nix', program);
      // await safeWriteFile(programFile, programContent);
    }
  }
  // Build Bundles - for each bundle and will link to each bundle
  const bundleDirectory = path.join(outputDir, 'bundles');
  for (const [bundleName, bundle] of config.bundles) {
    const bundleFile = path.join(bundleDirectory, `${bundleName}.nix`);
    const bundleContent = await eta.renderAsync('bundle.nix', bundle);
    await safeWriteFile(bundleFile, bundleContent);
  }
  // Build Users - for each user and will link to home manager
  const userDirectory = path.join(outputDir, 'users');
  for (const [userName, user] of config.users) {
    const userFile = path.join(userDirectory, `${userName}.nix`);
    const userContent = await eta.renderAsync('user.nix', user);
    await safeWriteFile(userFile, userContent);
  }
  // Build Systems - for each system and will either be darwin or nix
  const systemDirectory = path.join(outputDir, 'systems');
  for (const [systemName, system] of config.systems) {
    const systemFile = path.join(systemDirectory, `${systemName}.nix`);
    if (getSystemType(system.platform) == 'darwin') {
      const systemContent = await eta.renderAsync('darwinSystem.nix', system);
      await safeWriteFile(systemFile, systemContent);
    } else {
      // TODO: Support NixOs Systems
      throw new Error('Not Yet Supported NixOs System');
      // const systemContent = await eta.renderAsync('nixSystem.nix', system);
      // await safeWriteFile(systemFile, systemContent);
    }
  }
  return none();
};

export const process = async (
  inputDir: string,
  outputDir: string
): Promise<Option<string>> => {
  // Read All Input Files
  const config = await getConfiguration(inputDir);
  if (config.isErr) return some(config.err);
  const validProgram = await isValidConfiguration(config.ok);
  if (validProgram.isSome) return some(validProgram.value);
  // Build Configuration
  const buildResult = await buildConfiguration(config.ok, outputDir);
  if (buildResult.isSome) return some(buildResult.value);
  return none();
};
