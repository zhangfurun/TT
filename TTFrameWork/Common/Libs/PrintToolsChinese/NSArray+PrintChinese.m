

#import "NSArray+PrintChinese.h"

@implementation NSArray (PrintChinese)
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *str = [NSMutableString stringWithFormat:@"count:%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}
@end
