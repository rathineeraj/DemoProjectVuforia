//
//  PostDataViewController.m
//  VuforiaSamples
//
//  Created by Navraj Singh on 01/05/14.
//  Copyright (c) 2014 Qualcomm. All rights reserved.
//

#import "PostDataViewController.h"
#import <CommonCrypto/CommonHMAC.h>

@interface PostDataViewController ()

@end

@implementation PostDataViewController

static const char* const kAccessKey = "353f3dc54fd18fafdc6326b49a510dc4a9ff9a19";
static const char* const kSecretKey = "158bd9903b5320fb9aa243140bfa5c42ae5edd69";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIImage *img =[[UIImage alloc] initWithContentsOfFile:@"test.jpg"];
//    
//    NSData *data = UIImagePNGRepresentation(img);
//    
//    NSString *imageDataString = [data base64Encoding];    //// I have used the Category to find out the base64encoded String
    
    NSDictionary * postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"ASW_Image",@"name", @"100",@"width", nil];
    
    NSError * error = nil;
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:kNilOptions error:&error];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://vws.vuforia.com/targets"]];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setHTTPBody:jsonData];
    
    NSDate *currDate = [NSDate date];
    
    NSString *dateStr = [self getUTCFormateDate:currDate];
    
    [urlRequest setValue:dateStr forHTTPHeaderField:@"Date"];
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *contentmd5 =[self md5:[[NSString alloc]initWithData:urlRequest.HTTPBody encoding:NSUTF8StringEncoding]];
    
    
    NSString *dataValue =[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",urlRequest.HTTPMethod,contentmd5,@"application/json",dateStr,urlRequest.URL.path];
    
    NSString *hmacStr = [self HMAC:[NSString stringWithUTF8String:kSecretKey] :dataValue];
    
    NSString *authStr = [NSString stringWithFormat:@"VWS %@:%@",[NSString stringWithUTF8String:kAccessKey],hmacStr];
    
    [urlRequest setValue:authStr forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"%@",result);
                               
                           }];
    // Do any additional setup after loading the view from its nib.
}

- (NSString *)base64String:(NSString *)str
{
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

-(NSString*)HMAC:(NSString*)key :(NSString*)data{
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64Encoding];   //// I have used the Category to find out the base64encoded String
    
    return hash;
    
}


-(NSString *)getUTCFormateDate:(NSDate *)localDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:@"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"];
    
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    return dateString;
    
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
