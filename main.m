// vi: filetype=objc

#import <Foundation/Foundation.h>


NSDictionary<NSNumber*,NSNumber*> * makeTransformer();
NSString* choseongWithString(NSString* text);

NSDictionary<NSNumber*,NSNumber*> * makeTransformer()
{
	NSDictionary<NSNumber*,NSNumber*> * dict = @{
		@(0x1100): @(0x3131), @(0x1101): @(0x3132), @(0x1102): @(0x3134), @(0x1103): @(0x3137),
		@(0x1104): @(0x3138), @(0x1105): @(0x3139), @(0x1106): @(0x3141), @(0x1107): @(0x3142),
		@(0x1108): @(0x3143), @(0x1109): @(0x3145), @(0x110a): @(0x3146), @(0x110b): @(0x3147),
		@(0x110c): @(0x3148), @(0x110d): @(0x3149), @(0x110e): @(0x314a), @(0x110f): @(0x314b),
		@(0x1110): @(0x314c), @(0x1111): @(0x314d), @(0x1112): @(0x314e), @(0x1114): @(0x3165),
		@(0x1115): @(0x3166), @(0x111a): @(0x3140), @(0x111c): @(0x316e), @(0x111d): @(0x3171),
		@(0x111e): @(0x3172), @(0x1120): @(0x3173), @(0x1121): @(0x3144), @(0x1122): @(0x3174),
		@(0x1123): @(0x3175), @(0x1127): @(0x3176), @(0x1129): @(0x3177), @(0x112b): @(0x3178),
		@(0x112c): @(0x3179), @(0x112d): @(0x317a), @(0x112e): @(0x317b), @(0x112f): @(0x317c),
		@(0x1132): @(0x317d), @(0x1136): @(0x317e), @(0x1140): @(0x317f), @(0x1147): @(0x3180),
		@(0x114c): @(0x3181), @(0x1157): @(0x3184), @(0x1158): @(0x3185), @(0x1159): @(0x3186),
		@(0x115b): @(0x3167), @(0x115c): @(0x3135), @(0x115d): @(0x3136)
	};
	return dict;
}

NSString* choseongWithString(NSString* text)
{
	NSMutableArray<NSString*> *array = 
		[NSMutableArray arrayWithCapacity:[text length]];
	// unichar = unsigned short
	unichar c, f;
	NSNumber *k;
	int i;
	@autoreleasepool {
		NSDictionary<NSNumber*,NSNumber*> *tranform = makeTransformer();
		for(i=0;i<[text length];i++) {
			c = [text characterAtIndex:i];
			if( c >= 0xAC00 && c <= 0xD7A3 ) {
				f = ((c - 0xAC00) / 28) / 21 + 0x1100;
				k = [tranform objectForKey:@(f)];
				f = k == nil ? f : [k unsignedShortValue];
			} else {
			    f = c;	
			}
			[array addObject:[NSString stringWithFormat:@"%C", f]];
		}
	}
	return [array componentsJoinedByString:@""];
}

void test(void) {
	NSString *text = @"안녕하세요";
	NSLog(@"%@", choseongWithString(text));
}

int main(int argc, const char *argv[]) {
	@autoreleasepool{
		NSString *text, *result;
		if (argc > 1) {
			NSMutableArray<NSString*> *array = 
				[NSMutableArray arrayWithCapacity:argc-1];
			int i;
			for(i=1;i<argc;i++) {
				[array addObject:[NSString stringWithUTF8String:argv[i]]];
			}
			text = [array componentsJoinedByString:@" "];
		} else {
			NSFileHandle *stdin = [NSFileHandle fileHandleWithStandardInput];
			NSData *data = [stdin availableData];
			text = [[[NSString alloc] initWithData:data 
									  encoding:NSUTF8StringEncoding]
					autorelease];
		}
		result = choseongWithString(text);
		printf("%s\n", [result UTF8String]);
	}
	return 0;
}
