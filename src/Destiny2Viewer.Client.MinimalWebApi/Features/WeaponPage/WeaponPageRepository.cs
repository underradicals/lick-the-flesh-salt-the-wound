using Microsoft.Data.Sqlite;

namespace Destiny2App.Client.WebApi.Features.WeaponPage;

public class WeaponPageRepository : IWeaponPageRepository
{
    public async Task<long> GetTotalCount()
    {
        var connectionString= new SqliteConnectionStringBuilder()
        {
            Mode = SqliteOpenMode.ReadWriteCreate,
            Pooling = true,
            Cache = SqliteCacheMode.Shared,
            ForeignKeys = true,
            DataSource = @"D:\Destiny2Viewer\d2.db"
        }.ToString();
        await using var connection = new SqliteConnection(connectionString);
        await connection.OpenAsync();
        var transaction = await connection.BeginTransactionAsync();
        var command = connection.CreateCommand();
        
        command.Transaction = (SqliteTransaction?)transaction;
        command.CommandText = @"
                            select count(*) from Weapons;";
        var result = await command.ExecuteScalarAsync();
        await transaction.CommitAsync();
        return (long)result!;
    }
    
    public async Task<List<WeaponEntity>> GetPage(int offset, int pageSize)
    {
        List<WeaponEntity> weapons = [];
        var connectionString= new SqliteConnectionStringBuilder()
        {
            Mode = SqliteOpenMode.ReadWriteCreate,
            Pooling = true,
            Cache = SqliteCacheMode.Shared,
            ForeignKeys = true,
            DataSource = @"D:\Destiny2Viewer\d2.db"
        }.ToString();
        await using var connection = new SqliteConnection(connectionString);
        await connection.OpenAsync();
        var transaction = await connection.BeginTransactionAsync();
        var command = connection.CreateCommand();
        
        command.Transaction = (SqliteTransaction?)transaction;
        command.CommandText = @"
                            select 
                            id, name, display_name, tier_type, damage_type_url, icon_url, watermark_url, season_icon, year
                            from Weapons order by id limit $limit offset $offset;";

        var cursorParam = command.CreateParameter();
        cursorParam.ParameterName = "$offset";
        cursorParam.SqliteType = SqliteType.Integer;
        cursorParam.Value = offset;
        
        var limitParam = command.CreateParameter();
        limitParam.ParameterName = "$limit";
        limitParam.SqliteType = SqliteType.Integer;
        limitParam.Value = pageSize;
        
        command.Parameters.Clear();
        command.Parameters.Add(cursorParam);
        command.Parameters.Add(limitParam);

        await using var reader = await command.ExecuteReaderAsync();
        while (reader.Read())
        {
            var id = reader.GetInt64(reader.GetOrdinal("id"));
            var name = GetSafeString("name", reader);
            var displayName = GetSafeString("display_name", reader);
            var tierType = GetSafeString("tier_type", reader);
            var damageTypeUrl = GetSafeString("damage_type_url", reader);
            var iconUrl = GetSafeString("icon_url", reader);
            var watermarkUrl = GetSafeString("watermark_url", reader);
            var seasonIconUrl = GetSafeString("season_icon", reader);
            int year = GetSafeInt("year", reader);
            
            weapons.Add(new WeaponEntity
            {
                Id = id,
                Name = name!,
                DisplayName = displayName!,
                TierType = tierType!,
                DamageTypeUrl = damageTypeUrl!,
                IconUrl = iconUrl!,
                WatermarkUrl = watermarkUrl!,
                SeasonIconUrl = seasonIconUrl!,
                SeasonYear = year
            });
        }
        await transaction.CommitAsync();
        return weapons;
    }

    private string? GetSafeString(string? value, SqliteDataReader reader)
    {
        return value != null && reader.IsDBNull(reader.GetOrdinal(value)) ? null : reader.GetString(reader.GetOrdinal(value!));
    }
    
    private int GetSafeInt(string? value, SqliteDataReader reader)
    {
        return value != null && reader.IsDBNull(reader.GetOrdinal(value)) ? 0 : reader.GetInt32(reader.GetOrdinal(value!));
    }
}