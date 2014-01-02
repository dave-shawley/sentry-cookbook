# Sentry Cookbook

Installs and configures a sentry instance.

# Requirements

## Platforms
This cookbook is intended to support the following platforms:

- Debian, Ubuntu

It is tested under the following platforms:

- Ubuntu 10.04

# Attributes
See `attributes/default.rb` for default values.

- `node['sentry']['user']`: privilege separation user for the Sentry daemon.
    The default recipe will create/update this user as a system user without
    the login privilege.
- `node['sentry']['home']`: directory that the Sentry package will be installed
    into.  This directory will be writeable by the Sentry administrative group
    (see below).

## Security Attributes
- `node['sentry']['admin_user']`: an existing user that can administer the
    Sentry daemon.  This user will have write privilege to sensitive files.
- `node['sentry']['admin_group']`: user group that Sentry files will be
    installed as.

# Recipes

## default
Include this recipe in a run list to use `sentry`.  Installs the Sentry
daemon in a recommended configuration.

# License & Author(s)

Author:: Dave Shawley (<daveshawley@gmail.com>)

>
Copyright (C) 2013 Dave Shawley
>
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
>
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
>
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
>
