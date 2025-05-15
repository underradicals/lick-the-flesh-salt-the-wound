namespace Destiny2Viewer.Client.MinimalWebApi.Ingestion.Models;

public class CacheEntry
{
    public string Data { get; init; } = string.Empty;
    public string LastModified { get; init; } = string.Empty;
    public string Expires { get; init; } = string.Empty;
    public string ContentType { get; init; } = string.Empty;
    public string ContentLength { get; init; } = string.Empty;
}