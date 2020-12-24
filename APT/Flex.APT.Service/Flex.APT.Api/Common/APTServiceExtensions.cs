using Flex.APT.FrameWork.Resources;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.Extensions.DependencyInjection;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;

namespace Flex.APT.Api.Common
{
    public static class APTServiceExtensions
    {
        public static IServiceCollection ConfigureAPTAPI(this IServiceCollection services)
            => services.AddLogging(loggingBuilder => loggingBuilder.AddSerilog(dispose: true))
                    .Configure<FormOptions>(x =>
                    {
                        x.ValueLengthLimit = int.MaxValue;
                        x.MultipartBodyLengthLimit = int.MaxValue;
                    })
                    .Do(s =>
                           s.AddMvc(config =>
                           {
                               config.Filters.Add(new ExceptionFilter());
                           })
                        )
                    .Do(s =>
                           s.AddMvc(o =>
                           {
                               var policy = new AuthorizationPolicyBuilder()
                                            .RequireAuthenticatedUser()
                                            .Build();
                               o.Filters.Add(new AuthorizeFilter(policy));
                           })
                        );
        public static IApplicationBuilder ConfigureAppForAPTAPI(this IApplicationBuilder app, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory)
        {
            loggerFactory.AddSerilog();
            app.UseAuthentication()
                .UseCors(builder => builder.AllowAnyOrigin()
                              .AllowAnyMethod()
                              .AllowAnyHeader());
            return app;
        }

        public static void ConfigureLogger()
        {
            Log.Logger = new LoggerConfiguration()
                      .Enrich.FromLogContext()
                      .WriteTo.File("log/GDPNSlog.txt", rollingInterval: RollingInterval.Day)
                      .CreateLogger();
        }
    }
}
