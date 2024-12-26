using Todo.API.Extensions;

var builder = WebApplication.CreateBuilder(args);

// Configure services
builder.Services.AddDbContextConfig(builder.Configuration);
builder.Services.AddDatabaseDeveloperPageExceptionFilter(); // Add database developer page exception filter
builder.Services.AddControllers(); // Add controller services
builder.Services.AddEndpointsApiExplorer(); // Add endpoints API explorer
builder.Services.AddSwaggerGen(); // Add Swagger for API documentation

var app = builder.Build();

// Apply database migrations during application startup
app.ApplyMigrations();

// Use HTTPS redirection
app.UseHttpsRedirection(); // Redirect HTTP requests to HTTPS

// Enable Swagger in development environment
app.UseSwagger();
app.UseSwaggerUI();

// Use authorization middleware
app.UseAuthorization();
app.MapControllers(); // Map controller routes

app.Run(); // Run the application
