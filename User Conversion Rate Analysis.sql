-- Counting the number of users in each type of behavior
select behavior_type,
count(distinct user_id) user_num 
from temp_behavior
group by behavior_type
order by behavior_type desc;

-- Save the results
create table behavior_user_num(
behavior_type varchar(5),
user_num int);

insert into behavior_user_num
select behavior_type,
count(distinct user_id) user_num 
from user_behavior
group by behavior_type
order by behavior_type desc;

select * from behavior_user_num

select 6870/9967

-- Statistics on the number of each type of behavior
select behavior_type,
count(*) user_num 
from temp_behavior
group by behavior_type
order by behavior_type desc;

-- Save the results
create table behavior_num(
behavior_type varchar(5),
behavior_count_num int);

insert into behavior_num
select behavior_type,
count(*) behavior_count_num 
from user_behavior
group by behavior_type
order by behavior_type desc;

select * from behavior_num

select 20885/922124 -- bought rate

select (28879+56895)/922124 -- fav_cart_rate