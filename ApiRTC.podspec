Pod::Spec.new do |s|

s.name         = 'ApiRTC'
s.module_name  = 'ApiRTC'
s.version      = '0.3.0'
s.summary      = 'ApiRTC is a WebRTC Platform as a Service that simplifies developers access to WebRTC technology'
s.description  = 'ApiRTC cloud-based WebRTC API are built for web and mobile developers. Empower you website with real-time text, audio and video interaction by leveraging our javascript library (compatible Node.js or Angular.js) or use our plugins for your mobile apps. Apizee takes care of browser compatibility, security and NAT traversal issues for you.'
s.homepage     = 'https://apirtc.com'
s.license      = { :type => 'Commercial', :text => 'Copyright 2011-2017 Apizee. All rights reserved. Use of this software is subject to the terms and conditions of the Apizee Terms of Service located at https://apirtc.com/ApiRTC_TermsofService.pdf' }
s.author      = { 'Aleksandr Khorobrykh' => 'aleksandr.khorobrykh@apizee.com', 'Frederic Luart' => 'frederic.luart@apizee.com', 'Samuel Liard' => 'samuel.liard@apizee.com'  }

s.ios.deployment_target = '9.0'

s.source = { :git => 'https://github.com/apizee/ApiRTC-ios.git', :tag => '0.3.0' }

s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

s.dependency 'Socket.IO-Client-Swift', '13.1.0'
s.dependency 'GoogleWebRTC', '1.1.20913'

s.vendored_frameworks = 'ApiRTC.framework'

spec.prepare_command = 'ruby prepare.rb'

end
