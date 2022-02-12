package repository

import (
	"context"
	"fmt"
	"github.com/Atplaceinc/atplace_api/internal/domain/entities"
	"github.com/Atplaceinc/atplace_api/internal/external/database/schema/generated"
	"github.com/Atplaceinc/atplace_api/internal/external/database/schema/generated/todo"
)

type TodoRepository struct {
	client *generated.Client
}

func NewTodoRepository(
	client *generated.Client,
) *TodoRepository {
	return &TodoRepository{client: client}
}

func (r *TodoRepository) FindTodoByIDs(ctx context.Context, todoIDs []entities.TodoID) ([]entities.Todo, error) {
	ids := make([]int, 0, len(todoIDs))
	for _, todoID := range todoIDs {
		ids = append(ids, int(todoID))
	}

	_, err := r.client.Todo.
		Query().
		Where(todo.IDIn(ids...)).All(ctx)
	if err != nil {
		return nil, fmt.Errorf("find todos: %w", err)
	}

	entTodo := entities.NewTodos(todoIDs)

	return entTodo, nil
}
