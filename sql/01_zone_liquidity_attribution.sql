-- Zone-Level Marketplace Liquidity & Unfulfilled Attribution Analysis
SELECT 
    pickup_zone,
    COUNT(*) AS total_demand_pings,
    SUM(CASE WHEN trip_status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
    ROUND(SUM(CASE WHEN trip_status = 'Completed' THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fulfillment_rate_pct,
    SUM(CASE WHEN unfulfilled_reason = 'No_Driver_Found' THEN 1 ELSE 0 END) AS unfulfilled_supply_deficit,
    SUM(CASE WHEN unfulfilled_reason = 'Rider_Surge_Dropoff' THEN 1 ELSE 0 END) AS unfulfilled_surge_dropoff,
    SUM(CASE WHEN unfulfilled_reason = 'Driver_Rejection_Timeout' THEN 1 ELSE 0 END) AS unfulfilled_driver_timeout,
    ROUND(AVG(surge_multiplier), 2) AS avg_surge_multiplier,
    ROUND(SUM(trip_fare), 2) AS total_gross_bookings
FROM fact_ride_requests
GROUP BY pickup_zone
ORDER BY total_demand_pings DESC;
