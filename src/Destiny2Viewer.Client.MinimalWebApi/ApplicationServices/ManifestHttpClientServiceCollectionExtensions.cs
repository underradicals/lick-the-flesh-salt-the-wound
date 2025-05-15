using System.Net;
using Polly;
using Polly.Retry;

namespace Destiny2App.Client.WebApi.ApplicationServices;

public static class ManifestHttpClientServiceCollectionExtensions
{
    private const string ClientName = "ManifestClient";
    public static IServiceCollection AddManifestHttpClient(this IServiceCollection services, IConfiguration Configuration)
    {
        services.AddHttpClient(ClientName, ConfigureHttpClient(Configuration))
            .ConfigurePrimaryHttpMessageHandler(ConfigureHttpMessageHandler());
        services.AddResiliencePipeline(ClientName, ConfigureResiliencePipeline());
        return services;
    }

    private static Action<HttpClient> ConfigureHttpClient(IConfiguration Configuration)
    {
        return options =>
        {
            options.BaseAddress = new Uri(Configuration["Secrets:BaseAddress"]!);
            options.DefaultRequestHeaders.Add("X-API-Key", Configuration["Secrets:ApiKey"]!); 
            options.DefaultRequestHeaders.Add("Accept-Language", "en-US");
            options.DefaultRequestHeaders.Add("Accept-Encoding", "gzip, deflate");
            options.DefaultRequestHeaders.Add("Accept", "application/json");
            options.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36");
        };
    }
    
    private static Func<HttpMessageHandler> ConfigureHttpMessageHandler()
    {
        return () => new HttpClientHandler
        {
            AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate,
        };
    }

    private static Action<ResiliencePipelineBuilder> ConfigureResiliencePipeline()
    {
        return builder =>
        {
            builder.AddRetry(new RetryStrategyOptions
            {
                BackoffType = DelayBackoffType.Exponential,
                UseJitter = true,
                MaxRetryAttempts = 3
            });
        };
    }
}