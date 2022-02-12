package database

import (
	"fmt"
	"github.com/Atplaceinc/atplace_api/internal/config/env"
	"github.com/Atplaceinc/atplace_api/internal/external/database/schema/generated"
	_ "github.com/go-sql-driver/mysql"
)

func NewDatabase() (*generated.Client, error) {
	e := env.Get()
	client, err := generated.Open(
		"mysql", e.DBUser+":"+e.DBPassword+"@tcp("+e.DBHost+":"+e.DBPort+")/"+e.DBName+"?parseTime=true",
	)
	if err != nil {
		return nil, fmt.Errorf("failed to open database connection: %w", err)
	}

	if env.Get().GoEnv == "development" {
		client = client.Debug()
	}

	return client, nil
}
