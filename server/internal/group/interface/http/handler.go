package http

import (
	"github.com/labstack/echo/v4"
	"net/http"
)

type GroupHandler struct {
	GUsecase usecase.Usecase
}

func NewGroupHandler(router EchoRouter, si GroupServerInterface, baseURL string) {
	handler := &GroupHandler{
		Handler: si,
	}

	router.POST(baseURL+"/groups", handler.PostGroups)
	router.POST(baseURL+"/groups/:groupId/invitation", handler.PostGroupsGroupIdInvitation)
}

func (h *GroupHandler) PostGroups(ctx echo.Context) error {
	return ctx.JSON(http.StatusOK, nil)
}

func (h *GroupHandler) PostGroupsGroupIdInvitation(ctx echo.Context, groupId int) error {
	return ctx.JSON(http.StatusOK, nil)
}
