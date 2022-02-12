package v1

import (
	"fmt"
	"github.com/Atplaceinc/atplace_api/internal/domain/entities"
	"github.com/Atplaceinc/atplace_api/internal/external/database/schema/generated"
	"github.com/Atplaceinc/atplace_api/internal/interfaces"
	"github.com/Atplaceinc/atplace_api/internal/interfaces/repository"
	"strconv"

	"github.com/Atplaceinc/atplace_api/internal/usecases"
	"net/http"
)

type TodoController struct {
	findTodosByIDsUseCase usecases.FindTodosByIDsUseCase
}

func NewTodoController(client *generated.Client) TodoController {
	return TodoController{
		findTodosByIDsUseCase: usecases.NewFindTodosByIDsUseCase(repository.NewTodoRepository(client)),
	}
}

// Details
// @version 1.0
// @Summary TODO リストを返すエンドポイント
// @Description TODO ID のリストを受け取って、それらの情報を返すエンドポイント
// @Produce json
// @Param todo_ids query array true "todo_ids"
// @Param X-API-TOKEN header string true "X-API-TOKEN"
// @Success 200 {array} entities.Todo
// @Failure 400 {object} interfaces.HTTPError
// @Failure 500 {object} interfaces.HTTPError
// @Router /v1/todos/details [get]
// @id Details
func (controller *TodoController) Details(ctx interfaces.Context) error {
	queryParams := ctx.QueryParams()
	if len(queryParams) == 0 {
		return ctx.JSON(http.StatusOK, []entities.Todo{})
	}

	todoIDs := make([]entities.TodoID, 0, 0)
	for _, param := range queryParams {
		for _, todoID := range param {
			value, _ := strconv.Atoi(todoID)
			todoIDs = append(todoIDs, entities.TodoID(value))
		}
	}

	todos, err := controller.findTodosByIDsUseCase.Exec(ctx.Request().Context(), todoIDs)
	if err != nil {
		return &interfaces.HTTPError{
			Code:    http.StatusInternalServerError,
			Message: fmt.Sprintf("missing find todos todoIDs=%v: %s", todoIDs, err.Error()),
		}
	}

	return ctx.JSON(http.StatusOK, todos)
}
