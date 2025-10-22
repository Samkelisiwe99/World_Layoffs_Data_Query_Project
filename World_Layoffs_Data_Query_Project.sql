-- Exploritory Data Analysis

select *
From layoffs_staging2;

select MAX(total_laid_off), MAX(percentage_laid_off)
From layoffs_staging2;

select *
From layoffs_staging2
Where percentage_laid_off = 1 
order by total_laid_off desc;

select *
From layoffs_staging2
Where percentage_laid_off = 1 
order by funds_raised_millions desc;

select company, sum(total_laid_off)
From layoffs_staging2
group by company
order by 2 desc;

select min( `date`), max( `date`)
From layoffs_staging2;

select industry, sum(total_laid_off)
From layoffs_staging2
group by industry
order by 2 desc;

select year( `date`), sum(total_laid_off)
From layoffs_staging2
group by year( `date`)
order by 2 desc;

select stage, sum(total_laid_off)
From layoffs_staging2
group by stage
order by 2 desc;

select substring( `date`, 1, 7) as `month`, sum(total_laid_off)
From layoffs_staging2
where substring( `date`, 1, 7) is not null
group by `month`
order by 1 asc;

with rolling_total as
(select substring( `date`, 1, 7) as `month`, sum(total_laid_off) as total_off
From layoffs_staging2
where substring( `date`, 1, 7) is not null
group by `month`
order by 1 asc)
select `month`, total_off , sum(total_off) over( order by `month`) as  rolling_total
from rolling_total; 

select company, `date` , sum(total_laid_off)
From layoffs_staging2
group by company, `date`
Order by `date` desc;

select company, year(`date`),sum(total_laid_off)
From layoffs_staging2
group by company,  year(`date`)
order by company asc;

WITH company_year AS (
  SELECT 
    company, 
    YEAR(`date`) AS years, 
    SUM(total_laid_off) AS total_lay_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(`date`)
), Company_Year_Rank as
(SELECT 
  *, 
  DENSE_RANK() OVER (PARTITION BY years ORDER BY total_lay_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL )
select *
From Company_Year_Rank
Where  ranking <= 5;



