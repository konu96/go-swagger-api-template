package schema

import (
	"entgo.io/ent"
)

// Todo : rename
type Todo struct {
	ent.Schema
}

func (Todo) Fields() []ent.Field {
	return []ent.Field{}
}

func (Todo) Edges() []ent.Edge {
	return []ent.Edge{}
}
