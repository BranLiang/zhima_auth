$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'yaml'
require "zhima_auth"
# require 'webmock/rspec'
secret = YAML.load_file('spec/zhima.yml')

# fake config
ZhimaAuth.configure do |config|
  config.app_id = secret["app_id"]
  config.private_key = secret["private_key"]
end
