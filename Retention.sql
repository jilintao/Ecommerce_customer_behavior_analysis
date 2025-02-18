select user_id,dates 
from temp_behavior
group by user_id,dates;

-- Self-association
select * from 
(select user_id,dates 
from temp_behavior
group by user_id,dates
) a 
,(select user_id,dates 
from temp_behavior
group by user_id,dates
) b 
where a.user_id = b.user_id;

-- Filter
select * from 
(select user_id,dates 
from temp_behavior
group by user_id,dates
) a 
,(select user_id,dates 
from temp_behavior
group by user_id,dates
) b 
where a.user_id = b.user_id and a.dates < b.dates;

-- retention level
select a.dates,
count(if(datediff(b.dates,a.dates)=1,b.user_id,null)) retention_1
from 
(select user_id,dates 
from temp_behavior
group by user_id,dates
) a 
,(select user_id,dates 
from temp_behavior
group by user_id,dates
) b 
where a.user_id = b.user_id and a.dates <= b.dates
group by a.dates;

-- Retention rate
select a.dates,
count(if(datediff(b.dates,a.dates)=1,b.user_id,null))/count(if(datediff(b.dates,a.dates)=0,b.user_id,null)) retention_rate
from 
(select user_id,dates 
from temp_behavior
group by user_id,dates
) a 
,(select user_id,dates 
from temp_behavior
group by user_id,dates
) b 
where a.user_id = b.user_id and a.dates <= b.dates
group by a.dates;

-- Save results
create table retention_rate (
dates char(10),
retention_1 float
);

insert into retention_rate
select a.dates,
count(if(datediff(b.dates,a.dates)=1,b.user_id,null))/count(if(datediff(b.dates,a.dates)=0,b.user_id,null)) retention_rate
from 
(select user_id,dates 
from user_behavior
group by user_id,dates
) a 
,(select user_id,dates 
from user_behavior
group by user_id,dates
) b 
where a.user_id = b.user_id and a.dates <= b.dates
group by a.dates;

select * from retention_rate order by retention_1

delete from retention_rate where retention_1 = 0

-- Bounce rate
-- Missing user
select count(*)
from 
(select user_id from user_behavior
group by user_id 
having count(behavior_type)=1
) a

select sum(pv) from pv_uv_puv; -- 913024

-- Bounce rate 0/913024 unreliable because of random sampling of data