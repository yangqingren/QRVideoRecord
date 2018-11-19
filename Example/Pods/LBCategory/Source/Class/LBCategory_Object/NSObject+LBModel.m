//
//  NSObject+LBModel.m
//  app
//
//  Created by 刘文扬 on 17/6/9.
//  Copyright © 2017年 Duke_Lee. All rights reserved.
//

#import "NSObject+LBModel.h"
#import <objc/runtime.h>
#import <MJExtension/MJExtension.h>

@implementation NSObject (LBModel)


+(id)lb_changeModel:(id)toModel toModelClass:(Class)toModelClass fromModel:(id)fromModel
{
    NSDictionary *fromModelDic = [fromModel mj_JSONObject];
    id returnModel = [toModelClass mj_objectWithKeyValues:fromModelDic];
    return returnModel;
}

@end
