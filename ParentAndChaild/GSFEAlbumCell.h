//
//  GSFEPhotoAlbumCell.h
//  My Album
//
//  Created by Shiv Vaishnav on 4/14/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSFEAlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UIView *noImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumImageCount;
- (void)showNoImageOnCell:(BOOL)show;
@end
