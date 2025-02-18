-- Behavior of statistical date-hours
select dates,hours,
count(if(behavior_type='pv',behavior_type,null)) 'pv',
count(if(behavior_type='cart',behavior_type,null)) 'cart',
count(if(behavior_type='fav',behavior_type,null)) 'fav',
count(if(behavior_type='buy',behavior_type,null)) 'buy'

from temp_behavior
group by dates,hours 
order by dates,hours 

-- Save results
create table date_hour_behavior(
dates char(10),
hours char(2),
pv int,
cart int,
fav int,
buy int);

-- Insert results
insert into date_hour_behavior
select dates,hours,
count(if(behavior_type='pv',behavior_type,null)) 'pv',
count(if(behavior_type='cart',behavior_type,null)) 'cart',
count(if(behavior_type='fav',behavior_type,null)) 'fav',
count(if(behavior_type='buy',behavior_type,null)) 'buy'

from user_behavior
group by dates,hours 
order by dates,hours 

delete from date_hour_behavior where buy = 0
select * from date_hour_behavior;