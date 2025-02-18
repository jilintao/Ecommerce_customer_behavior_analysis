-- Creating temporary tables
create table temp_behavior like user_behavior;

-- interception
insert into temp_behavior
select * from user_behavior limit 100000;

select * from temp_behavior;

-- pv
select dates,
count(*) 'pv'
from temp_behavior
where behavior_type='pv'
GROUP BY dates;

-- uv
select dates,
count(distinct user_id) 'uv'
from temp_behavior
where behavior_type='pv'
GROUP BY dates;

-- One query
select dates,
count(*) 'pv',
count(distinct user_id) 'uv',
round(count(*)/count(distinct user_id),1) 'pv/uv'
from temp_behavior
where behavior_type='pv'
group by dates;

-- Handling of real data
create table pv_uv_puv (
dates char(10),
pv int(9),
uv int(9),
puv decimal(10,1)
);

insert into pv_uv_puv
select dates,
count(*) 'pv',
count(distinct user_id) 'uv',
round(count(*)/count(distinct user_id),1) 'pv/uv'
from user_behavior
where behavior_type='pv'
group by dates;

select * from pv_uv_puv

delete from pv_uv_puv where dates between '2017-09-11' and '2017-11-24'