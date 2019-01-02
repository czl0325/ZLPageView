Pod::Spec.new do |s|

  s.name         = "ZLPageView"
  s.version      = "2.1.3"
  s.summary      = "ZLPageView"

  s.description  = <<-DESC
                      github上唯一支持autolayout的tablayuot
                   DESC

  s.homepage     = "https://github.com/czl0325/ZLPageView"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "czl0325" => "295183917@qq.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/czl0325/ZLPageView.git", :tag => s.version }
  
  #s.ios.deployment_target = '8.0'
  s.source_files  = "ZLPageViewDemo/ZLPageView/*.{h,m}"
  #s.resources = 'SXWaveAnimate/images/*.{png,xib}'
 #s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
  s.dependency 'Masonry' 
  s.dependency 'SDWebImage'

end
