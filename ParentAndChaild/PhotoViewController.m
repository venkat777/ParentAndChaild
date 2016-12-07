//
//  PhotoViewController.m
//  ParentAndChaild
//
//  Created by VENKATARAMANA on 06/12/16.
//  Copyright © 2016 rjil. All rights reserved.
//

#import "PhotoViewController.h"
#import "CollectionViewCell.h"

@interface PhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation PhotoViewController

- (void)viewDidLoad {

    
      UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.CollectionView registerNib:cellNib forCellWithReuseIdentifier:@"PhotoCell"];

    self.CollectionView.delegate=self;
    self.CollectionView.dataSource =self;
    self.CollectionView.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    return 12;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *identifier = @"PhotoCell";
    CollectionViewCell *cell= (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.imageView1.backgroundColor=[UIColor grayColor];
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
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        default:
            break;
    }
}
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.editing=YES;
    imagePicker.sourceType=sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
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
