unit Cache.Manager.IntegrationTests;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Nathan.Cache.Manager.Intf;

type
  [TestFixture]
  TTestNathanCacheManager = class
  strict private
    FCut: INathanCacheManager;
  public
    [TearDown]
    procedure TearDown();
  published
    [Test]
    [Ignore('Ignore this test')]
    procedure Test_Manager_GetOrAddCache();

    [Test]
    procedure Test_Manager_ClearCacheEx();

    [Test]
    procedure Test_Manager_Singleton();
  end;

{$M-}

implementation

uses
  System.Classes,
  System.SysUtils,
  Nathan.Cache.Provider.Intf,
  Nathan.Cache.Provider.Impl2,
  Nathan.Cache.Manager.Impl;

procedure TTestNathanCacheManager.TearDown();
begin
  FCut := nil;
end;

procedure TTestNathanCacheManager.Test_Manager_GetOrAddCache();
var
  DummyCacheProvider: INathanCacheProvider;
  DummyObject: TObject;
  Actual: TObject;
begin
  //  Arrange...
  DummyCacheProvider := TNathanCacheProvider2.Create();
  DummyObject := TObject.Create;

  FCut := TNathanCacheManager.Create();

  //  Act...
  FCut.AddCacheProvider(DummyCacheProvider);
  Actual := FCut.GetOrAddCache(1,
    function: TObject
    begin
      Result := DummyObject;
    end);

  while (CheckSynchronize(1000)) do
    ;

  Assert.IsNull(Actual);
  Actual := FCut.GetOrAddCache(1,
    function: TObject
    begin
      Result := DummyObject;
    end);

  while (CheckSynchronize(1000)) do
    ;

  //  Assert...
  Assert.IsNotNull(Actual);
  Assert.AreEqual(DummyObject, Actual);
end;

procedure TTestNathanCacheManager.Test_Manager_ClearCacheEx();
begin
  //  Arrange...
  FCut := TNathanCacheManager.Create();

  //  Assert...
  Assert.WillRaise(
    procedure
    begin
      FCut.ClearCache();
    end, EArgumentNilException);
end;

procedure TTestNathanCacheManager.Test_Manager_Singleton;
var
  RaiseMethod: TTestLocalMethod;
begin
  RaiseMethod :=
    procedure
    begin
      FCut.ClearCache();
    end;

  FCut := TNathanCacheManager.GetInstance();

  Assert.IsNotNull(FCut);
  Assert.WillRaise(RaiseMethod, EArgumentNilException);
  Assert.IsNotNull(FCut);
  Assert.WillRaise(RaiseMethod, EArgumentNilException);
  Assert.IsNotNull(FCut);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestNathanCacheManager, 'Manager2');

end.
