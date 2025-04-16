-- Q1. Get the title of each book and the name of its publisher
select t.title, p.pub_name
from titles t
inner join publishers p on p.pub_id = t.pub_id

-- Retrieve all book titles along with their publisher names
-- Include books even if they do not have a matching publisher
select t.title, p.pub_name
from titles t
left join publishers p on p.pub_id = t.pub_id

-- Retrieve all publisher names along with their associated book titles
-- Include all publishers, even those without any books
select t.title, p.pub_name
from titles t
right join publishers p on p.pub_id = t.pub_id

-- Retrieve publisher names that are not associated with any book titles
-- by performing a FULL JOIN and filtering for rows where 'title_id' is NULL
-- We’re using this condition to find publishers who do not have any books listed in the titles table.
select t.title, p.pub_name
from titles t
full join publishers p on p.pub_id = t.pub_id
where t.title_id is null


-- Q2. Retrieve the first and last names of authors along with the titles they have written
-- We're linking the authors to titles through the bridge table titleauthor, which handles the many-to-many relationship
select a.au_fname, a.au_lname, t.title
from authors a
inner join titleauthor ta on ta.au_id = a.au_id
inner join titles t on t.title_id = ta.title_id

-- Q3. Retrieve the first and last names of authors along with the names of the publishers of their books
select a.au_fname, a.au_lname, p.pub_name
from authors a
inner join titleauthor ta on ta.au_id = a.au_id
inner join titles t on t.title_id = ta.title_id
inner join publishers p on p.pub_id = t.pub_id

-- Q4. Count the total number of authors in the 'authors' table
select COUNT(au_id) as 'authors count'
from authors a

-- Q5.Count the number of unique authors who have written at least one valid (non-null) book title
select count(distinct a.au_id) as 'distinct authors count'
from authors a
full join titleauthor ta on ta.au_id = a.au_id
full join titles t on t.title_id = ta.title_id
where t.title is not null

-- As joins are very slow when it comes to big data, a faster way is as bellow.
-- It will give the same result as above and improve performance
select count(distinct au_id) as 'distinct authors count'
from titleauthor ta


-- Q6.Count the number of sales transactions (rows) for each book (title_id)
-- regardless of how many copies were sold in each transaction 
select s.title_id, count(s.qty) as "total_transactions"
from sales as s
group by s.title_id

-- Calculate the total number of copies sold for each book (title_id)
-- by summing the quantity sold in each transaction
select s.title_id, sum(s.qty) as "total_copies_sold"
from sales as s
group by s.title_id

-- Q7.Retrieve each book title along with the total number of copies sold
select t.title, sum(s.qty) as total_copies_sold
from titles as t
left join sales as s on s.title_id = t.title_id
group by t.title

-- Retrieve each book title along with the total number of copies sold
-- Use a LEFT JOIN to include all titles, even those without any sales
-- Replace NULL sales values with 0 using COALESCE
-- Group the results by title and sort them in descending order of total copies sold
select t.title, COALESCE(sum(s.qty), 0) as total_copies_sold
from titles as t
left join sales as s on s.title_id = t.title_id
group by t.title
order by total_copies_sold desc