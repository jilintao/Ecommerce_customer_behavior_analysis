-- Product-specific conversion rates
select item_id
,count(if(behavior_type='pv',behavior_type,null)) 'pv'
,count(if(behavior_type='fav',behavior_type,null)) 'fav'
,count(if(behavior_type='cart',behavior_type,null)) 'cart'
,count(if(behavior_type='buy',behavior_type,null)) 'buy'
,count(distinct if(behavior_type='buy',user_id,null))/count(distinct user_id) Product_Conversion_Rate
from temp_behavior
group by item_id
order by Product_Conversion_Rate desc


-- Save the results 
create table item_detail(
item_id int,
pv int,
fav int,
cart int,
buy int,
user_buy_rate float);

insert into item_detail
select item_id
,count(if(behavior_type='pv',behavior_type,null)) 'pv'
,count(if(behavior_type='fav',behavior_type,null)) 'fav'
,count(if(behavior_type='cart',behavior_type,null)) 'cart'
,count(if(behavior_type='buy',behavior_type,null)) 'buy'
,count(distinct if(behavior_type='buy',user_id,null))/count(distinct user_id) Product_Conversion_Rate
from temp_behavior
group by item_id
order by Product_Conversion_Rate desc

select * from item_detail;

-- Category Conversion Rate 

create table category_detail(
category_id int,
pv int,
fav int,
cart int,
buy int,
user_buy_rate float);

insert into category_detail
select category_id
,count(if(behavior_type='pv',behavior_type,null)) 'pv'
,count(if(behavior_type='fav',behavior_type,null)) 'fav'
,count(if(behavior_type='cart',behavior_type,null)) 'cart'
,count(if(behavior_type='buy',behavior_type,null)) 'buy'
,count(distinct if(behavior_type='buy',user_id,null))/count(distinct user_id) Category_Conversion_Rate
from user_behavior
group by category_id
order by Category_Conversion_Rate desc;

select * from category_detail;