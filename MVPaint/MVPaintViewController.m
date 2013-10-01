//
//  MVPaintViewController.m
//  MVPaint
//
//  Created by Igor Smirnov on 22.05.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "MVPaintViewController.h"
#import "MVSaveViewController.h"

@interface MVPaintViewController ()

@end

@implementation MVPaintViewController {
    UIColor * _pencilColor;
    CGPoint _lastPoint;
    CGFloat _pencilSize, _opacity;
    Boolean _movingStarted;
    Boolean _wasMoved;
    MVSettingsView * _popoverView;
    UIPopoverController * _settingsViewController;

    MVPaintDrawing * _drawing;
    MVPaintDrawing * _currentDrawing;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    _opacity = 1;
    [self colorSelectAction: self.startColor];
    _pencilSize = 10.0f;
    _drawing = [MVPaintDrawing drawingWithName:@"Новый рисунок"];
    _drawing.delegate = self;
    [self drawingChanged: _drawing];
    self.navigationItem.title = _drawing.name;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) colorSelectAction: (UIButton *) sender {
    for (UIButton * button in self.colorPencils) {
        if (button.tag == sender.tag) {
            button.alpha = 0;
            _pencilColor = [button titleColorForState: UIControlStateNormal];
            _pencilColor = [_pencilColor colorWithAlphaComponent: _opacity];
        } else {
            button.alpha = 0.5;
        }
    }
}

- (void) newPoint: (CGPoint) point {
    MVPaintTransaction * transaction;
    if (_currentDrawing.drawing.count == 0) {
        transaction = [_currentDrawing newTransactionWithPoint: point color: _pencilColor size: _pencilSize];
    } else {
        transaction = _currentDrawing.drawing[0];
    }
    [transaction addPoint: point];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    UITouch *touch = [touches anyObject];
    _lastPoint = [touch locationInView:self.view];
    if ([_resultImageView pointInside: _lastPoint withEvent: event]) {
        _wasMoved = false;
        _movingStarted = true;
        _currentDrawing = [[MVPaintDrawing alloc] init];
        //NSLog(@"touchesBegan x = %f, y = %f", _lastPoint.x, _lastPoint.y);
    }
}

-(void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event {
    if (_movingStarted) {
        UITouch * touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        if ([_drawingSurface pointInside: currentPoint withEvent: event]) {
            _wasMoved = true;

            [self newPoint: currentPoint];

            _drawingSurface.image = [_currentDrawing drawOnSurface: _drawingSurface xScale: 1.0 yScale: 1.0];
            _lastPoint = currentPoint;
        }
    }
    //NSLog(@"touchesMoved x = %f, y = %f", _lastPoint.x, _lastPoint.y);
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {

    if (_movingStarted) {
        if (!_wasMoved) {
            [self newPoint: _lastPoint];
            _drawingSurface.image = [_currentDrawing drawOnSurface: _drawingSurface xScale: 1.0 yScale: 1.0];
        }

        [_drawing joinDrawing: _currentDrawing];

        UIGraphicsBeginImageContext(self.resultImageView.frame.size);
        CGRect rect = CGRectMake(0, 0, self.resultImageView.frame.size.width, self.resultImageView.frame.size.height);
        [self.resultImageView.image drawInRect: rect blendMode: kCGBlendModeNormal alpha: 1];
        [self.drawingSurface.image drawInRect: rect blendMode: kCGBlendModeNormal alpha: 1];
        self.resultImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        self.drawingSurface.image = nil;
        UIGraphicsEndImageContext();
        [_drawing clearRedo];
        _movingStarted = false;
        
        //NSLog(@"touchesEnd %d", _drawing.drawing.count);
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        self.resultImageView.image = nil;
        [self dismissPopover];
    }
}

- (IBAction)showPopover: (id) sender {

    if (!(_settingsViewController)) {
        _popoverView = [[MVSettingsView alloc] initWithNibName: @"MVSettingsView" bundle: [NSBundle mainBundle]];
        _popoverView.delegate = self;
        [_popoverView setContentSizeForViewInPopover: _popoverView.view.frame.size];

        _settingsViewController = [[UIPopoverController alloc] initWithContentViewController: _popoverView];
        [_settingsViewController presentPopoverFromBarButtonItem: sender permittedArrowDirections: UIPopoverArrowDirectionAny animated: true];
    } else {
        if (_settingsViewController.isPopoverVisible) {
            [self dismissPopover];
        } else {
            [_settingsViewController presentPopoverFromBarButtonItem: sender permittedArrowDirections: UIPopoverArrowDirectionAny animated: true];
        }
    }
    if (_popoverView) {
        [_popoverView update];
    }
}

- (void) redraw {
    self.resultImageView.image = nil;
    self.resultImageView.image = [_drawing drawOnSurface: self.resultImageView xScale: 1.0 yScale: 1.0];
    self.drawingSurface.image = nil;
}

- (IBAction)undoClick:(id)sender {
    [_drawing undo];
    [self redraw];
}

- (IBAction)redoClick:(id)sender {
    [_drawing redo];
    [self redraw];
}

- (void) dismissPopover {
    [_settingsViewController dismissPopoverAnimated: true];
    _settingsViewController = nil;
    _popoverView = nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"SaveDrawing"]) {
        MVSaveViewController * view = (MVSaveViewController *) segue.destinationViewController;
        view.drawing = _drawing;
        view.originalSize = self.view.frame.size;
    } else
    if ([segue.identifier isEqualToString: @"ListOfDrawings"]) {
        MVFileViewController * view = (MVFileViewController *) segue.destinationViewController;
        view.originalSize = self.view.frame.size;
        view.delegate = self;
    }
}

#pragma mark -
#pragma mark MVFileViewConrollerDelegate

- (void) wantToLoadDrawing: (MVPaintDrawing *) drawing {
    _drawing = drawing;
    _drawing.delegate = self;
    [_drawing performChanged];
    [self redraw];
}

#pragma mark -
#pragma mark MVPaintDrawingDelegate

- (void) drawingChanged: (MVPaintDrawing *) drawing {
    self.undoButton.enabled = (drawing) && (drawing.canUndo);
    self.redoButton.enabled = (drawing) && (drawing.canRedo);
}

#pragma mark -
#pragma mark MVSettingsDelegate

- (void) currentSize: (CGFloat *) size opacity: (CGFloat *) opacity color: (UIColor *) color {
    *size = _pencilSize;
    *opacity = _opacity;
    color = _pencilColor;
}

- (CGFloat) currentSize {
    return _pencilSize;
}

- (CGFloat) currentOpacity {
    return _opacity;
}

- (UIColor *) currentColor {
    return _pencilColor;
}


- (void) sizeChangedTo: (CGFloat) newSize {
    _pencilSize = newSize;
}

- (void) opacityChangedTo: (CGFloat) newOpacity {
    _opacity = newOpacity;
    _pencilColor = [_pencilColor colorWithAlphaComponent: newOpacity];
}

- (void) clearDrawing {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Очистка" message: @"Очистить рисунок?" delegate: self cancelButtonTitle: @"Нет" otherButtonTitles: @"Очистить", nil];
    [alert show];
}

- (void) loadDrawing {
    [self dismissPopover];
    [self performSegueWithIdentifier: @"ListOfDrawings" sender: self];
}

- (void) saveDrawing {
    [self dismissPopover];
    [self performSegueWithIdentifier: @"SaveDrawing" sender: self];
}

@end
