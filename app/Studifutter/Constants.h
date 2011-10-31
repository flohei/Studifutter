//
//  Constants.h
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                          API
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// API
#define API_LIVE_SERVER                                 NO
#define API_SERVER_PATH_TEST                            @"http://studifutter.rtfnt.com/api"
#define API_SERVER_PATH_LIVE                            @"http://studifutter.rtfnt.com"
#define API_AUTH                                        "key=key&secret=secret&"
#define API_SECRET                                      "bGBHAvNRNsTsOJv7JbvtPTXwQoxi2XpL"

#define SF_API_STATUS_OK                                200
#define SF_API_STATUS_UNKNOWN_ERROR                     1
#define SF_API_STATUS_INVALID_CHECKSUM                  2
#define SF_API_STATUS_UNKNOWN_METHOD                    3
#define SF_API_STATUS_MISSING_PARAMETER                 100
#define SF_API_STATUS_ERROR                             400

// Exception Name ([exception name])
#define AX_API_ERROR                                    @"SFAPIError"

// Error Types ([exception type])
#define SF_API_ERROR_TYPE_JSON			                @"JSONError"
#define SF_API_ERROR_TYPE_STATUS		                @"APIStatusError"
#define SF_API_ERROR_TYPE_NETWORK		                @"NetworkError"
#define SF_API_ERROR_TYPE_LOGIN			                @"LoginError"
