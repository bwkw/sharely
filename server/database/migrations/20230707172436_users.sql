-- +goose Up
CREATE TABLE users(
  id INT PRIMARY KEY AUTO_INCREMENT,
  sex INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  image VARCHAR(255),
  created_at DATETIME,
  updated_at DATETIME
);

-- +goose Down
DROP TABLE users;
