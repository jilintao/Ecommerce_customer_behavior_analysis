-- Statistics of products in popular categories, popular products, popular products in popular categories popular products
select category_id
,count(if(behavior_type='pv',behavior_type,null)) 'Category Views'
from temp_behavior
GROUP BY category_id
order by 2 desc
limit 10

select item_id
,count(if(behavior_type='pv',behavior_type,null)) 'Product Views'
from temp_behavior
GROUP BY item_id
order by 2 desc
limit 10

select category_id,item_id,
Category_Product_Views from
(
select category_id,item_id
,count(if(behavior_type='pv',behavior_type,null)) 'Category_Product_Views'
,rank()over(partition by category_id order by 'Category_Product_Views' desc) r
from temp_behavior
GROUP BY category_id,item_id
order by 3 desc
) a
where a.r = 1
order by a.Category_Product_Views desc
limit 10

-- Save the result
create table popular_categories(
category_id int,
pv int);
create table popular_items(
item_id int,
pv int);
create table popular_cateitems(
category_id int,
item_id int,
pv int);

insert into popular_categories
select category_id
,count(if(behavior_type='pv',behavior_type,null)) 'Category Views'
from user_behavior
GROUP BY category_id
order by 2 desc
limit 10;

insert into popular_items
select item_id
,count(if(behavior_type='pv',behavior_type,null)) 'Product Views'
from user_behavior
GROUP BY item_id
order by 2 desc
limit 10;

insert into popular_cateitems
select category_id,item_id,
Category_Product_Views from
(
select category_id,item_id
,count(if(behavior_type='pv',behavior_type,null)) 'Category_Product_Views'
,rank()over(partition by category_id order by 'Category_Product_Views' desc) r
from temp_behavior
GROUP BY category_id,item_id
order by 3 desc
) a
where a.r = 1
order by a.Category_Product_Views desc
limit 10

select * from popular_categories;
select * from popular_items;
select * from popular_cateitems;