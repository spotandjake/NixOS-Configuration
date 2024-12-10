import { Command } from '@cliffy/command';
import { get_dir, error } from './utils.ts';
import { get_configurations } from './input.ts';
import { set_configurations } from './output.ts';

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
    const directoryPath = get_dir(input);
    const outputPath = get_dir(output);
    // Get The input
    const input_configurations = await get_configurations(directoryPath);
    if (input_configurations.isErr) return error(input_configurations.err);
    // Generate The Output
    const output_configurations = await set_configurations(
      input_configurations.ok,
      outputPath
    );
    if (output_configurations.isErr) return error(output_configurations.err);
  })
  .parse(Deno.args);

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
