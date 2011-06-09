# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "s3_bucket_sync/version"

Gem::Specification.new do |s|
  s.name        = "s3_bucket_sync"
  s.version     = S3BucketSync::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Factory Design Labs Interactive"]
  s.email       = ["interactive@factorylabs.com"]
  s.homepage    = "http://rubygems.org/gems/s3_bucket_sync"
  s.summary     = %q{Copies files from one s3 bucket to another}
  s.description = %q{Copies files from one s3 bucket to another}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "s3"
  s.add_dependency "thor"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", ">=2.0.0"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "aruba"
end
