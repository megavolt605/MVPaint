//
//  MVPaintStorage.m
//  MVPaint
//
//  Created by Igor Smirnov on 19.06.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "MVPaintStorage.h"
#import "MVPaintModel.h"

@implementation MVPaintStorage {
    NSMutableArray * _drawings;
}

static MVPaintStorage * storage;

+ (MVPaintStorage *) storage {
    if (!storage) {
        storage = [[super allocWithZone: nil] init];
    }
    return storage;
}

- (id) init {
    if (self = [super init]) {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSData * loadedData = [userDefaults objectForKey: @"drawings"];
        _drawings = [NSKeyedUnarchiver unarchiveObjectWithData: loadedData];
        if (!_drawings) {
            _drawings = [NSMutableArray new];
        }
    }
    return self;
}

+ (id) allocWithZone: (NSZone *) zone {
    return storage;
}

- (NSInteger) indexOfDrawingWithName: (NSString *) name {
    NSInteger result = 0;
    for (MVPaintDrawing * drawing in _drawings) {
        if ([drawing.name isEqualToString: name]) {
            return result;
        }
        result++;
    }
    return -1;
}

- (MVPaintDrawing *) drawingAtIndex: (NSInteger) index {
    return _drawings[index];
}

- (void) savePaintDrawing: (MVPaintDrawing *) drawing withName: (NSString *) name {
    NSInteger index = [self indexOfDrawingWithName: name];
    if (index < 0) {
        [_drawings addObject: drawing];
    } else {
        [_drawings replaceObjectAtIndex: index withObject: drawing];
    }

    NSData * data = [NSKeyedArchiver archivedDataWithRootObject: _drawings];

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: data forKey: @"drawings"];
    [userDefaults synchronize];
}

- (NSUInteger) count {
    return _drawings.count;
}

@end
