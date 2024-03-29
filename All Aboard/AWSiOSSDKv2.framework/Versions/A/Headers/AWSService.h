/*
 * Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <AWSiOSSDKv2/AWSNetworking.h>
#import <AWSiOSSDKv2/AWSCredentialsProvider.h>
#import <AWSiOSSDKv2/AWSServiceEnum.h>

@class AWSEndpoint;

#pragma mark - AWSService

@interface AWSService : NSObject

@end

#pragma mark - AWSServiceManager

@class AWSServiceConfiguration;

/**
 *  The service manager class that manages the default service configuration.
 */
@interface AWSServiceManager : NSObject

/**
 *  The default service configuration object.
 */
@property (nonatomic, strong, readonly) AWSServiceConfiguration *defaultServiceConfiguration;

/**
 *  Returns a default singleton object. You should use this singleton method instead of creating an instance of the service manager.
 *
 *  @return The default service manager. This is a singleton object.
 */
+ (instancetype)defaultServiceManager;

/**
 *  Sets the default service configuration. This method can be called only once, and any subsequent calls are ignored.
 *
 *  @param defaultServiceConfiguration The default configuration object.
 */
- (void)setDefaultServiceConfiguration:(AWSServiceConfiguration *)defaultServiceConfiguration;

- (AWSService *)serviceForKey:(id)key;
- (void)setService:(AWSService *)service forKey:(id)key;
- (void)removeServiceForKey:(id)key;

@end

#pragma mark - AWSServiceConfiguration

@interface AWSServiceConfiguration : AWSNetworkingConfiguration

@property (nonatomic, assign, readonly) AWSRegionType regionType;
@property (nonatomic, strong, readonly) id<AWSCredentialsProvider> credentialsProvider;
@property (nonatomic, strong, readonly) AWSEndpoint *endpoint;
@property (nonatomic, assign) uint32_t maxRetryCount;

+ (instancetype)configurationWithRegion:(AWSRegionType)regionType
                    credentialsProvider:(id<AWSCredentialsProvider>)credentialsProvider;

@end

#pragma mark - AWSEndpoint

@interface AWSEndpoint : NSObject

@property (nonatomic, readonly) AWSRegionType regionType;
@property (nonatomic, readonly) NSString *regionName;
@property (nonatomic, readonly) AWSServiceType serviceType;
@property (nonatomic, readonly) NSString *serviceName;
@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) NSString *hostName;
@property (nonatomic, readonly) BOOL useUnsafeURL;

- (instancetype)initWithRegion:(AWSRegionType)regionType
                       service:(AWSServiceType)serviceType
                  useUnsafeURL:(BOOL)useUnsafeURL;

@end
