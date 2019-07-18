#
# Be sure to run `pod lib lint KLServer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KLServer'
  s.version          = '1.0.0'
  s.summary          = '组件化中间件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  组件简介：
  组件化中间件，负责组件化中所有业务组件的服务调度；
  对CTMediator命名规范进行修改；
  将Target-Action概念 转成 Service(服务)-Task(任务);
  KLServer(服务器) -> Service(服务) perform Task(任务).
                       DESC

  s.homepage         = 'https://github.com/Kalanhall'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kalan' => 'Kalanhall@163.com' }
  s.source           = { :git => 'https://github.com/Kalanhall/KLServer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'KLServer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KLServer' => ['KLServer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
