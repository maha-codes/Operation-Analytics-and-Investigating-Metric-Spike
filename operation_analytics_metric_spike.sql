#Case Study 1 (Job Data)

#A.Number of jobs reviewed: Amount of jobs reviewed over time.
#Your task: Calculate the number of jobs reviewed per hour per day for November 2020?
select ds, count(job_id) JobsPerDay, sum(time_spent)/3600 HoursPerDay from job_data 
where ds>='2020-11-01' and ds<='2020-11-30' group by ds;

#B.Throughput: It is the no. of events happening per second.
#Your task: Let’s say the above metric is called throughput. Calculate 7 day rolling average of throughput? For throughput, do you prefer daily metric or 7-day rolling and why?
select ds,no_of_jobs,avg(no_of_jobs) over(order by ds ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as throughput_rolling_avg 
from
(select ds, count(distinct job_id) as no_of_jobs from job_data group by ds order by ds ) a;

#C.Percentage share of each language: Share of each language for different contents.
#Your task: Calculate the percentage share of each language in the last 30 days?
select language, 100*(count(language)/(select count(*) from job_data)) as percentage from job_data group by language;

#D.Duplicate rows: Rows that have the same value present in them.
#Your task: Let’s say you see some duplicate rows in the data. How will you display duplicates from the table?
select* from(select *, ROW_NUMBER() OVER(partition by job_id) duplicate from job_data)a where duplicate>1;


#Case Study 2 (Investigating metric spike)

#A.User Engagement: To measure the activeness of a user. Measuring if the user finds quality in a product/service.
#Your task: Calculate the weekly user engagement?
select weekofyear(created_at) weeks, count(user_id) as no_of_users from users where state='active' group by weeks;

#B.User Growth: Amount of users growing over time for a product.
#Your task: Calculate the user growth for product?
select date(created_at) day, count(distinct user_id) user_growth from users group by week(created_at);

#C.Weekly Retention: Users getting retained weekly after signing-up for a product.
#Your task: Calculate the weekly retention of users-sign up cohort?
select weekofyear(u.created_at) week, count(e.user_id) retained_users from users u left join events e on u.user_id = e.user_id where u.state='active' group by week order by week;

#D.Weekly Engagement: To measure the activeness of a user. Measuring if the user finds quality in a product/service weekly.
#Your task: Calculate the weekly engagement per device?
select weekofyear(u.created_at) week, e.device, count(u.user_id) users from events e 
right join users u on e.user_id=u.user_id where e.event_type='engagement' 
group by week,e.device order by week;

#E.Email Engagement: Users engaging with the email service.
#Your task: Calculate the email engagement metrics?
select action, week(occurred_at) week, count(distinct user_id) engagement_count from email_events 
group by action, week order by action,week;
