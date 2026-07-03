-- Conditions Breakdown: which conditions drive the worst readmission performance
SELECT
  measure_name AS condition,
  COUNT(*) AS record_count,
  ROUND(AVG(excess_readmission_ratio), 4) AS avg_excess_ratio,
  ROUND(100 * SUM(CASE WHEN excess_readmission_ratio > 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_above_benchmark
FROM `healthflow-analytics.hospital_readmissions.readmissions_clean`
GROUP BY measure_name
ORDER BY avg_excess_ratio DESC;