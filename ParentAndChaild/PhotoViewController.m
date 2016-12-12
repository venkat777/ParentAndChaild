//
//  PhotoViewController.m
//  ParentAndChaild
//
//  Created by VENKATARAMANA on 06/12/16.
//  Copyright © 2016 rjil. All rights reserved.
//

#import "PhotoViewController.h"
#import "CollectionViewCell.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "GSFEAlbumListVC.h"
#import "GSFEImageCollectionListVC.h"
#import "GSFEImageCollectionViewCell.h"
@interface PhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ChoosenImageView;
@property (nonatomic, strong) NSArray *imageDataArray;
@property (nonatomic, strong) NSArray *imageNameArray;
@property (nonatomic, strong) NSArray *imageMimeTypes;
@end

@implementation PhotoViewController

- (void)viewDidLoad {

    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.CollectionView registerNib:cellNib forCellWithReuseIdentifier:@"PhotoCell"];

    self.CollectionView.delegate=self;
    self.CollectionView.dataSource =self;
    self.CollectionView.backgroundColor = [UIColor whiteColor];
    self.CollectionView.layer.borderWidth=1;
    self.CollectionView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.CollectionView.layer.cornerRadius=5;

    
    self.ChoosenImageView.layer.borderWidth=1;
    self.ChoosenImageView.layer.borderColor =[UIColor darkGrayColor].CGColor;
    self.ChoosenImageView.layer.cornerRadius=5;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if(!_ChoosenImageView.image)
        _ChoosenImageView.backgroundColor=[UIColor lightGrayColor];
    else
        _ChoosenImageView.backgroundColor=[UIColor blackColor];

    [super viewWillAppear:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageDataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *identifier = @"PhotoCell";
    CollectionViewCell *cell= (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.imageView.backgroundColor=[UIColor grayColor];
    cell.imageView.image=[UIImage imageWithData:self.imageDataArray[indexPath.row]];
    return cell;
}
-(IBAction)selectPhotoGalery:(id)sender
{
    UIButton *button= (UIButton *)sender;
    switch (button.tag) {
        case 1:
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 2:
          //  [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            if([GSFEAlbumListVC isImageSourcePhotoLibraryAvailableAndAllowed]) {
                GSFEAlbumListVC *imageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumListVC"];
                imageViewController.delegate = self;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
                [self presentViewController:navController animated:YES completion:nil];
            }
            break;
        default:
            break;
    }
}
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;
    imagePicker.sourceType=sourceType;
    //imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    //imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
#pragma UIImagePickerDelegate methods
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chooseimage=info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
        [self uploadProfileImage:chooseimage];
    }];
}

- (void)uploadProfileImage:(UIImage *)image
{
     self.ChoosenImageView.image = [image copy];
    _ChoosenImageView.backgroundColor=[UIColor blackColor];

}
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    if ([identifier isEqualToString:@"CollectionList"]) {
//        if ([sender isKindOfClass:[UITableViewCell class]]) {
//            if ([(ALAssetsGroup *)[self.albumArray objectAtIndex:[[self.tableView indexPathForCell:(GSFEAlbumCell *)sender] row]] numberOfAssets] > 0) {
//                return YES;
//            }
//        }
//    }
//    return NO;
//}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([GSFEAlbumListVC isImageSourcePhotoLibraryAvailableAndAllowed]) {
        GSFEAlbumListVC *imageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumListVC"];
        imageViewController.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

#pragma mark - check for permission
+ (BOOL)isImageSourcePhotoLibraryAvailableAndAllowed {
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Open the settings and check that this app is enabled under Privacy > Photos." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
    
    BOOL val =  (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined);
    return val;
}
- (void)imagePickerController:(GSFEAlbumListVC *)picker didFinishPickingMediaWithFiles:(NSArray *)images fileNames:(NSArray *)fileNames mimeTypes:(NSArray *)mimeTypes{
    
    //dismiss modal view
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.imageDataArray = [NSArray arrayWithArray:images];
    self.imageNameArray = [NSArray arrayWithArray:fileNames];
    self.imageMimeTypes = [NSArray arrayWithArray:mimeTypes];
    [self.CollectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(GSFEAlbumListVC *)picker error:(NSError *)error{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
