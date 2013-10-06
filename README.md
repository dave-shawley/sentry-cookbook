# Sentry Cookbook

Installs and configures a sentry instance.

# Requirements

## Platforms
- Debian, Ubuntu

## Cookbooks
- python

# Usage
Include the default recipe in a run list to use `sentry`.  Installs the
Sentry daemon in the most basic working configuration.  This is not
necessarily suited for production use since it runs over an SQLite database,
but it will work for simple use cases.  The other recipes will extend the
default case with more realistic and production ready configurations.

## Configuration Details
This cookbook installs Sentry following the guidelines described in version
[2.3 of the Filesystem Hierarchy Standard][FHS].  In particular, the Python
virtual environment is installed as _/opt/sentry_.  This is configurable via
the `node[sentry][home]` attribute though changing it will violate the FHS.


# Attributes
See `attributes/default.rb` for default values.

- `node["sentry"]["user"]`: privilege separation user for the Sentry daemon.
    The default recipe will create/update this user as a system user without
    the login privilege.
- `node["sentry"]["home"]`: directory that the Sentry package will be installed
    into.  This directory will be writeable by the Sentry administrative group
    (see below).
- `node["sentry"]["version"]`: version of the Sentry package to install.
    A value of `nil` will result in installing the latest package from the
    Package Index.

## Security Attributes
- `node["sentry"]["admin_user"]`: an existing user that can administer the
    Sentry daemon.  This user will have write privilege to sensitive files.
- `node["sentry"]["admin_group"]`: user group that Sentry files will be
    installed as.

# Recipes

# Author

Author:: Dave Shawley (<daveshawley@gmail.com>)

[FHS]: http://www.pathname.com/fhs/pub/fhs-2.3.html

