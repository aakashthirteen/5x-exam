with t1 as(select country, location, extract(month from date_) month, extract(year from date_) year, mmyyyy, sum(new_recovered) Monthly_Recovery
from 
(select country, location, date, new_recovered, cast(date as DATETIME) date_, to_varchar(to_date(date, 'MM/DD/YYYY'), 'MM/YYYY') MMYYYY
from {{ ref("covid_recovery_daily")}}
group by 1,2,3,4,5,6
order by date_)

group by 1,2,3,4,5),

t2 as (
select t1.*, ifnull(lag(Monthly_Recovery) over(partition by country, location order by to_date(mmyyyy, 'mm/yyyy')), 0) last_month_recovery
from t1)
select t2.*, case when Monthly_Recovery = 0 then last_month_recovery 
            else ((Monthly_Recovery-last_month_recovery)/Monthly_Recovery)*100 end as Monthly_Change
from t2