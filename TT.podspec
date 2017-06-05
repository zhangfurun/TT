Pod::Spec.new do |s|
s.name         = 'TT'
s.version      = '1.0'
s.summary      = '日常项目开发的功能性的整理,项目中集合了诸多的功能,如一站式第三方支付,高性能的网路请求封装,分享等等功能'
s.homepage     = 'https://github.com/zhangfurun'
s.license      = 'MIT'
s.author       = { 'zhangfurun' => '122674287@qq.com' }
s.platform     = :ios, '8.0'
s.source       = { :git => 'https://github.com/zhangfurun/TT.git', :tag => s.version}

s.source_files  = 'TTFrameWork', 'TT/TTFrameWork/**/*.{h,m}'
s.exclude_files = 'TTFrameWork/Exclude'
s.public_header_files = "TT/TTFrameWork/**/*.h"
s.frameworks ='UIKit'
s.requires_arc = true
end
