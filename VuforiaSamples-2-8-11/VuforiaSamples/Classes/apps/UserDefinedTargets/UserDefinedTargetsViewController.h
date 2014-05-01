/*==============================================================================
 Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc.
 All Rights Reserved.
 ==============================================================================*/

#import <UIKit/UIKit.h>
#import "SampleAppMenu.h"
#import "UserDefinedTargetsEAGLView.h"
#import "SampleApplicationSession.h"
#import "DataSet.h"
#import "RefFreeFrame.h"
#import "CustomToolbar.h"

@interface UserDefinedTargetsViewController : UIViewController <SampleApplicationControl, CustomToolbarDelegateProtocol, SampleAppMenuCommandProtocol, UIGestureRecognizerDelegate>{
    CGRect viewFrame;
    UserDefinedTargetsEAGLView* eaglView;
    UITapGestureRecognizer * tapGestureRecognizer;
    SampleApplicationSession * vapp;
    
    QCAR::DataSet* dataSetUserDef;
    RefFreeFrame * refFreeFrame;
    CustomToolbar *toolbar;

    BOOL extendedTrackingIsOn;
}

@end
