package repositoryinterface

import (
	"context"

	"github.com/bwkw/sharely/internal/domain/models"
)

type IGroupRepository interface {
	CreateGroup(ctx context.Context, group *models.Group) (models.Group, error)
}
