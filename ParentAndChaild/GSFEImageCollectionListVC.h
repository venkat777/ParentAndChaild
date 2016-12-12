//
//  ImageCollectionViewController.h
//  My Album
//
//  Created by Shiv Vaishnav on 4/24/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GSFEImagePickerProtocol.h"

@interface GSFEImageCollectionListVC : UICollectionViewController
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, weak) id<GSFEImagePickerProtocol> delegate;
@end
