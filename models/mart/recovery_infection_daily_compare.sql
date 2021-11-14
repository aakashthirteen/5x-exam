with new_cases as (
    select * from {{ ref("covid_new_cases_daily")}}
),
recovery as (
    select * from {{ ref("covid_recovery_daily")}}
),
t1 as (
    select a.*, b.new_recovered
    from new_cases a
    inner join
    recovery b
    on a.country = b.country
    and a.location = b.location
    and a.date = b.date
)
select t1.*, ((new_recovered-new_cases)/nullif(new_cases,0))*100 Change 
from t1