//
//  WBImageStampler.m
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBImageStampler.h"

#import "WBReceiptAndIndex.h"

#import "WBDateFormatter.h"
#import "WBReportUtils.h"

#import "ZipFile.h"
#import "ZipWriteStream.h"

static const float IMG_SCALE_FACTOR = 2.1f;
static const float HW_RATIO = 0.75f;

@implementation WBImageStampler
{
    WBDateFormatter *_dateFormatter;
}

- (id)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[WBDateFormatter alloc] init];
    }
    return self;
}

static void drawEntry(float x, float y, NSString *name, NSString *value, NSDictionary *attrs) {
    [[NSString stringWithFormat:@"%@: %@", name, value] drawAtPoint:CGPointMake(x, y) withAttributes:attrs];
}

-(BOOL) zipToFile:(NSString*) outputPath stampedImagesForReceiptsAndIndexes:(NSArray*) receiptsAndIndexes inTrip:(WBTrip*) trip {
    
    ZipFile *zipFile= [[ZipFile alloc] initWithFileName:outputPath
                                                   mode:ZipFileModeCreate];
    
    for (WBReceiptAndIndex *rwi in receiptsAndIndexes) {
        @autoreleasepool {
            WBReceipt *receipt = [rwi receipt];
            int index = [rwi index];
            
            if (![receipt hasImage]) {
                continue;
            }
            
            UIImage *img = [self
                            stampedImage:[UIImage imageWithContentsOfFile:[receipt imageFilePathForTrip:trip]]
                            forReceipt:receipt
                            inTrip:trip];
            if (!img) {
                continue;
            }
            
            @try {
                NSString *filename = [NSString stringWithFormat:@"%d_%@.jpg", index, [receipt name]];
                
                ZipWriteStream *stream= [zipFile writeFileInZipWithName:filename
                                                       compressionLevel:ZipCompressionLevelDefault];
                
                [stream writeData:UIImageJPEGRepresentation(img, 0.85)];
                [stream finishedWriting];
            } @catch (NSException* e) {
                return NO;
            }
        }
    }
    
    @try {
        [zipFile close];
    } @catch (NSException* e) {
        return NO;
    }
    
    return YES;
}

-(UIImage*) stampedImage:(UIImage*) foreground forReceipt:(WBReceipt*) receipt inTrip:(WBTrip*) trip {
    
    if (!foreground) {
        return nil;
    }
    
    int foreWidth = foreground.size.width;
    int foreHeight = foreground.size.height;
    if (foreHeight > foreWidth) {
        foreWidth = (int) (foreHeight * HW_RATIO);
    }
    else {
        foreHeight = (int) (foreWidth / HW_RATIO);
    }
    
    // Set up the paddings
    int xPad = (int) (foreWidth / IMG_SCALE_FACTOR);
    int yPad = (int) (foreHeight / IMG_SCALE_FACTOR);
    
    CGSize backgroundSize = CGSizeMake(foreWidth + xPad, foreHeight + yPad);
    
    UIGraphicsBeginImageContext(backgroundSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, backgroundSize.width, backgroundSize.height) );
    
    [foreground drawAtPoint:CGPointMake((backgroundSize.width - foreground.size.width) / 2,
                                        (backgroundSize.height - foreground.size.height) / 2)];
    
    int num = 5;
    if ([receipt hasExtraEditText1]) num++;
    if ([receipt hasExtraEditText2]) num++;
    if ([receipt hasExtraEditText3]) num++;
    
    UIFont *font = [WBImageStampler optimalFontForCount:num inSpace:(yPad/2)];
    NSDictionary* attrs = @{ NSFontAttributeName: font };
    
    float spacing = font.lineHeight;
    float y = spacing*4;
    
    [[trip name] drawAtPoint:CGPointMake(xPad/2, y) withAttributes:attrs];
    y += spacing;
    
    {
        NSString *dtstr = [NSString stringWithFormat:@"%@ -- %@",
                           [_dateFormatter formattedDate:[trip startDate] inTimeZone:[trip startTimeZone]],
                           [_dateFormatter formattedDate:[trip endDate] inTimeZone:[trip endTimeZone]]];
        [dtstr drawAtPoint:CGPointMake(xPad/2, y) withAttributes:attrs];
    }
    
    // bottom texts
    
    y = backgroundSize.height - yPad/2 + spacing*2;
    
#define entry(name,value) { drawEntry(xPad / 2, y, name, value, attrs); y += spacing; }
    
    entry(NSLocalizedString(@"Name", nil), [receipt name]);
    entry(NSLocalizedString(@"Price", nil), [receipt priceWithCurrencyFormatted]);
    entry(NSLocalizedString(@"Date", nil), [_dateFormatter formattedDate:[receipt date] inTimeZone:[receipt timeZone]]);
    entry(NSLocalizedString(@"Category", nil), [receipt category]);
    entry(NSLocalizedString(@"Comment", nil), [receipt comment]);
    
#undef entry
    
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return backgroundImage;
}

+(UIFont*) optimalFontForCount:(int) count inSpace:(int) space {
    int fontSize = 8;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    while (space > (count + 2) * font.lineHeight) {
        font = [UIFont systemFontOfSize:(++fontSize)];
    }
    font = [UIFont systemFontOfSize:(--fontSize)];
    return font;
}

@end
