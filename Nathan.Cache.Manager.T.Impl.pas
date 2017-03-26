unit Nathan.Cache.Manager.T.Impl;

interface

uses
  System.SysUtils,
  Nathan.Cache.Provider.Intf,
  Nathan.Cache.Manager.Intf;

type
  TNathanCacheManager<T> = class(TInterfacedObject, INathanCacheManager<T>)
  strict private
    FUseThreading: Boolean;
    FCacheProvider: INathanCacheProvider<T>;
  private
    class var FInstance: INathanCacheManager<T>;

    function GetUseThreading(): Boolean;
    procedure SetUseThreading(Value: Boolean);

    procedure CacheRunner(Id: Integer; CacheValue: T);
  public
    class function GetInstance(): INathanCacheManager<T>;

    procedure ClearCache();
    procedure AddCacheProvider(Cache: INathanCacheProvider<T>);

    function GetOrAddCache(Id: Integer; AcquireFunc: TFunc<T>): T; overload;
    function GetOrAddCache(Id: Integer; AcquireFunc: TFunc<Integer, T>): T; overload;
    function GetOrAddCache(Id: Integer; AcquireFunc: TFunc<T>; CallbackAction: TProc<Integer, T>): T; overload;
  end;

implementation

uses
  System.Classes,
  System.Threading;

{ TNathanCacheManager<T> }

class function TNathanCacheManager<T>.GetInstance(): INathanCacheManager<T>;
begin
  if (FInstance = nil) then
    FInstance := TNathanCacheManager<T>.Create();

  FInstance.UseThreading := False;
  Result := FInstance;
end;

function TNathanCacheManager<T>.GetUseThreading: Boolean;
begin
  Result := FUseThreading;
end;

procedure TNathanCacheManager<T>.SetUseThreading(Value: Boolean);
begin
  FUseThreading := Value;
end;

procedure TNathanCacheManager<T>.ClearCache();
begin
  if not Assigned(FCacheProvider) then
    raise EArgumentNilException.Create(ArgumentNilExceptionCacheProvider);

  FCacheProvider.CleanCache();
end;

procedure TNathanCacheManager<T>.AddCacheProvider(Cache: INathanCacheProvider<T>);
begin
  FCacheProvider := Cache;
end;

function TNathanCacheManager<T>.GetOrAddCache(Id: Integer; AcquireFunc: TFunc<T>): T;
begin
  if FCacheProvider.Contains(Id) then
    Result := FCacheProvider.Get(Id)
  else
    CacheRunner(Id, AcquireFunc);
end;

function TNathanCacheManager<T>.GetOrAddCache(Id: Integer; AcquireFunc: TFunc<Integer, T>): T;
begin
  if FCacheProvider.Contains(Id) then
    Result := FCacheProvider.Get(Id)
  else
  begin
    CacheRunner(Id, AcquireFunc(Id));
    Result := FCacheProvider.Get(Id)
  end;
end;

function TNathanCacheManager<T>.GetOrAddCache(Id: Integer; AcquireFunc: TFunc<T>; CallbackAction: TProc<Integer, T>): T;
begin
  if FCacheProvider.Contains(Id) then
    Result := FCacheProvider.Get(Id)
  else
  begin
    CacheRunner(Id, AcquireFunc);
    CallbackAction(Id, FCacheProvider.Get(Id));
  end;
end;

//procedure TNathanCacheManager<T>.CacheRunner(Id: Integer; AcquireFunc: TFunc<T>);
procedure TNathanCacheManager<T>.CacheRunner(Id: Integer; CacheValue: T);
begin
  if not Assigned(FCacheProvider) then
    raise EArgumentNilException.Create(ArgumentNilExceptionCacheProvider);

  if (not FUseThreading) then
  begin
//    FCacheProvider.Put(Id, AcquireFunc);
    FCacheProvider.Put(Id, CacheValue);
    Exit;
  end;

  TTask.Run(
    procedure
    begin
      if (TTask.CurrentTask.Status = TTaskStatus.Canceled) then
        Exit;

//      FCacheProvider.Put(Id, AcquireFunc);
      FCacheProvider.Put(Id, CacheValue);
    end);
  {$REGION 'Demo'}
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
  {$ENDREGION}
end;

end.
