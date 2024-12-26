using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

using Todo.API.Contexts;
using Todo.API.Entities;

namespace Todo.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TodoItemsController : ControllerBase
    {
        private readonly TodoDbContext _context;

        public TodoItemsController(TodoDbContext context)
        {
            _context = context;
        }

        // GET: api/TodoItems
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TodoEntity>>> GetTodos()
        {
            return await _context.Todos.ToListAsync();
        }

        // GET: api/TodoItems/complete
        [HttpGet("complete")]
        public async Task<ActionResult<IEnumerable<TodoEntity>>> GetCompleteTodos()
        {
            return await _context.Todos.Where(t => t.IsComplete).ToListAsync();
        }

        // GET: api/TodoItems/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TodoEntity>> GetTodoEntity(int id)
        {
            var todoEntity = await _context.Todos.FindAsync(id);

            if (todoEntity == null)
            {
                return NotFound();
            }

            return todoEntity;
        }

        // POST: api/TodoItems
        [HttpPost]
        public async Task<ActionResult<TodoEntity>> PostTodoEntity(TodoEntity todoEntity)
        {
            _context.Todos.Add(todoEntity);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetTodoEntity), new { id = todoEntity.Id }, todoEntity);
        }

        // PUT: api/TodoItems/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTodoEntity(int id, TodoEntity todoEntity)
        {
            if (id != todoEntity.Id)
            {
                return BadRequest();
            }

            var todo = await _context.Todos.FindAsync(id);

            if (todo == null)
            {
                return NotFound();
            }

            todo.Name = todoEntity.Name;
            todo.IsComplete = todoEntity.IsComplete;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/TodoItems/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTodoEntity(int id)
        {
            var todoEntity = await _context.Todos.FindAsync(id);
            if (todoEntity == null)
            {
                return NotFound();
            }

            _context.Todos.Remove(todoEntity);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
