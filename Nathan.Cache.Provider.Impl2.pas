unit Nathan.Cache.Provider.Impl2;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  Nathan.Cache.Provider.Intf;

type
  /// <summary>
  ///   Implementation von INathanCacheProvider für TObjects. Es müssen Instanzen
  ///   vom Type TObject dem Cache übergeben werden und nur diese kommen zurück.
  /// </summary>
  TNathanCacheProvider2 = class(TInterfacedObject, INathanCacheProvider)
  strict private
    FMaxSize: Integer;
    FMap: TDictionary<Integer, TObject>;
  private
    class var FInstance: INathanCacheProvider;

    function GetCurrentNumberOfElements(): Integer;
    function GetSize(): Integer;
  protected
    procedure Evict(Id: Integer);
  public
    class function GetInstance(): INathanCacheProvider;

    constructor Create(MaxSize: Integer = 0);
    destructor Destroy(); override;

    function Contains(Id: Integer): Boolean;
    function Get(Id: Integer): TObject;

    procedure Put(Id: Integer; Item: TObject);
    procedure Remove(Id: Integer);
    procedure CleanCache();

    property MaxSize: Integer read GetSize;
    property CurrentNumberOfElements: Integer read GetCurrentNumberOfElements;
  end;

implementation

{ TNathanCacheProvider2 }

class function TNathanCacheProvider2.GetInstance(): INathanCacheProvider;
begin
  if (FInstance = nil) then
    FInstance := TNathanCacheProvider2.Create();

  Result := FInstance;
end;

constructor TNathanCacheProvider2.Create(MaxSize: Integer);
begin
  inherited Create();
  FMaxSize := MaxSize;
  FMap := TDictionary<Integer, TObject>.Create;
  //  FMRU := TCacheItemList.Create;
end;

destructor TNathanCacheProvider2.Destroy();
begin
  CleanCache();
  FMap.Free;

  inherited;
end;

function TNathanCacheProvider2.GetCurrentNumberOfElements(): Integer;
begin
  Result := FMap.Count;
end;

function TNathanCacheProvider2.GetSize(): Integer;
begin
  Result := FMaxSize;
end;

procedure TNathanCacheProvider2.CleanCache();
var
  Idx: Integer;
begin
  for Idx := FMap.Count - 1 downto 0 do
    Evict(FMap.Keys.ToArray[Idx]);

  FMap.Clear();
end;

function TNathanCacheProvider2.Contains(Id: Integer): Boolean;
begin
  Result := FMap.ContainsKey(Id);
end;

function TNathanCacheProvider2.Get(Id: Integer): TObject;
begin
  Assert(Contains(Id));
  Result := FMap[Id];
end;

procedure TNathanCacheProvider2.Put(Id: Integer; Item: TObject);
begin
  //  Keine Prüfung mehr nötig. Wir update immer...
  //  Assert(not Contains(Id));
  //  Vorhande löschen, führt zu memory leaks...
  if Contains(Id) then
    Remove(Id);

  if (FMaxSize > 0) and (GetCurrentNumberOfElements >= FMaxSize) then
  begin
    Assert(not Contains(Id));
    Evict(FMap.Keys.ToArray[FMap.Count - 1]);
  end;

  FMap.AddOrSetValue(Id, Item);
end;

procedure TNathanCacheProvider2.Remove(Id: Integer);
begin
  Assert(Contains(Id));
  Evict(Id);
end;

procedure TNathanCacheProvider2.Evict(Id: Integer);
begin
  FMap[Id].Free();
  FMap.Remove(Id);
end;

end.
