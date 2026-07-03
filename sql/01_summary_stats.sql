-- Summary Stats: overall dataset shape and average excess readmission ratio
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT facility_id) AS total_hospitals,
  COUNT(DISTINCT state) AS total_states,
  COUNT(DISTINCT measure_name) AS total_conditions,
  ROUND(AVG(excess_readmission_ratio), 4) AS avg_excess_ratio
FROM `healthflow-analytics.hospital_readmissions.readmissions_clean`;