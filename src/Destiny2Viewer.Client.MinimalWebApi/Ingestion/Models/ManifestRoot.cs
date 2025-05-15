using System.Text.Json.Serialization;

namespace Destiny2Viewer.Client.MinimalWebApi.Ingestion.Models;


public class ManifestRoot
{
    [JsonPropertyName("Response")] public ManifestResponse Response { get; init; } = new();
    [JsonPropertyName("ErrorCode")] public int ErrorCode { get; init; }
    [JsonPropertyName("ThrottleSeconds")] public int ThrottleSeconds { get; init; }
    [JsonPropertyName("ErrorStatus")] public string ErrorStatus { get; init; } = string.Empty;
    [JsonPropertyName("Message")] public string Message { get; init; } = string.Empty;
    [JsonPropertyName("MessageData")] public object MessageData { get; init; } = string.Empty;
}