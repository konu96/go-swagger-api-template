package entities

type TodoID int

func NewTodo(id TodoID) Todo {
	return Todo{ID: id}
}

func NewTodos(ids []TodoID) []Todo {
	todos := make([]Todo, 0, len(ids))
	for _, id := range ids {
		todos = append(todos, NewTodo(id))
	}

	return todos
}

type Todo struct {
	ID TodoID `json:"id" form:"id" example:"1"`
} // @name TodoElement
