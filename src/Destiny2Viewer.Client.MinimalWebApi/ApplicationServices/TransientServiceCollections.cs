using Destiny2Viewer.Client.MinimalWebApi.Ingestion.Repositories;

namespace Destiny2App.Client.WebApi.ApplicationServices;

public static class TransientServiceCollections
{
    public static IServiceCollection AddTransientServices(this IServiceCollection services)
    {
        services.AddTransient<ISQLiteRepository, SQLiteRepository>();
        return services;
    }
}