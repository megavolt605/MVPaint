//
//  MVSaveViewController.h
//  MVPaint
//
//  Created by Igor Smirnov on 19.06.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPaintModel.h"

@interface MVSaveViewController : UIViewController

- (IBAction)saveButtonClick:(id)sender;

@property (weak, nonatomic) MVPaintDrawing * drawing;
@property (nonatomic) CGSize originalSize;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;

@end
