using Destiny2App.Client.WebApi.Features.Common;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;

namespace Destiny2App.Client.WebApi.Features.WeaponPage;

public class WeaponPageEndpoint
{
    public WeaponPageEndpoint(IEndpointRouteBuilder app)
    {
        app.MapGet("/weapons", Handle);
    }

    private async Task<Results<Ok<WeaponPageResponse>, BadRequest>> Handle([AsParameters] WeaponPageRequest request, [FromServices] IMediator<WeaponPageQuery, WeaponPageResponse> mediator)
    {
        var query = new WeaponPageQuery
        {
            PageSize = request.PageSize,
            PageNumber = request.PageNumber,
        };
        var response = await mediator.Send(query);
        return response.GetType().Name == nameof(WeaponPageResponse)
            ? TypedResults.Ok(response) 
            : TypedResults.BadRequest();
    }
}