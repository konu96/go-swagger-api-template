package interfaces

import (
	"net/http"
	"net/url"
)

type Context interface {
	JSON(code int, i interface{}) error
	QueryParam(name string) string
	QueryParams() url.Values
	Request() *http.Request
}
