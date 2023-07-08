-- +goose Up
CREATE TABLE schedules(
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  start_datetime DATETIME NOT NULL,
  end_datetime DATETIME NOT NULL,
  is_repeated BOOLEAN NOT NULL,
  color INT NOT NULL,
  user_group_id INT NOT NULL,
  created_at DATETIME,
  updated_at DATETIME,
  FOREIGN KEY (user_group_id) REFERENCES user_group(id)
);

-- +goose Down
DROP TABLE schedules;
