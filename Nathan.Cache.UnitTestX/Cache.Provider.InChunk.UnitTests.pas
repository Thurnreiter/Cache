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

    [Test]
    procedure Test_KeyValueFreedByClear();
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

procedure TTestCacheProviderCoreT.Test_KeyValueFreedByClear;
var
  Cut: ICacheProviderCoreT<Integer, TObject>;
  Dummy1: TObject;
  Dummy2: TObject;
  Actual: TObject;
begin
  //  Arrange...
  Dummy1 := TObject.Create;
  Dummy2 := TObject.Create;
  try
    Cut := TCacheProviderCoreT<Integer, TObject>.Create;

    //  Assert + Act...
    Cut.Add(4711, Dummy1);
    Assert.AreEqual(1, Cut.Count);

    Cut.Add(4712, Dummy2);
    Assert.AreEqual(2, Cut.Count);

    Actual := Cut.Get(4711);
    Assert.AreEqual('TObject', Actual.ClassName);
    Cut.Clear;
  finally
    Dummy1.Free();
    Dummy2.Free();
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCacheProviderCoreT, 'ProviderTNextGen');

end.
