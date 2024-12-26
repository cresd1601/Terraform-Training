namespace Todo.API.Entities;

public class TodoEntity
{
    public int Id { get; set; }
    public string? Name { get; set; }
    public bool IsComplete { get; set; }
}