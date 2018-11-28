//
//  ScannerViewController.m
//  Generika
//
//  Created by b123400 on 2018/11/27.
//  Copyright © 2018 ywesee GmbH. All rights reserved.
//

#import "ScannerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Vision/Vision.h>
#import "DataMatrixResult.h"
#import "BarcodeExtractor.h"
#import "Helper.h"

@interface ScannerViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (atomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (atomic, strong) AVCaptureSession *captureSession;
@property (atomic, strong) UIToolbar *toolbar;

@end

@implementation ScannerViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectZero];

    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
            [self setupCaptureSession];
            break;
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self setupCaptureSession];
                } else {
                    // TODO: display permission denined message
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (void)setupCaptureSession {
    self.captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                                 mediaType:AVMediaTypeVideo
                                                                  position:AVCaptureDevicePositionBack];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (error != nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"")
                                                                       message:error.localizedDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
        return;
    }

    if ([self.captureSession canAddInput:input]) {
        [self.captureSession addInput:input];
    }

    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self
                              queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    if ([self.captureSession canAddOutput:output]) {
        [self.captureSession addOutput:output];
    }

    [self.captureSession startRunning];

    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    [self.view.layer addSublayer:self.previewLayer];
    self.previewLayer.frame = self.view.bounds;

    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                            target:self
                                                                            action:@selector(cancel)];
    [self.toolbar setItems:@[cancel,
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil]]];
    [self.view addSubview:self.toolbar];
}

- (void)viewDidLayoutSubviews {
    self.previewLayer.frame = self.view.bounds;
    self.toolbar.frame = CGRectMake(0,
                                    CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.toolbar.frame),
                                    CGRectGetWidth(self.view.bounds),
                                    CGRectGetHeight(self.toolbar.frame));
}

- (void)captureOutput:(AVCaptureOutput *)output
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    VNImageRequestHandler *requestHandler =
        [[VNImageRequestHandler alloc] initWithCVPixelBuffer:CMSampleBufferGetImageBuffer(sampleBuffer)
                                             orientation:[self convertVideoOrientation:connection.videoOrientation]
                                                 options:@{}];
    VNDetectBarcodesRequest *barcodeRequest = [[VNDetectBarcodesRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError *error) {
        BarcodeExtractor *extractor = [[BarcodeExtractor alloc] init];
        for (VNBarcodeObservation *result in request.results) {
            NSLog(@"string value %@", result.payloadStringValue);
            if (result.symbology == VNBarcodeSymbologyDataMatrix) {
                DataMatrixResult *r = [extractor extractGS1DataFrom:result.payloadStringValue];
            }
        }
    }];
    barcodeRequest.symbologies = @[VNBarcodeSymbologyEAN13, VNBarcodeSymbologyDataMatrix];
    NSError *error = nil;
    [requestHandler performRequests:@[barcodeRequest] error:&error];
    if (error != nil) {
        NSLog(@"perform error %@", error);
    }
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)dealloc {
    [self.captureSession stopRunning];
    self.captureSession = nil;
}

- (CGImagePropertyOrientation)convertVideoOrientation:(AVCaptureVideoOrientation)orientation {
    switch (orientation) {
        case AVCaptureVideoOrientationPortrait:
            return UIImageOrientationUp;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            return UIImageOrientationDown;
        case AVCaptureVideoOrientationLandscapeRight:
            return UIImageOrientationRight;
        case AVCaptureVideoOrientationLandscapeLeft:
            return UIImageOrientationLeft;
    }
}

@end
