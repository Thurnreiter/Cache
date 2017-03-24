unit Nathan.Cache.Manager.Impl;

interface

uses
  System.SysUtils,
  Nathan.Cache.Provider.Intf,
  Nathan.Cache.Manager.Intf;

type
  TNathanCacheManager = class(TInterfacedObject, INathanCacheManager)
  strict private
    FCacheProvider: INathanCacheProvider;
  private
    class var FInstance: INathanCacheManager;
    //class var FLock: TCriticalSection;  System.SyncObjs,

    procedure CacheRunner(Id: Integer; AcquireFunc: TFunc<TObject>);
  public
    class function GetInstance(): INathanCacheManager;

    procedure ClearCache();
    procedure AddCacheProvider(Cache: INathanCacheProvider);

    function GetOrAddCache(Id: Integer; AcquireFunc: TFunc<TObject>): TObject;
  end;

implementation

uses
  System.Threading;

{ TNathanCacheManager }

class function TNathanCacheManager.GetInstance(): INathanCacheManager;
begin
  if (FInstance = nil) then
    FInstance := TNathanCacheManager.Create();

  Result := FInstance;
end;

procedure TNathanCacheManager.ClearCache();
begin
  if not Assigned(FCacheProvider) then
    raise EArgumentNilException.Create(ArgumentNilExceptionCacheProvider);

  FCacheProvider.CleanCache();
end;

procedure TNathanCacheManager.AddCacheProvider(Cache: INathanCacheProvider);
begin
  FCacheProvider := Cache;
end;

function TNathanCacheManager.GetOrAddCache(Id: Integer; AcquireFunc: TFunc<TObject>): TObject;
begin
  if not Assigned(FCacheProvider) then
    raise EArgumentNilException.Create(ArgumentNilExceptionCacheProvider);

  if FCacheProvider.Contains(Id) then
    Result := FCacheProvider.Get(Id)
  else
  begin
    CacheRunner(Id, AcquireFunc);
    Result := nil;
  end;
end;

procedure TNathanCacheManager.CacheRunner(Id: Integer; AcquireFunc: TFunc<TObject>);
begin
  TTask.Run(
    procedure
    begin
      // Prüfen auf Cancelation
      if TTask.CurrentTask.Status = TTaskStatus.Canceled then
        Exit;

      FCacheProvider.Put(Id, AcquireFunc);
    end);

//  TTask.Run( procedure
//             begin
//               TTask.WaitForAll(Tasks1to2);
//               TThread.Synchronize(nil,
//                 procedure
//                 begin
//                   LabelTask1Plus2.Text :=
//                     LabelTask1.Text + ' + ' + LabelTask2.Text;
//                 end);
//             end );
end;

end.
