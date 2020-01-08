
Pod::Spec.new do |s|

  s.name         = "SYImageBrowser"
  s.version      = "2.3.0"
  s.summary      = "图片广告与浏览控件SYImageBrowser."
  s.homepage     = "https://github.com/potato512/SYImageBrowser"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "devZhang" => "zhangsy757@163.com" }  
  s.platform     = :ios, "5.0" 
  s.source       = { :git => "https://github.com/potato512/SYImageBrowser.git", :tag => s.version.to_s }
  s.source_files  = "SYImageBrowser/*.{h,m}"
  s.public_header_files = "SYImageBrowser/*.h"
  s.requires_arc = true

  s.dependency "SDWebImage"

end
