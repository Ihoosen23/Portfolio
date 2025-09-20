-- Data Cleaning

 Select *
 From layoffs
 ;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values/ Blank Values
-- 4. Remove Unnecessary Columns


Create Table layoffs_staging
Like layoffs
;

 Select *
 From layoffs_staging
 ;

Insert layoffs_staging
Select *
From layoffs
;


Select *,
Row_number() Over(
Partition By company, industry, total_laid_off, percentage_laid_off, 'date') As row_num
From layoffs_staging
;

With duplicate_cte As
(
Select *,
Row_number() Over(
Partition By company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage,
country, funds_raised_millions) As row_num
From layoffs_staging
)
Select *
From duplicate_cte
Where row_num > 1
;

 Select *
 From layoffs_staging
 Where company = 'iFit';


-- Deleting Rows/ Removing Duplicates
With duplicate_cte As
(
Select *,
Row_number() Over(
Partition By company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage,
country, funds_raised_millions) As row_num
From layoffs_staging
)
Delete
From duplicate_cte
Where row_num > 1
;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


 Select *
 From layoffs_staging2
 Where row_num > 1
 ;

Insert Into layoffs_staging2
Select *,
Row_number() Over(
Partition By company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage,
country, funds_raised_millions) As row_num
From layoffs_staging
;


Delete
From layoffs_staging2
Where row_num > 1
;

Select*
From layoffs_staging2
Where row_num > 1
;

Select*
From layoffs_staging2
;


-- Standardizing Data

Select company, TRIM(company)
From layoffs_staging2
;

Update layoffs_staging2
Set company = TRIM(company)
;

Select distinct industry
From layoffs_staging2
Order By 1
;

Select Distinct industry
From layoffs_staging2
;

Update layoffs_staging2
Set industry = 'Crypto'
Where industry Like 'Crypto%'
;


Select distinct country
From layoffs_staging2
Order By 1
;

Select distinct country, TRIM(trailing '.' from country)
From layoffs_staging2
Order By 1
;

Update layoffs_staging2
Set country = TRIM(trailing '.' from country)
where country like 'United States%'
;


Select `date`
From layoffs_staging2
;


Update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y')
;


alter table layoffs_staging2
modify column `date`date
;


Select *
From layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

update layoffs_staging2
set industry = null
where industry = ''
;

Select *
From layoffs_staging2
where industry is null
or industry = ''
;


Select *
From layoffs_staging2
where company = 'Airbnb'
;

-- wrong maybe
select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    and t1.location = t2.location
where t1.industry is null
and t2.industry is not null
;

-- right way
select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null
;

-- simplify
select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null
;


update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null
;


Select *
From layoffs_staging2
;



Select *
From layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;


delete
From layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;


Select *
From layoffs_staging2
;

alter table layoffs_staging2
drop column row_num
;
















