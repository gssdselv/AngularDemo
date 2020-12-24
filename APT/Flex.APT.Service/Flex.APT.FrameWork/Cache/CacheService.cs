using Flex.APT.FrameWork.Contract.Cache;
using Microsoft.Extensions.Caching.Distributed;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace Flex.APT.FrameWork.Cache
{
    public class CacheService : ICacheService
    {
        private IDistributedCache cache;
        public CacheService(IDistributedCache cache)
        {
            this.cache = cache;
        }
        public T GetOrCreate<T>(string key, Func<T> GetCacheItem)
        {
            T cacheItem;
            if (cache.Get(key) == null)
            {
                cacheItem = GetCacheItem();
                cache.Set(key, Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(cacheItem)));
            }
            else
            {
                cacheItem = JsonConvert.DeserializeObject<T>(Encoding.UTF8.GetString(cache.Get(key)));
            }
            return cacheItem;
        }

        public void Remove(string key)
        {
            this.cache.Remove(key);
        }
    }
}
