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

## A chunk cache
Processes the cache in blocks / chunks. For example, if the data is too large, which would cause "out of memory", you can use the cache to read only in blocks in it.<br>

Example:

```delphi
var
  Idx: Integer;
  Actual: Integer;
  CutManager: ICacheManagerCore;
  CutProvider: ICacheProviderCore;
begin
  Idx := 0;
  CutProvider := TCacheProviderCore.Create;
  CutManager := TCacheManagerCore.Create(3);
  CutManager.FillCacheProvider(
   procedure(Value: ICacheProviderCore)
   begin
     Value.Add(Idx.ToString, Idx);
     Inc(Idx);
     if Idx > 10 then
       Idx := 0;
   end);
   
  CutManager.AddCacheProvider(CutProvider);

  Actual := CutManager.Get('9');
  Assert.AreEqual(9, Actual);

  Actual := CutManager.Get('4');
  Assert.AreEqual(4, Actual);

  Actual := CutManager.Get('2');
  Assert.AreEqual(2, Actual);

  Actual := CutManager.Get('12');
  Assert.AreEqual(-1, Actual);

  Actual := CutManager.Get('3');
  Assert.AreEqual(3, Actual);

  Actual := CutManager.Get('4711');
  Assert.AreEqual(-1, Actual);
```
Given is a list of 10 elements. The list is to be searched in blocks of 3 elements. Should simulate a list with huge data, which can only be loaded in blocks with 3 elements.
