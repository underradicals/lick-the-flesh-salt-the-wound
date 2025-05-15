using System.Text.Json;
using Microsoft.Data.Sqlite;

namespace Destiny2Viewer.Client.MinimalWebApi.Ingestion.Repositories;

public interface ISQLiteRepository
{
    public Task CreateTable(string tableName);
    public Task DropTables(List<List<string>> tables);
    public Task BulkInsertAsync(JsonElement.ObjectEnumerator enumerator, string filename);
}

public class SQLiteRepository : ISQLiteRepository
{
    private readonly SqliteConnection _connection;
    private readonly ILogger<SQLiteRepository> _logger;

    public SQLiteRepository(SqliteConnection connection, ILogger<SQLiteRepository> logger)
    {
        _connection = connection;
        _logger = logger;
        _connection.Open();
    }


    public async Task DropTables(List<List<string>> tables)
    {
        var sql = "";
        foreach (var item in tables)
        {
            sql = string.Concat(sql, $"DROP TABLE IF EXISTS [{item[0].Split(".")[0]}];\n");
        }

        _logger.LogInformation($"Dropping tables");
        _logger.LogInformation(sql);
        var transaction = _connection.BeginTransaction();
        var command = _connection.CreateCommand();
        command.Transaction = (SqliteTransaction?)transaction;
        command.CommandText = sql;
        await command.ExecuteNonQueryAsync();
        await transaction.CommitAsync();
        await transaction.DisposeAsync();
    }

    public async Task BulkInsertAsync(JsonElement.ObjectEnumerator enumerator, string filename)
    {
        var transaction = await _connection.BeginTransactionAsync();
        var command = _connection.CreateCommand();


        command.CommandText = $@"
                                INSERT INTO [{filename}] (id, json) VALUES ($id, $json);
                              ";
        command.Transaction = (SqliteTransaction?)transaction;


        foreach (var item in enumerator)
        {
            var parameterId = command.CreateParameter();
            var parameterJson = command.CreateParameter();

            parameterId.ParameterName = "$id";
            parameterId.SqliteType = SqliteType.Integer;
            parameterId.Value = long.Parse(item.Name);

            parameterJson.ParameterName = "$json";
            parameterJson.SqliteType = SqliteType.Blob;
            parameterJson.Value = item.Value.GetRawText();

            command.Parameters.Clear();
            command.Parameters.Add(parameterId);
            command.Parameters.Add(parameterJson);

            await command.ExecuteNonQueryAsync();
        }

        await transaction.CommitAsync();
        _logger.LogInformation($"INSERT INTO [{filename}] (id, json) VALUES ($id, $json);");
    }

    public async Task CreateTable(string tableName)
    {
        var sql = $"""
                   CREATE TABLE IF NOT EXISTS [{tableName}] (
                       id integer not null primary key,
                       json jsonb not null
                   );
                   """;
        var transaction = await _connection.BeginTransactionAsync();
        var command = _connection.CreateCommand();
        command.Transaction = (SqliteTransaction?)transaction;
        command.CommandText = sql;
        await command.ExecuteNonQueryAsync();
        await transaction.CommitAsync();
        await transaction.DisposeAsync();
        _logger.LogInformation($"Created table {tableName}");
    }
}