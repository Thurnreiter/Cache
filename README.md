# Cache
Simple Cache Manager Provider
A simple implementation of a cache manager. The cache manager accepts a cache provider and can fill it eg. by thread.

Example:

Init:
FCacheManager := TNathanCacheManager<string>.GetInstance()
FCacheManager.AddCacheProvider(TNathanCacheProviderT<string>.Create());

```delphi
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
