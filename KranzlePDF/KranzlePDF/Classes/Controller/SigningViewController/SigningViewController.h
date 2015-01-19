//
//  OrderSigningViewController.h
//  RPTrade Plus
//
//  Created by Marlon on 30.01.14.
//
//

#import <UIKit/UIKit.h>

@class SigningViewController;

@protocol SigningDelegate <NSObject>
- (void)signingController:(SigningViewController*)signingController didSignWithImage:(UIImage*)image;
@end

@interface SigningViewController : UIViewController

@property (nonatomic, weak) id delegate;
@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, weak) IBOutlet UIImageView *drawingView;

- (IBAction)closeWindow:(id)sender;
- (IBAction)okayAndClose:(id)sender;

@end
