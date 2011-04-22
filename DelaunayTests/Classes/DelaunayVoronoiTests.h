//
//  DelaunayVoronoiTests.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "DelaunayVoronoi.h"
//#import "application_headers" as required


@interface DelaunayVoronoiTests : SenTestCase {
   DelaunayVoronoi *voronoi;
   CGPoint point0;
   CGPoint point1;
   CGPoint point2;
   CGPoint point3;
   NSMutableArray *points;
   CGRect plotBounds;
}

- (void) testRegionsHaveNoDuplicatedPoints;

@end
