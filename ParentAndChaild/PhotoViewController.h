//
//  PhotoViewController.h
//  ParentAndChaild
//
//  Created by VENKATARAMANA on 06/12/16.
//  Copyright © 2016 rjil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSFEImagePickerProtocol.h"

@interface PhotoViewController : UIViewController<GSFEImagePickerProtocol>
{
 
}
@property(nonatomic,weak) id<GSFEImagePickerProtocol> delegate;
@property (nonatomic,weak) IBOutlet UICollectionView *CollectionView;
@end
