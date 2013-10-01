//
//  MVPaintStorage.h
//  MVPaint
//
//  Created by Igor Smirnov on 19.06.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVPaintModel.h"

@interface MVPaintStorage : NSObject

@property (nonatomic, readonly) NSUInteger count;

+ (MVPaintStorage *) storage;

- (NSInteger) indexOfDrawingWithName: (NSString *) name;
- (void) savePaintDrawing: (MVPaintDrawing *) drawing withName: (NSString *) name;
- (MVPaintDrawing *) drawingAtIndex: (NSInteger) index;

@end
