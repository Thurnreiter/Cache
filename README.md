# Cache
Simple Cache Manager - Provider<br>
A simple implementation of a cache manager. The cache manager accepts any cache provider and can fill it eg. by thread.

Example:

```delphi
FCacheManager := TNathanCacheManager<string>.GetInstance()
FCacheManager.AddCacheProvider(TNathanCacheProviderT<string>.Create());
...
var
  CacheValue: string;
...
CacheValue := FCacheManager.GetOrAddCache(ARecordIndex,
  function: string
  begin
    Result := ARecordIndex.ToString;
  end,
  procedure(MyId: Integer; MyText: string)
  begin
    CacheValue := MyText;
  end);
```
For more examples, show test files.
