//
//  NSData+Safe.m
//  CategorySafeData
//
//  Created by wangfj on 2017/8/10.
//  Copyright © 2017年 FJcategory. All rights reserved.
//

#import "NSData+Safe.h"

#define IS_KIND_OF(obj, cls) [(obj) isKindOfClass:[cls class]]

#if DEBUG

#define LOG(...) NSLog(__VA_ARGS__)

#define ASSERT(obj)               assert((obj)) //断言实例对象

#define ASSERT_CLASS(obj, cls)  ASSERT((obj) && IS_KIND_OF(obj,cls))//断言实例有值和类型


#else

#define LOG(...)

#define ASSERT(obj)

#define ASSERT_CLASS(obj, cls)

#endif


@implementation NSData (Safe)



-(nullable id)safe_JSONObj
{
    return [self safe_JSONObj_options:NSJSONReadingMutableContainers];
}

-(nullable id)safe_JSONObj_options:(NSJSONReadingOptions)opt
{
    ASSERT_CLASS(self,NSData);
    
    id ret = nil;
    if (IS_KIND_OF(self, NSData) && self.length>0) {
        NSError *error;
        ret = [NSJSONSerialization JSONObjectWithData:self options:opt error:&error];
        
        if (error) {
            ret = nil;
            ASSERT(!error);
            LOG(@"JSON to object error %@",error);
        }
    }
    return ret;
}

- (nullable NSString *)safe_stringJSONObj
{
    id ret = [self safe_JSONObj];
    if (IS_KIND_OF(ret, NSString)) {
        return ret;
    }
    return nil;
}

- (nullable NSArray *)safe_arrayJSONObj
{
    id ret = [self safe_JSONObj];
    if (IS_KIND_OF(ret, NSArray)) {
        return ret;
    }
    return nil;
}

- (nullable NSDictionary *)safe_dictionaryJSONObj
{
    id ret = [self safe_JSONObj];
    if (IS_KIND_OF(ret, NSDictionary)) {
        return ret;
    }
    return nil;
}

- (nullable NSNumber *)safe_numberJSONObj
{
    id ret = [self safe_JSONObj];
    if (IS_KIND_OF(ret, NSNumber)) {
        return ret;
    }
    return nil;
}

- (nullable NSData *)safe_JSONDataFromObject:(id _Nonnull)obj
{
    ASSERT(obj);
    
    NSData *ret = nil;
    NSError *err = nil;
    ret = [NSJSONSerialization dataWithJSONObject:obj
                                          options:0
                                            error:&err];
    if (err)
    {
        LOG(@"Object to JsonData Error:%@",err);
        ret = nil;
    }
    return (ret);
}




@end
