-- +goose Up
CREATE TABLE `groups`(
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  image VARCHAR(255),
  creator_id INT NOT NULL,
  created_at DATETIME,
  updated_at DATETIME,
  FOREIGN KEY (creator_id) REFERENCES users(id)
);

-- +goose Down
DROP TABLE `groups`;
