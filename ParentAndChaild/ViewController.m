//
//  ViewController.m
//  ParentAndChaild
//
//  Created by VENKATARAMANA on 02/12/16.
//  Copyright © 2016 rjil. All rights reserved.
//

#import "ViewController.h"
#define kESPhotoEmbedSegue @"PhotoEmbedSegue"
#define kESVideoEmbedSegue @"VideoEmbedSegue"
#define kEOtherEmbedSegue @"OtherEmbedSegue"
#define unactionedBackgroundcolor [UIColor colorWithRed:237.0/255.0 green:27.0/255.0 blue:36.0/255.0 alpha:1]

@interface ViewController ()
@property (nonatomic,strong)UIViewController *currentViewController ,*PhotoViewController,*VIdeoViewController,*OtherViewController;
@property (nonatomic,strong)IBOutlet UIView *containerView;
@property (nonatomic,strong)IBOutlet UISegmentedControl *segment;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    self.segment.tintColor=unactionedBackgroundcolor;
    self.segment.selectedSegmentIndex=0;
    self.currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Photo"];
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
    [super viewDidLoad];
      // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)showComponent:(UISegmentedControl *)sender {
    
    [self setSelectedSegmentColor:sender];
    if (sender.selectedSegmentIndex == 0) {
       self.PhotoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Photo"];
       self.PhotoViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
       [self cycleFromViewController:self.currentViewController toViewController:self.PhotoViewController];
        self.currentViewController = self.PhotoViewController;

    }
    else if(sender.selectedSegmentIndex == 1){
        
         self.VIdeoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Video"];
        _VIdeoViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
         [self cycleFromViewController: self.currentViewController toViewController:self.VIdeoViewController];
        self.currentViewController = self.VIdeoViewController;

    }
    else
    {
      _OtherViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Other"];
        _OtherViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController: self.currentViewController toViewController:self.OtherViewController];
        self.currentViewController = self.OtherViewController;

    }
}
- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    newViewController.view.alpha = 0;
    [newViewController.view layoutIfNeeded];
    
//    [UIView animateWithDuration:0.5
//                     animations:^{
//                         newViewController.view.alpha = 1;
//                         oldViewController.view.alpha = 0;
//                     }
//                     completion:^(BOOL finished) {
//                         [oldViewController.view removeFromSuperview];
//                         [oldViewController removeFromParentViewController];
//                         [newViewController didMoveToParentViewController:self];
//                     }];
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options: UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
                         //self.view.alpha = 0.0f;
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;

                     }
                     completion:^(BOOL finished){
                                                [oldViewController.view removeFromSuperview];
                                                [oldViewController removeFromParentViewController];
                                                [newViewController didMoveToParentViewController:self];

                         
                     }];

   }

-(void)setSelectedSegmentColor:(UISegmentedControl *)mySegmentedControl{
    for (int i=0; i<[mySegmentedControl.subviews count]; i++)
    {
        if ([[mySegmentedControl.subviews objectAtIndex:i]isSelected] )
        {
            [mySegmentedControl.subviews objectAtIndex:i].layer.borderWidth=1;
            [mySegmentedControl.subviews objectAtIndex:i].layer.cornerRadius=1;
            [mySegmentedControl.subviews objectAtIndex:i].layer.borderColor=[UIColor blackColor].CGColor;
            
        }else{
            [mySegmentedControl.subviews objectAtIndex:i].layer.borderWidth=0;
            [[mySegmentedControl.subviews objectAtIndex:i] setTintColor:unactionedBackgroundcolor];
        }
    }
}
- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]
        isEqualToString:kESVideoEmbedSegue]) {
          self.PhotoViewController=[segue destinationViewController];
        self.currentViewController= self.VIdeoViewController;
           }
    if([[segue identifier] isEqualToString:kESPhotoEmbedSegue]) {
        self.VIdeoViewController=[segue destinationViewController];
        self.currentViewController= self.PhotoViewController;

    }
    if([[segue identifier] isEqualToString:kEOtherEmbedSegue]) {
         self.OtherViewController=[segue destinationViewController];
        self.currentViewController= self.OtherViewController;

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
