using Microsoft.EntityFrameworkCore;

using Todo.API.Entities;

namespace Todo.API.Contexts;

public class TodoDbContext : DbContext
{
    public TodoDbContext(DbContextOptions<TodoDbContext> options) : base(options) { }

    public DbSet<TodoEntity> Todos => Set<TodoEntity>();
}