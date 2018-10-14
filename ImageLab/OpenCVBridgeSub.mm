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
    char text[50];
    char text2[50];
    char text3[50];
    float blue [100];
    float green [100];
    float red [100];
    static int counter = 0;
    Scalar avgPixelIntensity;
    cv::Mat image = self.image;
    
    cvtColor(image, image_copy, CV_BGRA2BGR); // get rid of alpha for processing
    avgPixelIntensity = cv::mean( image_copy );
    sprintf(text,"Avg. B: %.0f, G: %.0f, R: %.0f", avgPixelIntensity.val[2],avgPixelIntensity.val[1],avgPixelIntensity.val[0]);
    cv::putText(image, text, cv::Point(50, 50), FONT_HERSHEY_PLAIN, 0.75, Scalar::all(255), 1, 2);
//    check if there is something covering the camera that causes any one pixel intensity to dip below 100
    if (avgPixelIntensity.val[2] < 100 || avgPixelIntensity.val[1] < 100 || avgPixelIntensity.val[0] < 100) {
        sprintf(text2,"SOMETHING IS COVERING");
        cv::putText(image,text2,cv::Point(100,100), FONT_HERSHEY_PLAIN, 0.75, Scalar::all(255), 1, 2);
        self.isCovered = true;
//        if(counter == 99) {
//            sprintf(text3,"ARRAYS ARE FULL");
//            cv::putText(image,text3,cv::Point(100,200), FONT_HERSHEY_PLAIN, 0.75, Scalar::all(255), 1, 2);
//        }
       // else {
        
//            blue[counter] = avgPixelIntensity.val[2];
//            green[counter] = avgPixelIntensity.val[1];
//            red[counter] = avgPixelIntensity.val[0];
        
        
            //NSLog(@"%f", avgPixelIntensity.val[0]);

//            NSNumber *test = @(avgPixelIntensity.val[0]); // adding red value to redValues
//            NSLog(@"%@", test);
        
            self.redValues[counter] = [NSNumber numberWithFloat: avgPixelIntensity.val[0]];
        // The old syntax

            //NSLog(@"%@", self.redValues[counter]);
            
            counter += 1;
       // }
    }
    else {
        self.isCovered = false;
    }
    
    self.image = image;
}



@end
