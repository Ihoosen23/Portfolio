-- Exploratory Data Analysis

Select *
From layoffs_staging2
;


Select max(total_laid_off), max(percentage_laid_off)
From layoffs_staging2
;

Select *
From layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc
;


Select company, sum(total_laid_off)
From layoffs_staging2
group by company
order by 2 desc
;


select min(`date`), max(`date`)
From layoffs_staging2
;


Select country, sum(total_laid_off)
From layoffs_staging2
group by country
order by 2 desc
;


select *
From layoffs_staging2
;


Select year(`date`), sum(total_laid_off)
From layoffs_staging2
group by year(`date`)
order by 1 desc
;


Select stage, sum(total_laid_off)
From layoffs_staging2
group by stage
order by 2 desc
;


Select company, avg(percentage_laid_off)
From layoffs_staging2
group by company
order by 2 desc
;


select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
;


with Rolling_Total as
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off
,sum(total_off) over(order by `month`) as rolling_total
from Rolling_Total
;


Select company, sum(total_laid_off)
From layoffs_staging2
group by company
order by 2 desc
;


Select company, year(`date`), sum(total_laid_off)
From layoffs_staging2
group by company, year(`date`)
order by 3 desc
;

with Company_year (company, years, total_laid_off) as
(
Select company, year(`date`), sum(total_laid_off)
From layoffs_staging2
group by company, year(`date`)
), Company_Years_Rank as
(select *, 
dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from Company_year
where years is not null
)
select *
from Company_Years_Rank
where ranking <= 5
;






















































