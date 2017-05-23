
Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "SYImageBrowser"
  s.version      = "0.0.1"
  s.summary      = "图片广告与浏览控件SYImageBrowser."
  s.description  = <<-DESC
                  SYImageBrowser控件功能包括：自定义显示样式的广告轮播图、图片定位浏览。
                   DESC

  s.homepage     = "https://github.com/potato512/SYImageBrowser"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "devZhang" => "zhangsy757@163.com" }
  
  s.platform     = :ios, "5.0"
  s.ios.deployment_target = "5.0"

  s.source       = { :git => "https://github.com/potato512/SYImageBrowser.git", :tag => "#{s.version}" }
  s.source_files  = "SYImageBrowser", "SYImageBrowser/*.{h,m}"
  s.public_header_files = "SYImageBrowser/*.h"
  s.resources = "SYImageBrowser/ImageSources/*.png"

  s.requires_arc = true

  s.dependency "SDWebImage"

end
