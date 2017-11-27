Pod::Spec.new do |s|

s.name         = 'ApiRTC'
s.module_name  = 'ApiRTC'
s.version      = '0.0.1'
s.summary      = 'ApiRTC framework'
s.description  = 'ApiRTC framework'
s.homepage     = 'http://apizee.com'
s.license      = { :type => 'MIT' }
s.author      = { 'Apizee' => 'contact@apizee.com' }

s.ios.deployment_target = '9.0'

s.source = { :path => "./ApiRTC"}

s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

s.dependency 'Socket.IO-Client-Swift', '13.0.1'
s.dependency 'GoogleWebRTC', '1.1.20621'

s.vendored_frameworks = 'ApiRTC.framework'

end
