#import "JSONModel.h"
#import "ExampleObjectModel.h"

@protocol ExampleModel
@end

@interface ExampleModel : JSONModel

@property (strong, nonatomic) NSArray *array;
@property (assign, nonatomic) BOOL boolean;
@property (assign, nonatomic) NSInteger integer;
@property (assign, nonatomic) double number;
@property (strong, nonatomic) NSString *string;
@property (strong, nonatomic) ExampleObjectModel *object;

@end
