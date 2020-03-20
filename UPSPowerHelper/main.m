//
//  main.m
//  UPSPowerHelper
//
//  Created by Dariusz Niklewicz on 20/03/2020.
//  Copyright © 2020 Dariusz Niklewicz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#include <CoreServices/CoreServices.h>
#include <Carbon/Carbon.h>

static OSStatus SendAppleEventToSystemProcess(AEEventID EventToSend);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int port = 58879;
        
        if (argc > 2) {
            NSString *param = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];
            int value = [[NSString stringWithFormat:@"%s", argv[2]] intValue];
            if ([param isEqualToString:@"--port"] && value > 0) {
                port = value;
            }
        }
        
        // Create server
        GCDWebServer* webServer = [[GCDWebServer alloc] init];
        
        // Add a handler to respond to GET requests on any URL
        [webServer addDefaultHandlerForMethod:@"GET"
                                 requestClass:[GCDWebServerRequest class]
                                 processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            
            if ([request.path hasSuffix:@"/info"]) {
                NSDictionary *json = [NSDictionary dictionaryWithObject:@"1.0" forKey:@"version"];
                return [GCDWebServerDataResponse responseWithJSONObject:json];
            } else if ([request.path hasSuffix:@"/shutdown"]) {
                SendAppleEventToSystemProcess(kAEShutDown);
                NSDictionary *json = [NSDictionary dictionaryWithObject:@"ok" forKey:@"result"];
                return [GCDWebServerDataResponse responseWithJSONObject:json];
            } else if ([request.path hasSuffix:@"/stop"]) {
                exit(0);
            } else {
                return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>Hello World</p></body></html>"];
            }
        }];
        
        NSLog(@"Running on port %d", port);
        // Use convenience method that runs server on port 8080
        // until SIGINT (Ctrl-C in Terminal) or SIGTERM is received
        [webServer runWithPort:port bonjourName:nil];
        NSLog(@"Visit %@ in your web browser", webServer.serverURL);
    }
    return 0;
}

OSStatus SendAppleEventToSystemProcess(AEEventID EventToSend)
{
    AEAddressDesc targetDesc;
    static const ProcessSerialNumber kPSNOfSystemProcess = { 0, kSystemProcess };
    AppleEvent eventReply = {typeNull, NULL};
    AppleEvent appleEventToSend = {typeNull, NULL};

    OSStatus error = noErr;

    error = AECreateDesc(typeProcessSerialNumber, &kPSNOfSystemProcess,
                                            sizeof(kPSNOfSystemProcess), &targetDesc);

    if (error != noErr)
    {
        return(error);
    }

    error = AECreateAppleEvent(kCoreEventClass, EventToSend, &targetDesc,
                   kAutoGenerateReturnID, kAnyTransactionID, &appleEventToSend);

    AEDisposeDesc(&targetDesc);
    if (error != noErr)
    {
        return(error);
    }

    error = AESend(&appleEventToSend, &eventReply, kAENoReply,
                  kAENormalPriority, kAEDefaultTimeout, NULL, NULL);

    AEDisposeDesc(&appleEventToSend);
    if (error != noErr)
    {
        return(error);
    }

    AEDisposeDesc(&eventReply);

    return(error);
}

