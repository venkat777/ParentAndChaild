//
//  GSFEImagePicker.h
//  My Album
//
//  Created by Shiv Vaishnav on 4/23/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface GSFEAssetList : NSObject
- (void)loadMediaAlbumWithSuccess:(void (^)(NSArray *albums))success failure:(void(^)(NSError *))failure;
@end
