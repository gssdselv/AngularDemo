using Flex.APT.FrameWork.Cache;
using Flex.APT.FrameWork.Contract.AppSettings;
using Flex.APT.FrameWork.Contract.Cache;
using Flex.APT.FrameWork.Contract.HttpClientRequest;
using Flex.APT.FrameWork.HttpclientRequest;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Text;

namespace Flex.APT.FrameWork.TypeResolver
{
    public static class FrameworkConfigurationForNetCore
    {
        public static IServiceCollection ConfigureAPTFramework(this IServiceCollection services, ICacheServiceAppsettings cacheServiceAppsettings)
        => services.AddDistributedRedisCache(option =>
        {
            option.Configuration = cacheServiceAppsettings.CacheServer;
            option.InstanceName = cacheServiceAppsettings.InstanceName;
        })
            .AddSingleton<ICacheService, CacheService>()
            .AddSingleton<IHttpClientRequest, HttpClientRequest>();
    }
}
