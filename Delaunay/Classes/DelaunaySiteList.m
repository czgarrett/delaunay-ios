//
//  DelaunaySiteList.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunaySiteList.h"
#import "DelaunaySite.h"

@implementation DelaunaySiteList

@synthesize currentIndex, sites;

+ (DelaunaySiteList *) siteList {
   DelaunaySiteList *siteList = [[[DelaunaySiteList alloc] init] autorelease];
   return siteList;
}

- (id) init {
   if ((self = [super init])) {
      sites = [[NSMutableArray alloc] init];
      currentIndex = 0;
   }
   return self;
}

- (NSString *) description {
   return [NSString stringWithFormat: @"SiteList (currentIndex: %d sorted: %d sites: %@", currentIndex, sorted, sites];
}



- (void) dealloc {
   [sites release];
   [super dealloc];
}

- (CGRect) sitesBounds {
   if (!sorted) {
      // Set the sites' indexes first
      NSInteger newIndex = 0;
      for (DelaunaySite *site in sites) {
         site.index = newIndex;
         newIndex++;
      }
      [sites sortUsingSelector: @selector(compare:)];
      sorted = YES;
   }
   CGFloat xmin, xmax, ymin, ymax;
   if ([sites count] == 0) {
      return CGRectZero;
   }
   xmin = CGFLOAT_MAX;
   xmax = CGFLOAT_MIN;
   for (DelaunaySite *site in sites) {
      if (site.x < xmin) {
         xmin = site.x;
      }
      if (site.x > xmax) {
         xmax = site.x;
      }
   }
   // we assume the sites have been sorted on y
   ymin = [(DelaunaySite *)[sites objectAtIndex: 0] y];
   ymax = [(DelaunaySite *)[sites objectAtIndex: [sites count] -1] y];
   return CGRectMake(xmin, ymin, xmax - xmin, ymax - ymin);
}

- (void) addSite: (DelaunaySite *) site {
   [sites addObject: site];
}

- (NSInteger) count {
   return [sites count];
}

- (DelaunaySite *) next {
   NSAssert(sorted, @"Sites have not been sorted");
   if (currentIndex < [sites count]) {
      DelaunaySite *site = [sites objectAtIndex: currentIndex++];
      return site;
   }
   return nil;
}

- (NSArray *) regions: (CGRect) plotBounds {
   NSMutableArray *result = [NSMutableArray array];
   for (DelaunaySite *site in sites) {
      [result addObject: [site region]];
   }
   return result;
}




@end
