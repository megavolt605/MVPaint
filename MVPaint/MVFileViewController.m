//
//  MVFileViewController.m
//  MVPaint
//
//  Created by admin on 28.05.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "MVFileViewController.h"
#import "MVFileViewCell.h"
#import "MVPaintStorage.h"

@implementation MVFileViewController {
    NSInteger lastSelected;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [MVPaintStorage storage].count;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)handleDoubleTap:(UIGestureRecognizer*)gr {
    NSLog(@"================= double tap %d ============", lastSelected);
    if (_delegate) {
        [_delegate wantToLoadDrawing: [[MVPaintStorage storage] drawingAtIndex: lastSelected]];
    }
    [self.navigationController popToRootViewControllerAnimated: true];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"================= deselected %d ============", indexPath.row);
    MVFileViewCell * cell = (MVFileViewCell *)[collectionView cellForItemAtIndexPath: indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    lastSelected = indexPath.row;
    NSLog(@"================= selected %d ============", indexPath.row);
    MVFileViewCell * cell = (MVFileViewCell *)[collectionView cellForItemAtIndexPath: indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
}


- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    MVFileViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Preview Cell" forIndexPath: indexPath];
    MVPaintDrawing * drawing = [[MVPaintStorage storage] drawingAtIndex: indexPath.row];
    NSLog(@"row = %d", indexPath.row);
    cell.backgroundColor = [UIColor whiteColor];

    cell.previewImageView.image = [drawing drawOnSurface: cell.previewImageView
                                                  xScale: cell.previewImageView.frame.size.width / _originalSize.width
                                                  yScale: cell.previewImageView.frame.size.height / _originalSize.height];
    cell.nameLabel.text = drawing.name;
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;

    [cell addGestureRecognizer: doubleTap];
    //[cell prepareForReuse];
    return cell;
}

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    NSLog(@"Tap");
}

- (IBAction)doubleTapGesture:(UITapGestureRecognizer *)sender {
    NSLog(@"Double tap");
}
@end
