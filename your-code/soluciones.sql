/*Paso 1: Calcule las regalías de cada venta para cada autor.*/
SELECT 
titleauthor.title_id as TITLE_ID, 
authors.au_id AS AUTHOR_ID, 
(titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100)) as SALES_ROYALTY
FROM publications.authors
INNER JOIN titleauthor
on authors.au_id = titleauthor.au_id
INNER JOIN titles
on titleauthor.title_id = titles.title_id
INNER JOIN sales
on titles.title_id = sales.title_id
order by SALES_ROYALTY desc;

/*##Paso 2: Agregue el total de regalías para cada título para cada autor####*/

SELECT 
AUTHOR_ID,
TITLE_ID,
sum(SALES_ROYALTY) as AGGREGATED_ROYALTY
FROM (
SELECT 
titleauthor.title_id as TITLE_ID, 
authors.au_id AS AUTHOR_ID, 
(titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100)) as SALES_ROYALTY
FROM publications.authors
INNER JOIN titleauthor
on authors.au_id = titleauthor.au_id
INNER JOIN titles
on titleauthor.title_id = titles.title_id
INNER JOIN sales
on titles.title_id = sales.title_id
order by SALES_ROYALTY desc
) summary
group by TITLE_ID, AUTHOR_ID
ORDER BY AGGREGATED_ROYALTY DESC; 

/*#####Paso 3: Calcula los beneficios totales de cada autor.####*/
SELECT AUTHOR_ID, SUM(AGGREGATED_ROYALTY) + adv/COUNT(TITLE_ID) AS Total_profits
FROM (
SELECT
TITLE_ID,
AUTHOR_ID,
SUM(SALES_ROYALTY) as AGGREGATED_ROYALTY,
adv
FROM (
SELECT
titleauthor.title_id as TITLE_ID,
titleauthor.au_id as AUTHOR_ID,
titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS SALES_ROYALTY,
titles.advance as adv
FROM titleauthor
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
INNER JOIN sales
ON titleauthor.title_id = sales.title_id
)summary
GROUP BY TITLE_ID, adv, AUTHOR_ID
)tablita
GROUP BY AUTHOR_ID, TITLE_ID
ORDER BY AGGREGATED_ROYALTY DESC
LIMIT 3;


