//
//  MVPaintViewController.h
//  MVPaint
//
//  Created by Igor Smirnov on 22.05.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVSettingsView.h"
#import "MVPaintModel.h"
#import "MVFileViewController.h"

@interface MVPaintViewController : UIViewController
    <UIAlertViewDelegate,
     UIActionSheetDelegate,
     MVSettingsDelegate,
     MVPaintDrawingDelegate,
     MVFileViewConrollerDelegate>

- (IBAction)colorSelectAction:(UIButton *)sender;
- (IBAction)showPopover:(id)sender;
- (IBAction)undoClick:(id)sender;
- (IBAction)redoClick:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *colorPencils;
@property (weak, nonatomic) IBOutlet UIImageView *drawingSurface;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UIButton *startColor;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;

@end
