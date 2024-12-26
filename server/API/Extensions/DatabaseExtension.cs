using Microsoft.EntityFrameworkCore;
using Todo.API.Contexts;

namespace Todo.API.Extensions
{
    public static class DbContextExtension
    {
        public static IServiceCollection AddDbContextConfig(this IServiceCollection services, IConfiguration configuration)
        {
            // Get connection string template from configuration
            var connectionString = configuration.GetConnectionString("DefaultConnection");

            if (string.IsNullOrEmpty(connectionString))
            {
                throw new ArgumentNullException(nameof(connectionString), "Connection string template is missing.");
            }

            // Declare and get environment variables
            var dbServer = Environment.GetEnvironmentVariable("DB_SERVER");
            var dbName = Environment.GetEnvironmentVariable("DB_NAME");
            var dbUser = Environment.GetEnvironmentVariable("DB_USER");
            var dbPassword = Environment.GetEnvironmentVariable("DB_PASSWORD");

            // Check for null values in environment variables
            if (string.IsNullOrEmpty(dbServer))
            {
                throw new ArgumentNullException(nameof(dbServer), "DB_SERVER environment variable is missing.");
            }

            if (string.IsNullOrEmpty(dbName))
            {
                throw new ArgumentNullException(nameof(dbName), "DB_NAME environment variable is missing.");
            }

            if (string.IsNullOrEmpty(dbUser))
            {
                throw new ArgumentNullException(nameof(dbUser), "DB_USER environment variable is missing.");
            }

            if (string.IsNullOrEmpty(dbPassword))
            {
                throw new ArgumentNullException(nameof(dbPassword), "DB_PASSWORD environment variable is missing.");
            }

            // Format the connection string
            connectionString = string.Format(connectionString, dbServer, dbName, dbUser, dbPassword);

            // Add the DbContext
            services.AddDbContext<TodoDbContext>(options => options.UseSqlServer(connectionString));

            return services;
        }

        public static void ApplyMigrations(this WebApplication app)
        {
            using var scope = app.Services.CreateScope();
            var services = scope.ServiceProvider;

            try
            {
                var context = services.GetRequiredService<TodoDbContext>();
                context.Database.Migrate();
            }
            catch (Exception ex)
            {
                var logger = services.GetRequiredService<ILogger<Program>>();
                logger.LogError(ex, "An error occurred while migrating the database.");
            }
        }
    }
}
