# TODO: Ensure nix compatibility

# Nushell Config File
alias vim = nvim
alias repo = gitkraken -p $env.PWD
# NU
$env.EDITOR = "vscode"
# ZED
$env.ZED_DISABLE_STAFF = 0
# General
$env.CMD_DURATION_MS = "7"
$env.COLORFGBG = "15;0"
$env.COLORTERM = 'truecolor'
$env.COMMAND_MODE = 'unix2003'
$env.DIRS_LIST = '[/Users/spotandjake]'
$env.DIRS_POSITION = '0'
$env.HOME = '/Users/spotandjake'
$env.ITERM_PROFILE = 'Default'
$env.ITERM_SESSION_ID = 'w0t3p0:059F6A20-C843-4817-BFCF-D412FDA5DDAE'
$env.LANG = 'en_CA.UTF-8'
$env.LAST_EXIT_CODE = '0'
$env.LC_TERMINAL = 'iTerm2'
$env.LC_TERMINAL_VERSION = '3.5.4beta1'
$env.LOGNAME = 'spotandjake'
$env.LOG_ANSI = '{CRITICAL: , ERROR: , WARNING: , INFO: , DEBUG: }'

$env.GPG_TTY = (tty)

# Completions
module completions {
  # Yazi
  def y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
      cd $cwd
    }
    rm -fp $tmp
  }
  # Custom completions for external commands (those outside of Nushell)
  # Each completions has two parts: the form of the external command, including its flags and parameters
  # and a helper command that knows how to complete values for those flags and parameters
  #
  # This is a simplified version of completions for git branches and git remotes
  def "nu-complete git branches" [] {
    ^git branch | lines | each { |line| $line | str replace '[\*\+] ' '' | str trim }
  }

  def "nu-complete git remotes" [] {
    ^git remote | lines | each { |line| $line | str trim }
  }

  export extern "git checkout" [
    branch?: string@"nu-complete git branches" # name of the branch to checkout
    -b: string                                 # create and checkout a new branch
    -B: string                                 # create/reset and checkout a branch
    -l                                         # create reflog for new branch
    --guess                                    # second guess 'git checkout <no-such-branch>' (default)
    --overlay                                  # use overlay mode (default)
    --quiet(-q)                                # suppress progress reporting
    --recurse-submodules: string               # control recursive updating of submodules
    --progress                                 # force progress reporting
    --merge(-m)                                # perform a 3-way merge with the new branch
    --conflict: string                         # conflict style (merge or diff3)
    --detach(-d)                               # detach HEAD at named commit
    --track(-t)                                # set upstream info for new branch
    --force(-f)                                # force checkout (throw away local modifications)
    --orphan: string                           # new unparented branch
    --overwrite-ignore                         # update ignored files (default)
    --ignore-other-worktrees                   # do not check if another worktree is holding the given ref
    --ours(-2)                                 # checkout our version for unmerged files
    --theirs(-3)                               # checkout their version for unmerged files
    --patch(-p)                                # select hunks interactively
    --ignore-skip-worktree-bits                # do not limit pathspecs to sparse entries only
    --pathspec-from-file: string               # read pathspec from file
  ]

  export extern "git push" [
    remote?: string@"nu-complete git remotes", # the name of the remote
    refspec?: string@"nu-complete git branches", # the branch / refspec
    --verbose(-v)                              # be more verbose
    --quiet(-q)                                # be more quiet
    --repo: string                             # repository
    --all                                      # push all refs
    --mirror                                   # mirror all refs
    --delete(-d)                               # delete refs
    --tags                                     # push tags (can't be used with --all or --mirror)
    --dry-run(-n)                              # dry run
    --porcelain                                # machine-readable output
    --force(-f)                                # force updates
    --force-with-lease: string                 # require old value of ref to be at this value
    --recurse-submodules: string               # control recursive pushing of submodules
    --thin                                     # use thin pack
    --receive-pack: string                     # receive pack program
    --exec: string                             # receive pack program
    --set-upstream(-u)                         # set upstream for git pull/status
    --progress                                 # force progress reporting
    --prune                                    # prune locally removed refs
    --no-verify                                # bypass pre-push hook
    --follow-tags                              # push missing but relevant tags
    --signed: string                           # GPG sign the push
    --atomic                                   # request atomic transaction on remote side
    --push-option(-o): string                  # option to transmit
    --ipv4(-4)                                 # use IPv4 addresses only
    --ipv6(-6)                                 # use IPv6 addresses only
  ]

  # Grain
  # export extern "grain" [
  #   filename: string # file to run
  #   --help(-h) # display help for command
  #   -o: string # output filename
  #   --version(-v) # output version
  #   --verbose     # print critical information at various stages of compilation
  #   --strict-sequence # enable strict sequencing
  #   --source-map                   # generate source maps
  #   --memory-base: number           # set the base address for the Grain heap
  #   --no-pervasives                # don't automatically import the Grain Pervasives module
  #   --no-bulk-memory               # polyfill WebAssembly bulk memory instructions
  #   --no-gc                        # turn off reference counting garbage collection
  #   --no-color                     # disable colored output
  #   --hide-locs                    # hide locations from intermediate trees. Only has an effect with `--verbose`
  #   --wat                          # additionally produce a WebAssembly Text (.wat) file
  #   --debug                        # compile with debugging information
  #   --no-wasm-tail-call            # disables tail-call optimization
  #   --release                      # compile using the release profile (production mode)
  #   --elide-type-info              # don't include runtime type information used by toString/print
  #   --env: string                 # WASI environment variables
  #   --dir: string                 # directory to preopen
  #   --import-memory                # import the memory from `env.memory`
  #   --maximum-memory-pages: int  # maximum number of WebAssembly memory pages
  #   --initial-memory-pages: int  # initial number of WebAssembly memory pages
  #   --wasi-polyfill: string    # path to custom WASI implementation
  #   --include-dirs(-I): string      # add additional dependency include directories (default: [])
  #   --stdlib(-S): string           # override the standard library with your own (default:

  #   # remote?: string@"nu-complete git remotes", # the name of the remote
  #   # refspec?: string@"nu-complete git branches", # the branch / refspec
  # ]
}

# Get just the extern definitions without the custom completion commands
use completions *

# for more information on themes see
# https://www.nushell.sh/book/coloring_and_theming.html
let default_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    bool: white
    int: white
    filesize: white
    duration: white
    date: white
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cellpath: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray

    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_binary: purple_bold
    shape_bool: light_cyan
    shape_int: purple_bold
    shape_float: purple_bold
    shape_range: yellow_bold
    shape_internalcall: cyan_bold
    shape_external: cyan
    shape_externalarg: green_bold
    shape_literal: blue
    shape_operator: yellow
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_datetime: cyan_bold
    shape_list: cyan_bold
    shape_table: blue_bold
    shape_record: cyan_bold
    shape_block: blue_bold
    shape_filepath: cyan
    shape_globpattern: cyan_bold
    shape_variable: purple
    shape_flag: blue_bold
    shape_custom: green
    shape_nothing: light_cyan
}

# Setup
alias nvm = fnm
alias open = ^open
alias explorer = ^open
alias cls = clear
# Config
$env.config = {
  ls: {
    use_ls_colors: true
    clickable_links: true
  }
  rm: {
    always_trash: false
  }
  history: {
    sync_on_enter: true # Enable to share the history between multiple sessions, else you have to close the session to persist history to file
    max_size: 10000 # Session has to be reloaded for this to take effect
  }
  filesize: {
    metric: false
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
  completions: {
    quick: true  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
  }
  table: {
    mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
  }
  show_banner: false
  # The default config record. This is where much of your global configuration is setup.
  color_config: $default_theme
  footer_mode: 25 # always, never, number_of_rows, auto
  float_precision: 4
  use_ansi_coloring: true
  edit_mode: emacs # emacs, vi
  menus: [
      # Configuration for default nushell menus
      # Note the lack of souce parameter
      {
        name: completion_menu
        only_buffer_difference: false
        marker: "| "
        type: {
            layout: columnar
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: history_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: help_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: description
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      # Example of extra menus created using a nushell source
      # Use the source field to create a list of records that populates
      # the menu
      {
        name: commands_menu
        only_buffer_difference: false
        marker: "# "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where command =~ $buffer
            | each { |it| {value: $it.command description: $it.usage} }
        }
      }
      {
        name: vars_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.vars
            | where name =~ $buffer
            | sort-by name
            | each { |it| {value: $it.name description: $it.type} }
        }
      }
      {
        name: commands_with_description
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where command =~ $buffer
            | each { |it| {value: $it.command description: $it.usage} }
        }
      }
  ]
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: emacs # Options: emacs vi_normal vi_insert
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_x
      mode: emacs
      event: {
        until: [
          { send: menu name: history_menu }
          { send: menupagenext }
        ]
      }
    }
    {
      name: history_previous
      modifier: control
      keycode: char_z
      mode: emacs
      event: {
        until: [
          { send: menupageprevious }
          { edit: undo }
        ]
      }
    }
    # Keybindings used to trigger the user defined menus
    {
      name: commands_menu
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_menu }
    }
    {
      name: vars_menu
      modifier: control
      keycode: char_y
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: vars_menu }
    }
    {
      name: commands_with_description
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_with_description }
    }
  ]
}
