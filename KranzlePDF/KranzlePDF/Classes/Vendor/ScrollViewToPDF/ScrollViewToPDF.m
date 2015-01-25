//
//  ScrollViewToPDF.m
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ScrollViewToPDF.h"
#import <UIKit/UIKit.h>

@implementation ScrollViewToPDF {

}

// based http://coderchrismills.wordpress.com/2011/06/25/making-a-pdf-from-a-uiwebview/
#define kDefaultPageHeight 1087
#define kDefaultPageWidth  768
#define kMargin 0
+ (NSData *)pdfDataOfScrollView:(UIScrollView *)scrollView {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
    }
    
    CGRect origFrame = scrollView.frame;
    BOOL horizontalScrollIndicator = [scrollView showsHorizontalScrollIndicator];
    BOOL verticalScrollIndicator = [scrollView showsVerticalScrollIndicator];
   
    
    
    int margin = 70;
    CGFloat maxHeight = kDefaultPageHeight - 2 * kMargin;
    CGFloat maxWidth = kDefaultPageWidth - 2 * kMargin;
    
   
    
    CGFloat height = scrollView.contentSize.height*0 + 2 * maxHeight;
    // Set up we the pdf we're going to be generating is
    [scrollView setFrame:CGRectMake(0.f, 64.f, maxWidth, maxHeight)];
    NSInteger pages = (NSInteger) ceil(height / maxHeight);

    NSMutableData *pdfData = [NSMutableData data];
    
    [self prepareForCapture:scrollView];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    for (int i = 0 ;i < pages ;i++){
        if (maxHeight * (i + 1) > height){
            // Check to see if page draws more than the height of the UIWebView
            CGRect scrollViewFrame = [scrollView frame];
            scrollViewFrame.size.height -= (((i + 1) * maxHeight) - height);
            [scrollView setFrame:scrollViewFrame];
        }
        // Specify the size of the pdf page
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, maxWidth, maxHeight), nil);
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
       
        // Move the context for the margins
        
        CGContextTranslateCTM(currentContext, kMargin, -(maxHeight * i) + kMargin);
       
        [scrollView setContentOffset:CGPointMake(0, maxHeight * i + margin) animated:NO];
        // draw the layer to the pdf, ignore the "renderInContext not found" warning.
        [scrollView.layer renderInContext:currentContext];
    }
    
    // all done with making the pdf
    UIGraphicsEndPDFContext();
    [scrollView setFrame:origFrame];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [scrollView setShowsHorizontalScrollIndicator:horizontalScrollIndicator];
    [scrollView setShowsVerticalScrollIndicator:verticalScrollIndicator];
    return pdfData;
}

+ (void)prepareForCapture:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointZero animated:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
}

@end