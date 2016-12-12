//
//  ImageCollectionViewCell.h
//  My Album
//
//  Created by Shiv Vaishnav on 4/24/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSFEImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageCheckMarkView;

- (void)setCellSelected:(BOOL)selected;
@end
