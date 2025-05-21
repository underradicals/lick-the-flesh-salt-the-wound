namespace Destiny2App.Client.WebApi.Features.Common;

public interface IMediator<in TRequest, TResponse>
{
    Task<TResponse> Send(TRequest request);
}