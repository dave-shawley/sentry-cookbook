module ChefSpec
  class ChefRunner
    def python_virtualenv(name)
      find_resource 'python_virtualenv', name
    end
    def supervisor_service(name)
      find_resource 'supervisor_service', name
    end
  end

  module Matchers
    define_resource_matchers([:create, :delete], [:python_virtualenv], :name)
    define_resource_matchers([:enable], [:supervisor_service], :name)
    define_resource_matchers([:create, :create_if_missing], [:template], :name)
  end
end

