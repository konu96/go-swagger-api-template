package server

import (
	"github.com/Atplaceinc/atplace_api/internal/infra"
	"github.com/Atplaceinc/atplace_api/internal/interfaces"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	echoSwagger "github.com/swaggo/echo-swagger"
	"net/http"
	"os"
)

type server struct{}

func NewServer() *server {
	return &server{}
}

func (s *server) Run() error {
	e := echo.New()
	e.HTTPErrorHandler = jsonHTTPErrorHandler

	if err := infra.Run(e); err != nil {
		return err
	}

	setAPIAuthentication(e)
	setSwagger(e)

	e.GET("/healthz", func(context echo.Context) error {
		return context.JSON(http.StatusOK, "ok")
	})

	e.Logger.Fatal(e.Start(":8080"))

	return nil
}

func setAPIAuthentication(e *echo.Echo) {
	e.Use(middleware.KeyAuthWithConfig(middleware.KeyAuthConfig{
		KeyLookup: "header:X-API-TOKEN",
		Validator: func(apiToken string, c echo.Context) (bool, error) {
			return apiToken == os.Getenv("API_TOKEN"), nil
		},
	}))
}

func setSwagger(e *echo.Echo) {
	e.GET("/swagger/*", echoSwagger.WrapHandler)
	e.Static("/api/swagger.yaml", "api/swagger.yaml")
}

func jsonHTTPErrorHandler(err error, c echo.Context) {
	code := http.StatusInternalServerError
	msg := http.StatusText(code)
	if he, ok := err.(*interfaces.HTTPError); ok {
		code = he.Code
		msg = he.Message
	}
	if !c.Response().Committed {
		c.JSON(code, map[string]interface{}{
			"statusCode": code,
			"message":    msg,
		})
	}
}
