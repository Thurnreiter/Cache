unit Cache.Provider.Thrid.UnitTests;

interface

{$M+}

uses
  System.Classes,
  DUnitX.TestFramework,
  Cache.Provider.First.UnitTests,
  Nathan.Cache.Provider.Intf,
  Nathan.Cache.Provider.T.Impl;

type
  [TestFixture]
  TUnitTestNathanCacheProviderTString = class
  strict private
    FCut: TNathanCacheProviderT<string>;
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
    procedure Test_Put_Get_Contains_SeveralTimes();

    [Test]
    [TestCase('TestcaseDuration25', '10,50')]
    [TestCase('TestcaseDuration50', '2,150')]
    procedure Test_Duration_MaxSize(ValueMaxSize, ValueMaxDuration: Integer);
  end;

{$M-}

implementation

uses
  System.SysUtils,
  System.Diagnostics;

procedure TUnitTestNathanCacheProviderTString.TearDown();
begin
  FCut.Free;
end;

procedure TUnitTestNathanCacheProviderTString.Test_Size;
begin
  //  Arrange...
  FCut := TNathanCacheProviderT<string>.Create(5);

  //  Act...
  FCut.Put(1, '11');
  FCut.Put(2, '22');
  FCut.Put(3, '33');
  FCut.Put(4, '44');
  FCut.Put(5, '55');

  //  Assert...
  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
  Assert.AreEqual(5, FCut.MaxSize);
end;

procedure TUnitTestNathanCacheProviderTString.Test_Remove();
begin
  FCut := TNathanCacheProviderT<string>.Create(5);

  FCut.Put(1, '11');
  FCut.Put(2, '22');
  FCut.Put(3, '33');

  Assert.AreEqual(3, FCut.CurrentNumberOfElements);

  FCut.Remove(2);

  Assert.AreEqual(2, FCut.CurrentNumberOfElements);
end;

procedure TUnitTestNathanCacheProviderTString.Test_Remove_Put;
begin
  FCut := TNathanCacheProviderT<string>.Create(5);
  FCut.Put(1, '11');
  FCut.Put(2, '22');
  FCut.Put(3, '33');
  FCut.Put(4, '44');
  FCut.Put(5, '55');

  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
  FCut.Remove(2);

  Assert.AreEqual(4, FCut.CurrentNumberOfElements);
  FCut.Put(6, '666');

  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
end;

procedure TUnitTestNathanCacheProviderTString.Test_Put_Get();
begin
  FCut := TNathanCacheProviderT<string>.Create(6);

  FCut.Put(1, '11');
  FCut.Put(2, '22');
  FCut.Put(3, '33');
  FCut.Put(4, '44');
  FCut.Put(5, '55');

  FCut.Put(6, '666');

  Assert.AreEqual('55', FCut.Get(5));
  Assert.AreEqual('666', FCut.Get(6));
end;

procedure TUnitTestNathanCacheProviderTString.Test_ClearCache_Contains(HasElementId: Integer; ResBool: Boolean);
begin
  FCut := TNathanCacheProviderT<string>.Create(5);

  FCut.Put(1, '11');
  FCut.Put(2, '22');
  FCut.Put(3, '33');
  FCut.Put(4, '44');
  FCut.Put(5, '55');

  Assert.AreEqual(5, FCut.CurrentNumberOfElements);
  Assert.AreEqual(5, FCut.MaxSize);
  Assert.IsTrue(FCut.Contains(5));

  FCut.CleanCache();

  Assert.AreEqual(0, FCut.CurrentNumberOfElements);
  Assert.AreEqual(5, FCut.MaxSize);
  Assert.IsFalse(FCut.Contains(5));
end;

procedure TUnitTestNathanCacheProviderTString.Test_MaxSize;
begin
  FCut := TNathanCacheProviderT<string>.Create(2);

  FCut.Put(1, '11');
  FCut.Put(2, '22');
  FCut.Put(3, '33');
  FCut.Put(4, '44');
  FCut.Put(5, '55');

  Assert.AreEqual(2, FCut.MaxSize);
  Assert.AreEqual(2, FCut.CurrentNumberOfElements);

  Assert.IsTrue(FCut.Contains(1));
  Assert.IsFalse(FCut.Contains(2));
  Assert.IsFalse(FCut.Contains(3));
  Assert.IsFalse(FCut.Contains(4));
  Assert.IsTrue(FCut.Contains(5));

  Assert.AreEqual('11', FCut.Get(1));
  Assert.AreEqual('55', FCut.Get(5));
end;

procedure TUnitTestNathanCacheProviderTString.Test_MaxSize_With0;
begin
  FCut := TNathanCacheProviderT<string>.Create();

  FCut.Put(1, '11');
  FCut.Put(2, '22');
  FCut.Put(3, '33');
  FCut.Put(4, '44');
  FCut.Put(5, '55');

  Assert.AreEqual(0, FCut.MaxSize);
  Assert.AreEqual(5, FCut.CurrentNumberOfElements);

  Assert.IsTrue(FCut.Contains(1));
  Assert.IsTrue(FCut.Contains(2));
  Assert.IsTrue(FCut.Contains(3));
  Assert.IsTrue(FCut.Contains(4));
  Assert.IsTrue(FCut.Contains(5));
end;

procedure TUnitTestNathanCacheProviderTString.Test_Put_Get_Contains_SeveralTimes;
begin
  FCut := TNathanCacheProviderT<string>.Create();

  FCut.Put(1, '11');
  FCut.Put(2, '22');
  FCut.Put(3, '33');
  FCut.Put(4, '44');
  FCut.Put(5, '55');

  FCut.Put(3, '3333');

  Assert.AreEqual(5, FCut.CurrentNumberOfElements);

  Assert.IsTrue(FCut.Contains(1));
  Assert.IsTrue(FCut.Contains(2));
  Assert.IsTrue(FCut.Contains(3));
  Assert.IsTrue(FCut.Contains(4));
  Assert.IsTrue(FCut.Contains(5));

  Assert.AreEqual('11', FCut.Get(1));
  Assert.AreEqual('22', FCut.Get(2));
  Assert.AreEqual('3333', FCut.Get(3));
  Assert.AreEqual('44', FCut.Get(4));
  Assert.AreEqual('55', FCut.Get(5));
end;

procedure TUnitTestNathanCacheProviderTString.Test_Duration_MaxSize(ValueMaxSize, ValueMaxDuration: Integer);
var
  MeasureWatch: TStopWatch;
begin
  MeasureWatch := TStopwatch.Create;
  MeasureWatch.Start;

  FCut := TNathanCacheProviderT<string>.Create(ValueMaxSize);
  FCut.Put(1, '11');
  FCut.Put(2, '22');
  FCut.Put(3, '33');
  FCut.Put(4, '44');
  FCut.Put(5, '55');

  MeasureWatch.Stop;

  Assert.IsTrue(
    (MeasureWatch.ElapsedTicks <= ValueMaxDuration),
    Format('Cache with %d max. need %d ElapsedTicks by %d, is to slow.',
      [ValueMaxSize, MeasureWatch.ElapsedTicks, ValueMaxDuration]));
end;

initialization
  TDUnitX.RegisterTestFixture(TUnitTestNathanCacheProviderTString, 'ProviderT');

end.
