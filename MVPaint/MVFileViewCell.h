//
//  MVFileViewCell.h
//  MVPaint
//
//  Created by Igor Smirnov on 30.06.13.
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVFileViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
