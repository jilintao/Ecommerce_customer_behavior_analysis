-- Recent bought time
select user_id,
max(dates) 'recent_bought_time'
from user_behavior
where behavior_type='buy'
group by user_id
order by 2 desc;

-- Number of purchases 
select user_id
,count(user_id) 'Number_of_purchases'
from temp_behavior
where behavior_type='buy'
group by user_id
order by 2 desc;

-- Recent bought time and number of purchases
select user_id
,count(user_id) 'recent_bought_time'
,max(dates) 'Number_of_purchases'
from user_behavior
where behavior_type='buy'
group by user_id
order by 2 desc,3 desc;

-- save the results
drop table if exists rfm_model;
create table rfm_model(
user_id int,
frequency int,
recent char(10)
);

insert into rfm_model
select user_id
,count(user_id) 'Number_of_purchases'
,max(dates) 'recent_bought_time'
from user_behavior
where behavior_type='buy'
group by user_id
order by 2 desc,3 desc;

-- Stratify users based on number of purchases
alter table rfm_model add column fscore int;

update rfm_model
set fscore = case
when frequency between 100 and 262 then 5
when frequency between 50 and 99 then 4
when frequency between 20 and 49 then 3
when frequency between 5 and 20 then 2
else 1
end

-- Stratify users based on recent purchase time 
alter table rfm_model add column rscore int;

update rfm_model
set rscore = case
when recent = '2017-12-03' then 5
when recent in ('2017-12-01','2017-12-02') then 4
when recent in ('2017-11-29','2017-11-30') then 3
when recent in ('2017-11-27','2017-11-28') then 2
else 1
end

select * from rfm_model

-- hierarchization
set @f_avg=null;
set @r_avg=null;
select avg(fscore) into @f_avg from rfm_model;
select avg(rscore) into @r_avg from rfm_model;

select *
,(case
when fscore>@f_avg and rscore>@r_avg then 'Valuable_user'
when fscore>@f_avg and rscore<@r_avg then 'Keepable_user'
when fscore<@f_avg and rscore>@r_avg then 'Potential_user'
when fscore<@f_avg and rscore<@r_avg then 'Retain_user'
end) class
from rfm_model

-- Insertation
alter table rfm_model add column class varchar(40);
update rfm_model
set class = case
when fscore>@f_avg and rscore>@r_avg then 'Valuable_user'
when fscore>@f_avg and rscore<@r_avg then 'Keepable_user'
when fscore<@f_avg and rscore>@r_avg then 'Potential_user'
when fscore<@f_avg and rscore<@r_avg then 'Retain_user'
end

-- Counting the number of users in each partition
select class,count(user_id) from rfm_model
group by class

