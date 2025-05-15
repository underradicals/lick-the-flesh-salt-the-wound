using System.Text.Json;
using Destiny2Viewer.Client.MinimalWebApi.Ingestion.Models;
using StackExchange.Redis;

namespace Destiny2Viewer.Client.MinimalWebApi.Ingestion.HttpClients;


public interface IManifestHttpClient
{
    Task<ManifestRoot> GetManifestAsync();

    public Task<CacheEntry> GetCachedEntry(string url);
    public Task<(HttpResponseMessage, CacheEntry)> SendHeadRequestAsync(string url, RedisValue cachedJson);
    public Task<HttpResponseMessage> GetAsync(string url);
}

public class ManifestHttpClient : IManifestHttpClient
{
    private readonly IHttpClientFactory _httpClientFactory;

    public ManifestHttpClient(IHttpClientFactory httpClientFactory)
    {
        _httpClientFactory = httpClientFactory;
    }

    public async Task<ManifestRoot> GetManifestAsync()
    {
        var client = _httpClientFactory.CreateClient("ManifestClient");
        try
        {
            var r = await client.GetAsync("/Platform/Destiny2/Manifest/");
            r.EnsureSuccessStatusCode();
            var j = await r.Content.ReadAsStringAsync();
            var jsonResponse = JsonSerializer.Deserialize<ManifestRoot>(j);
            return jsonResponse!;
        }
        catch (Exception e) when (e is HttpRequestException or TaskCanceledException or UriFormatException)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    public async Task<(HttpResponseMessage, CacheEntry)> SendHeadRequestAsync(string url, RedisValue cachedJson)
    {
        var client = _httpClientFactory.CreateClient("ManifestClient");
        try
        {
            var headRequest = new HttpRequestMessage(HttpMethod.Head, url);
            var cachedEntry = JsonSerializer.Deserialize<CacheEntry>(cachedJson!); 
            headRequest.Headers.IfModifiedSince = DateTimeOffset.Parse(cachedEntry!.LastModified); 
            return (await client.SendAsync(headRequest), cachedEntry); 
        }
        catch (Exception e) when (e is HttpRequestException or TaskCanceledException or UriFormatException or JsonException or NotSupportedException)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    public async Task<HttpResponseMessage> GetAsync(string url)
    {
        try
        {
            var client = _httpClientFactory.CreateClient("ManifestClient");
            var response = await client.GetAsync(url);
            response.EnsureSuccessStatusCode();
            return response;
        }
        catch (Exception e) when (e is HttpRequestException or TaskCanceledException or UriFormatException)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    public async Task<CacheEntry> GetCachedEntry(string url)
    {
        var response = await GetAsync(url);
        var content = await response.Content.ReadAsStringAsync();
        var lastModifiedString = response.Content.Headers.LastModified.ToString()!;
        return new CacheEntry
        {
            Data = content,
            LastModified = lastModifiedString,
            Expires = DateTime.UtcNow.AddDays(7).ToLongDateString(),
            ContentType = response.Content.Headers.ContentType?.ToString()!,
            ContentLength = content.Length.ToString() 
        }; 
    }
}