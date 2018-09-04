DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;


-- USERS
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

INSERT INTO 
  users (fname, lname)

VALUES 
  ('Joe Joe', 'Williams'),
  ('John', 'Adams'),
  ('Gwen', 'Stefani');
-- USERS


-- QUESTIONS
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO 
  questions (title, body, author_id)

VALUES 
  ('Favorite color?', 'What is your fave color?', (SELECT id FROM users WHERE fname = 'Joe Joe' AND lname = 'Williams')), 
  ('Favorite food?', 'What is your fave food?', (SELECT id FROM users WHERE fname = 'John' AND lname = 'Adams')),  
  ('Favorite drink?', 'What is your fave drink?', (SELECT id FROM users WHERE fname = 'Gwen' AND lname = 'Stefani'));   

-- QUESTIONS


CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  users_id INTEGER NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (users_id) REFERENCES users(id)
);


-- REPLIES
CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  parent_id INTEGER,
  
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO 
  replies (body, question_id, author_id, parent_id)
  
VALUES 
 ('My fave color is red', 1, 1, null),
 ('My fave food is steak', 2, 2, null),
 ('My fave drink is whiskey', 3, 3, null),
 ('Thanks. I like steak too', 2, 2, 2);
-- REPLIES

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  users_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (users_id) REFERENCES users(id)
);
 






















