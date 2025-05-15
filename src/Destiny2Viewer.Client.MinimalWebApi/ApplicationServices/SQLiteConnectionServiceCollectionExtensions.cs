using Microsoft.Data.Sqlite;

namespace Destiny2App.Client.WebApi.ApplicationServices;

public static class SQLiteConnectionServiceCollectionExtensions
{
    public static IServiceCollection AddSQLiteServices(this IServiceCollection services, IConfiguration Configuration)
    {
        services.AddSingleton(ConfigureSqliteConnection(Configuration));
        return services;
    }

    private static Func<IServiceProvider, SqliteConnection> ConfigureSqliteConnection(IConfiguration Configuration)
    {
        return (IServiceProvider provider) =>
        {
            var connectionString = new SqliteConnectionStringBuilder(Configuration["ConnectionStrings:Sqlite"]!)
            {
                Mode = SqliteOpenMode.ReadWriteCreate,
                Pooling = true,
                Cache = SqliteCacheMode.Shared,
                ForeignKeys = true,
                DataSource = @"D:\Destiny2Viewer\destiny2.db"
            }.ToString();
            return new SqliteConnection(connectionString);
        };
    }
}