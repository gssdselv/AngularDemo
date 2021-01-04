using Flex.APT.Application.Data_Contract.User;
using Flex.APT.Data.User;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Text;

namespace Flex.APT.Data.TypeResolver
{
    public static class DataTypeResolver
    {
        public static IServiceCollection ConfigureGDPNSData(this IServiceCollection services)
        {
            services.AddTransient<IUserRepository, UserRepository>();
            return services;
        }
    }
}
