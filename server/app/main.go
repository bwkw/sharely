package main

import (
	"database/sql"

	"github.com/bwkw/sharely/internal/infrastructure/repository/rdb"
	"github.com/bwkw/sharely/internal/interface/http/handler"
	"github.com/bwkw/sharely/internal/usecase/usecase"
	_ "github.com/go-sql-driver/mysql"
	"github.com/labstack/echo/v4"
)

func main() {
	db, err := sql.Open("mysql", "sharely:testtest@tcp(db:3306)/sharely")
	if err != nil {
		panic(err)
	}

	e := echo.New()

	GROUP_BASE_URL := "api/groups"
	gr := rdb.NewGroupRepository(db)
	gu := usecase.NewGroupUsecase(gr)

	handler.NewGroupHandler(e, gu, GROUP_BASE_URL)

	e.Logger.Info("Server is running at http://localhost:8080")
	e.Logger.Fatal(e.Start(":8080"))
}
