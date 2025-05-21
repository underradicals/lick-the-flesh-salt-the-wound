namespace Destiny2App.Client.WebApi.Features.WeaponPage;

public record WeaponPageRequest
{
    public int PageSize { get; init; } = 10;
    public int PageNumber { get; init; } = 1;
}