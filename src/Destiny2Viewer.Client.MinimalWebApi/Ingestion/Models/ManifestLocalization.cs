using System.Text.Json.Serialization;

namespace Destiny2Viewer.Client.MinimalWebApi.Ingestion.Models;


public class ManifestLocalization<T> where T : class
{
    [JsonPropertyName("en")]
    public T En { get; init; } = null!;
    [JsonPropertyName("fr")]
    public T Fr { get; init; } = null!;
    [JsonPropertyName("es")]
    public T Es { get; init; } = null!;
    [JsonPropertyName("es-mx")]
    public T EsMx { get; init; } = null!;
    [JsonPropertyName("de")]
    public T De { get; init; } = null!;
    [JsonPropertyName("it")]
    public T It { get; init; } = null!;
    [JsonPropertyName("ja")]
    public T Ja { get; init; } = null!;
    [JsonPropertyName("pt-br")]
    public T PtBr { get; init; } = null!;
    [JsonPropertyName("ru")]
    public T Ru { get; init; } = null!;
    [JsonPropertyName("pl")]
    public T Pl { get; init; } = null!;
    [JsonPropertyName("ko")]
    public T Ko { get; init; } = null!;
    [JsonPropertyName("zh-cht")]
    public T ZhCht { get; init; } = null!;
    [JsonPropertyName("zh-chs")]
    public T ZhChs { get; init; } = null!;
}