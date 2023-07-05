package group

import (
	"github.com/labstack/echo/v4"
	"net/http"
)

type GroupHandler struct {
	gusecase group.IGroupUsecase
}

func NewGroupHandler(e *echo.Echo, gu group.IGroupUsecase, baseURL string) {
	handler := &GroupHandler{
		GUsecase: gu,
	}

	e.POST(baseURL+"/groups", handler.PostGroups)
	e.POST(baseURL+"/groups/:groupId/invitation", handler.PostGroupsGroupIdInvitation)
}

func (h *GroupHandler) PostGroups(ctx echo.Context) error {
	return ctx.JSON(http.StatusOK, nil)
}

func (h *GroupHandler) PostGroupsGroupIdInvitation(ctx echo.Context) error {
	return ctx.JSON(http.StatusOK, nil)
}
