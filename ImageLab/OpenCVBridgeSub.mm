//
//  OpenCVBridgeSub.m
//  ImageLab
//
//  Created by Eric Larson on 10/4/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "OpenCVBridgeSub.h"
#import "AVFoundation/AVFoundation.h"

using namespace cv;

@interface OpenCVBridgeSub()
@property (nonatomic) cv::Mat image;
@end

@implementation OpenCVBridgeSub
@dynamic image;
//@dynamic just tells the compiler that the getter and setter methods are implemented not by the class itself but somewhere else (like the superclass or will be provided at runtime).

-(void)processImage{
    if(!self.redValues) {
        self.redValues = [[NSMutableArray alloc] init];
    }
    
    cv::Mat frame_gray,image_copy;
    Scalar avgPixelIntensity;
    cv::Mat image = self.image;
    static int counter = 0;

    cvtColor(image, image_copy, CV_BGRA2BGR); // get rid of alpha for processing
    avgPixelIntensity = cv::mean( image_copy );
    
    NSLog(@"counter: %i", counter);
    
    if (avgPixelIntensity.val[0] > 100) {
        self.redValues[counter] = [NSNumber numberWithFloat:avgPixelIntensity.val[0]];
        counter+=1;
        if([self.redValues count] > 100) {
            self.bpm = [self beatsPerMinute];
            NSLog(@"BPM: %i", self.bpm);
            [self.redValues removeObjectsInRange:NSMakeRange(0, 30)];
            counter = counter - 30;
        }
    }
    // NSLog(@"counter %i", counter);
    self.image = image;
}

-(int) beatsPerMinute{
    // 4s = 100 red values
    //
    
        NSMutableArray* maxArray = [[NSMutableArray alloc] init];
        int WINDOW_SIZE = 10;
        NSNumber *max;
        // var seconds = (self.bridge.redValues.count / 100) * 4
       //  let WINDOW_SIZE = self.bridge.redValues.count / seconds
        for(int i = 0; i < self.redValues.count - WINDOW_SIZE; i++) {
            max = self.redValues[i];
            for(int j = i; j < i + WINDOW_SIZE; j++) {
                if(self.redValues[j] > max) { max = self.redValues[j]; }
            }
            [maxArray addObject:max];
        }
        
        float peaks = 0.0;
        
        for (int i = 0; i < self.redValues.count - WINDOW_SIZE; i++) {
            if (self.redValues[i] == maxArray[i]) { peaks += 1.0; }
        }
    NSLog(@"peaks: %i", peaks);
        // NOTE
        //double seconds = (self.redValues.count / 100) * 4;
        //int bps = seconds/peaks;
        return peaks / (self.redValues.count / 30) * 30;
        //return bps * 60;
    }


@end
