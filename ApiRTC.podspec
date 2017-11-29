Pod::Spec.new do |s|

s.name         = 'ApiRTC'
s.module_name  = 'ApiRTC'
s.version      = '0.1.0'
s.summary      = 'ApiRTC framework'
s.description  = 'TODO'
s.homepage     = 'https://github.com/apizee/ApiRTC-ios'
s.license      = { :type => 'Commercial', :text => 'Copyright 2011-2017 Apizee. All rights reserved. Use of this software is subject to the terms and conditions of the Apizee Terms of Service located at https://www.apizee.com/legal-notice' }
s.author      = { 'Aleksandr Khorobrykh' => 'aleksandr.khorobrykh@apizee.com', 'Frederic Luart' => 'frederic.luart@apizee.com', 'Samuel Liard' => 'samuel.liard@apizee.com'  }

s.ios.deployment_target = '9.0'

s.source = { :path => "./ApiRTC.framework"}

s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

s.dependency 'Socket.IO-Client-Swift', '13.0.1'
s.dependency 'GoogleWebRTC', '1.1.20621'

s.vendored_frameworks = 'ApiRTC.framework'

end
