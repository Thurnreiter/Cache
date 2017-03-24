unit Cache.Provider.First.UnitTests;

interface

{$M+}

uses
  System.Classes,
  DUnitX.TestFramework,
  Nathan.Cache.Provider.Intf;

type
  IMyObject = interface
    ['{9551F190-DF83-4256-B067-3FB9A8C11CBE}']
  end;

  TMyObject = class(TInterfacedObject, IMyObject)
  private
    FValue: Integer;
  public
    class function CreateInstance(Value: Integer): TMyObject;

    property Value: Integer read FValue write FValue;
  end;


  [TestFixture]
  TUnitTestNathanCacheProvider = class
  strict private
    FCut: INathanCacheProvider;
  private
    procedure FiveElements();
  public
    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_BaseTests_TMyObject();

    [Test]
    [TestCase('TestcaseContainsElement0', '0,False')]
    [TestCase('TestcaseContainsElement1', '1,True')]
    [TestCase('TestcaseContainsElement2', '2,True')]
    [TestCase('TestcaseContainsElement3', '3,True')]
    [TestCase('TestcaseContainsElement4', '4,True')]
    [TestCase('TestcaseContainsElement5', '5,True')]
    [TestCase('TestcaseContainsElement99', '99,False')]
    procedure Test_Cache_Contains(HasElementId: Integer; ResBool: Boolean);

    [Test]
    procedure Test_Cache_CurrentNumberOfElements_WithClear();

    [Test]
    [TestCase('TestcaseDuration25', '10,25')]
    [TestCase('TestcaseDuration50', '2,50')]
    procedure Test_Duration_MaxSize(ValueMaxSize, ValueMaxDuration: Integer);
  end;

{$M-}

implementation

uses
  System.SysUtils,
  System.Diagnostics,
  Nathan.Cache.Provider.Impl1;

{ TMyObject }

class function TMyObject.CreateInstance(Value: Integer): TMyObject;
begin
  Result := TMyObject.Create();
  Result.Value := Value;
end;

procedure TUnitTestNathanCacheProvider.FiveElements();
begin
  FCut.Put(1, TMyObject.CreateInstance(11));
  FCut.Put(2, TMyObject.CreateInstance(22));
  FCut.Put(3, TMyObject.CreateInstance(33));
  FCut.Put(4, TMyObject.CreateInstance(44));
  FCut.Put(5, TMyObject.CreateInstance(55));
end;

procedure TUnitTestNathanCacheProvider.TearDown();
begin
  FCut := nil;
end;

procedure TUnitTestNathanCacheProvider.Test_BaseTests_TMyObject();
var
  CacheObj1: TMyObject;
  CacheObj4: TMyObject;
begin
  //  Arrange...
  FCut := TNathanCacheProvider.Create(2);
  FiveElements();

  //  Act...
  CacheObj1 := (FCut.Get(1) as TMyObject);
  CacheObj4 := (FCut.Get(4) as TMyObject);

  //  Assert...
  Assert.IsNotNull(CacheObj1);
  Assert.IsNotNull(CacheObj4);

  Assert.AreEqual(11, CacheObj1.Value);
  Assert.AreEqual(44, CacheObj4.Value);

  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
  Assert.AreEqual(6, FCut.MaxSize);
end;

procedure TUnitTestNathanCacheProvider.Test_Cache_Contains(HasElementId: Integer; ResBool: Boolean);
begin
  FCut := TNathanCacheProvider.Create(2);
  FiveElements();
  Assert.AreEqual(ResBool, FCut.Contains(HasElementId));
end;

procedure TUnitTestNathanCacheProvider.Test_Cache_CurrentNumberOfElements_WithClear();
begin
  FCut := TNathanCacheProvider.Create(2);
  FiveElements();

  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
  Assert.IsTrue(FCut.Contains(5));

  FCut.CleanCache();

  Assert.AreEqual(0, FCut.CurrentNumberOfElements);
  Assert.IsFalse(FCut.Contains(5));
end;

procedure TUnitTestNathanCacheProvider.Test_Duration_MaxSize(ValueMaxSize, ValueMaxDuration: Integer);
var
  MeasureWatch: TStopWatch;
begin
  MeasureWatch := TStopwatch.Create;
  MeasureWatch.Start;

  FCut := TNathanCacheProvider.Create(ValueMaxSize);
  FiveElements();

  MeasureWatch.Stop;

  Assert.IsTrue(
    (MeasureWatch.ElapsedTicks < ValueMaxDuration),
    Format('Cache with %d max. %d ElapsedTicks is to slow.', [ValueMaxSize, ValueMaxDuration]));
end;

initialization
  TDUnitX.RegisterTestFixture(TUnitTestNathanCacheProvider, 'Provider1');

end.
