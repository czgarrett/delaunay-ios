//
//  DelaunaySiteList.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DelaunaySite;

@interface DelaunaySiteList : NSObject {
   NSMutableArray *sites;
   NSInteger currentIndex;
   BOOL sorted;
}

@property(readonly) NSInteger currentIndex;
@property(readonly) NSArray *sites;

+ (DelaunaySiteList *) siteList;
- (CGRect) sitesBounds;
- (void) addSite: (DelaunaySite *) site;
- (NSInteger) count;
- (DelaunaySite *) next;
- (NSArray *) regions: (CGRect) plotBounds;

@end
