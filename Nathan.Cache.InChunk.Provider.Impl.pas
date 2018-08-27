unit Nathan.Cache.InChunk.Provider.Impl;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Nathan.Cache.InChunk.Provider.Intf;

{$M+}

type
  TCacheProviderCoreT<K, V> = class(TInterfacedObject, ICacheProviderCoreT<K, V>)
  strict private
    FDic: TDictionary<K,V>;
    FOnFirstKey: TProc<K>;
  public
    constructor Create();
    destructor Destroy(); override;

    function Count(): Integer;
    function Get(AKey: K): V;
    procedure Add(AKey: K; AValue: V);
    procedure Clear;

    procedure OnFirstKey(Value: TProc<K>);
  end;

{$M-}

implementation

{ TCacheProviderCoreT<K, V> }

constructor TCacheProviderCoreT<K, V>.Create;
begin
  inherited Create;
  FDic := TDictionary<K,V>.Create;
end;

destructor TCacheProviderCoreT<K, V>.Destroy;
begin
  FDic.Clear;
  FDic.Free;
  inherited;
end;

procedure TCacheProviderCoreT<K, V>.Add(AKey: K; AValue: V);
begin
  FDic.AddOrSetValue(AKey, AValue);
  if (FDic.Count = 1) and Assigned(FOnFirstKey) then
    FOnFirstKey(AKey);
end;

procedure TCacheProviderCoreT<K, V>.Clear;
var
  Idx: Integer;
begin
  for Idx := FDic.Count - 1 downto 0 do
    FDic.Remove(FDic.Keys.ToArray[Idx]);

  FDic.Clear;
end;

function TCacheProviderCoreT<K, V>.Count: Integer;
begin
  Result := FDic.Count;
end;

function TCacheProviderCoreT<K, V>.Get(AKey: K): V;
begin
  if FDic.ContainsKey(AKey) then
    Result := FDic[AKey]
  else
    Result := Default(V);
end;

procedure TCacheProviderCoreT<K, V>.OnFirstKey(Value: TProc<K>);
begin
  FOnFirstKey := Value;
end;

end.
