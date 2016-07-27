//
//  MXAlert.m
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/27.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXAlert.h"

@implementation MXAlert
+ (instancetype _Nonnull)infoAlert {
    return [MXAlert buildWithType:MXAlertTypeInfo];
}

+ (instancetype _Nonnull)aboutAlert {
    return [MXAlert buildWithType:MXAlertTypeAbout];
}

+ (instancetype _Nonnull)inquireAlert {
    return [MXAlert buildWithType:MXAlertTypeInquire];
}

+ (instancetype _Nonnull)inputAlert {
    return [MXAlert buildWithType:MXAlertTypeInput];
}

+ (instancetype _Nonnull)loadingAlert {
    return [MXAlert buildWithType:MXAlertTypeLoading];
}

+ (instancetype _Nonnull)pointsAlert {
    return [MXAlert buildWithType:MXAlertTypePoints];
}

+ (instancetype _Nonnull)imageAlert {
    return [MXAlert buildWithType:MXAlertTypeImage];
}

+ (instancetype _Nonnull)detailAlert {
    return [MXAlert buildWithType:MXAlertTypeDetail];
}
@end
