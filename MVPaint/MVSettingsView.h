//
//  MVSettingsView.h
//  MVPaint
//
//  Created by Igor Smirnov on 16.06.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import <UIKit/UIKit.h>

// протокол для контроллера, чтобы создатель мог обеспечить реакцию на события
@protocol MVSettingsDelegate <NSObject>
@required

- (CGFloat) currentSize;
- (CGFloat) currentOpacity;
- (UIColor *) currentColor;

- (void) sizeChangedTo: (CGFloat) newSize;
- (void) opacityChangedTo: (CGFloat) newOpacity;

- (void) clearDrawing;
- (void) loadDrawing;
- (void) saveDrawing;

@end

@interface MVSettingsView : UIViewController

@property (weak, nonatomic) id <MVSettingsDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;
@property (weak, nonatomic) IBOutlet UISlider *opacitySlider;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

- (void) update;

- (IBAction)sizeSliderChanged:(UISlider *)sender;
- (IBAction)opacitySliderChanged:(UISlider *)sender;
- (IBAction)clearDrawingClick:(UIButton *)sender;
- (IBAction)saveDrawingClick:(UIButton *)sender;
- (IBAction)loadDrawingClick:(UIButton *)sender;

@end
