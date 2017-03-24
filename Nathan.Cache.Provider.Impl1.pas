unit Nathan.Cache.Provider.Impl1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Contnrs,
  System.Generics.Collections,
  Nathan.Cache.Provider.Intf;

type
  TNathanCacheProvider = class(TInterfacedObject, INathanCacheProvider)
  strict private
    FMaxSize: Integer;
    FCacheDict: TDictionary<Integer, TObject>;
    FCacheIDs: TList<Integer>;

    FObjectList: System.Contnrs.TObjectList;
  private
    function GetCurrentNumberOfElements(): Integer;
    function GetSize(): Integer;
  public
    constructor Create(MaxSize: Integer);
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


{ TNathanCacheProvider }

constructor TNathanCacheProvider.Create(MaxSize: Integer);
begin
  inherited Create;

  //  1.Version...
  FObjectList := System.Contnrs.TObjectList.Create(True);
  FObjectList.Capacity := MaxSize;

  //  2.Version...
  FMaxSize := MaxSize;
  FCacheDict := TDictionary<Integer, TObject>.Create;
  FCacheIDs := TList<Integer>.Create;
end;

destructor TNathanCacheProvider.Destroy();
begin
  //  1.Version...
  FObjectList.Free;

  //  2.Version...
  FreeAndNil(FCacheDict);
  FreeAndNil(FCacheIDs);

  inherited;
end;

procedure TNathanCacheProvider.CleanCache();
//var
//  Idx: Integer;
begin
  //  1.Version...
  FObjectList.Clear;

  //  2.Version...
  //  for Idx := FCacheIDs.Count-1 downto FMaxSize do
  //  begin
  //    FCacheDict.Remove(FCacheIDs[Idx]);
  //    FCacheIDs.Delete(Idx);
  //  end;
end;

function TNathanCacheProvider.Contains(Id: Integer): Boolean;
begin
  //  1.Version...
  Result := Get(Id) <> nil;

  //  2.Version...
  //  Result := FCacheDict.ContainsKey(ID);
end;

function TNathanCacheProvider.Get(ID: Integer): TObject;
begin
  //  1.Version...
  //  Result := nil;
  //  if InRange(ID, 0, FObjectList.Count - 1) then
  //  begin
  //    Result := FObjectList.Items[ID];
  //  end;

  if (Id <= 0) or (Id > FObjectList.Count) then
    Result := nil
  else
    Result := FObjectList.Items[Id - 1];

  //  2.Version...
  //  if Contains(ID) then
  //  begin
  //    Result := FCacheDict[ID];
  //    Renew(ID);
  //  end
  //  else
  //    raise EListError.CreateFmt('Das Element mit der ID %d ist nicht im Cache enthalten!', [ID]);
end;

function TNathanCacheProvider.GetCurrentNumberOfElements(): Integer;
begin
  //  1.Version...
  Result := FObjectList.Count;

  //  2.Version...
  //  Result := FCacheDict.Count;
end;

function TNathanCacheProvider.GetSize(): Integer;
begin
  //  1.Version...
  Result := FObjectList.Capacity;

  //  2.Version...
  //  Result := FMaxSize;
end;

procedure TNathanCacheProvider.Put(Id: Integer; Item: TObject);
begin
  //  1.Version...
  if (Id <> -1) then
    FObjectList.Add(Item)
  else
    FObjectList.Insert(Id, Item);

  //  2.Version...
  //  if not Contains(Id) then
  //  begin
  //    FCacheIDs.Insert(0, Id);
  //    FCacheDict.Add(Id, Item);
  //    CleanCache();
  //  end
  //  else
  //    Renew(Id); // Evtl eher ne Exception? Ist Geschmackssache denke ich.
end;

procedure TNathanCacheProvider.Remove(Id: Integer);
begin
  //  1.Version...
  FObjectList.Delete(ID);

  //  2.Version...
  //  FCacheIDs.Remove(Id);
  //  FCacheDict.Remove(Id);
end;

//procedure TNathanCacheProvider.Renew(Id: Integer);
//var
//  OldIndex: Integer;
//begin
  //  2.Version...
  //  OldIndex := FCacheIDs.IndexOf(ID);
  //  if OldIndex <> -1 then
  //    FCacheIDs.Move(OldIndex, 0);
//end;

end.
