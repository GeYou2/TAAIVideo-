#
# Be sure to run `pod lib lint TAAVideo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TAAVideo'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TAAVideo.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/GeYou2/TAAIVideo-'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = 'LICENSE'
  s.author           = { 'geyou2' => '2387034197@qq.com' }
  s.source           = { :git => 'https://github.com/GeYou2/TAAIVideo-.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TAAVideo/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TAAVideo' => ['TAAVideo/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking'
  # s.dependency 'MJExtension'
  # s.dependency 'Masonry'
  # s.dependency 'SDWebImage'
  # s.dependency 'MBProgressHUD'
  # s.dependency 'Masonry'
  # s.dependency 'MJRefresh'
  # s.dependency 'SensorsAnalyticsSDK'
end
