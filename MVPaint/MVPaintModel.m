//
//  MVPaintModel.m
//  MVPaint
//
//  Created by admin on 28.05.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "MVPaintModel.h"
#import "MVPaintStorage.h"

#pragma mark Point

@implementation MVPaintPoint : NSObject

+ (MVPaintPoint *) point: (CGPoint) point {
    return [[MVPaintPoint alloc] initWithPoint: point];
}

- (id) initWithPoint: (CGPoint) point {
    if (self = [super init]) {
        _point = point;
    }
    return self;
}

- (void) moveToInContext: (CGContextRef) context {
    CGContextMoveToPoint(context, _point.x, _point.y);
}

- (void) drawInContext: (CGContextRef) context {
    CGContextAddLineToPoint(context, _point.x, _point.y);
}

#pragma mark -
#pragma mark NSCoding

- (id) initWithCoder: (NSCoder *) aDecoder {
    if (self = [self init]) {
        _point.x = [aDecoder decodeFloatForKey: @"x"];
        _point.y = [aDecoder decodeFloatForKey: @"y"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *) aCoder {
    [aCoder encodeFloat: _point.x forKey: @"x"];
    [aCoder encodeFloat: _point.y forKey: @"y"];
}

@end

#pragma mark Transaction

@implementation MVPaintTransaction : NSObject

+ (MVPaintTransaction *) transactionWithOwner: (MVPaintDrawing *) owner point: (CGPoint) point color: (UIColor *) color size: (CGFloat) size {
    return [[MVPaintTransaction alloc] initWithOwner: owner point: point color: color size: size];
}

- (id) initWithOwner: (MVPaintDrawing *) owner point: (CGPoint) point color: (UIColor *) color size: (CGFloat) size {
    if (self = [self init]) {
        _color = color;
        _size = size;
        _points = [NSMutableArray new];
        // добавляем первую точку
        [_points addObject: [MVPaintPoint point: point]];
    }
    return self;
}

- (void) addPoint: (CGPoint) point {
    [_points addObject: [MVPaintPoint point: point]];
}

- (void) draw {
    //[view.image drawInRect:CGRectMake(0, 0, self.resultImageView.frame.size.width, self.resultImageView.frame.size.height)];
    Boolean firstPoint = true;

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextBeginPath(context);
    CGContextSetLineWidth(context, _size);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [_color CGColor]);
    CGContextSetBlendMode(context, kCGBlendModeNormal);

    // рисуем все жесты
    for (MVPaintPoint * point in _points) {
        if (firstPoint) {
            [point moveToInContext: context];
            firstPoint = false;
        } else {
            [point drawInContext: context];
        }
    }

    // если у нас только один жест, рисуем как точку
    if (_points.count == 1) {
        [_points[0] drawInContext: context];
    }
    CGContextStrokePath(context);
}

#pragma mark -
#pragma mark NSCoding

- (id) initWithCoder: (NSCoder *) aDecoder {
    if (self = [self init]) {
        _size = [aDecoder decodeFloatForKey: @"size"];
        _color = [aDecoder decodeObjectForKey: @"color"];
        _points = [aDecoder decodeObjectForKey: @"points"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *) aCoder {
    [aCoder encodeFloat: _size forKey: @"size"];
    [aCoder encodeObject: _color forKey: @"color"];
    [aCoder encodeObject: _points forKey: @"points"];
}

@end

#pragma mark -
#pragma mark Drawing

@implementation MVPaintDrawing {
    NSMutableArray * _drawing;
    NSMutableArray * _redoBuffer;
    Boolean _changed;
    NSInteger _beginUpdate;
}

- (id) init {
    if (self = [super init]) {
        _drawing = [NSMutableArray new];
        _redoBuffer = [NSMutableArray new];
        _name = nil;
    }
    return self;
}

+ (MVPaintDrawing *) drawingWithName: (NSString *) name {
    return [[[self class] alloc] initWithName: name];
}

- (id) initWithName: (NSString *) name {
    if (self = [self init]) {
        _name = name;
    }
    return self;
}

- (NSArray *) drawing {
    return _drawing;
}

- (void) setDrawing: (NSArray *) drawing {
    _drawing = [drawing mutableCopy];
}

- (UIImage *) drawOnSurface: (UIImageView *) surface xScale: (CGFloat) xScale yScale: (CGFloat) yScale {
    UIImage * result;
    UIGraphicsBeginImageContext(surface.frame.size);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), xScale, yScale);

    // рисуем все наборы
    for (MVPaintTransaction * transaction in _drawing) {
        [transaction draw];
    }

    // получаем изображение
    result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return result;
}

- (MVPaintTransaction *) newTransactionWithPoint: (CGPoint) point color: (UIColor *) color size: (CGFloat) size {
    MVPaintTransaction * result;
    [self beginUpdate];
    @try {
        result = [MVPaintTransaction transactionWithOwner: self point: point color: color size: size];
        [_drawing addObject: result];
        _changed = true;
    } @finally {
        [self endUpdate];
    }
    return result;
}

- (void) joinDrawing: (MVPaintDrawing *) drawing {
    [self beginUpdate];
    @try {
        for (MVPaintTransaction * transaction in drawing.drawing) {
            [_drawing addObject: transaction];
        }
        _changed = true;
    } @finally {
        [self endUpdate];
    }
}

- (void) beginUpdate {
    if (!_beginUpdate) {
        _changed = false;
    }
    _beginUpdate++;
}

- (void) endUpdate {
    _beginUpdate--;
    if ((_delegate) && (!_beginUpdate) && _changed) {
        [self.delegate drawingChanged: self];
    }
}

- (void) undo {
    if (self.canUndo) {
        [self beginUpdate];
        @try {
            MVPaintTransaction * transaction = [_drawing lastObject];
            [_drawing removeLastObject];
            [_redoBuffer addObject: transaction];
            _changed = true;
        } @finally {
            [self endUpdate];
        }
    }
}

- (void) redo {
    if (self.canRedo) {
        [self beginUpdate];
        @try {
            MVPaintTransaction * transaction = [_redoBuffer lastObject];
            [_redoBuffer removeLastObject];
            [_drawing addObject: transaction];
            _changed = true;
        } @finally {
            [self endUpdate];
        }
    }
}

- (void) clearRedo {
    [_redoBuffer removeAllObjects];
    if (_delegate) {
        [_delegate drawingChanged: self];
    }
}

- (Boolean) canUndo {
    return _drawing.count > 0;
}

- (Boolean) canRedo {
    return _redoBuffer.count > 0;
}

- (void) save {
    MVPaintStorage * storage = [MVPaintStorage storage];
    [storage savePaintDrawing: self withName: _name];
}

- (void) performChanged {
    if (_delegate) {
        [_delegate drawingChanged: self];
    }
}

#pragma mark -
#pragma mark NSCoding

- (void) encodeWithCoder: (NSCoder *) aCoder {
    [aCoder encodeObject: _name forKey: @"name"];
    [aCoder encodeObject: _drawing forKey: @"drawing"];
}

- (id) initWithCoder: (NSCoder *) aDecoder {
    if (self = [self init]) {
        _name = [aDecoder decodeObjectForKey: @"name"];
        _drawing = [aDecoder decodeObjectForKey: @"drawing"];
    }
    return self;
}

@end

