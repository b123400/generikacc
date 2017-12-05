//
//  ProductTests.m
//  ProductTests
//
//  Copyright (c) 2012-2017 ywesee GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Product.h"

@interface ProductTests : XCTestCase

@end

@implementation ProductTests

- (void)setUp
{
  [super setUp];

}

- (void)tearDown
{

  [super tearDown];
}

- (void)testInit
{
  DLogMethod

  Product *product = [[Product alloc] init];
  XCTAssertNotNil(product);
}

- (void)testDealloc
{
  // pass
}

- (void)testInitWithEan
{
  DLogMethod

  NSString *vEan = @"7680317060176";

  Product *product = [[Product alloc] initWithEan:vEan];

  NSString *ean = product.ean;
  XCTAssertEqualObjects(ean, vEan);
}

- (void)testInitWithCoder_withoutExpiresAt
{
  DLogMethod

  NSString *vEan = @"7680317060176";

  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc]
                              initForWritingWithMutableData:data];
  [encoder encodeObject:vEan forKey:@"ean"];
  [encoder finishEncoding];

  NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc]
                                initForReadingWithData:data];
  Product *product = [[Product alloc] initWithCoder:decoder];

  DLog(@"product.ean -> %@", [decoder decodeObjectForKey:@"ean"]);
  DLog(@"product.expiresAt -> %@", [decoder decodeObjectForKey:@"expiresAt"]);

  NSString *ean = product.ean;
  XCTAssertEqualObjects(ean, vEan);

  NSString *expiresAt = product.expiresAt;
  XCTAssertEqualObjects(expiresAt, @"");
}

- (void)testInitWithCoder_withExpiresAt
{
  DLogMethod

  NSString *vEan = @"7680317060176";
  NSString *vExpiresAt = @"29.02.2017";

  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc]
                              initForWritingWithMutableData:data];
  [encoder encodeObject:vEan forKey:@"ean"];
  [encoder encodeObject:vExpiresAt forKey:@"expiresAt"];
  [encoder finishEncoding];

  NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc]
                                initForReadingWithData:data];
  Product *product = [[Product alloc] initWithCoder:decoder];

  DLog(@"product.ean -> %@", [decoder decodeObjectForKey:@"ean"]);
  DLog(@"product.expiresAt -> %@", [decoder decodeObjectForKey:@"expiresAt"]);

  NSString *ean = product.ean;
  XCTAssertEqualObjects(ean, vEan);

  NSString *expiresAt = product.expiresAt;
  XCTAssertEqualObjects(expiresAt, vExpiresAt);
}

- (void)testEncodeWithCoder_withoutExpiresAt
{
  // pass
}

- (void)testEncodeWithCoder_withExpiresAt
{
  // pass
}

- (void)testReg_reg
{
  DLogMethod

  NSString *vReg = @"31706";

  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc]
                              initForWritingWithMutableData:data];
  [encoder encodeObject:vReg forKey:@"reg"];
  [encoder finishEncoding];

  NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc]
                                initForReadingWithData:data];
  Product *product = [[Product alloc] initWithCoder:decoder];

  NSString *reg = product.reg;
  XCTAssertEqualObjects(reg, vReg);

  NSString *ean = product.ean;
  XCTAssertEqualObjects(ean, nil);
}

- (void)testReg_extractingFromEan
{
  DLogMethod

  NSString *vEan = @"7680317060176";

  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc]
                              initForWritingWithMutableData:data];
  [encoder encodeObject:vEan forKey:@"ean"];
  [encoder finishEncoding];

  NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc]
                                initForReadingWithData:data];
  Product *product = [[Product alloc] initWithCoder:decoder];

  NSString *reg = product.reg;
  XCTAssertEqualObjects(reg, @"31706");

  NSString *ean = product.ean;
  XCTAssertEqualObjects(ean, vEan);
}

- (void)testReg_noProperties
{
  DLogMethod

  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc]
                              initForWritingWithMutableData:data];
  [encoder finishEncoding];

  NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc]
                                initForReadingWithData:data];
  Product *product = [[Product alloc] initWithCoder:decoder];

  NSString *reg = product.reg;
  XCTAssertEqualObjects(reg, @"");

  NSString *ean = product.ean;
  XCTAssertEqualObjects(ean, nil);
}

- (void)testSeq_seq
{
  DLogMethod

  NSString *vSeq = @"017";

  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc]
                              initForWritingWithMutableData:data];
  [encoder encodeObject:vSeq forKey:@"seq"];
  [encoder finishEncoding];

  NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc]
                                initForReadingWithData:data];
  Product *product = [[Product alloc] initWithCoder:decoder];

  NSString *seq = product.seq;
  XCTAssertEqualObjects(seq, vSeq);

  NSString *ean = product.ean;
  XCTAssertEqualObjects(ean, nil);
}

- (void)testSeq_extractingFromEan
{
  DLogMethod

  NSString *vEan = @"7680317060176";

  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc]
                              initForWritingWithMutableData:data];
  [encoder encodeObject:vEan forKey:@"ean"];
  [encoder finishEncoding];

  NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc]
                                initForReadingWithData:data];
  Product *product = [[Product alloc] initWithCoder:decoder];

  NSString *seq = product.seq;
  XCTAssertEqualObjects(seq, @"017");

  NSString *ean = product.ean;
  XCTAssertEqualObjects(ean, vEan);
}

- (void)testSeq_noProperties
{
  DLogMethod

  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc]
                              initForWritingWithMutableData:data];
  [encoder finishEncoding];

  NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc]
                                initForReadingWithData:data];
  Product *product = [[Product alloc] initWithCoder:decoder];

  NSString *seq = product.seq;
  XCTAssertEqualObjects(seq, @"");

  NSString *ean = product.ean;
  XCTAssertEqualObjects(ean, nil);
}

- (void)testDetectNumberFromEanWithRegexpString_regexpString
{
  // pass
}

- (void)testDictConversion_usingProductKeys
{
  NSString *vReg = @"31706";
  NSString *vSeq = @"017";
  NSString *vPack = @"6";
  NSString *vName = @"Inderal";
  NSString *vSize = @"1";
  NSString *vDeduction = @"";
  NSString *vPrice = @"12.34";
  NSString *vCategory = @"A";
  NSString *vBarcode = @"";
  NSString *vEan = @"7680317060176";
  NSString *vDatetime = @"02.02.2017";
  NSString *vExpiresAt = @"29.02.2017";

  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc]
                              initForWritingWithMutableData:data];
  [encoder encodeObject:vEan forKey:@"ean"];
  [encoder encodeObject:vSeq forKey:@"seq"];
  [encoder encodeObject:vPack forKey:@"pack"];
  [encoder encodeObject:vName forKey:@"name"];
  [encoder encodeObject:vSize forKey:@"size"];
  [encoder encodeObject:vDeduction forKey:@"deduction"];
  [encoder encodeObject:vPrice forKey:@"price"];
  [encoder encodeObject:vCategory forKey:@"category"];
  [encoder encodeObject:vBarcode forKey:@"barcode"];
  [encoder encodeObject:vEan forKey:@"ean"];
  [encoder encodeObject:vDatetime forKey:@"datetime"];
  [encoder encodeObject:vExpiresAt forKey:@"expiresAt"];
  [encoder finishEncoding];

  NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc]
                                initForReadingWithData:data];
  Product *product = [[Product alloc] initWithCoder:decoder];

  NSDictionary *productDict = [product
    dictionaryWithValuesForKeys:[product productKeys]];
  NSDictionary *expected = @{
    @"reg": vReg,
    @"seq": vSeq,
    @"pack": vPack,
    @"name": vName,
    @"size": vSize,
    @"deduction": vDeduction,
    @"price": vPrice,
    @"category": vCategory,
    @"barcode": vBarcode,
    @"ean": vEan,
    @"datetime": vDatetime,
    @"expiresAt": vExpiresAt,
  };
  XCTAssertEqualObjects(productDict, expected);
}

@end