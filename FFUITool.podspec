#
# Be sure to run `pod lib lint FFUITool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FFUITool'
  s.version          = '0.2.5'
  s.summary          = 'A short description of FFUITool.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/caochengfei/FFUITool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cofey' => 'cchengfei@outlook.com' }
  s.source           = { :git => 'https://github.com/caochengfei/FFUITool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '5.0'
  s.ios.deployment_target = '12.0'

  s.source_files = 'Sources/FFUITool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FFUITool' => ['FFUITool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'SnapKit'
   
   # pod spec lint FFUITool.podspec --verbose --allow-warnings
   
   # 发布到私有库
   #pod repo push FFUITool FFUITool.podspec --allow-warnings --verbose --use-libraries --skip-tests --use-modular-headers --skip-import-validation
   
   #发布到公共库
   #pod trunk push FFUITool.podspec --allow-warnings --use-libraries

end
