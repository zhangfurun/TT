
Pod::Spec.new do |s|

s.name         = "TT"
s.version      = "1.0"
s.summary      = "Test File"

s.description  = <<-DESC
Testing TTFrameWork
DESC

s.homepage     = "https://github.com/zhangfurun/TT"

s.license      = "MIT"

s.author       = { "zhangfurun" => "122674287@qq.com" }
s.platform     = :ios, "8.0"
s.ios.deployment_target = "8.0"

s.source       = { :git => "https://github.com/zhangfurun/TT.git", :commit => "b99ac90cd5676fcf0c4b21860bb537625254f317" }

s.source_files  = "TTFrameWork", "TT/TTFrameWork/**/*.{h,m}"


s.requires_arc = true

end
