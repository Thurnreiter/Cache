unit Cache.Provider.InChunk.UnitTests;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Nathan.Cache.InChunk.Provider.Intf;

type
  [TestFixture]
  TTestCacheProviderCoreT = class
  published
    [Test]
    procedure Test_KeyValueStringObject();

    [Test]
    procedure Test_KeyValueStringInteger();

    [Test]
    procedure Test_KeyValueIntegerString();
  end;

{$M-}

implementation

uses
  Cache.Provider.InChunk.DummyObject,
  Nathan.Cache.InChunk.Provider.Impl;

{ TTestCacheProviderCoreT }

procedure TTestCacheProviderCoreT.Test_KeyValueStringObject;
var
  Cut: ICacheProviderCoreT<string, IDummyObject>;
  ActualDummy: IDummyObject;
begin
  //  Arrange...
  Cut := TCacheProviderCoreT<string, IDummyObject>.Create;

  //  Assert + Act...
  Cut.Add('4711', TDummyObject.Create);
  Assert.AreEqual(1, Cut.Count);

  ActualDummy := Cut.Get('4711');
  Assert.IsNotNull(ActualDummy);
  Assert.AreEqual(4711, ActualDummy.GetAny1(4711));
end;

procedure TTestCacheProviderCoreT.Test_KeyValueStringInteger;
var
  Cut: ICacheProviderCoreT<string, Integer>;
  Actual: Integer;
begin
  //  Arrange...
  Cut := TCacheProviderCoreT<string, Integer>.Create;

  //  Assert + Act...
  Cut.Add('4711', 1234);
  Assert.AreEqual(1, Cut.Count);

  Actual := Cut.Get('4711');
  Assert.AreEqual(1234, Actual);
end;

procedure TTestCacheProviderCoreT.Test_KeyValueIntegerString;
var
  Cut: ICacheProviderCoreT<Integer, string>;
  Actual: string;
begin
  //  Arrange...
  Cut := TCacheProviderCoreT<Integer, string>.Create;

  //  Assert + Act...
  Cut.Add(4711, 'Hello world...');
  Assert.AreEqual(1, Cut.Count);

  Actual := Cut.Get(4711);
  Assert.AreEqual('Hello world...', Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCacheProviderCoreT, 'ProviderT');

end.
