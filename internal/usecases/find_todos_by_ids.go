package usecases

import (
	"context"
	"fmt"
	"github.com/Atplaceinc/atplace_api/internal/domain/entities"
	"github.com/Atplaceinc/atplace_api/internal/usecases/repository"
)

type FindTodosByIDsUseCase interface {
	Exec(ctx context.Context, todoIDs []entities.TodoID) ([]entities.Todo, error)
}

func NewFindTodosByIDsUseCase(repository repository.TodoRepository) FindTodosByIDsUseCase {
	return &findTodosByIDsInteractor{
		Repository: repository,
	}
}

type findTodosByIDsInteractor struct {
	Repository repository.TodoRepository
}

func (i *findTodosByIDsInteractor) Exec(ctx context.Context, todoIDs []entities.TodoID) ([]entities.Todo, error) {
	todos, err := i.Repository.FindTodoByIDs(ctx, todoIDs)
	if err != nil {
		return nil, fmt.Errorf("find todos by ids=%v: %w", todoIDs, err)
	}

	return todos, nil
}
