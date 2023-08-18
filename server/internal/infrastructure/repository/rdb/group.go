package rdb

import (
	"context"
	"database/sql"
	"log"

	"github.com/bwkw/sharely/internal/domain/models"
	repositoryinterface "github.com/bwkw/sharely/internal/domain/repository_interface"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

type GroupRepository struct {
	DB *sql.DB
}

func NewGroupRepository(db *sql.DB) repositoryinterface.IGroupRepository {
	return &GroupRepository{
		DB: db,
	}
}

func (gr *GroupRepository) CreateGroup(ctx context.Context, group *models.Group) (models.Group, error) {
	err := group.Insert(ctx, gr.DB, boil.Infer())
	if err != nil {
		log.Println("Error creating group:", err)
	}
	return *group, err
}
