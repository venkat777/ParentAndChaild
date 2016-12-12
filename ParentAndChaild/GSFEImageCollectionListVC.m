//
//  ImageCollectionViewController.m
//  My Album
//
//  Created by Shiv Vaishnav on 4/24/15.
//  Copyright (c) 2015 Good Technologies. All rights reserved.
//

#import "GSFEImageCollectionListVC.h"
#import "GSFEImageCollectionViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kImageFilenameDateFormat @"yyyy-MM-dd hh.mm.ss.SSS a"

@interface GSFEImageCollectionListVC ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSNumber* totalSize;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *selectedItemsLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIView *keyLineView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation GSFEImageCollectionListVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:kImageFilenameDateFormat];
    
    self.selectedAssets = [NSMutableArray new];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.allowsSelection = YES;
    
    CGRect frame = self.collectionView.frame;
    frame.origin.y = frame.size.height - 44;
    frame.size.height = 44;
    
    self.bottomView = [[UIView alloc] initWithFrame:frame];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.alpha = 0;
    
    frame.origin.x = 10;
    frame.origin.y = 12;
    frame.size.height = 20;
    frame.size.width = frame.size.width/2-20;
    self.selectedItemsLabel = [[UILabel alloc] initWithFrame:frame];
    self.selectedItemsLabel.textAlignment = NSTextAlignmentLeft;
    self.selectedItemsLabel.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14];
    [self.bottomView addSubview:self.selectedItemsLabel];
    
    frame.origin.x = self.bottomView.frame.size.width/2+10;
    self.sizeLabel = [[UILabel alloc] initWithFrame:frame];
    self.sizeLabel.textAlignment = NSTextAlignmentRight;
    self.sizeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.sizeLabel.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14];
    [self.bottomView addSubview:self.sizeLabel];
    [self.view addSubview:self.bottomView];
    
    frame = self.bottomView.frame;
    frame.origin.y = 0;
    frame.size.height = 1.5f;
    self.keyLineView = [[UIView alloc] initWithFrame:frame];
    self.keyLineView.backgroundColor = [UIColor colorWithRed:0.239 green:0.584 blue:0.906 alpha:1.000];
    self.keyLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.bottomView addSubview:self.keyLineView];
    
    self.bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelImagePicker:)] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    if (!self.assets) {
        self.assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets addObject:result];
        }
    };
    
    ALAssetsFilter *allAssetsFilter = [ALAssetsFilter allAssets];
    [self.assetsGroup setAssetsFilter:allAssetsFilter];
    [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}

#pragma mark - collectionview methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (IS_IPAD) {
//        return CGSizeMake(121.0, 121.0);
//    }
//    else if (IS_IPHONE_6_PLUS){
//        return CGSizeMake(75.0, 75.0);
//    }
//    else if (IS_IPHONE_6){
//        return CGSizeMake(86.0, 86.0);
//    }
//    else{
//        return CGSizeMake(73.0, 73.0);
//    }
    return CGSizeMake(73.0, 73.0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    GSFEImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setCellSelected:cell.selected];
    ALAsset *asset = self.assets[indexPath.row];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    cell.imageView.image = thumbnail;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self updateMessageOnCellSelection:YES forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self updateMessageOnCellSelection:NO forIndexPath:indexPath];
}

#pragma mark - custom methods

- (GSFEAlbumListVC *)getImageViewController{
    NSUInteger currentVCIndex = [self.navigationController.viewControllers indexOfObject:self.navigationController.topViewController];
    //previous view controller
    GSFEAlbumListVC *imageViewController = (GSFEAlbumListVC *)[self.navigationController.viewControllers objectAtIndex:currentVCIndex - 1];
    return imageViewController;
}

- (void)cancelImagePicker:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:error:)]) {
        [self.delegate imagePickerControllerDidCancel:[self getImageViewController] error:nil];
    }
}

- (void)saveImagesToDocs:(id)sender{
    NSMutableArray *images = [NSMutableArray new];
    NSMutableArray *fileNames = [NSMutableArray new];
    NSMutableArray *fileMimeType = [NSMutableArray new];
//    
//    [[GSAppDelegate sharedInstance] displayApplicationProgressHUDWithTitle:[GCSModuleBundle localizedStringForKey:@"GCSDocs_ProcessingFiles" value:@"Processing files..." table:nil] message:nil inView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (ALAsset *asset in self.selectedAssets) {
            // get data from alasset
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            NSString* MIMEType = (__bridge_transfer NSString*)UTTypeCopyPreferredTagWithClass
            ((__bridge CFStringRef)[assetRep UTI], kUTTagClassMIMEType);
            
            NSString *fileName = nil;
            if (assetRep.filename != nil) {
                fileName = assetRep.filename;
            }
            else{
                fileName = [self getFilenameWithTimestampOfAsset:asset];
            }
            Byte *buffer = (Byte*)malloc(assetRep.size);
            NSUInteger buffered = [assetRep getBytes:buffer fromOffset:0.0 length:assetRep.size error:nil];
            NSData* data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            
            [images addObject:data];
            [fileNames addObject:fileName];
            [fileMimeType addObject:MIMEType];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithFiles:fileNames:mimeTypes:)]) {
                [self.delegate imagePickerController:[self getImageViewController] didFinishPickingMediaWithFiles:[NSArray arrayWithArray:images] fileNames:[NSArray arrayWithArray:fileNames] mimeTypes:[NSArray arrayWithArray:fileMimeType]];
            }
//            [[GSAppDelegate sharedInstance] dismissApplicationProgressHUDWithDelay:0];
        });
    });
}

// get file size
- (NSString*)stringForFileSize:(NSNumber*)fileSize {
    float fileSizeInt = 0;
    NSString *fileSizeLabel = @"B";
    
    if (fileSize != nil) {
        fileSizeInt = [fileSize floatValue];
        if (fileSizeInt > 0) {
            if(fileSizeInt > 0 && fileSizeInt < 1024) {
                // Anything less than 1 KB should be shown as 1KB
                fileSizeLabel = @"KB";
                fileSizeInt = 1;
            }
            else if (fileSizeInt >= 1024 && fileSizeInt < 1048576) {
                // KB
                fileSizeLabel = @"KB";
                fileSizeInt /= 1024;
            } else if (fileSizeInt >= 1048576 && fileSizeInt < 1073741824) {
                // MB
                fileSizeLabel = @"MB";
                fileSizeInt /= 1048576;
            } else {
                // GB
                fileSizeLabel = @"GB";
                fileSizeInt /= 1073741824;
            }
        }
    }
    
    return [NSString stringWithFormat:@"%.2f %@", (float)fileSizeInt, fileSizeLabel];
}

// get random file name
- (NSString *)getFilenameWithTimestampOfAsset:(ALAsset *)asset {
    NSDate *date = [NSDate date];
    BOOL isVideo = [[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
    NSString *extension = [asset.defaultRepresentation.url pathExtension];
    NSString *filename = [NSString stringWithFormat:@"%@ %@.%@",isVideo?@"Video":@"Photo",[self.dateFormatter stringFromDate:date],extension];
    return filename;
}

//update total size and selected image
- (void)updateMessageOnCellSelection:(BOOL)isSelected forIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = self.assets[indexPath.row];
    GSFEImageCollectionViewCell *cell = (GSFEImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (isSelected) {
        if (self.selectedAssets.count == 25) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You can only select 25 photos at a time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
            return;
        }
        [self.selectedAssets addObject:asset];
        self.totalSize = [NSNumber numberWithLongLong:[self.totalSize longLongValue] + asset.defaultRepresentation.size];
        
        if (self.bottomView.alpha == 0) {
            [UIView animateKeyframesWithDuration:.3 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
                self.bottomView.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }
        [cell setCellSelected:isSelected];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveImagesToDocs:)] animated:YES];
    }
    else {
        [self.selectedAssets removeObject:asset];
        self.totalSize = [NSNumber numberWithLongLong:[self.totalSize longLongValue] - asset.defaultRepresentation.size];
        if (self.selectedAssets.count == 0 && self.bottomView.alpha == 1) {
            [UIView animateKeyframesWithDuration:.3 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
                self.bottomView.alpha = 0;
            } completion:^(BOOL finished) {
            }];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelImagePicker:)] animated:YES];
        }
        [cell setCellSelected:isSelected];
    }
    self.selectedItemsLabel.text = [NSString stringWithFormat:@"Selected items (%lu)",(unsigned long)self.selectedAssets.count];
    self.sizeLabel.text = [NSString stringWithFormat:@"total %@",[self stringForFileSize:self.totalSize]];
}
@end
