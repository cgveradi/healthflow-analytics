-- Enriched Dataset: adds rate_gap and a single clean, ordered risk_tier

SELECT
  facility_id,
  facility_name,
  state,
  measure_name AS condition,
  predicted_readmission_rate,
  expected_readmission_rate,
  excess_readmission_ratio,
  number_of_readmissions,
  ROUND(predicted_readmission_rate - expected_readmission_rate, 4) AS rate_gap,
  CASE
    WHEN excess_readmission_ratio < 0.98 THEN 'Low Risk'
    WHEN excess_readmission_ratio <= 1.02 THEN 'Average'
    ELSE 'High Risk'
  END AS readmission_risk_tier
FROM `healthflow-analytics.hospital_readmissions.readmissions_clean`;