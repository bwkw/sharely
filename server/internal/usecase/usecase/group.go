package usecase

import (
	"context"

	"github.com/bwkw/sharely/internal/domain/models"
	repositoryinterface "github.com/bwkw/sharely/internal/domain/repository_interface"
	"github.com/volatiletech/null/v8"
)

type IGroupUsecase interface {
	CreateGroup(ctx context.Context, group *CreateGroupDTO) (models.Group, error)
}

type GroupUsecase struct {
	gr repositoryinterface.IGroupRepository
}

type CreateGroupDTO struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	Image       string `json:"image"`
	CreatorID   int    `json:"creator_id"`
}

func NewGroupUsecase(gr repositoryinterface.IGroupRepository) IGroupUsecase {
	return &GroupUsecase{
		gr: gr,
	}
}

func (g *GroupUsecase) CreateGroup(ctx context.Context, group *CreateGroupDTO) (models.Group, error) {
	groupEntity := &models.Group{
		Name:        group.Name,
		Description: null.StringFrom(group.Description),
		Image:       null.StringFrom(group.Image),
		CreatorID:   group.CreatorID,
	}
	return g.gr.CreateGroup(ctx, groupEntity)
}
