unit Nathan.Cache.Manager.Intf;

interface

uses
  System.SysUtils,
  Nathan.Cache.Provider.Intf;

const
  ArgumentNilExceptionCacheProvider = 'No Cache-Provider found.';

type

{$M+}

  /// <summary>
  ///   Interface für alle Cache Manager mit fixem TObject als Value.
  /// </summary>
  INathanCacheManager = interface
    ['{79F6A07A-3240-4097-9C3A-1E121B9F291B}']

    /// <summary>
    ///   Leert in allen Cache Provider den Cache.
    /// </summary>
    procedure ClearCache();

    /// <summary>
    ///   Fügt den Cache Provider dem Manager hinzu. Der Manager kann mehrere Cache
    ///   Provider beinhalten und duchsucht diese wird nach einem Element gefragt.
    /// </summary>
    procedure AddCacheProvider(Cache: INathanCacheProvider);

    /// <summary>
    ///   Sucht in allen Cache Providern nach dem ersten Treffer der Id und gibt
    ///   entsprechendes Object zurück. Object ist nil sollt4e keines gefunden
    ///   werden oder der Cache nicht aktuell ist.
    ///   Ist für den Cache-Key noch kein Inhalt vorhanden, wird nil zurückgegeben.
    ///   Dies kann gleichzeitig als Indiz für das Neuanlegen des Cache-Inhalts
    ///   verwendet werden oder bedeuetet, das kein Element gefunden wurde.
    /// </summary>
    function GetOrAddCache(Id: Integer; AcquireFunc: TFunc<TObject>): TObject;
  end;

  INathanCacheManager<T> = interface
    ['{60061C74-A21E-41C2-9D6F-BD23BC6D5220}']
    function GetUseThreading(): Boolean;
    procedure SetUseThreading(Value: Boolean);

    procedure ClearCache();
    procedure AddCacheProvider(Cache: INathanCacheProvider<T>);

    function GetOrAddCache(Id: Integer; AcquireFunc: TFunc<T>): T; overload;
    function GetOrAddCache(Id: Integer; AcquireFunc: TFunc<T>; CallbackAction: TProc<Integer, T>): T; overload;

    property UseThreading: Boolean read GetUseThreading write SetUseThreading;
  end;

{$M-}

implementation

end.
