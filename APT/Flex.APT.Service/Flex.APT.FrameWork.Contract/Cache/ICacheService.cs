using System;
using System.Collections.Generic;
using System.Text;

namespace Flex.APT.FrameWork.Contract.Cache
{
    public interface ICacheService
    {
        T GetOrCreate<T>(string key, Func<T> func);
        void Remove(string key);
    }
}
