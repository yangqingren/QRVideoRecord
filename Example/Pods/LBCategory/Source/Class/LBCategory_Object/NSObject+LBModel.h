//
//  NSObject+LBModel.h
//  app
//
//  Created by 刘文扬 on 17/6/9.
//  Copyright © 2017年 Duke_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LBModel)


+(id)lb_changeModel:(id)toModel toModelClass:(Class)toModelClass fromModel:(id)fromModel;

@end
