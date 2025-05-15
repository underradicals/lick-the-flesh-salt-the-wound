using System.Security.Cryptography;
using System.Text;

namespace Destiny2App.Client.WebApi.Helpers;

public interface ICryptography
{
    public string Hash(string cacheKey);
}

public class Cryptography : ICryptography
{
    public string Hash(string cacheKey)
    {
        var stringBuilder = new StringBuilder();
        var hashBytes = SHA256.HashData(Encoding.UTF8.GetBytes(cacheKey));
        foreach (var t in hashBytes)
        {
            stringBuilder.Append(t.ToString("X2"));
        }
        return stringBuilder.ToString();
    }
}