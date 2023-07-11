package main_test

import (
	"bytes"
	"context"
	"database/sql"
	"net/http/httptest"
	"testing"

	"github.com/bwkw/sharely/internal/infrastructure/repository/rdb"
	"github.com/bwkw/sharely/internal/interface/http/handler"
	"github.com/bwkw/sharely/internal/usecase/usecase"
	"github.com/getkin/kin-openapi/openapi3filter"
	_ "github.com/go-sql-driver/mysql"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/require"
)

func setup() (*echo.Echo, error) {
	db, err := sql.Open("mysql", "calendar:testtest@/calendar_test")
	if err != nil {
		return nil, err
	}

	e := echo.New()

	GROUP_BASE_URL := "api/groups"
	gr := rdb.NewGroupRepository(db)
	gu := usecase.NewGroupUsecase(gr)

	handler.NewGroupHandler(e, gu, GROUP_BASE_URL)

	return e, nil
}

func makeTestRequest(e *echo.Echo, method, path string, body []byte) error {
	req := httptest.NewRequest(method, path, bytes.NewReader(body))
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	c.Echo().ServeHTTP(rec, req)
	e.Router().Find(method, path, c)
	c.Handler()(c)

	requestValidationInput := &openapi3filter.RequestValidationInput{
		Request: req,
	}

	responseValidationInput := &openapi3filter.ResponseValidationInput{
		RequestValidationInput: requestValidationInput,
		Status:                 rec.Code,
		Header:                 rec.HeaderMap,
	}
	responseValidationInput.SetBodyBytes(rec.Body.Bytes())

	return openapi3filter.ValidateResponse(context.Background(), responseValidationInput)
}

func TestRequest(t *testing.T) {
    e, err := setup()
    require.NoError(t, err)

    err = makeTestRequest(e, "GET", "/api/groups", nil)
    require.NoError(t, err)
}
