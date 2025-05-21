namespace Destiny2App.Client.WebApi.Features.WeaponPage;

public record WeaponResponse
{
    public long Id { get; init; }
    public string Name { get; init; } = string.Empty;
    public string DisplayName { get; init; } = string.Empty;
    public string TierType { get; init; } = string.Empty;
    public string DamageTypeUrl { get; init; } = string.Empty;
    public string IconUrl { get; init; } = string.Empty;
    public string WatermarkUrl { get; init; } = string.Empty;
    public string SeasonIconUrl { get; init; } = string.Empty;
    public int SeasonYear { get; init; }
}