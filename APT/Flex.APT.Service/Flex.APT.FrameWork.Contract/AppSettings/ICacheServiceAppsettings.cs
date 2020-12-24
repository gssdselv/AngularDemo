using System;
using System.Collections.Generic;
using System.Text;

namespace Flex.APT.FrameWork.Contract.AppSettings
{
    public interface ICacheServiceAppsettings
    {
        string CacheServer { get; set; }
        string InstanceName { get; set; }
    }
}
