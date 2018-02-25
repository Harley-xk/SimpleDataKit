#
# Be sure to run `pod lib lint SimpleDataKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

s.name             = 'SimpleDataKit'
s.version          = '0.6.0'
s.summary          = 'Simple ORM framework based on SQLite And FMDB.'
s.homepage         = 'https://github.com/Harley-xk/SimpleDataKit'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Harley.xk' => 'harley.gb@foxmail.com' }
s.source           = { :git => 'https://github.com/Harley-xk/SimpleDataKit.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'SimpleDataKit/**/*'

# s.resource_bundles = {
#   'SimpleDataKit' => ['SimpleDataKit/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
s.dependency 'FMDB', '~> 2.7'

end

