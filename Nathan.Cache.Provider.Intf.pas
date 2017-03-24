unit Nathan.Cache.Provider.Intf;

interface

type
  {$REGION 'Links'}
  {
    http://www.delphipraxis.net/186051-code-kata-cache-klasse-wer-produziert-den-besten-code.html
  }
  {$ENDREGION}

{$M+}

  {TODO -oNathan -cGeneral: Don't use TObject, but better are generics. }

  INathanCacheProvider = interface
    ['{714F69BA-B10A-44D4-9364-791CA9B6DD01}']

    /// <summary>
    ///   Gibt die maximale Grösse des Caches an. MaxSize = 2 bedeuet, hier wird beim
    ///   Einfügen ab dem Element 3 z.B. "Put(3, TMyObject.CreateInstance(333));" das
    ///   letzte Element, hier 2 gelöscht und 3 als letztes hinzugefügt. Das gannze passiert so
    ///   oft, bis nur noch Element 1 und z.B. 5 (letztes hinzufügen) im Cache verbleiben.
    /// </summary>
    function GetSize(): Integer;

    /// <summary>
    ///   Aktuelle Anzahl enthaltener Elemente im Cache. Hat nichts mit MaxSize zu tun.
    /// </summary>
    function GetCurrentNumberOfElements(): Integer;

    /// <summary>
    ///   Prüft ob das Element mit ID vorhanden ist.
    /// </summary>
    function Contains(Id: Integer): Boolean;

    /// <summary>
    ///   Gibt das Element zur ID zurück.
    /// </summary>
    function Get(Id: Integer): TObject;

    /// <summary>
    ///   Fügt ein Element mit der ID dem Cache hinzu.
    /// </summary>
    procedure Put(Id: Integer; Item: TObject);

    /// <summary>
    ///   Entfernt das Element mit ID aus dem Cache.
    /// </summary>
    procedure Remove(Id: Integer);

    /// <summary>
    ///   Leert den gesamten Cache.
    /// </summary>
    procedure CleanCache();

    /// <summary>
    ///   Read only property. Gibt die maximale Anzahl an Element, welche der Cache aufnehmen darf.
    /// </summary>
    property MaxSize: Integer read GetSize;

    /// <summary>
    ///   Die tatsächliche Anzahl Elemente im Cache.
    /// </summary>
    property CurrentNumberOfElements: Integer read GetCurrentNumberOfElements;
  end;

  /// <summary>
  ///   Interface für generische Values. sonst gleich wie der Manager für TObjects.
  /// </summary>
  INathanCacheProvider<T> = interface
    ['{BBCBBCE9-5AE1-4AF8-B299-8E0909250CDB}']
    function GetSize(): Integer;

    function GetCurrentNumberOfElements(): Integer;
    function Contains(Id: Integer): Boolean;
    function Get(Id: Integer): T;

    procedure Put(Id: Integer; Item: T);
    procedure Remove(Id: Integer);
    procedure CleanCache();

    property MaxSize: Integer read GetSize;
    property CurrentNumberOfElements: Integer read GetCurrentNumberOfElements;
  end;

{$M-}

implementation

end.
