#
# Be sure to run `pod lib lint LBVideoRecord.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = ''LBVideoRecord
  s.version          = '0.1.0'
  s.summary          = 'A short description of LBVideoRecord.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yangqingren/QRVideoRecord.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangqingren' => '564008993@qq.com' }
  s.source           = { :git => 'https://github.com/yangqingren/QRVideoRecord.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'LBVideoRecord/Classes/**/*'
  s.resource     = 'LBVideoRecord/Assets/*.bundle'
  
  s.dependency 'SCRecorder'
  s.dependency 'Masonry'
  s.dependency 'LBLoadingView'
  s.dependency 'LBCategory'
  s.dependency 'LBToastView'

end
