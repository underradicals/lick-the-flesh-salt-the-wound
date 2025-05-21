using Destiny2App.Client.WebApi.Features.Common;

namespace Destiny2App.Client.WebApi.Features.WeaponPage;

public class WeaponPageMediator : IMediator<WeaponPageQuery, WeaponPageResponse>
{
    private readonly IRequestHandler<WeaponPageQuery, WeaponPageResponse> _handler;

    public WeaponPageMediator(IRequestHandler<WeaponPageQuery, WeaponPageResponse> handler)
    {
        _handler = handler;
    }

    public async Task<WeaponPageResponse> Send(WeaponPageQuery request)
    {
        var response = await _handler.Handler(request);
        return response;
    }
}