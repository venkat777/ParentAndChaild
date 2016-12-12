//
//  ImageViewVC.m
//  My Album
//
//  Created by Shiv Vaishnav on 4/23/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import "GSFEAlbumListVC.h"
#import "GSFEAlbumCell.h"
#import "GSFEAssetList.h"
#import "GSFEImageCollectionListVC.h"

@interface GSFEAlbumListVC ()
@property (nonatomic, strong) NSArray *albumArray;
@end

@implementation GSFEAlbumListVC

- (void)viewDidLoad{
    [super viewDidLoad];

    self.albumArray = [NSArray new];
    GSFEAssetList *assetList = [[GSFEAssetList alloc] init];
    [assetList loadMediaAlbumWithSuccess:^(NSArray *albums) {
        if (albums) {
            self.albumArray = albums;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:error:)]) {
            [self.delegate imagePickerControllerDidCancel:self error:error];
        }
    }];
    
    self.title = @"Photos";
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelImagePicker:)] animated:YES];
}

- (void)cancelImagePicker:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:error:)]) {
        [self.delegate imagePickerControllerDidCancel:self error:nil];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    GSFEAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    ALAssetsGroup *groupForCell = self.albumArray[indexPath.row];
    CGImageRef posterImageRef = [groupForCell posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    if (!posterImage) {
        [cell showNoImageOnCell:YES];
    }
    else{
        [cell showNoImageOnCell:NO];
    }
    cell.albumImageView.image = posterImage;
    cell.albumName.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
    cell.albumImageCount.text = [@(groupForCell.numberOfAssets) stringValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([(ALAssetsGroup *)[self.albumArray objectAtIndex:indexPath.row] numberOfAssets] > 0) {
        GSFEImageCollectionListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionList"];
        vc.delegate = self.delegate;
        vc.assetsGroup = (ALAssetsGroup *)[self.albumArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }

   }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99.0;
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"CollectionList"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            if ([(ALAssetsGroup *)[self.albumArray objectAtIndex:[[self.tableView indexPathForCell:(GSFEAlbumCell *)sender] row]] numberOfAssets] > 0) {
                return YES;
            }
        }
    }
    return NO;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"CollectionList"]) {
//        GSFEImageCollectionListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionList"];
//        vc.delegate = self.delegate;
//        vc.assetsGroup = (ALAssetsGroup *)[self.albumArray objectAtIndex:[[self.tableView indexPathForCell:(GSFEAlbumCell *)sender] row]];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

#pragma mark - check for permission
+ (BOOL)isImageSourcePhotoLibraryAvailableAndAllowed {
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Open the settings and check that this app is enabled under Privacy > Photos." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
    
    BOOL val =  (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined);
    return val;
}

@end
