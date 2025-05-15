using Destiny2App.Client.WebApi.ApplicationServices.ConfigurationSecrets;

namespace Destiny2Viewer.Client.MinimalWebApi.Ingestion;


public class WeeklyScheduledJob
{
    private readonly ILogger<WeeklyScheduledJob> _logger;
    private readonly ConnectionStrings _connectionStrings;

    public WeeklyScheduledJob(ILogger<WeeklyScheduledJob> logger, ConnectionStrings connectionStrings)
    {
        _logger = logger;
        _connectionStrings = connectionStrings;
    }

    public void Handle()
    {
        Console.WriteLine(_connectionStrings.RedisStackExchange);
        Console.WriteLine(_connectionStrings.Hangfire);
        Console.WriteLine(_connectionStrings.Sqlite);
    }
}