namespace Destiny2App.Client.WebApi.Features.WeaponPage;

public interface IWeaponPageRepository
{
    public Task<long> GetTotalCount();
    public Task<List<WeaponEntity>> GetPage(int offset, int pageSize);
}