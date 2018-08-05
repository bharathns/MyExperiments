### Usage:



##### Book class needs to implement BNPreferences and all the properties which needs to be saved needs to have a @dynamickeyword

	Book *book = [[Book alloc] init];
	// Following three lines of code would save into NSUserDefaults (preferences)
	book.username = @"labamba";
    book.title = @"Jithin3";
    book.isOK = YES;
    
	// Following three lines would fetch from NSUserDefaults (prefeerences
	NSLog(@"username: %@",book.username);
    NSLog(@"title: %@",book.title);
    NSLog(@"isOK: %d",book.isOK);



	
Using Message forwarding to achieve the above functionality
	
combination of 
	
1. -(BOOL)resolveMethodInstance:(SEL)sel <br />
   I build the property table here, deciding which are the properties I can save and the one's I cannot.
2. -(NSMethodSignature)methodSignatureForSelector:(SEL)selector <br />
   here I sent method type interms of argument and return type(setter/getter)
3. -(void)forwardInvocation:(NSInvocation)invocation <br />
   here I do the actual save and retrieve from NSUserDefaults
The approach is to add those setters and getters
There is an implementation by [Denis Hennesey](http://hennessynet.com) which makes use of dynamic programming and message forwarding in a different way.[PAPreferences](https://github.com/dhennessy/PAPreferences)
    I like this implmentation as well, which is different from what I have done.
    Here is what is done...
    
  1. Builds the property list in init
  2. He has prototypes for all setters and getters supported by NSUserDefaults.
  3. He adds those setters and getters using class_addMethod. in resolveInstanceMethod
 
