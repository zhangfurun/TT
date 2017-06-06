
Pod::Spec.new do |s|

s.name         = 'TT'
s.version      = '1.0'
s.summary      = 'Test File'
#s.description  = <<-DESC
#Testing TTFrameWork
#DESC
s.homepage     = 'https://github.com/zhangfurun/TT'
s.license      = 'MIT'
s.author       = { 'zhangfurun' => '122674287@qq.com' }
s.platform     = :ios, '8.0'
s.ios.deployment_target = '8.0'
s.source       = { :git => 'https://github.com/zhangfurun/TT.git', :tag => s.version }
s.requires_arc = true
s.libraries = 'z', 'c++', 'stdc++.6.0.9', 'icucore','c++.1','sqlite3.0','z.1.2.8'

s.source_files  = 'TTFrameWork', 'TTFrameWork/**/*'

s.frameworks = ['CFNetwork', 'CoreMotion', 'Foundation', 'UIKit', 'CoreText', 'CoreGraphics', 'QuartzCore', 'CoreTelephony', 'SystemConfiguration', 'AdSupport', 'JavaScriptCore', 'MessageUI', 'Security']


s.resources = [ 'TTFrameWork/ReasourceFiles/*',
                'TTFrameWork/TTOtherPayManager/AliPayTool/Support/AliPaySDK/AlipaySDK.bundle',
                'TTFrameWork/TTShare/ShareDataSource/TencentCenter/SDK_2_9_3/TencentOpenApi_IOS_Bundle.bundle',
                'TTFrameWork/TTShare/ShareDataSource/SinaCenter/SDK_3_1_1/WeiboSDK.bundle']



s.vendored_frameworks =['TTFrameWork/TTOtherPayManager/AliPayTool/Support/AliPaySDK/AlipaySDK.framework',
                        'TTFrameWork/Common/Libs/AliyunOSS/AliyunOSSiOS.framework',
                        'TTFrameWork/TTShare/ShareDataSource/TencentCenter/SDK_2_9_3/TencentOpenAPI.framework',
                        'TTFrameWork/Common/Libs/SMS_SDK/SMS_SDK.framework',
                        'TTFrameWork/Common/Libs/SMS_SDK/MOBFoundation.framework']

s.vendored_libraries = ['TTFrameWork/TTOtherPayManager/AliPayTool/Support/AliPaySDK/libcrypto.a',
                        'TTFrameWork/TTOtherPayManager/AliPayTool/Support/AliPaySDK/libssl.a',
                        'TTFrameWork/TTShare/ShareDataSource/SinaCenter/SDK_3_1_1/libWeiboSDK.a',
                        'TTFrameWork/TTShare/ShareDataSource/WeChatCenter/SDK_1_6_2/libWeChatSDK.a']
end

