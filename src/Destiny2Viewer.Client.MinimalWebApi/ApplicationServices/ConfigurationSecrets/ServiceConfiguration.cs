using Microsoft.Extensions.Options;

namespace Destiny2App.Client.WebApi.ApplicationServices.ConfigurationSecrets;



public static class ServiceConfiguration
{
    public static void BindConfiguration<TSecret>(this IServiceCollection services, IConfiguration Configuration, string name) where TSecret : class, new()
    {
        services.Configure<TSecret>(Configuration.GetSection(name));
        services.AddTransient<TSecret>(provider => provider.GetRequiredService<IOptionsMonitor<TSecret>>().CurrentValue);
    }
}