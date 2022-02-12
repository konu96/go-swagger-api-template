package infra

import (
	"fmt"
	"github.com/Atplaceinc/atplace_api/internal/external/database"
	"github.com/Atplaceinc/atplace_api/internal/interfaces/controllers/v1"
	"github.com/labstack/echo/v4"
)

func Run(e *echo.Echo) error {
	if err := setV1Routing(e); err != nil {
		return fmt.Errorf("server error: %w", err)
	}

	return nil
}

func setV1Routing(e *echo.Echo) error {
	v1MovieGroup := e.Group("/v1").Group("/todos")

	client, err := database.NewDatabase()
	if err != nil {
		return err
	}
	todoController := v1.NewTodoController(client)

	v1MovieGroup.GET("/details", func(context echo.Context) error {
		return todoController.Details(context)
	})

	return nil
}
