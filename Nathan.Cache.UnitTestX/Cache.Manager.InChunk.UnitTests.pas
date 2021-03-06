unit Cache.Manager.InChunk.UnitTests;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Nathan.Cache.InChunk.Provider.Intf,
  Nathan.Cache.InChunk.Manager.Intf;

type
  [TestFixture]
  TTestCacheManagereCoreT = class
  published
    [Test(False)]
    procedure Test_ManagerWithKeyValueIntegerString;

    [Test]
    procedure Test_CacheManagerUpper9LoopT;

    [Test]
    procedure Test_CacheManagerWithNoDataFiller;

    [Test(False)]
    procedure Test_CacheManagerEndlessLoop;

    [Test]
    procedure Test_CacheManagerEndlessLoopWithHugerData;

    [Test]
    procedure Test_CacheManagerEndlessLoopWith5Elements;
  end;

{$M-}

implementation

uses
  System.SysUtils,
  Cache.Provider.InChunk.DummyObject,
  Nathan.Cache.InChunk.Provider.Impl,
  Nathan.Cache.InChunk.Manager.Impl;

{ **************************************************************************** }

{ TTestCacheManagereCoreT }

procedure TTestCacheManagereCoreT.Test_ManagerWithKeyValueIntegerString;
const
  DummyValue = 'Hello world...';
var
  CutManager: ICacheManagerCoreT<Integer, string>;
  CutProvider: ICacheProviderCoreT<Integer, string>;
  Actual: string;
  Idx: Integer;
begin
  //  Arrange...
  Idx := 0;
  CutProvider := TCacheProviderCoreT<Integer, string>.Create;
  CutManager := TCacheManagerCoreT<Integer, string>.Create(3);
  CutManager.FillCacheProvider(
    procedure(Value: ICacheProviderCoreT<Integer, string>)
    begin
      Value.Add(Idx, Idx.ToString);
      Inc(Idx);
      if (Idx > 10) then
        Idx := 0;
    end);
  CutManager.AddCacheProvider(CutProvider);

  //  Assert + Act...
  CutProvider.Add(4711, DummyValue);
  Assert.AreEqual(1, CutProvider.Count);

  Actual := CutManager.Get(4711);
  Assert.AreEqual(DummyValue, Actual);

  Actual := CutManager.Get(4712);
  Assert.AreEqual('', Actual);
end;

procedure TTestCacheManagereCoreT.Test_CacheManagerUpper9LoopT;
var
  Idx: Integer;
  Actual: string;
  CutManager: ICacheManagerCoreT<Integer, string>;
  CutProvider: ICacheProviderCoreT<Integer, string>;
begin
  Idx := 0;
  CutProvider := TCacheProviderCoreT<Integer, string>.Create;
  CutManager := TCacheManagerCoreT<Integer, string>.Create(3);

  CutManager.FillCacheProvider(
    procedure(Value: ICacheProviderCoreT<Integer, string>)
    begin
      Value.Add(Idx, Idx.ToString);
      Inc(Idx);
      if (Idx > 10) then
        Idx := 0;
    end);
  CutManager.AddCacheProvider(CutProvider);

  Actual := CutManager.Get(9);
  Assert.AreEqual('9', Actual);

  Actual := CutManager.Get(4);
  Assert.AreEqual('4', Actual);

  Actual := CutManager.Get(2);
  Assert.AreEqual('2', Actual);

  Actual := CutManager.Get(12);
  Assert.AreEqual('', Actual);

  Actual := CutManager.Get(3);
  Assert.AreEqual('3', Actual);

  Actual := CutManager.Get(4711);
  Assert.AreEqual('', Actual);
end;

procedure TTestCacheManagereCoreT.Test_CacheManagerWithNoDataFiller;
var
  Actual: string;
  CutManager: ICacheManagerCoreT<Integer, string>;
  CutProvider: ICacheProviderCoreT<Integer, string>;
begin
  CutProvider := TCacheProviderCoreT<Integer, string>.Create;
  CutManager := TCacheManagerCoreT<Integer, string>.Create(3);

  CutManager.FillCacheProvider(
    procedure(Value: ICacheProviderCoreT<Integer, string>)
    begin
    end);
  CutManager.AddCacheProvider(CutProvider);

  Actual := CutManager.Get(9);
  Assert.AreEqual('', Actual);
end;

procedure TTestCacheManagereCoreT.Test_CacheManagerEndlessLoop;
var
  Idx: Integer;
  Actual: string;
  CutManager: ICacheManagerCoreT<Integer, string>;
  CutProvider: ICacheProviderCoreT<Integer, string>;
begin
  //  5 Elements in two-parts chunks...
  //  Arrange...
  Idx := 1;
  CutProvider := TCacheProviderCoreT<Integer, string>.Create;
  CutManager := TCacheManagerCoreT<Integer, string>.Create(2);

  CutManager.FillCacheProvider(
    procedure(Value: ICacheProviderCoreT<Integer, string>)
    begin
      Value.Add(Idx, Idx.ToString);
      Inc(Idx);
      if (Idx > 5) then
        Idx := 1;   //  Start from first element...
    end);
  CutManager.AddCacheProvider(CutProvider);

  //  Assert + Act...
  Actual := CutManager.Get(4);
  Assert.AreEqual('4', Actual);

  Actual := CutManager.Get(4711);
  Assert.AreEqual('', Actual);
end;

procedure TTestCacheManagereCoreT.Test_CacheManagerEndlessLoopWithHugerData;
var
  Idx: Integer;
  Actual: string;
  CutManager: ICacheManagerCoreT<Integer, string>;
  CutProvider: ICacheProviderCoreT<Integer, string>;
begin
  //  Arrange...
  Idx := 1;
  CutProvider := TCacheProviderCoreT<Integer, string>.Create;
  CutManager := TCacheManagerCoreT<Integer, string>.Create(10);
  CutManager.SetMax(50000000);

  CutManager.FillCacheProvider(
    procedure(Value: ICacheProviderCoreT<Integer, string>)
    begin
      Value.Add(Idx, Idx.ToString);
      Inc(Idx);

      if (Idx > 50000000) then
        Idx := 1;
    end);
  CutManager.AddCacheProvider(CutProvider);

  //  Assert + Act...
  Actual := CutManager.GetMax(4);
  Assert.AreEqual('4', Actual);

  Actual := CutManager.GetMax(22);
  Assert.AreEqual('22', Actual);

  Actual := CutManager.GetMax(2);
  Assert.AreEqual('2', Actual);

  Actual := CutManager.GetMax(4711);
  Assert.AreEqual('4711', Actual);

  Actual := CutManager.GetMax(50000010);
  Assert.AreEqual('', Actual);
end;

procedure TTestCacheManagereCoreT.Test_CacheManagerEndlessLoopWith5Elements;
var
  Idx: Integer;
  Actual: string;
  CutManager: ICacheManagerCoreT<Integer, string>;
  CutProvider: ICacheProviderCoreT<Integer, string>;
begin
  //  Arrange...
  Idx := 1;
  CutProvider := TCacheProviderCoreT<Integer, string>.Create;
  CutManager := TCacheManagerCoreT<Integer, string>.Create(2);
  CutManager.SetMax(5);

  CutManager.FillCacheProvider(
    procedure(Value: ICacheProviderCoreT<Integer, string>)
    begin
      Value.Add(Idx, Idx.ToString);
      Inc(Idx);
      if (Idx > 5) then
        Idx := 1;
    end);
  CutManager.AddCacheProvider(CutProvider);

  //  Assert + Act...
  Actual := CutManager.GetMax(4);
  Assert.AreEqual('4', Actual);

  Actual := CutManager.GetMax(2);
  Assert.AreEqual('2', Actual);

  Actual := CutManager.GetMax(15);
  Assert.AreEqual('', Actual);

  Actual := CutManager.GetMax(5);
  Assert.AreEqual('5', Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCacheManagereCoreT, 'ManagerTNextGen');

end.
