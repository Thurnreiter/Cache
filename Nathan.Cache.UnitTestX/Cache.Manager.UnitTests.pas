unit Cache.Manager.UnitTests;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Delphi.Mocks,
  Cache.Provider.First.UnitTests,
  Nathan.Cache.Manager.Intf;

type
  [TestFixture]
  TUnitTestNathanCacheManager = class
  strict private
    FMockMyObject: TMyObject;
    FCut: INathanCacheManager;
  public
    [Setup]
    procedure Setup();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    [Ignore('Ignore this test')]
    [TestCase('GetOrAddCacheTrue', 'True')]
    [TestCase('GetOrAddCacheTrue', 'False')]
    procedure Test_Manager_GetOrAddCache(ContainsValue: Boolean);
  end;

{$M-}

implementation

uses
  System.SysUtils,
  Nathan.Cache.Provider.Intf,
  Nathan.Cache.Manager.Impl;

procedure TUnitTestNathanCacheManager.Setup();
begin
  FMockMyObject := TMyObject.CreateInstance(11);
end;

procedure TUnitTestNathanCacheManager.TearDown();
begin
  FMockMyObject.Free;
  FCut := nil;
end;

procedure TUnitTestNathanCacheManager.Test_Manager_GetOrAddCache(ContainsValue: Boolean);
var
  MockCacheProvider: TMock<INathanCacheProvider>;
  Actual: TObject;
begin
  //  Arrange...
  MockCacheProvider := TMock<INathanCacheProvider>.Create();

  MockCacheProvider.Setup.WillReturn(ContainsValue).When.Contains(1);
  if ContainsValue then
    MockCacheProvider.Setup.WillReturn(FMockMyObject).When.Get(1)
  else
    MockCacheProvider.Setup.Expect.AtLeastOnce.When.Put(1, FMockMyObject);

  FCut := TNathanCacheManager.Create();

  //  Act...
  FCut.AddCacheProvider(MockCacheProvider);
  Actual := FCut.GetOrAddCache(1,
    function: TObject
    begin
      Result := FMockMyObject;
    end);

  //  Assert...
  Assert.IsNotNull(FCut);
  if ContainsValue then
    Assert.IsNotNull(Actual)
  else
    Assert.IsNull(Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TUnitTestNathanCacheManager, 'Manager');

end.
