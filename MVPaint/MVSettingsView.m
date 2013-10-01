//
//  MVSettingsView.m
//  MVPaint
//
//  Created by Igor Smirnov on 16.06.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "MVSettingsView.h"
#import "MVPaintModel.h"

@interface MVSettingsView () {
    UIColor * _color;
}

@end

@implementation MVSettingsView

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
    [self update];
    // Do any additional setup after loading the view from its nib.
}

- (void) update {
    if (_delegate) {
        self.sizeSlider.value = [_delegate currentSize];
        self.opacitySlider.value = [_delegate currentOpacity];
        _color = [_delegate currentColor];
    }
    [self updatePreview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updatePreview {
    MVPaintDrawing * tempDrawing = [[MVPaintDrawing alloc] init];
    MVPaintTransaction * tempTransaction;
    CGPoint point = CGPointMake(self.previewImageView.frame.size.width / 2 , self.previewImageView.frame.size.height / 2);

    tempTransaction = [tempDrawing newTransactionWithPoint: point color: _color size: self.sizeSlider.value];
    [tempTransaction addPoint:point];

    self.previewImageView.image = [tempDrawing drawOnSurface: self.previewImageView xScale: 1.0 yScale: 1.0];
}

- (IBAction)sizeSliderChanged:(UISlider *)sender {
    if (_delegate) {
        [_delegate sizeChangedTo: sender.value];
    }
    [self updatePreview];
}

- (IBAction)opacitySliderChanged:(UISlider *)sender {
    if (_delegate) {
        [_delegate opacityChangedTo: sender.value];
    }
    _color = [_color colorWithAlphaComponent: sender.value];
    [self updatePreview];
}

- (IBAction)saveDrawingClick:(UIButton *)sender {
    if (_delegate) {
        [_delegate saveDrawing];
    }
    [self updatePreview];
}

- (IBAction)loadDrawingClick:(UIButton *)sender {
    if (_delegate) {
        [_delegate loadDrawing];
    }
    [self updatePreview];
}

- (IBAction)clearDrawingClick:(UIButton *)sender {
    if (_delegate) {
        [_delegate clearDrawing];
    }
}

@end
