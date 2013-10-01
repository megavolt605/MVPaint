//
//  MVSaveViewController.m
//  MVPaint
//
//  Created by Igor Smirnov on 19.06.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "MVSaveViewController.h"

@interface MVSaveViewController ()

@end

@implementation MVSaveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.previewImage.image = [_drawing drawOnSurface: self.previewImage xScale: 1.0 yScale: 1.0];

    self.nameTextField.text = _drawing.name;
    [self.nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonClick:(id)sender {

    self.drawing.name = self.nameTextField.text;
    [self.drawing save];
}

@end
