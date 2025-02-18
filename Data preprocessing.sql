use taobao;
desc user_behavior;
select * from user_behavior limit 5;

-- Alter column name
alter table user_behavior change timestamp timestamps int(14);
desc user_behavior;

-- Check null values
select * from user_behavior where user_id is null;
select * from user_behavior where item_id is null;
select * from user_behavior where category_id is null;
select * from user_behavior where behavior_type is null;
select * from user_behavior where timestamps is null;

-- Check duplicated values
select user_id,item_id,timestamps from user_behavior
group by user_id,item_id,timestamps
having count(*)>1;


-- Add dates: date time hour
-- datetime
alter table user_behavior add datetimes TIMESTAMP(0);
update user_behavior set datetimes=FROM_UNIXTIME(timestamps);
select * from user_behavior limit 5;
-- date
alter table user_behavior add dates char(10);
alter table user_behavior add times char(8);
alter table user_behavior add hours char(2);
-- update user_behavior set dates=substring(datetimes,1,10),times=substring(datetimes,12,8),hours=substring(datetimes,12,2)
update user_behavior set dates=substring(datetimes,1,10);
update user_behavior set times=substring(datetimes,12,8);
update user_behavior set hours=substring(datetimes,12,2);
select * from user_behavior limit 5;

-- Check abnormal values
select max(datetimes),min(datetimes) from user_behavior;

-- Data overview
desc user_behavior;
select * from user_behavior limit 5;
select count(1) from user_behavior; -- 1028783 records