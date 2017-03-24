unit Nathan.Cache.Provider.T.Impl;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  Nathan.Cache.Manager.Intf,
  Nathan.Cache.Provider.Intf;

type
  /// <summary>
  ///   Implementation von INathanCacheProvider für generische Daten.
  /// </summary>
  TNathanCacheProviderT<T> = class(TInterfacedObject, INathanCacheProvider<T>)
  strict private
    FMaxSize: Integer;
    FMap: TDictionary<Integer, T>;
  private
    function GetCurrentNumberOfElements(): Integer;
    function GetSize(): Integer;
  protected
    procedure Evict(Id: Integer);
  public
    constructor Create(MaxSize: Integer = 0);
    destructor Destroy(); override;

    function Contains(Id: Integer): Boolean;
    function Get(Id: Integer): T;

    procedure Put(Id: Integer; Item: T);
    procedure Remove(Id: Integer);
    procedure CleanCache();

    property MaxSize: Integer read GetSize;
    property CurrentNumberOfElements: Integer read GetCurrentNumberOfElements;
  end;

implementation

{ TNathanCacheProviderT<T> }

constructor TNathanCacheProviderT<T>.Create(MaxSize: Integer = 0);
begin
  inherited Create();
  FMaxSize := MaxSize;
  FMap := TDictionary<Integer, T>.Create;
end;

destructor TNathanCacheProviderT<T>.Destroy();
begin
  CleanCache();
  FMap.Free;
  inherited;
end;

function TNathanCacheProviderT<T>.GetCurrentNumberOfElements(): Integer;
begin
  Result := FMap.Count;
end;

function TNathanCacheProviderT<T>.GetSize(): Integer;
begin
  Result := FMaxSize
end;

function TNathanCacheProviderT<T>.Get(Id: Integer): T;
begin
  Assert(Contains(Id));
  Result := FMap[Id];
end;

procedure TNathanCacheProviderT<T>.Put(Id: Integer; Item: T);
begin
  if Contains(Id) then
    Remove(Id);

  if (FMaxSize > 0) and (GetCurrentNumberOfElements >= FMaxSize) then
  begin
    Assert(not Contains(Id));
    Evict(FMap.Keys.ToArray[FMap.Count - 1]);
  end;

  FMap.AddOrSetValue(Id, Item);
end;

procedure TNathanCacheProviderT<T>.CleanCache();
var
  Idx: Integer;
begin
  for Idx := FMap.Count - 1 downto 0 do
    Evict(FMap.Keys.ToArray[Idx]);

  FMap.Clear();
end;

procedure TNathanCacheProviderT<T>.Remove(Id: Integer);
begin
  Assert(Contains(Id));
  Evict(Id);
end;

function TNathanCacheProviderT<T>.Contains(Id: Integer): Boolean;
begin
  Result := FMap.ContainsKey(Id);
end;

procedure TNathanCacheProviderT<T>.Evict(Id: Integer);
begin
  FMap.Remove(Id);
end;

end.
