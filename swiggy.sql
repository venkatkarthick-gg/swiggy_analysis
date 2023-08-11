use v2k;

select distinct restaurant_no,rating,restaurant_name
from swiggy
where rating > 4.5;

-- top 1 city with highest number of restaurants
select * from swiggy
limit 50;

select distinct count(restaurant_no)over(partition by city)total_rest,city
from swiggy
order by total_rest desc
limit 1;

-- as we can see banglore has the highest no of restaurant with he count of 34552 restaurants.

----------------------------------
-- Q3 HOW MANY RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME?


select distinct restaurant_name,city
from swiggy
where restaurant_name like '%pizza%';

-----------------------------
-- Q4 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?

select distinct count(*)over(partition by cuisine)pop_cuis,cuisine
from swiggy
order by pop_cuis desc
limit 1;

---------------------------------
-- Q5 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?

desc swiggy;
select distinct avg(rating)over(partition by city)avg_ratings,city
from swiggy
order by avg_ratings desc;

-- we can see the banglore rating is higher than the ahemadabad rating

------------------------------------
-- Q6 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED MENU CATEGORY FOR EACH RESTAURANT?


desc swiggy;


select * from swiggy
limit 40;

select distinct restaurant_name,max(price)over(partition by restaurant_name)max_price from swiggy
where menu_category like '%ecomme%'
order by max_price desc;

-------------------------------------------------------
-- Q7 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE.

select distinct restaurant_name,cost_per_person
from swiggy
where cuisine != '%dian%'
order by cost_per_person desc
limit 5;


-------------------------------------------------------
-- Q8 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER.

select distinct*
from swiggy
limit 1000;

select distinct restaurant_name,cost_per_person 
from swiggy
where cost_per_person> (select avg(average_cost) from(
select distinct avg(cost_per_person)over(partition by restaurant_name)average_cost
from swiggy)as tan);

--------------------------------------

-- Q9 RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.

select * from swiggy;

select distinct j1.restaurant_name,j1.city
from swiggy j1 
join swiggy j2
on j1.restaurant_name=j2.restaurant_name and j1.city!=j2.city;

-- Q10 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE MAIN COURSE' CATEGORY

select * from swiggy
limit 50;
select distinct menu_category
from swiggy;

with t as
(select distinct count(item)over(partition by restaurant_name)cnt_item, restaurant_name
from swiggy
where menu_category='Main Course')
select * from t
order by cnt_item desc
limit 1;

-- Q11 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.

select * from swiggy
limit 50;

select distinct restaurant_name,veg_or_nonveg
from swiggy
where veg_or_nonveg ='veg'
order by restaurant_name asc;

-- Q12 WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?

select distinct restaurant_name, avg(price)over(partition by restaurant_name)av_price
from swiggy
order by av_price asc
limit 1;

-- Q13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?

select distinct restaurant_name,count(menu_category)over(partition by restaurant_name)cnt_cat
from swiggy
order by cnt_cat desc
limit 5;

-- Q14 WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?

select * from swiggy
limit 10;

select distinct restaurant_name,(sum(if(veg_or_nonveg='Non-veg',1,0))over(partition by restaurant_name)/count(veg_or_nonveg)over(partition by restaurant_name))*100 as
perc_val
from swiggy
order by perc_val desc
limit 10;


