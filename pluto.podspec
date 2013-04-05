#
# Be sure to run `pod spec lint pluto.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "pluto"
  s.version      = "1.0"
  s.summary      = "some tools brought by xhan."
  # s.description  = <<-DESC
  #                   An optional longer description of pluto
  #
  #                   * Markdown format.
  #                   * Don't worry about the indent, we strip it!
  #                  DESC
  s.homepage     = "http://ixhan.com/pluto"
  s.license  = 'BSD / Apache License, Version 2.0'


  s.author       = { "xhan" => "xhan87@gmail.com" }
  s.source       = { :git => "https://github.com/xhan/PlutoLand.git", #:tag => "0.0.1" }
  :commit => 'ff8143bfc73c89fea8d907eceec595229b6a4fd4'}


  s.platform     = :ios, '4.3'

  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'

  # A list of file patterns which select the source files that should be
  # added to the Pods project. If the pattern is a directory then the
  # path will automatically have '*.{h,m,mm,c,cpp}' appended.
  #
  # s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.source_files = 'PlutoLand/**/*.{h,m}'



  # Specify a list of frameworks that the application needs to link
  # against for this Pod to work.
  #
  s.frameworks = 'UIKit','QuartzCore'
  # s.framework  = 'SomeFramework'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'

  # Specify a list of libraries that the application needs to link
  # against for this Pod to work.
  #
  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'

  # If this Pod uses ARC, specify it like so.
  #
  s.requires_arc = false

  #
  # s.dependency 'JSONKit', '~> 1.4'
end
