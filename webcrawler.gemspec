# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'webcrawler/version'

Gem::Specification.new do |s|
  s.name          = "webcrawler"
  s.required_ruby_version = ">= 1.9.3"
  s.version       = WebCrawler::VERSION
  s.date          = WebCrawler::DATE

  s.files         = Dir.glob("{bin,lib}/**/*")
  s.require_paths = ["lib"]

  s.summary       = "WebCrawler"
  s.description   = "WebCrawler Main Core for Webcrawler Service"
  s.homepage      = "http://joelcarvalho.pt"
  s.license       = "MIT"

  s.author        = "Joel Carvalho"
  s.email         = "joelsilvacarvalho@gmail.com"

  s.add_runtime_dependency "sinatra",  '~> 1.4', ">= 1.4.6"
  s.add_runtime_dependency "capybara",  '~> 2.5', ">= 2.5.0"
  s.add_runtime_dependency "capybara-screenshot",  '~> 1.0', ">= 1.0.11"
  s.add_runtime_dependency "selenium",  '~> 0.2', ">= 0.2.11"
  s.add_runtime_dependency "poltergeist",  '~> 1.7', ">= 1.7.0"
  s.add_runtime_dependency "css_parser",  '~> 1.3', ">= 1.3.6"
  s.add_runtime_dependency "chromedriver-helper", '~> 1.0',  ">= 1.0.0"
  s.add_runtime_dependency "headless",  '~> 2.2', ">= 2.2.0"
end