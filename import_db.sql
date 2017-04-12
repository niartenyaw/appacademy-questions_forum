DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(30) NOT NULL,
  lname VARCHAR(30) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Aaron', 'Wayne'),
  ('Jon', 'Jaffe'),
  ('Dallas', 'Hall'),
  ('Average', 'Joe');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('SQL issues', 'My Postgres is not working!', (SELECT id FROM users WHERE users.fname = 'Aaron')),
  ('Ruby issues', 'Ruby caused me to lose my humor', (SELECT id FROM users WHERE users.fname = 'Jon'));

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  ((SELECT id from questions WHERE questions.title = 'Ruby issues'), (SELECT id FROM users WHERE users.fname = 'Aaron')),
  ((SELECT id from questions WHERE questions.title = 'SQL issues'), (SELECT id FROM users WHERE users.fname = 'Dallas')),
  ((SELECT id from questions WHERE questions.title = 'SQL issues'), (SELECT id FROM users WHERE users.fname = 'Jon')),
  ((SELECT id from questions WHERE questions.title = 'Ruby issues'), (SELECT id FROM users WHERE users.fname = 'Dallas'));

INSERT INTO
  replies (question_id, parent_reply_id, user_id, body)
VALUES
  (
    (SELECT id from questions WHERE questions.title = 'Ruby issues'),
    NULL,
    (SELECT id FROM users WHERE users.fname = 'Average'),
    "I am answering your question"
  ),
  (
    (SELECT id from questions WHERE questions.title = 'Ruby issues'),
    1,
    (SELECT id FROM users WHERE users.fname = 'Aaron'),
    "I am answering your question"
  ),
  (
    (SELECT id from questions WHERE questions.title = 'SQL issues'),
    NULL,
    (SELECT id FROM users WHERE users.fname = 'Jon'),
    "SQL is hard, yo!"
  );

  INSERT INTO
    question_likes (user_id, question_id)
  VALUES
    (1,2),
    (1,1),
    (4,2),
    (3,2);
