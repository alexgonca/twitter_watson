create view twitter_watson as
select
  substr(json_extract(twitter.response, '$.created_at'), 27, 4) || '-' ||
  case(substr(json_extract(twitter.response, '$.created_at'), 5, 3))
    when 'Jan' then '01'
    when 'Feb' then '02'
    when 'Mar' then '03'
    when 'Apr' then '04'
    when 'May' then '05'
    when 'Jun' then '06'
    when 'Jul' then '07'
    when 'Aug' then '08'
    when 'Sep' then '09'
    when 'Oct' then '10'
    when 'Nov' then '11'
	when 'Dec' then '12'
	else '00'
  end || '-' ||
  substr(json_extract(twitter.response, '$.created_at'), 9, 2) ||
  substr(json_extract(twitter.response, '$.created_at'), 11, 9) as tweeted_at,
  json_extract(twitter.response, '$.id_str') as tweet_id,
  json_extract(twitter.response, '$.text') as tweet_text,
  json_extract(twitter.response, '$.retweet_count') as retweet_count,
  json_extract(twitter.response, '$.favorite_count') as favorite_count,
  twitter.response as twitter_response,
  watson.response as watson_response,
  twitter.querytime as twitter_query_time,
  watson.querytime as watson_query_time
from
  Nodes as twitter,
  Nodes as watson
where
  twitter.objecttype = 'data' and
  twitter.querytype = 'Twitter:/statuses/user_timeline' and
  watson.objecttype = 'data' and
  watson.parent_id = twitter.id;

create view twitter_hashtag as
select
  tweeted_at,
  tweet_id,
  tweet_text,
  retweet_count,
  favorite_count,
  hashtag.value as hashtag
from
  twitter_watson,
  json_tree(twitter_response, '$.entities.hashtags') as hashtag
where
  hashtag.key = 'text'
order by
  tweet_id;

create view watson_keyword as
select
  tweeted_at,
  tweet_id,
  tweet_text,
  retweet_count,
  favorite_count,
  json_extract(keyword.value,'$.text') as keyword,
  json_extract(keyword.value,'$.relevance') as relevance,
  json_extract(keyword.value,'$.count') as count
from
  twitter_watson,
  json_tree(watson_response, '$.keywords') as keyword
where
  keyword.type = 'object'
order by
  tweet_id,
  relevance desc;

create view watson_entity as
select
  tweeted_at,
  tweet_id,
  tweet_text,
  retweet_count,
  favorite_count,
  json_extract(entity.value,'$.type') as type,
  json_extract(entity.value,'$.text') as entity,
  json_extract(entity.value,'$.relevance') as relevance,
  json_extract(entity.value,'$.count') as count,
  json_extract(entity.value,'$.confidence') as confidence
from
  twitter_watson,
  json_tree(watson_response, '$.entities') as entity
where
  entity.type = 'object'
order by
  tweet_id,
  relevance desc;

create view watson_concept as
select
  tweeted_at,
  tweet_id,
  tweet_text,
  retweet_count,
  favorite_count,
  json_extract(concept.value,'$.text') as concept,
  json_extract(concept.value,'$.relevance') as relevance,
  json_extract(concept.value,'$.dbpedia_resource') as dbpedia_resource
from
  twitter_watson,
  json_tree(watson_response, '$.concepts') as concept
where
  concept.type = 'object'
order by
  tweet_id,
  relevance desc;

create view watson_concept as
select
  tweeted_at,
  tweet_id,
  tweet_text,
  retweet_count,
  favorite_count,
  json_extract(concept.value,'$.text') as concept,
  json_extract(concept.value,'$.relevance') as relevance,
  json_extract(concept.value,'$.dbpedia_resource') as dbpedia_resource
from
  twitter_watson,
  json_tree(watson_response, '$.concepts') as concept
where
  concept.type = 'object'
order by
  tweet_id,
  relevance desc;

create view watson_sentiment as
select
  tweeted_at,
  tweet_id,
  tweet_text,
  retweet_count,
  favorite_count,
  json_extract(watson_response, '$.sentiment.document.label') as label,
  json_extract(watson_response, '$.sentiment.document.score') as score
from
  twitter_watson
order by
  tweet_id,
  score desc;