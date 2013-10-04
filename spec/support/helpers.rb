module ChefSpec
  class ChefRunner
    def python_virtualenv(name)
      find_resource 'python_virtualenv', name
    end
  end

  module Matchers
    define_resource_matchers([:create, :delete], [:python_virtualenv], :name)
  end
end

