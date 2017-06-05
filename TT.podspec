#
#  Be sure to run `pod spec lint TT.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name         = "TT"
    s.version      = "1.0"
    s.summary      = "日常项目开发的功能性的整理,项目中集合了诸多的功能,如一站式第三方支付,高性能的网路请求封装,分享等等功能"
s.description  = <<-DESC
this project provide all kinds of categories for iOS developer
DESC
    s.homepage     = "https://github.com/zhangfurun"
    s.license      = "MIT"
    s.license      = { :type => "MIT"， :file => "LICENSE" }
    s.author       = { "zhangfurun" => "122674287@qq.com" }
    s.platform     = :ios, "8.0"
    s.source       = { :git => "https://github.com/zhangfurun/TT.git", :tag => s.version }
    s.source_files  = "TTFrameWork", "TTFrameWork/**/*.{h,m}"
    s.exclude_files = "TTFrameWork/Exclude"
    s.public_header_files = "TTFrameWork/**/*.h"
    s.requires_arc = true
end
