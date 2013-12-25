# -*- coding: UTF-8 -*-
#
# This file contains custom chef spec matchers that should really be
# included in the individual cookbooks.
#

def create_python_virtualenv(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(
    :python_virtualenv,
    :create,
    resource_name,
  )
end
