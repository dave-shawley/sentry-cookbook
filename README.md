# Sentry Cookbook

Installs and configures a sentry instance.

# Requirements

## Platforms
- Debian, Ubuntu

## Cookbooks
- python

# Usage
## default
Include this recipe in a run list to use `sentry`.  Installs the Sentry
daemon in a recommended configuration.

# Attributes
See `attributes/default.rb` for default values.

- `node["sentry"]["user"]`: privilege separation user for the Sentry daemon.
    The default recipe will create/update this user as a system user without
    the login privilege.
- `node["sentry"]["home"]`: directory that the Sentry package will be installed
    into.  This directory will be writeable by the Sentry administrative group
    (see below).

## Security Attributes
- `node["sentry"]["admin_user"]`: an existing user that can administer the
    Sentry daemon.  This user will have write privilege to sensitive files.
- `node["sentry"]["admin_group"]`: user group that Sentry files will be
    installed as.

# Recipes

# Author

Author:: Dave Shawley (<daveshawley@gmail.com>)

