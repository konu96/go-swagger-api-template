//go:generate mockgen -source=todo_repository.go -destination mock/mock_repository.go

package repository

import (
	"context"
	"github.com/Atplaceinc/atplace_api/internal/domain/entities"
)

type TodoRepository interface {
	FindTodoByIDs(ctx context.Context, todoIDs []entities.TodoID) ([]entities.Todo, error)
}
