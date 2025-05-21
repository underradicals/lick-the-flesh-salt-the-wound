namespace Destiny2App.Client.WebApi.Features.Common;

public interface IRequestHandler<in TRequest, TResponse>
{
    Task<TResponse> Handler(TRequest request);
}