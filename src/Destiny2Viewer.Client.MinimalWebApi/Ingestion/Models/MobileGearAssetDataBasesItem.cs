using System.Text.Json.Serialization;

namespace Destiny2Viewer.Client.MinimalWebApi.Ingestion.Models;


public class MobileGearAssetDataBasesItem
{
    [JsonPropertyName("version")]
    public int Version { get; init; }
    [JsonPropertyName("path")]
    public string Path { get; init; } = string.Empty;
}