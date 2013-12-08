ignore %r{^\.}
ignore %r{.+\.swp}

guard :rspec do
  watch(%r{metadata\.rb}) { "spec" }
  watch(%r{^attributes/.+\.rb$}) { "spec" }
  watch(%r{^templates/.+\.rb$}) { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/spec_helper\.rb$}) { "spec" }

  watch(%r{^libraries/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^recipes/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end

