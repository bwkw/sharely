-- +goose Up
-- users
INSERT INTO users(sex, name, email, password, image) VALUES
(1, 'John Doe', 'john@example.com', 'hashed_password1', 'image_url1'),
(2, 'Jane Doe', 'jane@example.com', 'hashed_password2', 'image_url2');

-- groups
INSERT INTO `groups`(name, description, image, creator_id) VALUES
('Group1', 'This is group 1', 'group_image_url1', 1),
('Group2', 'This is group 2', 'group_image_url2', 2);

-- user_group
INSERT INTO user_group(user_id, group_id) VALUES
(1, 1),
(2, 2);

-- schedules
INSERT INTO schedules(title, description, start_datetime, end_datetime, is_repeated, is_shared_to_gc, color, user_id, group_id) VALUES
('Schedule1', 'This is schedule 1', NOW(), DATE_ADD(NOW(), INTERVAL 1 HOUR), false, false, 1, 1, 1),
('Schedule2', 'This is schedule 2', NOW(), DATE_ADD(NOW(), INTERVAL 2 HOUR), false, false, 2, 2, 2);

-- invitations
INSERT INTO invitations(sender_id, receiver_id, group_id) VALUES
(1, 2, 1),
(2, 1, 2);

-- +goose Down
DELETE FROM invitations;
DELETE FROM schedules;
DELETE FROM user_group;
DELETE FROM `groups`;
DELETE FROM users;
