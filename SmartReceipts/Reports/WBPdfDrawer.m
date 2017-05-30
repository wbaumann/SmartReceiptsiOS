//
//  WBPdfDrawer.m
//  SmartReceipts
//
//  Created on 03/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBPdfDrawer.h"

#import "WBImageUtils.h"

typedef struct {
    CGRect labelRect, imageRect;
} WBImageCell;

static WBImageCell createCell(CGRect rect, int labelHeight) {
    WBImageCell cell;
    cell.labelRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, labelHeight);
    cell.imageRect = CGRectMake(rect.origin.x, rect.origin.y + labelHeight, rect.size.width, rect.size.height - labelHeight);
    return cell;
}

@implementation WBPdfDrawer
{
    CGRect _pageRect;
    int _margin;
    CGRect _contentRect;
    
    int _lineSize;
    int _spaceFromLine;
    
    int _takenY;
    int _currMiniImageIdx;
    
    NSMutableDictionary *_attributes;
    NSMutableDictionary *_attributesForLabels;
    
    WBImageCell _miniImagesCells[4];
    WBImageCell _fullPageCell;
}

- (id) init
{
    self = [super init];
    if (self) {
        _pageRect = CGRectMake(0, 0, 612, 792);
        _margin = 20;
        _contentRect = CGRectMake(_margin, _margin, _pageRect.size.width - _margin * 2, _pageRect.size.height - _margin * 2);
        
        _lineSize = 1;
        _spaceFromLine = _lineSize;
        
        _takenY = 0;
        _currMiniImageIdx = 0;
        
        // measuring
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        _attributes = @{
                        NSParagraphStyleAttributeName: paragraphStyle,
                        NSFontAttributeName: [ UIFont systemFontOfSize: 13.0 ]
                        }.mutableCopy;
        
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        _attributesForLabels = @{
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 NSFontAttributeName: [ UIFont systemFontOfSize: 13.0 ]
                                 }.mutableCopy;
        
        // positions for images
        
        [self createMiniImagesRectsForContent:_contentRect];
        [self createFullPageImageRectForContent:_contentRect];
    }
    return self;
}

-(void) createMiniImagesRectsForContent:(CGRect) content {
    
    int margin = content.origin.x;
    int cellWidth = (content.size.width - (margin * 2)) / 2;
    int cellHeight = (content.size.height - (margin * 2)) / 2;
    
    int rightStartX = content.origin.x + (content.size.width / 2) + margin;
    int bottomStartY = content.origin.y + (content.size.height / 2) + margin;
    
    int labelHeight = 20;
    
    CGRect topLeftRect = CGRectMake(content.origin.x,
                             content.origin.y,
                             cellWidth,
                             cellHeight);
    
    _miniImagesCells[0] = createCell(topLeftRect, labelHeight);
    
    CGRect topRightRect = topLeftRect;
    topRightRect.origin.x = rightStartX;
    
    _miniImagesCells[1] = createCell(topRightRect, labelHeight);
    
    CGRect bottomLeftRect = topLeftRect;
    bottomLeftRect.origin.y = bottomStartY;
    
    _miniImagesCells[2] = createCell(bottomLeftRect, labelHeight);
    
    CGRect bottomRightRect = topRightRect;
    bottomRightRect.origin.y = bottomStartY;
    
    _miniImagesCells[3] = createCell(bottomRightRect, labelHeight);
}

-(void) createFullPageImageRectForContent:(CGRect) content {
    _fullPageCell = createCell(content, 20);
}

#pragma mark - drawing for client

- (void) drawRowText:(NSString*) text {
    if (_currMiniImageIdx > 0) {
        // no rows & images on the same page
        [self moveToNextPage];
    }
    
    CGRect bounds = [text boundingRectWithSize:_contentRect.size
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:_attributes
                                       context:nil];
    
    if (_takenY > 0) {
        CGRect r = [self remainingRectForRow];
        if (r.size.height >= bounds.size.height) {
            [text drawInRect:r withAttributes:_attributes];
            _takenY += round(bounds.size.height);
            return;
        } else {
            [self moveToNextPage];
        }
    }
    
    // we are on new page, we cannot draw more anyway
    bounds.origin = _contentRect.origin;
    [text drawInRect:bounds withAttributes:_attributes];
    _takenY += round(bounds.size.height);
}

- (void) drawRowBorderedTexts:(NSArray*) texts {
    if (_currMiniImageIdx > 0) {
        [self moveToNextPage];
    }
    
    if (texts.count == 0) {
        return;
    }
    
    int additionalWidthCost = (int)(_lineSize * (texts.count + 1) + (_spaceFromLine * 2 * texts.count));
    int width = (((int)(_contentRect.size.width - additionalWidthCost)) / texts.count);
    
    int maxContentHeight = (int)(_contentRect.size.height - (_lineSize * 2 + _spaceFromLine * 2));
    
    CGSize colContentSize = CGSizeMake(width, maxContentHeight);
    
    int maxFoundHeight = 0;
    
    for (NSString *str in texts) {
        int h = ceil([str boundingRectWithSize:colContentSize
                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                               attributes:_attributes
                                  context:nil].size.height);
        
        if (h > maxFoundHeight) {
            maxFoundHeight = h;
        }
    }
    
    CGSize columnSize = CGSizeMake(width, maxFoundHeight);
    
    if (_takenY > 0) {
        if ([self remainingRectForRow].size.height >= maxFoundHeight) {
            [self drawRowBorderedTexts:texts atY:_takenY withColumnSize:columnSize];
            return;
        } else {
            [self moveToNextPage];
        }
    }
    
    // we are on new page, we cannot draw more anyway
    [self drawRowBorderedTexts:texts atY:_takenY withColumnSize:columnSize];
}

- (void) drawImage:(UIImage*) image withLabel:(NSString*) text {
    if (_takenY > 0) {
        // no rows & images on the same page
        [self moveToNextPage];
    }
    
    WBImageCell cell = _miniImagesCells[_currMiniImageIdx];
    [self drawImageCell:cell withImage:image withLabel:text];
    
    ++_currMiniImageIdx;
    if (_currMiniImageIdx > 3) {
        _takenY = _pageRect.size.height + 1;
    }
}

- (void) drawFullPageImage:(UIImage*) image withLabel:(NSString*) text {
    if (_takenY > 0 || _currMiniImageIdx > 0) {
        [self moveToNextPage];
    }
    
    [self drawImageCell:_fullPageCell withImage:image withLabel:text];
    _takenY = _pageRect.size.height + 1;
}

- (void) drawFullPagePDFPage:(CGPDFPageRef) page withLabel:(NSString*) text {
    if (_takenY > 0 || _currMiniImageIdx > 0) {
        [self moveToNextPage];
    }
    
    CGRect cropBox = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    if (CGRectIsEmpty(cropBox) || CGRectEqualToRect(cropBox, CGRectNull) || CGRectEqualToRect(cropBox, CGRectZero)) {
        LOGGER_ERROR(@"drawFullPagePDFPage:withLabel: - page has invalid kCGPDFCropBox, label = %@", text);
    }
    
    [text drawInRect:_fullPageCell.labelRect withAttributes:_attributesForLabels];
    [WBPdfDrawer renderPage:page inContext:UIGraphicsGetCurrentContext() inRectangle:_fullPageCell.imageRect];
    _takenY = _pageRect.size.height + 1;
}

- (void) drawGap {
    _takenY += 40;
}

#pragma mark - helpers

- (void) drawImageCell:(WBImageCell) cell withImage:(UIImage*) image withLabel:(NSString*) text {
    if (!image.hasContent) {
        LOGGER_ERROR(@"drawImageCell: withImage %@ withLabel %@", image, text);
    }
    [text drawInRect:cell.labelRect withAttributes:_attributesForLabels];
    [self drawImageWithAspectFit:image inRect:cell.imageRect];
}

- (void) drawRowBorderedTexts:(NSArray*) texts atY:(int) startY withColumnSize:(CGSize) columnSize {
    int additionalWidthCost = (int)(_lineSize * (texts.count + 1) + (_spaceFromLine * 2 * texts.count));
    
    int totalHeight = round(columnSize.height + (_lineSize * 2 + _spaceFromLine * 2));
    
    int startX = round(_contentRect.origin.x);
    int endLineX = round(_contentRect.origin.x + additionalWidthCost + (columnSize.width*texts.count) - _lineSize);
    int endLineY = round(startY + totalHeight - _lineSize);
    
    // horizontal lines
    [self drawLineFromPoint:CGPointMake(startX, startY)
                    toPoint:CGPointMake(endLineX, startY)];
    
    [self drawLineFromPoint:CGPointMake(startX, endLineY)
                    toPoint:CGPointMake(endLineX, endLineY)];
    
    // vertical line
    [self drawLineFromPoint:CGPointMake(startX, startY)
                    toPoint:CGPointMake(startX, endLineY + _lineSize)];
    
    int xAdv = _lineSize + (_spaceFromLine * 2) + columnSize.width;
    
    for (NSUInteger i = 0; i < texts.count; ++i) {
        CGRect rect = CGRectMake(startX + _lineSize + _spaceFromLine + (xAdv * i),
                                 startY + _lineSize + _spaceFromLine,
                                 columnSize.width,
                                 columnSize.height);
        
        NSString *str = [texts objectAtIndex:i];
        [str drawInRect:rect withAttributes:_attributes];
        
        // vertical line after cell
        int lineX = round(rect.origin.x + rect.size.width + _spaceFromLine);
        [self drawLineFromPoint:CGPointMake(lineX, startY)
                        toPoint:CGPointMake(lineX, endLineY + _lineSize)];
    }

    _takenY += totalHeight - _lineSize;
}

- (CGRect) remainingRectForRow {
    return CGRectMake(_contentRect.origin.x, _contentRect.origin.y + _takenY,
                      _contentRect.size.height, _contentRect.size.height - _takenY);
}

- (void) moveToNextPage {
    _takenY = 0;
    _currMiniImageIdx = 0;
    UIGraphicsBeginPDFPageWithInfo(_pageRect, nil);
}

- (BOOL) beginDrawingToFile:(NSString*)fileName {
    if(!UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil)) {
        return NO;
    }
    [self moveToNextPage];
    return YES;
}

- (void) endDrawing {
    UIGraphicsEndPDFContext();
}

- (void) drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, _lineSize);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.0, 0.0, 0.0, 1.0};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

- (void) drawImageWithAspectFit:(UIImage*) image inRect:(CGRect) rect{
    [[WBImageUtils image:image scaledToFitSize:rect.size] drawInRect:rect];
}

// renderPage: ... functions are by Sorin Nistor with below license
/*
 
 Copyright (c) 2011 Sorin Nistor. All rights reserved. This software is provided 'as-is',
 without any express or implied warranty. In no event will the authors be held liable for
 any damages arising from the use of this software. Permission is granted to anyone to
 use this software for any purpose, including commercial applications, and to alter it
 and redistribute it freely, subject to the following restrictions:
 1. The origin of this software must not be misrepresented; you must not claim that you
 wrote the original software. If you use this software in a product, an acknowledgment
 in the product documentation would be appreciated but is not required.
 2. Altered source versions must be plainly marked as such, and must not be misrepresented
 as being the original software.
 3. This notice may not be removed or altered from any source distribution.
 
 */

+ (void) renderPage: (CGPDFPageRef) page inContext: (CGContextRef) context atPoint: (CGPoint) point withZoom: (float) zoom{
	
	CGRect cropBox = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
	int rotate = CGPDFPageGetRotationAngle(page);
    
    if (CGRectIsEmpty(cropBox) || CGRectEqualToRect(cropBox, CGRectNull) || CGRectEqualToRect(cropBox, CGRectZero)) {
        LOGGER_ERROR(@"renderPage:inContext:iatPoint:withZoom: - page has invalid kCGPDFCropBox");
    }
	
	CGContextSaveGState(context);
	
	// Setup the coordinate system.
	// Top left corner of the displayed page must be located at the point specified by the 'point' parameter.
	CGContextTranslateCTM(context, point.x, point.y);
	
	// Scale the page to desired zoom level.
	CGContextScaleCTM(context, zoom / 100, zoom / 100);
	
	// The coordinate system must be set to match the PDF coordinate system.
	switch (rotate) {
		case 0:
			CGContextTranslateCTM(context, 0, cropBox.size.height);
			CGContextScaleCTM(context, 1, -1);
			break;
		case 90:
			CGContextScaleCTM(context, 1, -1);
			CGContextRotateCTM(context, -M_PI / 2);
			break;
		case 180:
		case -180:
			CGContextScaleCTM(context, 1, -1);
			CGContextTranslateCTM(context, cropBox.size.width, 0);
			CGContextRotateCTM(context, M_PI);
			break;
		case 270:
		case -90:
			CGContextTranslateCTM(context, cropBox.size.height, cropBox.size.width);
			CGContextRotateCTM(context, M_PI / 2);
			CGContextScaleCTM(context, -1, 1);
			break;
	}
	
	// The CropBox defines the page visible area, clip everything outside it.
	CGRect clipRect = CGRectMake(0, 0, cropBox.size.width, cropBox.size.height);
	CGContextAddRect(context, clipRect);
	CGContextClip(context);
	
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextFillRect(context, clipRect);
	
	CGContextTranslateCTM(context, -cropBox.origin.x, -cropBox.origin.y);
	
	CGContextDrawPDFPage(context, page);
	
	CGContextRestoreGState(context);
}

+ (void) renderPage: (CGPDFPageRef) page inContext: (CGContextRef) context inRectangle: (CGRect) displayRectangle {
    
    if ((displayRectangle.size.width == 0) || (displayRectangle.size.height == 0)) {
        LOGGER_WARNING(@"renderPage:inContext:inRectangle: - displayRectangle is 0x0");
        return;
    }
    
    CGRect cropBox = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
	int pageRotation = CGPDFPageGetRotationAngle(page);
    
    if (CGRectIsEmpty(cropBox) || CGRectEqualToRect(cropBox, CGRectNull) || CGRectEqualToRect(cropBox, CGRectZero)) {
        LOGGER_ERROR(@"renderPage:inContext:inRectangle: - page has invalid kCGPDFCropBox");
    }
	
	CGSize pageVisibleSize = CGSizeMake(cropBox.size.width, cropBox.size.height);
	if ((pageRotation == 90) || (pageRotation == 270) ||(pageRotation == -90)) {
		pageVisibleSize = CGSizeMake(cropBox.size.height, cropBox.size.width);
	}
    
    float scaleX = displayRectangle.size.width / pageVisibleSize.width;
    float scaleY = displayRectangle.size.height / pageVisibleSize.height;
    float scale = scaleX < scaleY ? scaleX : scaleY;
    
    // Offset relative to top left corner of rectangle where the page will be displayed
    float offsetX = 0;
    float offsetY = 0;
    
    float rectangleAspectRatio = displayRectangle.size.width / displayRectangle.size.height;
    float pageAspectRatio = pageVisibleSize.width / pageVisibleSize.height;
    
    if (pageAspectRatio < rectangleAspectRatio) {
        // The page is narrower than the rectangle, we place it at center on the horizontal
        offsetX = (displayRectangle.size.width - pageVisibleSize.width * scale) / 2;
    }
    else {
        // The page is wider than the rectangle, we place it at center on the vertical
        offsetY = (displayRectangle.size.height - pageVisibleSize.height * scale) / 2;
    }
    
    CGPoint topLeftPage = CGPointMake(displayRectangle.origin.x + offsetX, displayRectangle.origin.y + offsetY);
    
    [WBPdfDrawer renderPage:page inContext:context atPoint:topLeftPage withZoom:scale * 100];
}

@end
