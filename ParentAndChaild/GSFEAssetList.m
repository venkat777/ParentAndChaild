//
//  GSFEImagePicker.m
//  My Album
//
//  Created by Shiv Vaishnav on 4/23/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import "GSFEAssetList.h"

@interface GSFEAssetList ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@end
@implementation GSFEAssetList

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.assetsLibrary = [self defaultAssetsLibrary];
    }
    return self;
}
- (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)loadMediaAlbumWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    // setup our failure view controller in case enumerateGroupsWithTypes fails
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Open the settings and check that this app is enabled under Privacy > Photos." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                failure(nil);
            }
                break;
            default:
                failure(error);
                break;
        }
    };
    
    __block NSMutableArray *groupArray = [NSMutableArray new];
    // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            ALAssetsFilter *allAssetsFilter = [ALAssetsFilter allAssets];
            [group setAssetsFilter:allAssetsFilter];
            [groupArray addObject:group];
        }
        else{
            success([NSArray arrayWithArray:groupArray]);
        }
    };
    // enumerate only photos
    NSUInteger groupTypes = ALAssetsGroupAll;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

@end
