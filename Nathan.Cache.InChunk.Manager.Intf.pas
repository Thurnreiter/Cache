unit Nathan.Cache.InChunk.Manager.Intf;

interface

uses
  System.SysUtils,
  Nathan.Cache.InChunk.Provider.Intf;

{$M+}

type
  ICacheManagerCoreT<K, V> = interface
    ['{F4C1D1F5-9935-4D4F-9B27-2C0A2763FE99}']
    /// <summary>
    ///   Gibt die maximale Anzahgl Elemente an.
    /// </summary>
    procedure SetMax(AValue: Integer);

    /// <summary>
    ///   Fügt einen Cache Provider dem Manager hinzu.
    /// </summary>
    procedure AddCacheProvider(ACacheProviderCore: ICacheProviderCoreT<K, V>);

    /// <summary>
    ///   Event mit dem der Cache Manager den Provider füllt.
    /// </summary>
    procedure FillCacheProvider(AValue: TProc<ICacheProviderCoreT<K, V>>);

    /// <summary>
    ///   Sucht im Cache Provider nach dem ersten Treffer und gibt entsprechendes zurück.
    ///   Return ist der Value. Sollte nicht gefunden, gibt's ein Default(V).
    /// </summary>
    function Get(AKey: K): V;

    function GetMax(AKey: K): V;
  end;

{$M-}

implementation

end.
