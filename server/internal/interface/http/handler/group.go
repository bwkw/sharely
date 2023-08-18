package handler

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/volatiletech/null/v8"

	"github.com/bwkw/sharely/internal/usecase/usecase"
)

type GroupHandler struct {
	gu usecase.IGroupUsecase
}

func NewGroupHandler(e *echo.Echo, gu usecase.IGroupUsecase, baseURL string) {
	handler := &GroupHandler{
		gu: gu,
	}

	e.POST(baseURL+"/", handler.CreateGroup)
	e.POST(baseURL+"/:groupId/invitation", handler.PostGroupsGroupIDInvitation)
}

type GroupResponse struct {
	ID          int         `json:"id"`
	Name        string      `json:"name"`
	Description null.String `json:"description"`
	Image       null.String `json:"image"`
	CreatorID   int         `json:"creator_id"`
	CreatedAt   null.Time   `json:"created_at"`
	UpdatedAt   null.Time   `json:"updated_at"`
}

func (h *GroupHandler) CreateGroup(ctx echo.Context) error {
	var group usecase.CreateGroupDTO
	if err := ctx.Bind(&group); err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]string{"error": "Invalid data"})
	}

	resultGroup, err := h.gu.CreateGroup(ctx.Request().Context(), &group)
	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	}

	response := &GroupResponse{
		ID:          resultGroup.ID,
		Name:        resultGroup.Name,
		Description: resultGroup.Description,
		Image:       resultGroup.Image,
		CreatorID:   resultGroup.CreatorID,
		CreatedAt:   resultGroup.CreatedAt,
		UpdatedAt:   resultGroup.UpdatedAt,
	}

	return ctx.JSON(http.StatusOK, response)
}

func (h *GroupHandler) PostGroupsGroupIDInvitation(ctx echo.Context) error {
	return ctx.JSON(http.StatusOK, nil)
}
