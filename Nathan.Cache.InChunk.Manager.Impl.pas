unit Nathan.Cache.InChunk.Manager.Impl;

interface

uses
  System.SysUtils,
  System.Generics.Defaults,
  Nathan.Cache.InChunk.Manager.Intf,
  Nathan.Cache.InChunk.Provider.Intf;

{$M+}

type
  TCacheManagerCoreT<K, V> = class(TInterfacedObject, ICacheManagerCoreT<K, V>)
  private
    type
      TFirstKeyStorage = record
      strict private
        FKey: K;
        FIsFirst: Boolean;
        FEndlessLoop: Boolean;
      public
        property Key: K read FKey write FKey;
        property IsFirst: Boolean read FIsFirst write FIsFirst;
        property EndlessLoop: Boolean read FEndlessLoop write FEndlessLoop;
      end;
  strict private
    FComparerV: IEqualityComparer<V>;
    FComparerK: IEqualityComparer<K>;
    FCapacity: Integer;
    FCacheProviderCoreT: ICacheProviderCoreT<K, V>;
    FFillCacheProvider: TProc<ICacheProviderCoreT<K, V>>;
    FFirstKeyStorage: TFirstKeyStorage;
    FCounter: Integer;
    FMaxCapacity: Integer;
  private
    function InnerGet(AKey: K): V;
    function InnerGetMax(AKey: K): V;
  public
    constructor Create(ACapacity: Integer = 10);

    procedure SetMax(AValue: Integer);
    procedure AddCacheProvider(ACacheProviderCore: ICacheProviderCoreT<K, V>);
    procedure FillCacheProvider(Value: TProc<ICacheProviderCoreT<K, V>>);

    function Get(AKey: K): V;
    function GetMax(AKey: K): V;
  end;

{$M-}

implementation

uses
  System.Math;

{ TCacheManagerCoreT<K, V> }

constructor TCacheManagerCoreT<K, V>.Create(ACapacity: Integer);
begin
  inherited Create;
  FCapacity := ACapacity;
  FMaxCapacity := 0;
  FCounter := 0;
  FComparerV := TEqualityComparer<V>.Default;
  FComparerK := TEqualityComparer<K>.Default;
end;

procedure TCacheManagerCoreT<K, V>.SetMax(AValue: Integer);
begin
  FMaxCapacity := AValue;
end;

procedure TCacheManagerCoreT<K, V>.FillCacheProvider(Value: TProc<ICacheProviderCoreT<K, V>>);
begin
  FFillCacheProvider := Value;
end;

procedure TCacheManagerCoreT<K, V>.AddCacheProvider(ACacheProviderCore: ICacheProviderCoreT<K, V>);
begin
  FCacheProviderCoreT := ACacheProviderCore;
  if (not Assigned(FFillCacheProvider)) then
    raise ENotImplemented.Create('First has to implement FillCacheProvider()');

  FCacheProviderCoreT.OnFirstKey(
    procedure(AKey: K)
    begin
      FFirstKeyStorage.EndlessLoop := (FFirstKeyStorage.IsFirst)
        and FComparerK.Equals(FFirstKeyStorage.Key, AKey);

      if (not FFirstKeyStorage.IsFirst) then
      begin
        FFirstKeyStorage.IsFirst := True;
        FFirstKeyStorage.Key := AKey;
      end;
    end);
end;

function TCacheManagerCoreT<K, V>.Get(AKey: K): V;
begin
  FFirstKeyStorage := Default(TFirstKeyStorage);
  Result := InnerGet(AKey);
end;

function TCacheManagerCoreT<K, V>.InnerGet(AKey: K): V;
begin
  Result := FCacheProviderCoreT.Get(AKey);
  if FComparerV.Equals(Result, Default(V)) then
  begin
    //  Chunk filling...
    while (FCacheProviderCoreT.Count = 0)
    or (not ((FCacheProviderCoreT.Count mod FCapacity) = 0)) do
    begin
      FFillCacheProvider(FCacheProviderCoreT);
      if (FCacheProviderCoreT.Count = 0) or FFirstKeyStorage.EndlessLoop then
      begin
        Result := FCacheProviderCoreT.Get(AKey);
        if FComparerV.Equals(Result, Default(V)) then
          Exit(Default(V));
      end;
    end;

    Result := FCacheProviderCoreT.Get(AKey);
    if FComparerV.Equals(Result, Default(V)) then
    begin
      FCacheProviderCoreT.Clear;
      Result := InnerGet(AKey);
    end;
  end;
end;

function TCacheManagerCoreT<K, V>.GetMax(AKey: K): V;
begin
  FCacheProviderCoreT.OnFirstKey(nil);
  Result := InnerGetMax(AKey);
end;

function TCacheManagerCoreT<K, V>.InnerGetMax(AKey: K): V;
var
  CurrentStartPos: Integer;
  FillIt: TProc;
begin
  FillIt :=
    procedure
    begin
      FFillCacheProvider(FCacheProviderCoreT);
      Inc(FCounter);
    end;

  CurrentStartPos := Min(FCounter, FMaxCapacity);
  while (FCounter <> FMaxCapacity) do
  begin
    FillIt;
    while (FCacheProviderCoreT.Count < FCapacity) do
      FillIt;

    Result := FCacheProviderCoreT.Get(AKey);
    if FComparerV.Equals(Result, Default(V)) then
      FCacheProviderCoreT.Clear
    else
      Exit(Result);

    if (FCounter = CurrentStartPos) then
      Break;

    if (FCounter >= FMaxCapacity) then
      FCounter := 0;
  end;

  Exit(Default(V));
end;

end.
