CREATE TABLE IF NOT EXISTS users (
id SERIAL PRIMARY KEY ,
username varchar(25) NOT NULL UNIQUE,
last_login timestamp Default now()
);

CREATE TABLE IF NOT EXISTS topics (
topic_id serial primary key ,
topic_name varchar(30) NOT NULL UNIQUE,
topic_dsc varchar(500),
topic_time timestamp default now(),
user_id INTEGER NOT NULL REFERENCES users(id)
);
CREATE TABLE IF NOT EXISTS posts(
posts_id serial primary key ,
user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
topic_id INTEGER NOT NULL REFERENCES topics(topic_id) ON DELETE CASCADE NOT
NULL,
posts_title varchar(100) not null ,
url TEXT ,
text_content TEXT ,
posts_time TIMESTAMP DEFAULT now(),
constraint only_one_null_content_url check (
(url is not null)::integer + (text_content is not null)::integer = 1
)
);
CREATE TABLE IF NOT EXISTS comments (
comments_id serial primary key,
parent_comment_id int REFERENCES comments(comments_id) ON DELETE CASCADE,
text_content TEXT NOT NULL,
comments_time timestamp default now(),
post_id INTEGER NOT NULL REFERENCES posts(posts_id) ON DELETE CASCADE,
user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
constraint comment_fk FOREIGN KEY (parent_comment_id) REFERENCES comments
(comments_id)
);

CREATE TYPE vote_type AS ENUM ('1', '0', '-1');
CREATE TABLE IF NOT EXISTS Votes (
id serial primary key,
vote vote_type DEFAULT '0',
post_id INTEGER NOT NULL REFERENCES posts(posts_id) ON DELETE CASCADE,
user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
constraint one_vote_per_user UNIQUE(post_id,user_id)
);

create index login

on users (last_login);
create index username
on users(username);
create index topic
on topics(topic_name);
create index post
on posts(posts_id);
create index post_title
on posts (posts_title);
create index post_time
on posts(posts_time);
create index url
on posts(url);
create index parent_comment
on comments(parent_comment_id);
create index vote
on votes(id);
