-- Top 10 Worst States by average excess readmission ratio
SELECT
  state,
  COUNT(DISTINCT facility_id) AS hospital_count,
  ROUND(AVG(excess_readmission_ratio), 4) AS avg_excess_ratio
FROM `healthflow-analytics.hospital_readmissions.readmissions_clean`
GROUP BY state
ORDER BY avg_excess_ratio DESC
LIMIT 10;