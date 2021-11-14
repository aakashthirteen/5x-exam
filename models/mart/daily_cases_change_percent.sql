select location, date, concat(cast(percentage_increase as int), '%') case_percent_increase from (
select *, ((total_cases-last_day)/total_cases) * 100 percentage_increase
from (select location, 
    date, 
    total_cases, 
    lag(total_cases,1) over(partition by location order by date_) last_day 
from 
(select *, cast(date as DATETIME) date_ from fivetran_interview_db.google_sheets.covid_19_indonesia_aakash_sharma)))