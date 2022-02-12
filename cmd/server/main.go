package main

import (
	_ "github.com/Atplaceinc/atplace_api/api"
	"github.com/Atplaceinc/atplace_api/internal/external/server"
)

// @license.name Atplace
// @title Atplace API
// @description This is Atplace server.
// @BasePath localhost:8080/
func main() {
	s := server.NewServer()
	s.Run()
}
