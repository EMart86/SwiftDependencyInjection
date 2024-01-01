#
# Be sure to run `pod lib lint SwiftDependencyInjection.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftDependencyInjection'
  s.version          = '1.3'
  s.summary          = 'A dependency Injection Framework in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Have you ever struggled withe dependency injection framework in swift. Here is one, that's based on dagger. You have modules, you have injectors that provides you with the modules, you require in your code. We also did some dependency resolving in our modules. Now let's get swifty.
                       DESC

  s.homepage         = 'https://github.com/EMart86/SwiftDependencyInjection'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Martin Eberl' => 'eberl_ma@gmx.at' }
  s.source           = { :git => 'https://github.com/EMart86/SwiftDependencyInjection.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'SwiftDependencyInjection/Classes/**/*'
end
