-- +goose Up
CREATE TABLE user_group(
  user_id INT NOT NULL,
  group_id INT NOT NULL,
  created_at DATETIME,
  updated_at DATETIME,
  PRIMARY KEY (user_id, group_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (group_id) REFERENCES `groups`(id)
);

-- +goose Down
DROP TABLE user_group;
