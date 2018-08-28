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
//  private
//    procedure OnValueNotify(Sender: TObject; const Item: V; Action: TCollectionNotification);
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

uses
  System.Rtti,
  System.TypInfo;

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
begin
//  FDic.OnValueNotify := OnValueNotify;
  FDic.Clear;
//  FDic.OnValueNotify := nil;
end;

//procedure TCacheProviderCoreT<K, V>.OnValueNotify(Sender: TObject; const Item: V; Action: TCollectionNotification);
//var
//  Info: PTypeInfo;
//begin
//  Action: TCollectionNotification = cnRemoved
//  if PTypeInfo(TypeInfo(V))^.Kind  <> tkClass then
//    raise Exception.Create('V are unsupported type.');

//  Info := System.TypeInfo(V);
//  if (Info.Kind = tkClass) then
//    TObject(Item).Free;
//end;

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
