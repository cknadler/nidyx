#import "JSONModel.h"

@class ExampleObjectModel;
@protocol ExampleObjectModel;
@protocol ExampleModel; @end

@interface ExampleModel : JSONModel
@property (strong, nonatomic) NSArray *array;
@property (assign, nonatomic) BOOL boolean;
// this is a comment that will show up as documentation
@property (assign, nonatomic) NSInteger integer;
// this is another comment with some 'special characters'
@property (assign, nonatomic) double number;
@property (strong, nonatomic) NSString *string;
@property (strong, nonatomic) ExampleObjectModel *object;
@end
