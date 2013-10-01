//
//  MVPaintModel.h
//  MVPaint
//
//  Created by admin on 28.05.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MVPaintDrawing, MVPaintTransaction;

@protocol MVPaintDrawingDelegate <NSObject>
@required
- (void) drawingChanged: (MVPaintDrawing *) drawing;
@end

@interface MVPaintPoint : NSObject <NSCoding>

@property CGPoint point;

+ (MVPaintPoint *) point: (CGPoint) point;
- (id) initWithPoint: (CGPoint) point;

@end

@interface MVPaintTransaction : NSObject <NSCoding>

@property UIColor * color;
@property CGFloat size;
@property (strong, nonatomic) NSMutableArray * points;
@property (weak) MVPaintDrawing * owner;

+ (MVPaintTransaction *) transactionWithOwner: (MVPaintDrawing *) owner point: (CGPoint) point color: (UIColor *) color size: (CGFloat) size;
- (id) initWithOwner: (MVPaintDrawing *) owner point: (CGPoint) point color: (UIColor *) color size: (CGFloat) size;

- (void) addPoint: (CGPoint) point;
- (void) draw;

@end

@interface MVPaintDrawing : NSObject <NSCoding>

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSArray * drawing;
@property (weak) id <MVPaintDrawingDelegate> delegate;


+ (MVPaintDrawing *) drawingWithName: (NSString *) name;
- (id) initWithName: (NSString *) name;

- (UIImage *) drawOnSurface: (UIImageView *) surface xScale: (CGFloat) xScale yScale: (CGFloat) yScale;
- (MVPaintTransaction *) newTransactionWithPoint: (CGPoint) point color: (UIColor *) color size: (CGFloat) size;
- (void) joinDrawing: (MVPaintDrawing *) drawing;

- (void) beginUpdate;
- (void) endUpdate;

- (void) undo;
- (void) redo;
- (void) clearRedo;

- (void) performChanged;

- (void) save;

@property (readonly) Boolean canUndo;
@property (readonly) Boolean canRedo;

@end


