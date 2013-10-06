#
# Cookbook Name:: sentry
# Recipe:: default
#
# Copyright (C) 2013 Dave Shawley
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

include_recipe 'python'

package 'python-setuptools' do
  action :install
end

user node['sentry']['user'] do
  gid 'daemon'
  shell '/bin/false'
  system true
  home node['sentry']['home']
  action :create
end

group node['sentry']['admin_group'] do
  members node['sentry']['admin_user']
  action :create
end

directory node['sentry']['home'] do
  owner node['sentry']['user']
  group node['sentry']['admin_group']
  mode 0750
  action :create
end

directory '/opt/sentry' do
  owner node['sentry']['admin_user']
  group node['sentry']['admin_group']
  mode 0775
  action :create
end

python_virtualenv '/opt/sentry' do
  owner node['sentry']['admin_user']
  group node['sentry']['admin_group']
  action :create
end

python_pip 'sentry' do
  virtualenv '/opt/sentry'
  user node['sentry']['admin_user']
  group node['sentry']['admin_group']
  version node['sentry']['version']
end

directory '/etc/opt/sentry' do
  owner node['sentry']['admin_user']
  group node['sentry']['admin_group']
  mode 0775
  action :create
end

template '/etc/opt/sentry/conf.py' do
  owner node['sentry']['admin_user']
  group node['sentry']['admin_group']
  mode 0660
  action :create_if_missing
end
