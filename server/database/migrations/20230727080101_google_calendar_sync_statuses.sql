-- +goose Up
CREATE TABLE google_calendar_sync_statuses(
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  schedule_id INT NOT NULL,
  is_synced BOOLEAN NOT NULL,
  last_synced_at DATETIME,
  created_at DATETIME,
  updated_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (schedule_id) REFERENCES schedules(id),
  UNIQUE KEY (user_id, schedule_id)
);

-- +goose Down
DROP TABLE google_calendar_sync_statuses;
