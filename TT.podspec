
Pod::Spec.new do |s|

s.name         = "TT"
s.version      = "1.0"
s.summary      = "Test File"

s.description  = <<-DESC
Testing TTFrameWork
DESC

s.homepage     = "https://github.com/zhangfurun/TT"

s.license= { :type => "MIT", :file => "LICENSE" }

s.author       = { "zhangfurun" => "122674287@qq.com" }
s.platform     = :ios, "8.0"
s.ios.deployment_target = "8.0"

s.source       = { :git => "https://github.com/zhangfurun/TT.git", :tag => s.version }

s.source_files  = "TT/TTFrameWork/**/*"
s.requires_arc = true

end
