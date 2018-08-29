unit Cache.Provider.Second.UnitTests;

interface

{$M+}

uses
  System.Classes,
  DUnitX.TestFramework,
  Cache.Provider.First.UnitTests,
  Nathan.Cache.Provider.Intf;

type
  [TestFixture]
  TUnitTestNathanCacheProvider2 = class
  strict private
    FCut: INathanCacheProvider;
  private
    procedure FiveElements();
  public
    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_Size();

    [Test]
    procedure Test_Remove();

    [Test]
    procedure Test_Remove_Put();

    [Test]
    procedure Test_Put_Get();

    [Test]
    [TestCase('TestcaseContainsElement0', '0,False')]
    [TestCase('TestcaseContainsElement1', '1,True')]
    [TestCase('TestcaseContainsElement2', '2,True')]
    [TestCase('TestcaseContainsElement3', '3,True')]
    [TestCase('TestcaseContainsElement4', '4,True')]
    [TestCase('TestcaseContainsElement5', '5,True')]
    [TestCase('TestcaseContainsElement99', '99,False')]
    procedure Test_ClearCache_Contains(HasElementId: Integer; ResBool: Boolean);

    [Test]
    procedure Test_MaxSize();

    [Test]
    procedure Test_MaxSize_With0();

    [Test]
    [TestCase('TestcaseDuration25', '10,125')]
    [TestCase('TestcaseDuration50', '2,50')]
    procedure Test_Duration_MaxSize(ValueMaxSize, ValueMaxDuration: Integer);

    [Test]
    procedure Test_Put_Get_Contains_SeveralTimes();
  end;

{$M-}

implementation

uses
  System.SysUtils,
  System.Diagnostics,
  Nathan.Cache.Provider.Impl2;

procedure TUnitTestNathanCacheProvider2.FiveElements();
begin
  FCut.Put(1, TMyObject.CreateInstance(111));
  FCut.Put(2, TMyObject.CreateInstance(222));
  FCut.Put(3, TMyObject.CreateInstance(333));
  FCut.Put(4, TMyObject.CreateInstance(444));
  FCut.Put(5, TMyObject.CreateInstance(555));
end;

procedure TUnitTestNathanCacheProvider2.TearDown();
begin
  FCut := nil;
end;

procedure TUnitTestNathanCacheProvider2.Test_Size();
begin
  //  Arrange...
  FCut := TNathanCacheProvider2.Create(5);

  //  Act...
  FiveElements();

  //  Assert...
  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
  Assert.AreEqual(5, FCut.MaxSize);
end;

procedure TUnitTestNathanCacheProvider2.Test_Remove();
begin
  FCut := TNathanCacheProvider2.Create(5);
  FiveElements();
  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
  FCut.Remove(2);
  Assert.AreEqual(4, FCut.CurrentNumberOfElements);
end;

procedure TUnitTestNathanCacheProvider2.Test_Remove_Put();
begin
  FCut := TNathanCacheProvider2.Create(5);
  FiveElements();
  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
  FCut.Remove(2);
  Assert.AreEqual(4, FCut.CurrentNumberOfElements);
  FCut.Put(6, TMyObject.CreateInstance(666));
  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
end;

procedure TUnitTestNathanCacheProvider2.Test_Put_Get();
begin
  FCut := TNathanCacheProvider2.Create(6);
  FiveElements();
  FCut.Put(6, TMyObject.CreateInstance(666));
  Assert.AreEqual(555, (FCut.Get(5) as TMyObject).Value);
  Assert.AreEqual(666, (FCut.Get(6) as TMyObject).Value);
end;

procedure TUnitTestNathanCacheProvider2.Test_ClearCache_Contains(HasElementId: Integer; ResBool: Boolean);
begin
  FCut := TNathanCacheProvider2.Create(5);
  FiveElements();

  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
  Assert.AreEqual(5, FCut.MaxSize);
  Assert.IsTrue(FCut.Contains(5));

  FCut.CleanCache();

  Assert.AreEqual(0, FCut.CurrentNumberOfElements);
  Assert.AreEqual(5, FCut.MaxSize);
  Assert.IsFalse(FCut.Contains(5));
end;

procedure TUnitTestNathanCacheProvider2.Test_MaxSize();
begin
  FCut := TNathanCacheProvider2.Create(2);
  FiveElements();

  Assert.AreEqual(2, FCut.MaxSize);
  Assert.AreEqual(2, FCut.CurrentNumberOfElements);

  //  MaxSize = 2, damit wird beim Einfügen von Element 3 "Put(3, TMyObject.CreateInstance(333));"
  //  das letzte Element, hier 2 gelöscht und 3 als letztes hinzugefügt. Das gannze passiert so
  //  oft, bis nur noch Element 1 und 5 im Cache verbleiben. Wir haben ja von anfang an gesagt,
  //  MaxSize also die maximale Anzahl vorgehaltener Element ist 2.
  Assert.IsTrue(FCut.Contains(1));
  Assert.IsFalse(FCut.Contains(2));
  Assert.IsFalse(FCut.Contains(3));
  Assert.IsFalse(FCut.Contains(4));
  Assert.IsTrue(FCut.Contains(5));

  Assert.AreEqual(111, (FCut.Get(1) as TMyObject).Value);
  Assert.AreEqual(555, (FCut.Get(5) as TMyObject).Value);
end;

procedure TUnitTestNathanCacheProvider2.Test_MaxSize_With0;
begin
  FCut := TNathanCacheProvider2.Create();
  FiveElements();

  Assert.AreEqual(0, FCut.MaxSize);
  Assert.AreEqual(5, FCut.CurrentNumberOfElements);

  Assert.IsTrue(FCut.Contains(1));
  Assert.IsTrue(FCut.Contains(2));
  Assert.IsTrue(FCut.Contains(3));
  Assert.IsTrue(FCut.Contains(4));
  Assert.IsTrue(FCut.Contains(5));
end;

procedure TUnitTestNathanCacheProvider2.Test_Duration_MaxSize(ValueMaxSize, ValueMaxDuration: Integer);
var
  MeasureWatch: TStopWatch;
begin
  MeasureWatch := TStopwatch.Create;
  MeasureWatch.Start;

  FCut := TNathanCacheProvider2.Create(ValueMaxSize);
  FiveElements();

  MeasureWatch.Stop;

  Assert.IsTrue(
    (MeasureWatch.ElapsedTicks <= ValueMaxDuration),
    Format('Cache with %d max. need %d ElapsedTicks by %d, is to slow.',
      [ValueMaxSize, MeasureWatch.ElapsedTicks, ValueMaxDuration]));
end;

procedure TUnitTestNathanCacheProvider2.Test_Put_Get_Contains_SeveralTimes();
begin
  FCut := TNathanCacheProvider2.Create();
  FiveElements();

  FCut.Put(3, TMyObject.CreateInstance(3333));

  Assert.AreEqual(5, FCut.CurrentNumberOfElements);

  Assert.IsTrue(FCut.Contains(1));
  Assert.IsTrue(FCut.Contains(2));
  Assert.IsTrue(FCut.Contains(3));
  Assert.IsTrue(FCut.Contains(4));
  Assert.IsTrue(FCut.Contains(5));

  Assert.AreEqual(111, (FCut.Get(1) as TMyObject).Value);
  Assert.AreEqual(222, (FCut.Get(2) as TMyObject).Value);
  Assert.AreEqual(3333, (FCut.Get(3) as TMyObject).Value);
  Assert.AreEqual(444, (FCut.Get(4) as TMyObject).Value);
  Assert.AreEqual(555, (FCut.Get(5) as TMyObject).Value);
end;

initialization
  TDUnitX.RegisterTestFixture(TUnitTestNathanCacheProvider2, 'Provider2');

end.
