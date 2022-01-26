#
# Be sure to run `pod lib lint KKRulerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KKRulerView'
  s.version          = '1.0.0'
  s.summary          = '一个尺子视图'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
一个尺子视图，支持自定义文本样式，支持上文下尺，上尺下文
                       DESC

  s.homepage         = 'https://github.com/kkwong90@163.com/KKRulerView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kkwong' => 'kkwong90@163.com' }
  s.source           = { :git => 'https://github.com/kkwong90@163.com/KKRulerView.git', :tag => s.version.to_s }
  
  #社交网站地址
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  
  #源文件路径
  s.source_files = 'KKRulerView/Classes/**/*'
  
  #是否支持ARC
  s.requires_arc = true
  
  #资源路径
#   s.resource_bundles = {
#     'KKRulerView' => ['KKRulerView/Assets/*.png']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  #依赖系统库
  # s.frameworks = 'UIKit', 'MapKit'
  # 依赖的第三方库并指定版本号
  # s.dependency 'AFNetworking', '~> 2.3'
  # 添加系统依赖静态库
  # s.library = 'sqlite3', 'xml2'
end
