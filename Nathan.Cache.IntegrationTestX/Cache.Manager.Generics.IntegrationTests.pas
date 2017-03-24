unit Cache.Manager.Generics.IntegrationTests;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Nathan.Cache.Manager.Intf;

type
  [TestFixture]
  TTestNathanCacheManagerGenerics = class
  strict private
    FCut: INathanCacheManager<string>;
  public
    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_Manager_GetOrAddCache();

    [Test]
    procedure Test_Manager_GetOrAddCache_Callback();
  end;

{$M-}

implementation

uses
  System.Classes,
  System.SysUtils,
  Nathan.Cache.Provider.Intf,
  Nathan.Cache.Provider.T.Impl,
  Nathan.Cache.Manager.T.Impl;

procedure TTestNathanCacheManagerGenerics.TearDown();
begin
  FCut := nil;
end;

procedure TTestNathanCacheManagerGenerics.Test_Manager_GetOrAddCache();
var
  StringCacheProvider: INathanCacheProvider<string>;
  Actual: string;
begin
  StringCacheProvider := TNathanCacheProviderT<string>.Create();
  FCut := TNathanCacheManager<string>.Create();

  FCut.AddCacheProvider(StringCacheProvider);
  Actual := FCut.GetOrAddCache(1,
    function: string
    begin
      Result := 'MyText'; //  Add to Cache...
    end);

  Assert.AreEqual('', Actual);
  Actual := FCut.GetOrAddCache(1,
    function: string
    begin
      Result := 'MyText'; //  Comes from Cache...
    end);

  Assert.AreEqual('MyText', Actual);
end;

procedure TTestNathanCacheManagerGenerics.Test_Manager_GetOrAddCache_Callback();
var
  StringCacheProvider: INathanCacheProvider<string>;
  Actual: string;
  ActualCallback: string;
begin
  StringCacheProvider := TNathanCacheProviderT<string>.Create();
  FCut := TNathanCacheManager<string>.Create();

  FCut.AddCacheProvider(StringCacheProvider);
  Actual := FCut.GetOrAddCache(1,
    function: string
    begin
      Result := 'MyText'; //  Add to Cache...
    end,
    procedure(MyId: Integer; MyNalue: string)
    begin
      ActualCallback := MyNalue;
    end);

  Assert.AreEqual('', Actual);
  Assert.AreEqual('MyText', ActualCallback);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestNathanCacheManagerGenerics, 'Manager3');

end.
