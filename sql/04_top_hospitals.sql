-- Top 20 Worst Hospitals by excess readmission ratio
SELECT
  facility_name,
  state,
  measure_name AS condition,
  excess_readmission_ratio
FROM `healthflow-analytics.hospital_readmissions.readmissions_clean`
ORDER BY excess_readmission_ratio DESC
LIMIT 20;