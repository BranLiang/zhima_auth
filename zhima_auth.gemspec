# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zhima_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "zhima_auth"
  spec.version       = ZhimaAuth::VERSION
  spec.authors       = ["BranLiang"]
  spec.email         = ["lby89757@hotmail.com"]

  spec.summary       = %q{芝麻认证}
  spec.description   = %q{芝麻认证 for ruby}
  spec.homepage      = "http://www.liangboyuan.pub"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client"
  spec.add_development_dependency "pry-byebug", "~> 3.4.2"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.0"
end
