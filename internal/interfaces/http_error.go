package interfaces

type HTTPError struct {
	Code    int    `json:"-"`
	Message string `json:"message" example:"error message"`
} // @name HTTPError

func (h HTTPError) Error() string {
	return h.Message
}
