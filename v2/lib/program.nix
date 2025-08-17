# TODO: Put a flakelight module template here for a system
# yants for types safety: https://github.com/divnix/yants

# Sources:
# - homebrew: (string) => ProgramSource - A homebrew source
# - nixpkgs: (string) => ProgramSource - A nixpkgs source

# Program:
# - name: String - The name of the program
# - platforms: Array<Platform> - The platforms that this program is available on
# - options: { any }
# - config:
#   - program: ProgramSource - The program that this is a wrapper for
#   - configuration: ProgramConfig - The configuration for the program

# ProgramConfig:
# - sourceLocation: String - The location of the program's configs in your configuration
# - configLocation: String - The location of the program's configs on your system

# When we process a program we first call the program module
# We then validate the program source is valid on all systems
# We then set up our checks and functions for your configurations


# ProgramManager:
#   - programs: Array<Program> - The list of programs to manage
#   - withConfig: system, { program.<name>.configuration } => ModuleList

# We go through the programs, make sure we don't have duplicates
# when you call withConfig we filter your programs to the enabled ones
# and then we validate every program is valid on the system
# we then pass all the modules to the system module to handle