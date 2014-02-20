Pod::Spec.new do |s|
  s.name         = "delaunay-ios"
  s.version      = "1.0.0"
  s.summary      = "Delaunay and Voronoi diagram generators for iOS."
  s.homepage     = "https://github.com/czgarrett/delaunay-ios"
  s.license      = 'MIT'
  s.author       = { 'Christopher Z. Garrett' => 'z@zworkbench.com' }
  s.source       = { :git => "https://github.com/czgarrett/delaunay-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '4.3'
  s.framework    = 'Foundation', 'UIKit', 'CoreGraphics'
  s.requires_arc = false
  s.source_files = 'Delaunay/**/*.{h,m}'

  s.prefix_header_file = 'Delaunay/Delaunay-Prefix.pch'

end