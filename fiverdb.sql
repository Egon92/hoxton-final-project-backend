CREATE TABLE `employee` (
  `id` int PRIMARY KEY,
  `username` string,
  `full_name` stirng,
  `email` string,
  `avatar` stirng,
  `phone` int,
  `address` stirng,
  `bio` string
);

CREATE TABLE `employer` (
  `id` int PRIMARY KEY,
  `username` string,
  `full_name` stirng,
  `email` string,
  `avatar` stirng,
  `phone` int,
  `address` stirng,
  `bio` string
);

CREATE TABLE `category` (
  `id` int PRIMARY KEY,
  `category_name` string,
  `category_logo` string
);

CREATE TABLE `project` (
  `id` int PRIMARY KEY,
  `price` int,
  `deadline` date,
  `title` string,
  `overview` string,
  `description` string,
  `status` boolean,
  `employee_id` int,
  `employer_id` int,
  `category_id` int
);

CREATE TABLE `bids` (
  `id` int PRIMARY KEY,
  `project_id` int,
  `bids` int,
  `employee_id` int
);

CREATE TABLE `reviews` (
  `id` integer,
  `text` text,
  `project_id` int,
  `employee_id` int,
  `dateCreated` text
);

CREATE TABLE `conversations` (
  `id` int PRIMARY KEY,
  `participantId` int,
  `employee_id` int,
  `employer_id` int
);

CREATE TABLE `chat` (
  `id` int,
  `messageText` string,
  `employee_id` int,
  `conversations` int,
  `employer_id` int
);

ALTER TABLE `employee` ADD FOREIGN KEY (`id`) REFERENCES `project` (`employee_id`);

ALTER TABLE `employer` ADD FOREIGN KEY (`id`) REFERENCES `project` (`employer_id`);

ALTER TABLE `category` ADD FOREIGN KEY (`id`) REFERENCES `project` (`category_id`);

ALTER TABLE `bids` ADD FOREIGN KEY (`project_id`) REFERENCES `project` (`id`);

ALTER TABLE `employee` ADD FOREIGN KEY (`id`) REFERENCES `bids` (`employee_id`);

ALTER TABLE `reviews` ADD FOREIGN KEY (`project_id`) REFERENCES `project` (`id`);

ALTER TABLE `reviews` ADD FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`);

ALTER TABLE `conversations` ADD FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`);

ALTER TABLE `employer` ADD FOREIGN KEY (`id`) REFERENCES `conversations` (`employer_id`);

ALTER TABLE `chat` ADD FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`);

ALTER TABLE `chat` ADD FOREIGN KEY (`conversations`) REFERENCES `conversations` (`id`);

ALTER TABLE `employer` ADD FOREIGN KEY (`id`) REFERENCES `chat` (`employer_id`);
