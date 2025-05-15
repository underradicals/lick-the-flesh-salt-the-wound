using Destiny2App.Client.WebApi.ApplicationServices.ConfigurationSecrets;
using StackExchange.Redis;

namespace Destiny2App.Client.WebApi.ApplicationServices;

public static class ConnectionMultiplexerServiceCollectionExtensions
{

    public static IServiceCollection AddRedisConnectionMultiplexer(this IServiceCollection services, IConfiguration Configuration)
    {
        services.AddSingleton<IConnectionMultiplexer>(
            ConnectionMultiplexer.Connect(Configuration["ConnectionStrings:RedisStackExchange"]!));
        return services;
    }
}