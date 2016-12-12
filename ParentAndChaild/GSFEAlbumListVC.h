//
//  ImageViewVC.h
//  My Album
//
//  Created by Shiv Vaishnav on 4/23/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSFEImagePickerProtocol.h"

@interface GSFEAlbumListVC : UITableViewController
@property (nonatomic, weak) id<GSFEImagePickerProtocol> delegate;
+ (BOOL)isImageSourcePhotoLibraryAvailableAndAllowed;
@end
