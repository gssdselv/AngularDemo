using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Flex.APT.Api.Common;
using Flex.APT.FrameWork.Resources;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Elastic.Apm.NetCoreAll;
using Microsoft.AspNetCore.Mvc;
using Flex.APT.FrameWork.TypeResolver;
using Flex.APT.Data.TypeResolver;
using Flex.APT.Application;

namespace Flex.APT.Api
{
    public class Startup
    {
        public IConfiguration Configuration { get; }
        Appsetting appsetting;
        public Startup(IConfiguration configuration)
        {
            ThreadPool.SetMinThreads(200, 200);
            APTServiceExtensions.ConfigureLogger();
            Configuration = configuration;
            appsetting = new Appsetting();
            configuration.Bind("AppSetting", appsetting);
        }
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
         => services.ConfigureAPTAPI()
                    .ConfigureAPTApplication()
                    .ConfigureAPTFramework(appsetting)
                    .ConfigureGDPNSData()
                    .Do(serviceCollection => serviceCollection.AddMvc(x => x.EnableEndpointRouting = false).SetCompatibilityVersion(CompatibilityVersion.Version_3_0));

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILoggerFactory loggerFactory)
        {
            app.ConfigureAppForAPTAPI(loggerFactory)
                           .UseMvc()
                           .When(() => env.EnvironmentName == "Local", () => app.UseDeveloperExceptionPage()
                           .UseAllElasticApm(Configuration));
        }
    }
}
