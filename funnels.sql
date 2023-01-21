SELECT question, COUNT(DISTINCT user_id)
FROM survey
GROUP BY question; 

SELECT DISTINCT q.user_id, h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
purchase.user_id IS NOT NULL AS 'is_puchase'
FROM quiz q
LEFT JOIN home_try_on h 
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON p.user_id = q.user_id
LIMIT 5;

WITH q AS (
SELECT '1-quiz' AS stage, COUNT(DISTINCT user_id)
   FROM quiz
),
h AS (
  SELECT '2-home-try-on' AS stage, COUNT(DISTINCT user_id)
   FROM home_try_on
), 
p AS (
  SELECT '3-purchase' AS stage, COUNT(DISTINCT user_id)
   FROM purchase
)
SELECT * FROM q
UNION ALL 
SELECT * FROM h
UNION ALL
SELECT * FROM p;

WITH base_table AS (
  SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs AS 'AB_variant',
  p.user_id IS NOT NULL AS 'is_purchase'
  FROM quiz q
  LEFT JOIN home_try_on h
    ON q.user_id = h.user_id
  LEFT JOIN purchase p
    ON p.user_id = q.user_id
)
SELECT AB_variants, 
  SUM(CASE WHEN is_home_try_on = 1
    THEN 1
    ELSE 0
      END) 'home_trial',
  SUM(CASE WHEN is_purchase = 1
    THEN 1
    ELSE 0
      END) 'purchase'
FROM base_table
GROUP BY AB_variant
HAVING home_trial > 0;