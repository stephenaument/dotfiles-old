#WMENV

**wmenv** is a set of shell functions that make it easy to switch between "sets" of environment variables.

####Table of Contents

* [Commands](#commands)
  * [info](#info)
  * [global](#global)
  * [local](#local)
  * [shell](#shell)
  * [revert](#revert)
  * [help](#help)
* [Key Concepts](#key-concepts)
* [How It Works](#how-it-works)
* [Credits](#credits)

##Commands
### `info`
Shows the current environment and its origin.

```ShellSession
$ wmenv info
Current environment is: test
               Context: local (~/src/someproject/.wmenv-local)
           Loaded from: ~/src/someproject/.wmenv/test
```

This is also the default command used when wmenv is not given any arguments:

```ShellSession
$ wmenv
Current environment is: test
               Context: local (~/src/someproject/.wmenv-local)
           Loaded from: ~/src/someproject/.wmenv/test
```

### `global`
Sets or shows the global environment.

When setting a global environment, stores the provided environment in plaintext in `~/.wmenv-global`.

When reading the global environment, prints the contents of `~/.wmenv-global` (if it exists).

```ShellSession
$ wmenv global
Global environment isn't set

$ wmenv global development
Global environment is now "development"

$ wmenv global
development

$ cat ~/.wmenv-global
development
```

### `local`
Sets or shows the local (i.e. directory-specific) environment. 

When setting a local environment, creates a `.wmenv-local` file in the current directory containing the provided environment in plaintext.

When reading the local environment, prints the contents of the first `.wmenv-local` file it can find, starting with the current directory and then looking in each of its parent directories.

```ShellSession
$ wmenv local
Local environment isn't set

$ wmenv local development
Local environment is now "development"

$ wmenv local
development

$ cat .wmenv-local
development
```

### `shell`
Sets or shows the shell (i.e. specific to the current shell session) environment. Uses the WMENV_SHELL_ENV environment variable to keep track of what is set here.

When setting a shell environment, stores the provided environment in the `WMENV_SHELL_ENV` environment variable in the current shell only.

When reading the shell environment, prints the value of the `WMENV_SHELL_ENV` environment variable.

```ShellSession
$ wmenv shell
Shell environment isn't set for current session

$ wmenv shell development
Current shell's environment is now "development"

$ wmenv shell
development

$ echo "$WMENV_SHELL_ENV"
development
```

### `revert`
Unsets the current environment definition and uses the next-most specific definition.

For example, if `wmenv shell` and `wmenv global` are both currently set, calling `wmenv revert` will clear the shell-specific environment in use and switch back to using the global environment:

```ShellSession
$ wmenv shell
test

$ wmenv local
Local environment isn't set

$ wmenv global
development

$ wmenv
Current environment is: test
               Context: shell
           Loaded from: ~/src/someproject/.wmenv/test

$ wmenv revert
Reverted shell environment specification. Using global (~/.wmenv-global)

$ wmenv
Current environment is: development
               Context: global (~/.wmenv-global)
           Loaded from: ~/src/someproject/.wmenv/development

```

### `help`
```ShellSession
$ wmenv help
Usage: wmenv <command> [<args>]

Available wmenv commands are:
  info                    Show the current environment and its origin
  global [ENVIRONMENT]    Set or show the global environment
  local [ENVIRONMENT]     Set or show the local project-specific environment
  shell [ENVIRONENT]      Set or show the current shell-specific enviroment
  revert                  Unsets the current environment specification
  [ENVIRONMENT]           Shortcut for "wmenv shell [ENVIRONMENT]"

<command> defaults to "info"

```

##Key Concepts

###Environment

Name for a set of environment variable names and values

Usually `production`, `development`, and `test`

###Context
What specifies the name of the Environment to be used

Options are `shell`, `local`, or `global`, ordered from highest precedence to lowest.

###Project

A folder named `.wmenv` containing two files for each Environment: `<environment>` and `<environment>_unset`

A standard project might include the following:

```
.wmenv
├── development
├── development_unset
├── production
├── production_unset
├── test
├── test_unset
```

The `<environment>` files contain one or more bash-compatible `export ENV_VAR=value` lines, which `wmenv` passes directly to a `source` call to load the specified environment variables into the calling shell.

The `<environment>_unset` files contain bash-compatible commands to unset all environment variables set in their corresponding `<environment>` files, which `wmenv` also directly passes to a `source` call to clean up when an environment is no longer relevant.

For example, take this `development` environment file:

```
export RAILS_ENV=development
export DATABASE_URL="postgres://localhost:5432/chupacabra"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
```

Its corresponding `development_unset` file should contain the following:

```
unset RAILS_ENV
unset DATABASE_URL
unset AWS_SECRET_ACCESS_KEY
```

##How It Works

Before every shell command is run, the following process occurs:

1. **Determine current Environment** - use the first context that has a defined Environment:
    1. **shell**: Is `wmenv shell` set? If so, stop and use the returned Environment.
    2. **local**: Is `wmenv local` set? If so, stop and use the returned Environment.
    3. **global**: Is `wmenv global` set? If so, stop and use the returned Environment.
    
    If no Context has an Environment defined, unset any environment variables previously set by `wmenv` and exit.

2. **Find current Project** - does the current directory or any of its parents contain a `.wmenv` folder?

    **Yes**: continue.

    **No**: unset any environment variables previously set by `wmenv` and exit

3. **Set corresponding environment variables** - if steps 1 and 2 succeed and have different values than the last time this logic ran in the current shell, `wmenv` will:
    1. Unset the environment variables set by the prior Environment:

        ```
        source <prior_project>/.wmenv/<prior_environment>_unset
        ```

    2. Set the new Environment's set of environment variables:

        ``` 
        source <project>/.wmenv/<environment>`
        ```

##Credits

The method used by `wmenv` to hook into the shell and automatically do its magic was heavily borrowed from [chruby's auto loader](https://github.com/postmodern/chruby/blob/master/share/chruby/auto.sh).
