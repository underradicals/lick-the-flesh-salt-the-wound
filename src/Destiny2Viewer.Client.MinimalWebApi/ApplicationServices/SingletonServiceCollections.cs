using Destiny2App.Client.WebApi.Helpers;
using Destiny2Viewer.Client.MinimalWebApi.Ingestion.HttpClients;

namespace Destiny2App.Client.WebApi.ApplicationServices;

public static class SingletonServiceCollections
{
    public static IServiceCollection AddSingletonServices(this IServiceCollection services)
    {
        services.AddSingleton<ICryptography, Cryptography>();
        services.AddSingleton<IManifestHttpClient, ManifestHttpClient>();
        return services;
    }
}