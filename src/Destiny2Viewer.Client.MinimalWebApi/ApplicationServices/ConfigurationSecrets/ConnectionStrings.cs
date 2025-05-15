namespace Destiny2App.Client.WebApi.ApplicationServices.ConfigurationSecrets;

public class ConnectionStrings
{
    public const string SectionName = nameof(ConnectionStrings);
    public string RedisStackExchange { get; init; } = string.Empty;
    public string Sqlite { get; init; } = string.Empty;
    public string Hangfire { get; init; } = string.Empty;
}