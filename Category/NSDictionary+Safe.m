//
//  NSDictionary+Safe.m
//  CategorySafeData
//
//  Created by wangfj on 2017/8/10.
//  Copyright © 2017年 FJcategory. All rights reserved.
//

#import "NSDictionary+Safe.h"

#define VALUE_FOR_KEY(key, func1, func2)  {\
if (![self isKindOfClass:[NSDictionary class]]||!key) {\
return (0.0f);\
}\
id _ret = [self objectForKey:key];\
if ([_ret isKindOfClass:[NSNumber class]]) {\
return ([(NSNumber *)_ret func1]);\
} else if ([_ret isKindOfClass:[NSString class]]) {\
return ([(NSString *)_ret func2]);\
}\
}

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


@implementation NSDictionary (Safe)

- (nullable id)safe_objectForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    if (IS_KIND_OF(self, NSDictionary) && key) {
        return [self objectForKey:key];
    }
    return nil;
}

- (nullable NSString *)safe_stringForKey:(id)key
{
    //为什么要每个里面都加断言呢，原因是如果只在上一个safe_objectForKey里面加断言不能马上知道到底是哪个方法调用的，在每个里面加断言可以离开知道是调用的哪个方法
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    NSString *ret=nil;
    
    id object = [self safe_objectForKey:key];
    
    if (IS_KIND_OF(object, NSString))
    {
        ret = (NSString *)object;
    }
    else if (IS_KIND_OF(object, NSNumber))
    {
        ret = [object stringValue];
    }
    else if (IS_KIND_OF(object, NSURL))
    {
        ret = [(NSURL *)object absoluteString];
    }
    else
    {
        ret = [object description];
    }
    
    return (ret);
}

- (nullable NSArray *)safe_arrayForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    NSArray *ret = nil;
    
    id object = [self safe_objectForKey:key];
    if (object && IS_KIND_OF(object, NSArray))
    {
        ret = object;
    }
    
    return (ret);
}

- (nullable NSDictionary *)safe_dictionaryForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    NSDictionary *ret = nil;
    
    id object = [self safe_objectForKey:key];
    if (object && IS_KIND_OF(object, NSDictionary))
    {
        ret = object;
    }
    
    return (ret);
}

- (nullable NSNumber *)safe_numberForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    NSNumber *ret = nil;
    
    id object= [self safe_objectForKey:key];
    if (object&&IS_KIND_OF(object, NSNumber))
    {
        ret = object;
    }
    
    return (ret);
}

- (nullable NSData *)safe_dataForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    NSData *ret = nil;
    id object= [self safe_objectForKey:key];
    if (object&&IS_KIND_OF(object, NSData))
    {
        ret = object;
    }
    
    return (ret);
}

- (NSInteger)safe_integerForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    VALUE_FOR_KEY(key, integerValue,integerValue);
    return (0);
}

- (int)safe_intForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    VALUE_FOR_KEY(key, intValue, intValue);
    return (0);
}

- (long)safe_longForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    VALUE_FOR_KEY(key, longValue, integerValue);
    return (0);
}

- (long long)safe_longLongForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    VALUE_FOR_KEY(key, longLongValue,longLongValue);
    return (0);
}

- (double)safe_doubleForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    VALUE_FOR_KEY(key, doubleValue,doubleValue);
    return (0.0f);
}

- (float)safe_floatForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    VALUE_FOR_KEY(key, floatValue,floatValue);
    return (0.0f);
}

- (BOOL)safe_boolForKey:(id)key
{
    ASSERT(key);
    ASSERT_CLASS(self,NSDictionary);
    
    VALUE_FOR_KEY(key, boolValue,boolValue);
    return (NO);
}

- (NSString*_Nullable)safe_stringForKeyPath:(NSString *)keyPath
{
    ASSERT_CLASS(keyPath,NSString);
    ASSERT_CLASS(self,NSDictionary);
    
    NSString *ret = nil;
    id object = [self safe_objectForKeyPath:keyPath];
    
    if (IS_KIND_OF(object, NSString))
    {
        ret = (NSString *)object;
    }
    else if (IS_KIND_OF(object, NSNumber))
    {
        ret = [object stringValue];
    }
    else if (IS_KIND_OF(object, NSURL))
    {
        ret = [(NSURL *)object absoluteString];
    }
    else
    {
        ret = [object description];
    }
    
    return ret;
}

- (id)safe_objectForKeyPath:(NSString *)keyPath
{
    ASSERT_CLASS(keyPath,NSString);
    ASSERT_CLASS(self,NSDictionary);
    
    if (IS_KIND_OF(keyPath, NSString) && IS_KIND_OF(self, NSDictionary)) {
        
        NSDictionary *dic = self;
        
        NSString *keyPathtemp = [keyPath stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *arr = [keyPathtemp componentsSeparatedByString:@"."];
        
        for (int i = 0; i<arr.count; i++) {
            NSString *str = arr[i];
            @try {
                dic = [dic objectForKey:str];
            } @catch (NSException *exception) {
                LOG(@"safe_objectForKeyPath error:%@", exception);
            } @finally {
            }
        }
        return dic;
    }
    else
    {
        LOG(@"keyPath  is not NSString ,or self is not NSDictionary");
        return nil;
    }
}


// add anObject
- (nullable NSDictionary *)safe_dictionaryBySetObject:(id)anObject forKey:(id)aKey
{
    ASSERT_CLASS(aKey,NSString);
    ASSERT_CLASS(self,NSDictionary);
    
    NSDictionary *ret = self;
    
    if (!ret) {
        ret = [NSDictionary new];
    }
    
    NSMutableDictionary *mDict = [ret mutableCopy];
    [mDict safe_setObject:anObject forKey:aKey];
    return ([mDict copy]);
    
    return self;
}

- (nullable NSDictionary *)safe_dictionaryAddEntriesFromDictionary:(nullable NSDictionary *)otherDictionary
{
    ASSERT_CLASS(otherDictionary,NSDictionary);
    ASSERT_CLASS(self,NSDictionary);
    
    NSDictionary *ret = self;
    
    if (!ret) {
        ret = [NSDictionary new];
    }
    
    NSMutableDictionary *dic = [ret mutableCopy];
    [dic safe_addEntriesFromDictionary:otherDictionary];
    return ([dic copy]);
    
    return self;
}

- (nullable NSData *)toJSONData
{
    ASSERT_CLASS(self,NSDictionary);
    
    NSData *ret = nil;
    NSError *err = nil;
    ret = [NSJSONSerialization dataWithJSONObject:self
                                          options:0
                                            error:&err];
    if (err)
    {
        LOG(@"Dictionary to JsonData Error:%@",err);
        ret = nil;
    }
    return (ret);
}

@end



#pragma mark - NSMutableDictionary + Safe
#define KeyType id
#define ObjectType id

@implementation NSMutableDictionary (Safe)

- (BOOL)safe_setObject:(nullable ObjectType)anObject forKey:(nullable KeyType)aKey;
{
    ASSERT_CLASS(self,NSMutableDictionary);
    ASSERT(aKey);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableDictionary) && aKey)
    {
        @synchronized (self) {
            if (anObject) {
                [self setObject:anObject forKey:aKey];
                ret = YES;
            }
            else
            {
                [self removeObjectForKey:aKey];
            }
        }
    }
    return (ret);
}

- (BOOL)safe_setString:(nullable NSString *)anObject forKey:(nullable KeyType)aKey;
{
    ASSERT_CLASS(self,NSMutableDictionary);
    ASSERT_CLASS(anObject, NSString);
    ASSERT(aKey);
    
    if (IS_KIND_OF(anObject, NSString)) {
        
        return [self safe_setObject:anObject forKey:aKey];
    }
    else if(IS_KIND_OF(anObject, NSNumber))
    {
        return [self safe_setObject:[(NSNumber*)anObject stringValue] forKey:aKey];
    }
    else
    {
        return [self safe_setObject:nil forKey:aKey];
    }
}

- (void)safe_addEntriesFromDictionary:(nullable NSDictionary *)otherDictionary
{
    ASSERT_CLASS(self,NSMutableDictionary);
    ASSERT_CLASS(otherDictionary,NSDictionary);
    
    if (IS_KIND_OF(self, NSMutableDictionary) && IS_KIND_OF(otherDictionary, NSDictionary) && otherDictionary.allKeys.count>0) {
        @synchronized (self) {
            [self addEntriesFromDictionary:otherDictionary];
        }
    }
}


@end
