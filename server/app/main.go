package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/bwkw/calendar"
)

type Server struct{}

func (s *Server) PostGroups(ctx echo.Context) error {
	return ctx.JSON(http.StatusOK, "PostGroups called")
}

func main() {
	e := echo.New()
	server := &Server{}

	calendar.RegisterHandlers(e, server)

	e.Logger.Fatal(e.Start(":8080"))
}
