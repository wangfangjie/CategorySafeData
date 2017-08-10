//
//  NSArray+Safe.m
//  CategorySafeData
//
//  Created by wangfj on 2017/8/10.
//  Copyright © 2017年 FJcategory. All rights reserved.
//

#import "NSArray+Safe.h"

#define SAFE_VALUE(value, func1, func2)  {\
\
if ([value isKindOfClass:[NSNumber class]]) {\
return ([(NSNumber *)value func1]);\
} else if ([value isKindOfClass:[NSString class]]) {\
return ([(NSString *)value func2]);\
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


@implementation NSArray (Safe)



- (id)safe_objectAtIndex:(NSInteger)index
{
    //加入断言是为了在debug下方便调试程序，如果有对象是空对象和类型问题，会停留在断言上，方便开发者查找问题，每个方法都加入，方便开发者直接找到调用地点
    
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    if (IS_KIND_OF(self, NSArray) && self.count>0 && index<self.count && index>=0) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (NSString*)safe_stringAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    if (IS_KIND_OF(obj, NSString)) {
        return (obj);
    }
    return nil;
}

- (NSDictionary*)safe_dictionaryAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    if (IS_KIND_OF(obj, NSDictionary)) {
        return (obj);
    }
    return nil;
}

- (NSArray*)safe_arrayAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    if (IS_KIND_OF(obj, NSArray)) {
        return (obj);
    }
    return nil;
}

- (UIImage*)safe_imageAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    if (IS_KIND_OF(obj, UIImage)) {
        return (obj);
    }
    return nil;
}

- (NSData*)safe_dataAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    if (IS_KIND_OF(obj, NSData)) {
        return (obj);
    }
    return nil;
}

- (NSInteger)safe_integerAtIndex:(NSUInteger)index;
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    SAFE_VALUE(obj, integerValue, integerValue);
    
    return 0;
}

-(int)safe_intAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    
    SAFE_VALUE(obj, intValue, intValue);
    
    return 0;
}

-(long)safe_longAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    
    SAFE_VALUE(obj, longValue, integerValue);
    
    return 0;
}

-(long long)safe_longlongAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    
    SAFE_VALUE(obj, longLongValue, longLongValue);
    
    return 0;
}

-(double)safe_doubleAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    
    SAFE_VALUE(obj, doubleValue, doubleValue);
    
    return 0.0f;
}

-(float)safe_floatAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    id obj = [self safe_objectAtIndex:index];
    
    SAFE_VALUE(obj, floatValue, floatValue);
    
    return 0.0f;
}

- (id)safe_getFirstObject
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    if (self.count>0) {
        return [self safe_objectAtIndex:0];
    }
    return nil;
}

- (id)safe_getLastObject
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(index>=0);
    ASSERT(self.count>0);
    
    if (self.count>0) {
        return [self safe_objectAtIndex:self.count-1];
    }
    return nil;
}

-(NSArray*)safe_valueForKey:(NSString *)key
{
    ASSERT_CLASS(self,NSArray);
    ASSERT_CLASS(key,NSString);
    ASSERT(self.count>0);
    
    if (IS_KIND_OF(self, NSArray) && key.length > 0)
    {
        NSArray *tmp = [self valueForKey:key];
        if (IS_KIND_OF(tmp, NSArray) && tmp.count>0)
        {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            for (id obj in tmp)
            {
                if (obj && !IS_KIND_OF(obj, NSNull))
                {
                    [arr addObject:obj];
                }
            }
            return ([arr copy]);
        }
    }
    return nil;
}

-(NSArray*)safe_arrayByRemoveObject:(id)anObject
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(self.count>0);
    ASSERT(anObject);
    
    NSArray *ret = self;
    if (IS_KIND_OF(self, NSArray) && anObject && self.count>0) {
        NSMutableArray *temp = [ret mutableCopy];
        [temp safe_removeObject:anObject];
        ret = [temp copy];
    }
    return ret;
}

-(NSArray*)safe_arrayByRemoveObjects:(NSArray *)otherArray
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(otherArray);
    ASSERT(self.count>0);
    
    NSArray *ret = self;
    if (IS_KIND_OF(self, NSArray) &&IS_KIND_OF(otherArray, NSArray)  && otherArray.count>0 && self.count>0)
    {
        NSMutableArray *temp = [ret mutableCopy];
        [temp safe_removeObjectsInArray:otherArray];
        ret = [temp copy];
    }
    return ret;
}

-(NSArray*)safe_arrayByRemoveNullObjects
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(self.count>0);
    
    NSArray *ret = self;
    if (self.count>0) {
        NSMutableArray *temp = [ret mutableCopy];
        [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSNull class]]) {
                [temp safe_removeObject:obj];
            }
        }];
        ret = [temp copy];
    }
    return ret;
}

-(NSArray*)safe_arrayByAddObject:(id)anObject
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(anObject);
    
    NSArray *ret = self;
    
    if (!ret) {
        ret = [NSArray new];
    }
    
    if (IS_KIND_OF(self, NSArray) && anObject) {
        NSMutableArray *temp = [ret mutableCopy];
        [temp safe_addObject:anObject];
        ret = [temp copy];
    }
    return ret;
}

-(NSArray*)safe_arrayByAddObjects:(NSArray *)array
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(array);
    
    NSArray *ret = self;
    
    if (!ret) {
        ret = [NSArray new];
    }
    
    if (IS_KIND_OF(self, NSArray) && IS_KIND_OF(array, NSArray)  && array.count>0)
    {
        NSMutableArray *temp = [ret mutableCopy];
        [temp safe_addObjectsFromArray:array];
        ret = [NSArray arrayWithArray:temp];
    }
    return ret;
}

-(BOOL)safe_containsObject:(id)anObject
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(anObject);
    ASSERT(self.count>0);
    
    if (anObject && self.count>0 && !IS_KIND_OF(anObject, NSNull)) {
        return [self containsObject:anObject];
    }
    return NO;
}

-(BOOL)safe_containsObjectsArray:(NSArray *)otherArray
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(otherArray);
    ASSERT(self.count>0);
    
    if (self.count>0 && otherArray.count>0&&IS_KIND_OF(self, NSArray)&&IS_KIND_OF(otherArray, NSArray)) {
        
        NSSet *set = [NSSet setWithArray:self];
        NSSet *set2 = [NSSet setWithArray:otherArray];
        return ([set2 isSubsetOfSet:set]);
    }
    return NO;
}

-(BOOL)safe_isExistObject:(NSDictionary *)newDic longKey:(NSString *)longKey
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(self.count>0);
    ASSERT_CLASS(newDic,NSDictionary);
    ASSERT_CLASS(longKey,NSString);
    
    if (IS_KIND_OF(self, NSArray) &&
        newDic &&
        [newDic isKindOfClass:[NSDictionary class]] &&
        longKey.length>0)
    {
        for (NSDictionary *obj1 in self)
        {
            //找到字典里面以唯一id为标识的字段相比较
            long oldid  = [obj1 safe_longForKey:longKey];
            long newid  = [newDic safe_longForKey:longKey];
            if (newid == oldid) {
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL)safe_isExistObject:(NSDictionary *)newDic stringKey:(NSString *)stringKey
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(self.count>0);
    ASSERT_CLASS(newDic,NSDictionary);
    ASSERT_CLASS(stringKey,NSString);
    
    if (newDic && [newDic isKindOfClass:[NSDictionary class]] && stringKey.length>0)
    {
        for (NSDictionary *obj1 in self) {
            //找到字典里面以唯一字符串为标识的字段相比较
            NSString *oldStr  = [obj1 safe_stringForKey:stringKey];
            NSString *newStr  = [newDic safe_stringForKey:stringKey];
            if ([newStr isEqualToString:oldStr]) {
                return YES;
            }
        }
    }
    return NO;
}

-(NSData*)toJSONData
{
    ASSERT_CLASS(self,NSArray);
    ASSERT(self.count>0);
    
    NSData *ret = nil;
    NSError *err = nil;
    ret = [NSJSONSerialization dataWithJSONObject:self
                                          options:0
                                            error:&err];
    if (err)
    {
        LOG(@"NSArraytoJsonDataError:%@",err.description);
        ret = nil;
    }
    return (ret);
}

@end

@implementation NSMutableArray (SPSafe)

- (BOOL)safe_addObject:(id)anObject
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT(anObject);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableArray) && anObject && !IS_KIND_OF(anObject, NSNull)) {
        @synchronized (self) {
            return YES;
            @try {
                [self addObject:anObject];
                ret = YES;
            } @catch (NSException *exception) {
                LOG(@"error:%@", exception);
                ret = NO;
            } @finally {
            }
        }
    }
    return ret;
}

- (BOOL)safe_addObjectsFromArray:(NSArray*)otherArray
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT_CLASS(otherArray,NSArray);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableArray) && IS_KIND_OF(otherArray, NSArray) && (otherArray.count > 0)) {
        @synchronized (self) {
            @try {
                [self addObjectsFromArray:otherArray];
                ret = YES;
                
            } @catch (NSException *exception) {
                LOG(@"error:%@", exception);
                ret = NO;
            } @finally {
            }
        }
    }
    return ret;
}

- (BOOL)safe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT(anObject);
    ASSERT(index>=0);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableArray) && anObject && index <= self.count) {
        @synchronized (self) {
            @try {
                [self insertObject:anObject atIndex:index];
                ret = YES;
            } @catch (NSException *exception) {
                LOG(@"error:%@", exception);
                ret = NO;
            } @finally {
            }
        }
    }
    return ret;
}

- (BOOL)safe_insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT_CLASS(objects,NSArray);
    ASSERT_CLASS(indexes,NSIndexSet);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableArray) && IS_KIND_OF(objects, NSArray)  && indexes) {
        @synchronized (self) {
            @try {
                [self insertObjects:objects atIndexes:indexes];
                ret = YES;
                
            } @catch (NSException *exception) {
                LOG(@"error:%@", exception);
                ret = NO;
                
            } @finally {
            }
        }
    }
    return ret;
}

- (BOOL)safe_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT(self.count>0);
    ASSERT(idx1>=0);
    ASSERT(idx2>=0);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableArray) && idx1 < self.count && idx2 < self.count && idx1!=idx2) {
        @synchronized (self) {
            @try {
                [self exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
                ret = YES;
            } @catch (NSException *exception) {
                LOG(@"error:%@", exception);
                ret = NO;
            } @finally {
            }
        }
    }
    return ret;
}

- (BOOL)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT(self.count>0);
    ASSERT(index>=0);
    ASSERT(anObject);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableArray) && index < self.count && anObject) {
        @synchronized (self) {
            @try {
                [self replaceObjectAtIndex:index withObject:anObject];
                ret = YES;
            } @catch (NSException *exception) {
                LOG(@"error:%@", exception);
                ret = NO;
            } @finally {
            }
            
        }
    }
    return ret;
}

-(BOOL)safe_addObjectsByRemoveRepeatWithNewArray:(NSArray<NSDictionary *> *)newArray longKey:(NSString *)longKey
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT_CLASS(newArray,NSArray);
    ASSERT_CLASS(longKey,NSString);
    
    
    for (NSDictionary *dic in newArray) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
    }
    
    for (NSDictionary *dic in self) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
    }
    
    //由于for in 在遍历的时候不能更改数组，所以使用系统提供的遍历方法
    //遍历删除旧数据里面和新数据重复的数据
    [self enumerateObjectsUsingBlock:^(NSDictionary *obj1, NSUInteger idx, BOOL * _Nonnull stop) {
        //找到字典里面以唯一id为标识的字段相比较
        long oldid  = [obj1 safe_longForKey:longKey];
        
        [newArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
            long newid  = [obj2 safe_longForKey:longKey];
            if (newid == oldid) {
                [self safe_removeObject:obj1];
            }
        }];
    }];
    
    //新数据加入到旧数据尾部
    return  [self safe_addObjectsFromArray:newArray];
}

-(BOOL)safe_addObjectsByRemoveRepeatWithNewArray:(NSArray<NSDictionary *> *)newArray stringKey:(NSString *)stringKey
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT_CLASS(newArray,NSArray);
    ASSERT_CLASS(stringKey,NSString);
    
    for (NSDictionary *dic in newArray) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
    }
    
    for (NSDictionary *dic in self) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
    }
    
    //遍历删除旧数据里面和新数据重复的数据
    [self enumerateObjectsUsingBlock:^(NSDictionary *obj1, NSUInteger idx, BOOL * _Nonnull stop) {
        //找到字典里面以唯一字符串为标识的字段相比较
        NSString *oldStr  = [obj1 safe_stringForKey:stringKey];
        
        [newArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *newStr  = [obj2 safe_stringForKey:stringKey];
            if ([newStr isEqualToString:oldStr]) {
                [self safe_removeObject:obj1];
            }
        }];
    }];
    
    //新数据加入到旧数据尾部
    return  [self safe_addObjectsFromArray:newArray];
}

-(BOOL)safe_insertObjectsAtHeadByRemoveRepeatWithNewArray:(NSArray<NSDictionary *> *)newArray longKey:(NSString *)longKey
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT_CLASS(newArray,NSArray);
    ASSERT_CLASS(longKey,NSString);
    
    for (NSDictionary *dic in newArray) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
    }
    
    for (NSDictionary *dic in self) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
    }
    
    //由于for in 在遍历的时候不能更改数组，所以使用系统提供的遍历方法
    //遍历删除旧数据里面和新数据重复的数据
    [self enumerateObjectsUsingBlock:^(NSDictionary *obj1, NSUInteger idx, BOOL * _Nonnull stop) {
        //找到字典里面以唯一id为标识的字段相比较
        long oldid  = [obj1 safe_longForKey:longKey];
        
        [newArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
            long newid  = [obj2 safe_longForKey:longKey];
            if (newid == oldid) {
                [self safe_removeObject:obj1];
            }
        }];
    }];
    
    //新数据加入到旧数据前部
    if (newArray.count>0) {
        NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newArray.count)];
        [self safe_insertObjects:newArray atIndexes:indexSet];
        return YES;
    }
    return NO;
}


-(BOOL)safe_insertObjectsAtHeadByRemoveRepeatWithNewArray:(NSArray<NSDictionary *> *)newArray stringKey:(NSString *)stringKey
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT_CLASS(newArray,NSArray);
    ASSERT_CLASS(stringKey,NSString);
    
    for (NSDictionary *dic in newArray) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
    }
    
    for (NSDictionary *dic in self) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
    }
    
    //遍历删除旧数据里面和新数据重复的数据
    [self enumerateObjectsUsingBlock:^(NSDictionary *obj1, NSUInteger idx, BOOL * _Nonnull stop) {
        //找到字典里面以唯一字符串为标识的字段相比较
        NSString *oldStr  = [obj1 safe_stringForKey:stringKey];
        
        [newArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *newStr  = [obj2 safe_stringForKey:stringKey];
            if ([newStr isEqualToString:oldStr]) {
                [self safe_removeObject:obj1];
            }
        }];
    }];
    
    //新数据加入到旧数据前部
    if (newArray.count>0) {
        NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newArray.count)];
        [self safe_insertObjects:newArray atIndexes:indexSet];
        return YES;
    }
    return NO;
}



#pragma mark - safe_remove
- (BOOL)safe_removeLastObject
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT(self.count>0);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableArray) && self.count > 0) {
        @synchronized (self) {
            @try {
                [self removeLastObject];
                ret = YES;
            } @catch (NSException *exception) {
                LOG(@"remove error:%@", exception);
                ret = NO;
            } @finally {
            }
        }
    }
    return ret;
}

- (BOOL)safe_removeObjectAtIndex:(NSUInteger)index
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT(self.count>0);
    ASSERT(index>=0);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableArray) && index < self.count) {
        
        @synchronized (self) {
            @try {
                [self removeObjectAtIndex:index];
                ret = YES;
            } @catch (NSException *exception) {
                LOG(@"remove error:%@", exception);
                ret = NO;
            } @finally {
            }
        }
    }
    return ret;
}

- (BOOL)safe_removeObject:(id)anObject
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT(anObject);
    ASSERT(self.count>0);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableArray) && self.count>0 && anObject) {
        @synchronized (self) {
            @try {
                [self removeObject:anObject];
                ret = YES;
            } @catch (NSException *exception) {
                LOG(@"remove error:%@", exception);
                ret = NO;
            } @finally {
            }
        }
    }
    return ret;
}

- (BOOL)safe_removeObject:(id)anObject inRange:(NSRange)range
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT(self.count>0);
    
    BOOL ret = NO;
    NSUInteger index = range.location + range.length;
    if (IS_KIND_OF(self, NSMutableArray) &&self.count>0 && index<self.count && anObject) {
        
        @synchronized (self) {
            @try {
                [self removeObject:anObject inRange:range];
                ret = YES;
            } @catch (NSException *exception) {
                LOG(@"remove error:%@", exception);
                ret = NO;
            } @finally {
            }
        }
    }
    return ret;
}

-(BOOL)safe_removeObjectsInArray:(NSArray *)otherArray
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT_CLASS(otherArray,NSArray);
    ASSERT(self.count>0);
    
    BOOL ret = NO;
    
    if (IS_KIND_OF(self, NSMutableArray) && IS_KIND_OF(otherArray, NSArray) &&self.count>0 && otherArray.count>0) {
        @synchronized (self) {
            @try {
                [self removeObjectsInArray:otherArray];
                ret = YES;
            } @catch (NSException *exception) {
                LOG(@"remove error:%@", exception);
                ret = NO;
            } @finally {
            }
        }
    }
    return ret;
}

-(BOOL)safe_removeObjectsInRange:(NSRange)range
{
    ASSERT_CLASS(self,NSMutableArray);
    ASSERT(self.count>0);
    
    BOOL ret = NO;
    
    NSUInteger index = range.location+range.length;
    if (IS_KIND_OF(self, NSMutableArray) && self.count>0 && index<self.count) {
        
        @synchronized (self) {
            @try {
                [self removeObjectsInRange:range];
                ret = YES;
            } @catch (NSException *exception) {
                LOG(@"remove error:%@", exception);
                ret = NO;
            } @finally {
            }
        }
    }
    return ret;
}




@end
