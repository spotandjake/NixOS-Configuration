// Add Global Commands For Managing Configurations And Rebuilding
// TODO: Add an import map
import * as path from '@std/path';
import { Command } from '@cliffy/command';
import { ok, Result } from './result.ts';
import { colors } from '@cliffy/ansi/colors';
import { type Systems, type User, type Bundle } from './schemas.ts';
import * as Data from './data.ts';
const error = colors.red.bold;

const get_directrory_path = (rawDirectory: string, sourceDirectory: string) => {
  return path.join(sourceDirectory, rawDirectory);
};

interface Configuration {
  systems: Systems;
  users: Map<string, User>;
  bundles: Map<string, Bundle>;
  // appConfigurations: AppConfigurations;
}

const get_input_configuration = async (
  input_directory: string
): Promise<Result<Configuration, string>> => {
  // Get The Inputs
  const systems = await Data.read_system_file(input_directory);
  if (systems.isErr) return systems;
  const users = await Data.read_user_files(input_directory);
  if (users.isErr) return users;
  const bundles = await Data.read_bundle_files(input_directory);
  if (bundles.isErr) return bundles;
  // Validate The Input Strings With Zod
  return ok({
    systems: systems.ok,
    users: users.ok,
    bundles: bundles.ok,
  });
};

await new Command()
  .name('NixOs Configuration Builder')
  .description(
    'Converts a Yaml System Configuration Into A NixOs Configuration File'
  )
  .version('0.1.0')
  .option('-o, --output <output_directory>', 'Set the output directory', {
    default: null,
  })
  .arguments('<project_directory>')
  .action(async ({ output }, input) => {
    // Get the working and output directory
    const sourceDirectory = Deno.cwd();
    const directoryPath = get_directrory_path(input, sourceDirectory);
    const outputPath = get_directrory_path(output, sourceDirectory);
    // Get The input
    const configurations = await get_input_configuration(directoryPath);
    if (configurations.isErr) {
      console.error(error('[Error]:'), configurations.err);
      Deno.exit(1);
    }
    console.log(configurations.ok);
    // Deep Validation
    // - Ensure the users exist
    // - Ensure the bundles exist
    // - Ensure the app configurations exist
    // Map the configs to direct outputs in the nix module system
    // Write to the output
    // TODO: Build the output
  })
  .parse(Deno.args);

// After we do this we can go to validation
// - Ensure the users exist
// - Ensure the bundles exist
// - Ensure the programs exist
// Transform into output
// - preprocess
//   - for each user
//   - merge in bundles
//   - put shared under home-manager
//     - if any programs contain home-brew packages fail
//   - put darwin under darwin
//     - we will need to go through all programs and figure out if they contribute home-brew packages
// Write output to main directory
//   - put nix under nix
//     - if we see any home-brew packages in programs fail
// flake.nix
// - setup standard template
// - map any darwin configurations to the darwin system
//   - inject the dock settings
//   - inject home-brew settings
//   - inject home-manager settings
// - map any nix os configurations to the nix os system
//   - inject home-manager settings
// - map any home-manager configurations to home-manager if no darwin or nix configurations
// Package using nix
// Add cli tools for managing the system
// - Rebuild
// - pull
//   - uses git to pull remote changes
// - push
//   - makes a new commit and pushes to the remote
//    - pregenerates from known changes, if we detect other changes we prompt for commit
// - revert
//   - reverts to the last commit
// - Add Program
//   - Adds a new Program to the configuration
//   - Adds the program to the current user's if it exists configuration
//     - prompts about this part
//   - launch editor at program for configuration
// - Remove Program
//   - Removes the program from the current users configuration, or adds it to a bundle omit
//   - Scans the users and comments references
// - Add User
//   - Adds a new user to the configuration
//   - prompts for name
//   - prompts for description
//   - prompts for configuration
//   - prompts for bundles
// - Remove User
//   - Removes the user from the configuration
//   - Scans the users and comments references
// - Add Bundle
//   - Adds a new bundle to the configuration
//   - prompts for name
//   - prompts for description
//   - prompts for programs
// - Remove Bundle
//   - Removes the bundle from the configuration
//   - Scans the users and comments references
// - Add System
//   - Adds a new system to the configuration
//   - prompts for name
//   - prompts for user
//   - prompts for platform
//   - prompts for specs
// - Remove System
//   - Removes the system from the configuration

// TODO:
// - deep validation
//  - resolve bundles
//  - resolve users
// - output
// - yaml programs
// - nice cli
