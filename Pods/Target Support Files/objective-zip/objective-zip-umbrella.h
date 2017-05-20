#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "OZZipFile.h"
#import "OZZipFile+Standard.h"
#import "OZZipFile+NSError.h"
#import "OZZipFileMode.h"
#import "OZZipCompressionLevel.h"
#import "OZZipException.h"
#import "OZZipWriteStream.h"
#import "OZZipWriteStream+Standard.h"
#import "OZZipWriteStream+NSError.h"
#import "OZZipReadStream.h"
#import "OZZipReadStream+Standard.h"
#import "OZZipReadStream+NSError.h"
#import "OZFileInZipInfo.h"
#import "Objective-Zip.h"
#import "Objective-Zip+NSError.h"

FOUNDATION_EXPORT double objective_zipVersionNumber;
FOUNDATION_EXPORT const unsigned char objective_zipVersionString[];

