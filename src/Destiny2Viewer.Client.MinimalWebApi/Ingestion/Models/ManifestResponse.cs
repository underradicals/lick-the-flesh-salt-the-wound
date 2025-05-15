using System.Text.Json.Serialization;
using Destiny2Viewer.Client.MinimalWebApi.Ingestion.Models.Enums;

namespace Destiny2Viewer.Client.MinimalWebApi.Ingestion.Models;


public class ManifestResponse
{
    [JsonPropertyName("version")] 
    public string Version { get; init; } = string.Empty;

    [JsonPropertyName("mobileAssetContentPath")]
    public string MobileAssetContentPath { get; init; } = string.Empty;

    [JsonPropertyName("mobileGearAssetDataBases")]
    public IEnumerable<MobileGearAssetDataBasesItem> MobileGearAssetDataBases { get; init; } = [];

    [JsonPropertyName("mobileWorldContentPaths")]
    public ManifestLocalization<string> MobileWorldContentPaths { get; init; } = new();

    [JsonPropertyName("jsonWorldContentPaths")]
    public ManifestLocalization<string> JsonWorldContentPaths { get; init; } = new();

    [JsonPropertyName("jsonWorldComponentContentPaths")]
    public ManifestLocalization<DestinyTables> JsonWorldComponentContentPaths { get; init; } = new();
    
    [JsonPropertyName("mobileClanBannerDatabasePath")]
    public string MobileClanBannerDatabasePath { get; init; } = string.Empty;

    [JsonPropertyName("mobileGearCDN")] 
    public MobileGearCDN MobileGearCDN { get; init; } = new();

    [JsonPropertyName("iconImagePyramidInfo")]
    public object[] IconImagePyramidInfo { get; init; } = [];

    public string GetJsonWorldContentPath(string language)
    {
        return language switch
        {
            ManifestLocalizationsEnumeration.En => JsonWorldContentPaths.En,
            ManifestLocalizationsEnumeration.Fr => JsonWorldContentPaths.Fr,
            ManifestLocalizationsEnumeration.Es => JsonWorldContentPaths.Es,
            ManifestLocalizationsEnumeration.EsMx => JsonWorldContentPaths.EsMx,
            ManifestLocalizationsEnumeration.De => JsonWorldContentPaths.De,
            ManifestLocalizationsEnumeration.It => JsonWorldContentPaths.It,
            ManifestLocalizationsEnumeration.Ja => JsonWorldContentPaths.Ja,
            ManifestLocalizationsEnumeration.PtBr => JsonWorldContentPaths.PtBr,
            ManifestLocalizationsEnumeration.Ru => JsonWorldContentPaths.Ru,
            ManifestLocalizationsEnumeration.Pl => JsonWorldContentPaths.Pl,
            ManifestLocalizationsEnumeration.Ko => JsonWorldContentPaths.Ko,
            ManifestLocalizationsEnumeration.ZhCht => JsonWorldContentPaths.ZhCht,
            ManifestLocalizationsEnumeration.ZhChs => JsonWorldContentPaths.ZhChs,
            _ => JsonWorldContentPaths.En,
        };
    }
    
    public string GetMobileWorldContentPath(string language)
    {
        return language switch
        {
            ManifestLocalizationsEnumeration.En => MobileWorldContentPaths.En,
            ManifestLocalizationsEnumeration.Fr => MobileWorldContentPaths.Fr,
            ManifestLocalizationsEnumeration.Es => MobileWorldContentPaths.Es,
            ManifestLocalizationsEnumeration.EsMx => MobileWorldContentPaths.EsMx,
            ManifestLocalizationsEnumeration.De => MobileWorldContentPaths.De,
            ManifestLocalizationsEnumeration.It => MobileWorldContentPaths.It,
            ManifestLocalizationsEnumeration.Ja => MobileWorldContentPaths.Ja,
            ManifestLocalizationsEnumeration.PtBr => MobileWorldContentPaths.PtBr,
            ManifestLocalizationsEnumeration.Ru => MobileWorldContentPaths.Ru,
            ManifestLocalizationsEnumeration.Pl => MobileWorldContentPaths.Pl,
            ManifestLocalizationsEnumeration.Ko => MobileWorldContentPaths.Ko,
            ManifestLocalizationsEnumeration.ZhCht => MobileWorldContentPaths.ZhCht,
            ManifestLocalizationsEnumeration.ZhChs => MobileWorldContentPaths.ZhChs,
            _ => MobileWorldContentPaths.En,
        };
    }
    
    public DestinyTables GetJsonWorldComponentContentPaths(string language)
    {
        return language switch
        {
            ManifestLocalizationsEnumeration.En => JsonWorldComponentContentPaths.En,
            ManifestLocalizationsEnumeration.Fr => JsonWorldComponentContentPaths.Fr,
            ManifestLocalizationsEnumeration.Es => JsonWorldComponentContentPaths.Es,
            ManifestLocalizationsEnumeration.EsMx => JsonWorldComponentContentPaths.EsMx,
            ManifestLocalizationsEnumeration.De => JsonWorldComponentContentPaths.De,
            ManifestLocalizationsEnumeration.It => JsonWorldComponentContentPaths.It,
            ManifestLocalizationsEnumeration.Ja => JsonWorldComponentContentPaths.Ja,
            ManifestLocalizationsEnumeration.PtBr => JsonWorldComponentContentPaths.PtBr,
            ManifestLocalizationsEnumeration.Ru => JsonWorldComponentContentPaths.Ru,
            ManifestLocalizationsEnumeration.Pl => JsonWorldComponentContentPaths.Pl,
            ManifestLocalizationsEnumeration.Ko => JsonWorldComponentContentPaths.Ko,
            ManifestLocalizationsEnumeration.ZhCht => JsonWorldComponentContentPaths.ZhCht,
            ManifestLocalizationsEnumeration.ZhChs => JsonWorldComponentContentPaths.ZhChs,
            _ => JsonWorldComponentContentPaths.En,
        };
    }

    public List<List<string>> GetJsonWorldComponentContentPathsAsIterable(string language)
    {
        var result = GetJsonWorldComponentContentPaths(language);
        List<List<string>> list = [];
        
        var type = result.GetType();
        var properties = type.GetProperties();
        foreach (var property in properties)
        {
            list.Add([$"{property.Name}.json", property.GetValue(result)?.ToString()!]);
        }

        return list;
    }
}