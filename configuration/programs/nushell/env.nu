# TODO: Ensure nix compatbility
$env.config = {
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
        # Cargo
        $env.PATH = ($env.PATH | append "/users/spotandjake/.cargo/bin")
        # Node Version Manager
        ^fnm env --resolve-engines --corepack-enabled --json | from json | load-env
        let node_path = match $nu.os-info.name {
          "windows" => $"($env.FNM_MULTISHELL_PATH)",
          _ => $"($env.FNM_MULTISHELL_PATH)/bin",
        }
        $env.PATH = ($env.PATH | prepend [ $node_path ])
      }
    }]
  }
}
$env.__NIX_DARWIN_SET_ENVIRONMENT_DONE = 1 

$env.PATH = ($env.PATH | prepend [
    $"($env.HOME)/.nix-profile/bin"
    $"/etc/profiles/per-user/($env.USER)/bin"
    "/run/current-system/sw/bin"
    "/nix/var/nix/profiles/default/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/usr/sbin"
    "/bin"
    "/sbin"
])
$env.EDITOR = "code"
$env.NIX_PATH = [
    $"darwin-config=($env.HOME)/.nixpkgs/darwin-configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
]
$env.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
$env.PAGER = "less -R"
$env.TERMINFO_DIRS = [
    $"($env.HOME)/.nix-profile/share/terminfo"
    $"/etc/profiles/per-user/($env.USER)/share/terminfo"
    "/run/current-system/sw/share/terminfo"
    "/nix/var/nix/profiles/default/share/terminfo"
    "/usr/share/terminfo"
]
$env.XDG_CONFIG_DIRS = [
    $"($env.HOME)/.nix-profile/etc/xdg"
    $"/etc/profiles/per-user/($env.USER)/etc/xdg"
    "/run/current-system/sw/etc/xdg"
    "/nix/var/nix/profiles/default/etc/xdg"
]
$env.XDG_DATA_DIRS = [
    $"($env.HOME)/.nix-profile/share"
    $"/etc/profiles/per-user/($env.USER)/share"
    "/run/current-system/sw/share"
    "/nix/var/nix/profiles/default/share"
]
$env.TERM = $env.TERM
$env.NIX_USER_PROFILE_DIR = $"/nix/var/nix/profiles/per-user/($env.USER)"
$env.NIX_PROFILES = [
    "/nix/var/nix/profiles/default"
    "/run/current-system/sw"
    $"/etc/profiles/per-user/($env.USER)"
    $"($env.HOME)/.nix-profile"
]

if ($"($env.HOME)/.nix-defexpr/channels" | path exists) {
    $env.NIX_PATH = ($env.PATH | split row (char esep) | append $"($env.HOME)/.nix-defexpr/channels")
}

if (false in (ls -l `/nix/var/nix`| where type == dir | where name == "/nix/var/nix/db" | get mode | str contains "w")) {
    $env.NIX_REMOTE = "daemon"
}

# Nushell Environment Config File
#
# version = 0.83.2

def in_git_repo [] {
  '.git' | path exists
}

def create_left_prompt [] {
  # Path
  let path_segment = if (is-admin) {
    $"(ansi red_bold)($env.PWD)"
  } else {
    $"(ansi xterm_springgreen1)($env.PWD)"
  }
  # Git
  let git_segment = if (in_git_repo) {
    use std
    let git_current_ref = $"(git branch --show-current)"
    let git_segment = if ($git_current_ref != "") {
      $"(ansi reset) | (ansi yellow)($git_current_ref)" 
    }
    $git_segment
  }
  # Output
  let prompt = $"($path_segment)($git_segment)"
  $prompt
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%Y/%m/%d %r')
    ] | str join | str replace --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
$env.PATH = ($env.PATH | append "/opt/homebrew/bin")
$env.PATH = ($env.PATH | append "/users/spotandjake/.cargo/bin")
$env.PATH = ($env.PATH | append "/usr/local/bin")
$env.RUST_BACKTRACE = 1

^fnm env --resolve-engines --corepack-enabled --json | from json | load-env
let node_path = match $nu.os-info.name {
  "windows" => $"($env.FNM_MULTISHELL_PATH)",
  _ => $"($env.FNM_MULTISHELL_PATH)/bin",
}
$env.PATH = ($env.PATH | prepend [ $node_path ])
