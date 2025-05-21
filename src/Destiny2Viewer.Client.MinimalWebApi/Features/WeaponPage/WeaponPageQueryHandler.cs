using Destiny2App.Client.WebApi.Features.Common;

namespace Destiny2App.Client.WebApi.Features.WeaponPage;

public class WeaponPageQueryHandler : IRequestHandler<WeaponPageQuery, WeaponPageResponse>
{
    private readonly IWeaponPageRepository _repository;

    public WeaponPageQueryHandler(IWeaponPageRepository repository)
    {
        _repository = repository;
    }

    public async Task<WeaponPageResponse> Handler(WeaponPageQuery request)
    {
        List<WeaponResponse> responseList = [];
        var totalCount = await _repository.GetTotalCount();
        var totalPageCount = (int)Math.Ceiling(totalCount / (double)request.PageSize);
        var offset = (request.PageNumber - 1) * request.PageSize;
        var weaponList = await _repository.GetPage(offset, request.PageSize);
        foreach (var item in weaponList)
        {
            responseList.Add(new WeaponResponse
            {
                Id = item.Id,
                Name = item.Name,
                DisplayName = item.DisplayName,
                TierType = item.TierType,
                DamageTypeUrl = item.DamageTypeUrl,
                IconUrl = item.IconUrl,
                WatermarkUrl = item.WatermarkUrl,
                SeasonIconUrl = item.SeasonIconUrl,
                SeasonYear = item.SeasonYear
            });
        }
        return new WeaponPageResponse
        {
            PageSize = request.PageSize,
            PageNumber = request.PageNumber,
            TotalItemCount = totalCount,
            TotalPageCount = totalPageCount,
            NextPage = request.PageNumber < totalPageCount
                ? $"/weapons?pageSize={request.PageSize}&pageNumber={request.PageNumber + 1}"
                : null,
            PreviousPage = request.PageNumber > 1
                ? $"/weapons?pageSize={request.PageSize}&pageNumber={request.PageNumber - 1}"
                : null,
            Data = responseList,
        };
    }
}