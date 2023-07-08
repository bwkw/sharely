-- +goose Up
CREATE TABLE invitations(
  id INT PRIMARY KEY AUTO_INCREMENT,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  group_id INT NOT NULL,
  created_at DATETIME,
  updated_at DATETIME,
  FOREIGN KEY (sender_id) REFERENCES users(id),
  FOREIGN KEY (receiver_id) REFERENCES users(id),
  FOREIGN KEY (group_id) REFERENCES `groups`(id)
);

-- +goose Down
DROP TABLE invitations;
