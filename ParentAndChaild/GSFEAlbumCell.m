//
//  GSFEPhotoAlbumCell.m
//  My Album
//
//  Created by Shiv Vaishnav on 4/14/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import "GSFEAlbumCell.h"

@implementation GSFEAlbumCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if ([super initWithCoder:aDecoder]) {
        [self.noImageView setHidden:YES];
    }
    return self;
}

- (void)showNoImageOnCell:(BOOL)show
{
    if (show) {
        [self.noImageView setHidden:NO];
    }
    else{
        [self.noImageView setHidden:YES];
    }
}

@end
