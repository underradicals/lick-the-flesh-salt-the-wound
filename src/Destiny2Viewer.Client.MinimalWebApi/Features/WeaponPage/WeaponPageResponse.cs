namespace Destiny2App.Client.WebApi.Features.WeaponPage;

public record WeaponPageResponse
{
    public int PageSize { get; init; } = 10;
    public int PageNumber { get; init; } = 1;
    public double TotalPageCount { get; init; }
    public long TotalItemCount { get; init; }
    public string? NextPage { get; init; } = string.Empty;
    public string? PreviousPage { get; init; } = string.Empty;
    public List<WeaponResponse> Data { get; init; } = null!;
};