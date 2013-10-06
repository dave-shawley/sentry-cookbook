module Helpers
  module Sentry
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    def lookup_resource(name)
      begin
        resource = run_context.resource_collection.lookup name
        resource.instance_eval do
          def must_exist
            self
          end
        end
      rescue Chef::Exceptions::ResourceNotFound
        resource = Chef::Resource.new name
        resource.instance_eval do
          def must_exist
            raise MiniTest::Assertion, "Resource #{@name} does not exist in the run context"
          end
        end
      end

      resource
    end
  end

  module ResourceAssertions
    def with_permissions(permission_set)
      # Similar to with(:mode, value) except that comparision
      # is a bitwise AND which is more appropriate than equality.

      # make a `nice' failure message
      failure_message = "The #{resource_name} #{path} does not have the " +
        "expected permission set: expected #{permission_set.to_s(8)}, " +
        "found #{mode}"
      masked_permissions = (mode.to_i(8) & permission_set)
      mt = Object.extend(MiniTest::Assertions)
      mt.assert masked_permissions == permission_set, failure_message

      self  # enable chaining
    end
  end
end

class Chef
  class Resource
    class Directory
      include Helpers::ResourceAssertions
    end
    class File
      include Helpers::ResourceAssertions
    end
  end
end
