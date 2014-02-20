Pod::Spec.new do |s|
  s.name	= "delaunay-ios"
  s.version	= "1.0.0"
  s.summary	= "Delaunay and Voronoi diagram generators for iOS."
  s.description = "Delaunay and Voronoi diagram generators for iOS.

These are adapted from various other projects, but the biggest inspiration for this code is the ActionScript library located at https://github.com/nodename/as3delaunay.  (Thanks Alan Shaw!)"
  s.homepage	= "https://github.com/czgarrett/delaunay-ios"
  s.license = { :type => 'MIT' }
  s.author	= "Christopher Z. Garrett"
  s.source  = { :git => "https://github.com/caidurbin/delaunay-ios.git", :tag => 'v1.0.0' }

  s.ios.deployment_target = "7.0"

  s.source_files = 'Delaunay/**/*.{h,m}'
  s.prefix_header_file = 'Delaunay/Delaunay-Prefix.pch'

  s.ios.framework = 'Foundation', 'UIKit', 'CoreGraphics'

end