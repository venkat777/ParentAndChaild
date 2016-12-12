//
//  ImageCollectionViewCell.m
//  My Album
//
//  Created by Shiv Vaishnav on 4/24/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import "GSFEImageCollectionViewCell.h"

@implementation GSFEImageCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if ([super initWithCoder:aDecoder]) {
        [self.selectedImageCheckMarkView setHidden:YES];
    }
    return self;
}

- (void)setCellSelected:(BOOL)selected{
    if (selected) {
        [self.selectedImageCheckMarkView setHidden:NO];
    }
    else{
        [self.selectedImageCheckMarkView setHidden:YES];
    }
}
@end
