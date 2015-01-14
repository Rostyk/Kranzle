//
//  PDFRenderer.m
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "PDFRenderer.h"
#import <UIKit/UIKit.h>
#import "CoreText/CoreText.h"
#import "Customer.h"

@interface PDFRenderer()
@property (nonatomic, strong) Customer *customer;
@end

@implementation PDFRenderer

#pragma mark shared instance

+ (instancetype)sharedRenderer
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                  });
    
    return sharedInstance;
}

#pragma mark insert predefined text

- (void)insertCustomerData:(Customer*)customer {
    self.customer = customer;
}


#pragma mark rendering
- (void)render{
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)[[NSBundle mainBundle] URLForResource:@"Fachhandelspartner" withExtension:@"pdf"]);
    
    const size_t numberOfPages = CGPDFDocumentGetNumberOfPages(pdf);
    
    NSMutableData* data = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(data, CGRectZero, nil);
    
    for(size_t page = 1; page <= numberOfPages; page++)
    {
        //	Get the current page and page frame
        CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdf, page);
        const CGRect pageFrame = CGPDFPageGetBoxRect(pdfPage, kCGPDFMediaBox);
        
        UIGraphicsBeginPDFPageWithInfo(pageFrame, nil);
        
        //	Draw the page (flipped)
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);

        CGContextTranslateCTM(ctx, 0, pageFrame.size.height);
        CGContextScaleCTM(ctx, 1, -1);
        
        CGContextDrawPDFPage(ctx, pdfPage);
        CGContextRestoreGState(ctx);
        CGContextSaveGState(ctx);
        CGContextScaleCTM(ctx, 1, -1);
        if(page == 1) {
           [self drawText: self.customer.name context:ctx origin:CGPointMake(160, 158)];
           [self drawText: self.customer.street context:ctx origin:CGPointMake(160, 176)];
        }
        CGContextRestoreGState(ctx);
    }
    
    UIGraphicsEndPDFContext();
    
    CGPDFDocumentRelease(pdf);
    pdf = nil;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFilePath = [documentsDirectory stringByAppendingPathComponent:@"Form.pdf"];
    
    [data writeToFile:pdfFilePath atomically:YES];
}

-(void)drawText:(NSString *)text context:(CGContextRef)currentContext origin:(CGPoint)origin
{
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,string.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica Bold" size:12] range: NSMakeRange(0,string.length)];

    
    CFAttributedStringRef stringRef = (__bridge CFAttributedStringRef)string;
    // Prepare the text using a Core Text Framesetter
    //CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(stringRef);
    
    int x = origin.x;
    int y = -origin.y; // The context is flipped upside-down
    CGRect frameRect = CGRectMake(x, y, 300, 50);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    //CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
   // CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    //CGContextTranslateCTM(currentContext, 0, -pageFrame.size.height);
    //CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CFRelease(frameRef);
    //CFRelease(stringRef);
    CFRelease(framesetter);
}

@end
