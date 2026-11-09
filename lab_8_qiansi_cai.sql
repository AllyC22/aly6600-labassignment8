-- Task 1: Single CTE
WITH customer_totals AS (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM `sakila-aly6600.sakila.payment`
  GROUP BY customer_id
)
SELECT customer_id, total_spent
FROM customer_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_totals)
ORDER BY total_spent DESC;

-- Task 2: Chained CTEs
WITH customer_totals AS (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM `sakila-aly6600.sakila.payment`
  GROUP BY customer_id
),
above_avg AS (
  SELECT customer_id, total_spent
  FROM customer_totals
  WHERE total_spent > (SELECT AVG(total_spent) FROM customer_totals)
),
customer_city AS (
  SELECT aa.customer_id, aa.total_spent, ct.city
  FROM above_avg AS aa
  INNER JOIN `sakila-aly6600.sakila.customer` AS c ON aa.customer_id = c.customer_id
  INNER JOIN `sakila-aly6600.sakila.address` AS a ON c.address_id = a.address_id
  INNER JOIN `sakila-aly6600.sakila.city` AS ct ON a.city_id = ct.city_id
)
SELECT city,
       COUNT(*) AS num_customers,
       SUM(total_spent) AS total_revenue
FROM customer_city
GROUP BY city
ORDER BY num_customers DESC, total_revenue DESC
LIMIT 5;
