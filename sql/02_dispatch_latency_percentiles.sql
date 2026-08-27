-- Dispatch Latency & ETA SLA Percentiles (p50, p90, p95)
SELECT 
    pickup_zone,
    COUNT(*) AS completed_trips,
    ROUND(AVG(eta_pickup_minutes), 2) AS avg_pickup_eta_min,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eta_pickup_minutes), 1) AS p50_eta_min,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eta_pickup_minutes), 1) AS p90_eta_min,
    ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eta_pickup_minutes), 1) AS p95_eta_min,
    SUM(CASE WHEN eta_pickup_minutes > 10 THEN 1 ELSE 0 END) AS sla_breaches_gt_10m,
    ROUND(SUM(CASE WHEN eta_pickup_minutes > 10 THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*), 2) AS sla_breach_rate_pct
FROM fact_ride_requests
WHERE trip_status = 'Completed'
GROUP BY pickup_zone
ORDER BY p95_eta_min DESC;
