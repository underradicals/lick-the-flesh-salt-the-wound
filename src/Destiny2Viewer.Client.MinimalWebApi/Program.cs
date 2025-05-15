using Destiny2App.Client.WebApi.ApplicationServices;
using Destiny2App.Client.WebApi.ApplicationServices.ConfigurationSecrets;
using Destiny2Viewer.Client.MinimalWebApi.Ingestion;

var builder = WebApplication.CreateBuilder(args);
var Configuration = builder.Configuration;

builder.Services.BindConfiguration<ConnectionStrings>(Configuration, ConnectionStrings.SectionName);
// builder.Services.Configure<ConnectionStrings>(Configuration.GetSection(ConnectionStrings.SectionName));
// builder.Services.AddSingleton<ConnectionStrings>(services => services.GetRequiredService<IOptions<ConnectionStrings>>().Value);

// Hangfire
// builder.Services.AddHangfire(x =>
// {
//     x.UseSimpleAssemblyNameTypeSerializer()
//         .UseRecommendedSerializerSettings()
//         .UseSQLiteStorage(Configuration["ConnectionStrings:Hangfire"], new SQLiteStorageOptions
//         {
//             PrepareSchemaIfNecessary = true,
//         });
// });
// builder.Services.AddHangfireServer(x =>
// {
//     x.SchedulePollingInterval = TimeSpan.FromSeconds(10);
// });

builder.Services.AddManifestHttpClient(Configuration);
builder.Services.AddSQLiteServices(Configuration);
builder.Services.AddRedisConnectionMultiplexer(Configuration);

builder.Services.AddSingletonServices();
builder.Services.AddTransientServices();

builder.Services.AddOpenApi();

var app = builder.Build();

// app.UseHangfireDashboard(
//     pathMatch: "/hangfire",
//     new DashboardOptions
//     {
//         DashboardTitle = "Destiny 2 Viewer"
//     });

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.MapGet("/job", () => "Hello World!")
    .WithName("Hangfire");

app.Run();