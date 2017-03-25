unit Nathan.Cache.Manager.Intf;

interface

uses
  System.SysUtils,
  Nathan.Cache.Provider.Intf;

const
  ArgumentNilExceptionCacheProvider = 'No Cache-Provider found.';

type
  {$REGION 'Links'}
  {
    https://www.backslash.ch/blog/2009/12/18/Was-ist-ein-Cache
    http://stackoverflow.com/questions/13520364/how-to-implement-a-generic-cache-manager-in-c-sharp
    https://github.com/ysharplanguage/GenericMemoryCache
    http://www.javaworld.com/article/2075440/core-java/develop-a-generic-caching-service-to-improve-performance.html

    http://adventure-php-framework.org/Seite/084-CacheManager/Version/1.X
    CacheManager
    Der CacheManager kümmert sich um die Verwaltung und Initialisierung der CacheProvider,
    die sich letztlich um die Funktion des Lesens, Schreibens und Löschen von Cache-Inhalten
    kümmern. Im Release sind bereits wichtige Provider und eine abstrakte Definition zur
    Implementierung von eigenen Providern enthalten.

    Als "Adresse" von Cache-Einträgen werden sogenannte CacheKeys eingesetzt.
    Dieses definieren einen beliebig komplexen Schlüssel, der für das Laden und Speichern
    von Objekten (einfache Zeichen, Objekte, Listen, ...) als eindeutiger Key gilt.

    Wie dem Beispiel bereits zu entnehmen ist, besitzt der CacheManager drei Methoden,
    die jeweils vom zuständigen Provider implementiert werden:
    - getFromCache(): Liest den gewünschten Cache-Inhalt. Ist für den Cache-Key noch
                      kein Inhalt vorhanden, wird null zurückgegeben. Dies kann gleichzeitig
                      als Indiz für das Neuanlegen des Cache-Inhalts verwendet werden.
    - writeToCache(): Schreibt den Inhalt unter dem konfigurierten Namespace und dem
                      übergebenen Cache-Key in den Cache. Bei Erfolg wird true, bei
                      einem Fehler false zurückgegeben.
    - clearCache():   Die Methode clearCache() dient zum Löschen des Caches. Hierbei
                      können durch Übergabe des gewünschten Cache-Keys dieser selbst,
                      oder ohne Argument, der komplette Namespace gelöscht werden.

    http://stackoverflow.com/questions/699996/java-web-application-how-to-implement-caching-techniques
      ServletContext ctx = sce.getServletContext();
      CacheManager singletonManager = CacheManager.create();
      Cache memoryOnlyCache = new Cache("dbCache", 100, false, true, 86400,86400);
      singletonManager.addCache(memoryOnlyCache);
      cache = singletonManager.getCache("dbCache");
      ctx.setAttribute("dbCache", cache );

  }
  {$ENDREGION}

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
    ///   Fügt den Cache Provider dem Manager hinzu. "Der Manager kann mehrere Cache
    ///   Provider beinhalten und duchsucht diese wird nach einem Element gefragt."
    ///   Folgt in der nächsten Generation.
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

  /// <summary>
  ///   Interface for Cache Manager implemtation.
  /// </summary>
  INathanCacheManager<T> = interface
    ['{60061C74-A21E-41C2-9D6F-BD23BC6D5220}']
    function GetUseThreading(): Boolean;
    procedure SetUseThreading(Value: Boolean);

    /// <summary>
    ///   Clears all cahce entire.
    /// </summary>
    procedure ClearCache();

    /// <summary>
    ///   Adds a cache provider to the manager.
    /// </summary>
    procedure AddCacheProvider(Cache: INathanCacheProvider<T>);

    /// <summary>
    ///   Searches for the first hit of the Id in all Cache Providers and return corresponding <T>.
    ///   If the return value is empty, this can be used simultaneously as an index for the new
    ///   creation of the cache content or meaning that no element was found.
    ///   The Parameter Method AcquireFunc, give the response value for the cache.
    /// </summary>
    function GetOrAddCache(Id: Integer; AcquireFunc: TFunc<T>): T; overload;

    /// <summary>
    ///   If you want to use the method "AcquireFunc" several times, it is bettter to use this.
    /// </summary>
    function GetOrAddCache(Id: Integer; AcquireFunc: TFunc<Integer, T>): T; overload;

    /// <summary>
    ///   If you are use a thread "property UseThreading" for fillling cache,
    ///   then it is beneficial to use the callback method.
    /// </summary>
    function GetOrAddCache(Id: Integer; AcquireFunc: TFunc<T>; CallbackAction: TProc<Integer, T>): T; overload;

    /// <summary>
    ///   Property to use a Thread, for fill the cache.
    /// </summary>
    property UseThreading: Boolean read GetUseThreading write SetUseThreading;
  end;

{$M-}

implementation

end.
