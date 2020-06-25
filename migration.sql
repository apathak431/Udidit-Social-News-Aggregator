--------- Users --------------
insert into users (username)
select distinct username from
(
select distinct username from bad_posts
union
select distinct username from bad_comments
) userlist;
--------- Topics --------------
insert into topics(topic_name,user_id)
select
topic,

u.id
from bad_posts p
INNER JOIN users u
ON p.username=u.username
ON CONFLICT DO NOTHING;
--------- Posts --------------
insert into posts (posts_id,user_id,topic_id,posts_title,url,text_content)
select
p.id, u.id,t.topic_id, LEFT(title,100), url, text_content
from
bad_posts p
INNER JOIN users u
ON p.username=u.username
INNER JOIN topics t
ON u.id=t.user_id
ON CONFLICT DO NOTHING;
--------- Comments --------------
insert into comments (text_content,post_id,user_id)
select
c.text_content, p.user_id, u.id FROM bad_comments c
INNER JOIN users u
ON c.username = u.username
INNER JOIN posts p
ON u.id = p.user_id
ON CONFLICT DO NOTHING;
--------- Votes --------------
insert into votes (vote,post_id,user_id)
select
'1' as vote, upvote.id, u.id
FROM (
select
id,
regexp_split_to_table(upvotes, ',') as upvotes
from bad_posts
) upvote JOIN users u
ON upvotes = u.username

where upvote.id IN (select posts_id from posts)
ON CONFLICT DO NOTHING;
insert into votes (vote,post_id,user_id)
select
'-1' as vote, downvote.id, u.id FROM (
SELECT
id,
regexp_split_to_table(downvotes, ',') as downvotes
FROM bad_posts
) downvote JOIN Users u
ON downvotes = u.username
where downvote.id IN (select posts_id from posts)
ON CONFLICT DO NOTHING;
