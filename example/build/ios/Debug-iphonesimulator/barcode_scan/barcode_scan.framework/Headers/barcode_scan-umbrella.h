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

#import "BarcodeScannerViewController.h"
#import "BarcodeScannerViewControllerDelegate.h"
#import "BarcodeScanPlugin.h"
#import "ScannerOverlay.h"

FOUNDATION_EXPORT double barcode_scanVersionNumber;
FOUNDATION_EXPORT const unsigned char barcode_scanVersionString[];

