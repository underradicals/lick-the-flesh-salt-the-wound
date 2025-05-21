using Destiny2App.Client.WebApi.Features.Common;
using Destiny2App.Client.WebApi.Features.WeaponPage;
using Destiny2Viewer.Client.MinimalWebApi.Ingestion.Repositories;

namespace Destiny2App.Client.WebApi.ApplicationServices;

public static class TransientServiceCollections
{
    public static IServiceCollection AddTransientServices(this IServiceCollection services)
    {
        services.AddTransient<ISQLiteRepository, SQLiteRepository>();
        services.AddTransient<IWeaponPageRepository, WeaponPageRepository>();
        services.AddTransient<IRequestHandler<WeaponPageQuery, WeaponPageResponse>, WeaponPageQueryHandler>();
        services.AddTransient<IMediator<WeaponPageQuery, WeaponPageResponse>, WeaponPageMediator>();
        return services;
    }
}