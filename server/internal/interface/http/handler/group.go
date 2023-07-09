package handler

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/bwkw/sharely/internal/usecase/usecase"
)

type GroupHandler struct {
	gu usecase.IGroupUsecase
}

func NewGroupHandler(e *echo.Echo, gu usecase.IGroupUsecase, baseURL string) {
	handler := &GroupHandler{
		gu: gu,
	}

	e.GET(baseURL+"/", handler.PostGroups)
	e.POST(baseURL+"/:groupId/invitation", handler.PostGroupsGroupIdInvitation)
}

func (h *GroupHandler) PostGroups(ctx echo.Context) error {
	return ctx.JSON(http.StatusOK, nil)
}

func (h *GroupHandler) PostGroupsGroupIdInvitation(ctx echo.Context) error {
	return ctx.JSON(http.StatusOK, nil)
}
