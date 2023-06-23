package main

import (
	"net/http"
	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	e.GET("/api/index", func(c echo.Context) error {
		return c.String(http.StatusOK, "hello")
	})

	e.Start(":8080")
}
