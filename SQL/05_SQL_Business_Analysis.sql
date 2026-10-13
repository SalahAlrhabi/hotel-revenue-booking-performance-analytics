

-- =========================================================
-- PHASE E — SQL Exploratory & Business Analysis
-- =========================================================

-- =========================================================
-- E8 — Advanced Business Analysis
-- =========================================================


-- E8.1 — High-Risk Booking Profiles

SELECT 
    Hotel,
    MarketSegment,
    LeadTimeGroup,
    COUNT(*) AS TotalBookings,
    SUM(IsCanceled) CanceledBookings,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY Hotel , MarketSegment , LeadTimeGroup
HAVING COUNT(*) >= 500
    AND AVG(IsCanceled) >= 0.30
ORDER BY CancellationRate DESC , TotalBookings DESC;

-- E8.2 — Hotel × Market Segment Performance 

SELECT
	Hotel,
    MarketSegment,
    COUNT(*) AS TotalBookings,
    ROUND(
		COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS BookingShare,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AvgStay,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM hotel_bookings
WHERE ADR_Status = 'Valid'
GROUP BY Hotel , MarketSegment
HAVING COUNT(*) >= 100
ORDER BY Hotel , TotalBookings DESC;

-- E8.3 — Cancellation Risk by Lead Time & Market Segment

SELECT 
    MarketSegment,
    LeadTimeGroup,
    COUNT(*) AS TotalBookings,
    SUM(IsCanceled) AS CanceledBookings,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY MarketSegment , LeadTimeGroup
HAVING COUNT(*) >= 300
ORDER BY CancellationRate DESC , TotalBookings DESC;

-- E8.4 — Booking Value by Market Segment

SELECT 
    MarketSegment,
    COUNT(*) AS CompletedBookings,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(SUM(ADR * TotalStayNights), 2) AS EstimatedStayValue,
    ROUND(SUM(ADR * TotalStayNights) / COUNT(*), 2) AS AvgEstimatedValuePerBooking
FROM
    hotel_bookings
WHERE
    IsCanceled = 0 AND ADR_Status = 'Valid'
GROUP BY MarketSegment
HAVING COUNT(*) >= 100
ORDER BY EstimatedStayValue DESC;


-- =========================================================
-- E9 — Final Business Summary
-- =========================================================

-- E9.1 — Executive Hotel Performance

SELECT 
    Hotel,
    COUNT(*) AS TotalBookings,
    SUM(IsCanceled) AS CanceledBookings,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStayNight,
    ROUND(AVG(TotalGuests), 2) AS AvgGuests,
    ROUND(AVG(LeadTime), 2) AS AvgLeadTime,
    SUM(RoomChanged = 'YES') AS RoomChangedBookings
FROM
    hotel_bookings
GROUP BY Hotel
ORDER BY TotalBookings DESC;

-- E9.2 — Overall Executive KPIs

SELECT 
    COUNT(*) AS TotalBookings,
    SUM(IsCanceled) AS CanceledBookings,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStayNights,
    ROUND(AVG(TotalGuests), 2) AS AvgGuests,
    ROUND(AVG(LeadTime), 2) AS AvgLeadTime,
    SUM(RoomChanged = 'Yes') AS RoomChangedBookings
FROM
    hotel_bookings;

