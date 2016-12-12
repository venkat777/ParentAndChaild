//
//  GSFEImagePickerProtocol.h
//  GSFileExplorer
//
//  Created by Shiv Vaishnav on 4/27/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GSFEAlbumListVC;

@protocol GSFEImagePickerProtocol <NSObject>
@required
- (void)imagePickerControllerDidCancel:(GSFEAlbumListVC *)picker error:(NSError *)error;
- (void)imagePickerController:(GSFEAlbumListVC *)picker didFinishPickingMediaWithFiles:(NSArray *)images fileNames:(NSArray *)fileNames mimeTypes:(NSArray *)mimeTypes;
@end
