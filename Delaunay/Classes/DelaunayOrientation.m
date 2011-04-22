//
//  DelaunayOrientation.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/13/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayOrientation.h"

DelaunayOrientation *left;
DelaunayOrientation *right;

@implementation DelaunayOrientation


+ (DelaunayOrientation *) left {
   if (!left) {
      left = [[DelaunayOrientation alloc] init];
   }
   return left;
}

+ (DelaunayOrientation *) right {
   if (!right) {
      right = [[DelaunayOrientation alloc] init];
   }
   return right;
}

- (NSString *) description {
   if ([self isLeft]) return @"LEFT";
   return @"RIGHT";
}

- (DelaunayOrientation *) opposite {
   if (self == left) return right;
   return left;
}

- (BOOL) isLeft {
   return self == left;
}
- (BOOL) isRight {
   return self == right;
}


@end

