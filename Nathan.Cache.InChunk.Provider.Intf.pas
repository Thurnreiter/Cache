unit Nathan.Cache.InChunk.Provider.Intf;

interface

uses
  System.SysUtils;

{$M+}

type
  ICacheProviderCoreT<K, V> = interface
    ['{6A7BECA7-972F-4BB4-B502-B058E5974338}']
    /// <summary>
    ///   Aktuelle Anzahl enthaltener Elemente im Cache.
    /// </summary>
    function Count(): Integer;

    /// <summary>
    ///   Gibt das Element zur ID zur�ck.
    /// </summary>
    function Get(AKey: K): V;

    /// <summary>
    ///   F�gt ein Key - Value dem Cache hinzu.
    /// </summary>
    procedure Add(AKey: K; AValue: V);

    /// <summary>
    ///   Leert den gesamten Cache.
    /// </summary>
    procedure Clear;

    /// <summary>
    ///   Event beim ersten Element das dem Cache hinzugef�gt wird.
    /// </summary>
    procedure OnFirstKey(Value: TProc<K>);
  end;

{$M-}

implementation

end.
