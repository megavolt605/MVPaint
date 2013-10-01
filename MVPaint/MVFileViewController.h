//
//  MVFileViewController.h
//  MVPaint
//
//  Created by admin on 28.05.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPaintModel.h"

@protocol MVFileViewConrollerDelegate <NSObject>

- (void) wantToLoadDrawing: (MVPaintDrawing *) drawing;

@end

@interface MVFileViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) id <MVFileViewConrollerDelegate> delegate;
@property (nonatomic) CGSize originalSize;
- (IBAction)tapGesture:(UITapGestureRecognizer *)sender;
- (IBAction)doubleTapGesture:(UITapGestureRecognizer *)sender;

@end
