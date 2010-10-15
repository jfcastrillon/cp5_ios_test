//
//  XSQueryParamKeys.h
//  CommunityPointMobile
//
//  Created by John Cannon on 10/14/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

static NSString* kXSQueryMaxCount = @"limit";
static NSString* kXSQueryOffset = @"offset";

static NSString* kXSQueryNatural = @"query";
static NSString* kXSQueryNaturalSubQuery = @"subquery";

static NSString* kXSQueryPhysicalLocationCity = @"city";
static NSString* kXSQueryPhysicalLocationCounty = @"county";
static NSString* kXSQueryPhysicalLocationZIP = @"zipcode";
static NSString* kXSQueryPhysicalLocationState = @"state";
static NSString* kXSQueryPhysicalLocationRangeFromZIP = @"range";

static NSString* kXSQueryGeoServedCity = @"geo_city";
static NSString* kXSQueryGeoServedCounty = @"geo_county";
static NSString* kXSQueryGeoServedZIP = @"geo_zipcode";
static NSString* kXSQueryGeoServedState = @"geo_state";

static NSString* kXSQueryVolunteerKeywords = @"volunteer_query";
static NSString* kXSQueryWishlistKeywords = @"wishlist_query";

static NSString* kXSQuerySearchHistoryId = @"search_history_id";
static NSString* kXSQueryReferenceLatitude = @"ref_latitude";
static NSString* kXSQueryReferenceLongitude = @"ref_longitude";
static NSString* kXSSortByDistance = @"sort_by_distance";
static NSString* kXSQueryKeywordsAll = @"query_all";
static NSString* kXSQueryKeywordsAny = @"query_any";
static NSString* kXSQueryKeywordsNone = @"query_none";