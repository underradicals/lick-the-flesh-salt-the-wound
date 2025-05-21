using Destiny2App.Client.WebApi.Features.Common;

namespace Destiny2App.Client.WebApi.Features.WeaponPage;

public record WeaponPageQuery : IQuery<WeaponPageResponse>
{
    public int PageSize { get; init; }
    public int PageNumber { get; init; }
}