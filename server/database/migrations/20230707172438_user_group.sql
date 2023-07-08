-- +goose Up
CREATE TABLE user_group(
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  group_id INT,
  created_at DATETIME,
  updated_at DATETIME,
  UNIQUE(user_id, group_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (group_id) REFERENCES `groups`(id)
);

-- +goose Down
DROP TABLE user_group;
