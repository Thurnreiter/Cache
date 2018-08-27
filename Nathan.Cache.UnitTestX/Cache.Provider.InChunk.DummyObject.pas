unit Cache.Provider.InChunk.DummyObject;

interface

{$M+}

type
  IDummyObject = interface
    ['{4DD6D9CB-CAD1-47EB-B10A-3B26ED23DA90}']
    function GetAny1(AVal1: Integer): Integer;
  end;

  TDummyObject = class(TInterfacedObject, IDummyObject)
  public
    function GetAny1(AVal1: Integer): Integer;
  end;

{$M-}

implementation

{ TDummyObject }

function TDummyObject.GetAny1(AVal1: Integer): Integer;
begin
  Result := AVal1;
end;

end.
