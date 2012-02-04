# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Updates bundles whenever the Gemfile or Gemfile.lock changes
guard 'bundler' do
  watch('Gemfile')
  watch('Gemfile.lock')
end

# Migrate the dev database when migrations exist
guard 'migrate' do
  watch(%r{^db/migrate/(\d+).+\.rb})
end

# Runs rspec tests
guard 'rspec', :cli => "--drb --fail-fast", :all_on_start => false, :all_after_pass => false, :version => 2, :keep_failed => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec(/.+)*.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app(/.+)*\.rb$})                         { |m| "spec/#{m[1]}_spec.rb" }
end
