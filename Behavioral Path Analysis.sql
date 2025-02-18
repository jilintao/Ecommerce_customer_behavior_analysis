create view user_behavior_view as

select user_id,item_id,
count(if(behavior_type='pv',behavior_type,null)) 'pv',
count(if(behavior_type='fav',behavior_type,null)) 'fav',
count(if(behavior_type='cart',behavior_type,null)) 'cart',
count(if(behavior_type='buy',behavior_type,null)) 'buy'
from temp_behavior
group by user_id,item_id


-- Standardization of user behavior
create view user_behavior_standard as
select user_id,
item_id,
(case when pv>0 then 1 else 0 end) viewd,
(case when fav>0 then 1 else 0 end) Favorited,
(case when cart>0 then 1 else 0 end) carted,
(case when buy>0 then 1 else 0 end) bought
from user_behavior_view

-- Path type
create view user_behavior_path as
select *,
concat(viewd,Favorited,carted,bought) Bought_path_type
from user_behavior_standard as a 
where a.bought >0

-- Statistics on the number of purchase paths in each category
create view path_count as 
select Bought_path_type,
count(*) amount
from user_behavior_path
group by Bought_path_type
order by amount desc

-- Interpretation of path number
create table interpretation(
path_type char(4),
description varchar(40));

insert into interpretation
values('0001','buy_directly'),
('1001','buy_after_view'),
('0011','buy_after_carted'),
('1011','buy_after_view_carted'),
('0101','buy_after_fav'),
('1101','buy_after_view_fav'),
('0111','buy_after_fav_carted'),
('1111','buy_after_view_fav_carted')

select * from interpretation

select * from path_count p
join interpretation i 
on p.Bought_path_type = i.path_type
order by amount desc

-- Save results

-- 
create table path_result(
path_type char(4),
description varchar(40),
num int);

-- In order to reuse the code, we need need to delete the views we created before
drop view user_behavior_view;
drop view user_behavior_standard;
drop view user_behavior_path;
drop view path_count;

create view user_behavior_view as
select user_id,item_id
,count(if(behavior_type='pv',behavior_type,null)) 'pv'
,count(if(behavior_type='fav',behavior_type,null)) 'fav'
,count(if(behavior_type='cart',behavior_type,null)) 'cart'
,count(if(behavior_type='buy',behavior_type,null)) 'buy'
from user_behavior
group by user_id,item_id

-- Standardization of user behavior
create view user_behavior_standard as
select user_id,
item_id,
(case when pv>0 then 1 else 0 end) viewd,
(case when fav>0 then 1 else 0 end) Favorited,
(case when cart>0 then 1 else 0 end) carted,
(case when buy>0 then 1 else 0 end) bought
from user_behavior_view

-- Path type
create view user_behavior_path as
select *,
concat(viewd,Favorited,carted,bought) Bought_path_type
from user_behavior_standard as a 
where a.bought >0

-- Statistics on the number of purchase paths in each category
create view path_count as 
select Bought_path_type,
count(*) amount
from user_behavior_path
group by Bought_path_type
order by amount desc

insert into path_result
select path_type,description,amount from
path_count p 
join interpretation i 
on p.Bought_path_type=i.path_type 
order by amount desc

select * from path_result

select sum(buy)
from user_behavior_view
where buy>0 and fav=0 and cart=0

-- 15684
select 20885-15684 -- 5201

select 5201/(28879+56895)




