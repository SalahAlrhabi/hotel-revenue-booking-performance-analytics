

-- =========================================================
-- PHASE E — SQL Exploratory & Business Analysis
-- =========================================================


-- =========================================================
-- E1 — Overall Booking Performance
-- =========================================================

SELECT 
    COUNT(*) AS TotalBookings,
    SUM(CASE
        WHEN IsCanceled = 1 THEN 1
        ELSE 0
    END) AS CanceledBookings,
    ROUND(100.0 * SUM(CASE
                WHEN IsCanceled = 1 THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS CancellationRate,
    ROUND(AVG(ADR), 2) AS AverageADR,
    ROUND(AVG(TotalStayNights), 2) AS AverageStayNights
FROM
    hotel_bookings;


-- =========================================================
-- E1 — Performance by Hotel
-- نقارن أداء City Hotel و Resort Hotel
-- =========================================================

SELECT 
    Hotel,
    COUNT(*) AS TotalBookings,
    SUM(CASE
        WHEN IsCanceled = 1 THEN 1
        ELSE 0
    END) AS CanceledBookings,
    ROUND(100 * SUM(CASE
                WHEN IsCanceled = 1 THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS CancellationRate,
    ROUND(AVG(ADR), 2) AS AverageADR,
    ROUND(AVG(TotalStayNights), 2) AS AverageStayNights,
    ROUND(AVG(TotalGuests), 2) AS AverageGuests
FROM
    hotel_bookings
GROUP BY Hotel;


-- =========================================================
-- E1 — Booking Status by Hotel
-- نرى توزيع الحجوزات الملغاة وغير الملغاة لكل فندق
-- =========================================================

SELECT 
    Hotel,
    BookingStatus,
    COUNT(*) AS BookingCount,
    ROUND(
        100 * COUNT(*) / 
        SUM(COUNT(*)) OVER (PARTITION BY Hotel),
        2
    ) AS PercentageWithinHotel
FROM
    hotel_bookings
GROUP BY 
    Hotel,
    BookingStatus
ORDER BY 
    Hotel,
    BookingStatus;


-- =========================================================
-- E1 — Available Arrival Months
-- نتحقق من الفترات الزمنية الموجودة في البيانات
-- =========================================================

SELECT 
    ArrivalYear,
    MONTH(ArrivalDate) AS ArrivalMonthNumber,
    ArrivalMonth
FROM
    hotel_bookings
WHERE
    ArrivalDate IS NOT NULL
GROUP BY ArrivalYear, MONTH(ArrivalDate), ArrivalMonth
ORDER BY ArrivalYear, ArrivalMonthNumber;


-- =========================================================
-- E1 — Hotel Performance by Year
-- نتابع تغير أداء كل فندق عبر السنوات
-- =========================================================

SELECT 
    ArrivalYear,
    Hotel,
    COUNT(*) AS BookingCount,
    ROUND(AVG(ADR), 2) AS AverageADR,
    ROUND(AVG(TotalStayNights), 2) AS AverageStayNights,
    SUM(CASE
        WHEN IsCanceled = 1 THEN 1
        ELSE 0
    END) AS CanceledBookings,
    ROUND(100 * SUM(CASE
                WHEN IsCanceled = 1 THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY ArrivalYear, Hotel
ORDER BY ArrivalYear, Hotel;


-- =========================================================
-- E1 — Monthly Performance
-- نبحث عن الأشهر التي تجمع بين الطلب والسعر والإلغاء
-- =========================================================

SELECT 
    ArrivalMonth,
    COUNT(*) AS Booking_Count,
    ROUND(AVG(ADR), 2) AS AverageADR,
    ROUND(100 * SUM(CASE
                WHEN IsCanceled = 1 THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY MONTH(ArrivalDate), ArrivalMonth
ORDER BY Booking_Count DESC;


-- =========================================================
-- E1 — Top 10 Booking Periods
-- نحدد أقوى الفترات من حيث عدد الحجوزات
-- =========================================================

SELECT 
    ArrivalYear,
    ArrivalMonth,
    COUNT(*) AS Booking_Count,
    ROUND(AVG(ADR), 2) AS AverageADR
FROM
    hotel_bookings
GROUP BY ArrivalYear, MONTH(ArrivalDate), ArrivalMonth
ORDER BY Booking_Count DESC
LIMIT 10;


-- =========================================================
-- E1 — ADR by Hotel and Year
-- نقارن الأسعار بين الفنادق والسنوات
-- مع استبعاد ADR السالب
-- =========================================================

SELECT 
    ArrivalYear,
    Hotel,
    ROUND(AVG(ADR), 2) AS AverageADR,
    ROUND(MIN(ADR), 2) AS MinimumADR,
    ROUND(MAX(ADR), 2) AS MaximumADR
FROM
    hotel_bookings
WHERE
    ADR >= 0
GROUP BY ArrivalYear, Hotel
ORDER BY ArrivalYear, Hotel;


-- =========================================================
-- E1 — Overall Performance Summary
-- ملخص سريع لأهم مؤشرات المشروع
-- =========================================================

SELECT 
    COUNT(*) AS TotalBookings,
    COUNT(DISTINCT HOTEL) AS NumberOfHotels,
    SUM(CASE
        WHEN IsCanceled = 1 THEN 1
        ELSE 0
    END) AS CanceledBookings,
    ROUND(100.0 * SUM(CASE
                WHEN IsCanceled = 1 THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS CancellationRate,
    ROUND(AVG(ADR), 2) AS AverageADR,
    ROUND(AVG(TotalStayNights), 2) AS AverageStay,
    ROUND(AVG(TotalGuests), 2) AS AverageGuests
FROM
    hotel_bookings;


-- =========================================================
-- E2 — Booking Trends & Seasonality
-- =========================================================


-- E2.1 — Monthly Booking Trend
-- نتابع حجم الحجوزات عبر الزمن
-- =========================================================

SELECT 
    ArrivalYear,
    MONTH(ArrivalDate) AS MonthNumber,
    ArrivalMonth,
    COUNT(*) AS Booking_Count
FROM
    hotel_bookings
WHERE
    ArrivalDate IS NOT NULL
GROUP BY ArrivalYear, MonthNumber, ArrivalMonth
ORDER BY ArrivalYear, MonthNumber;


-- =========================================================
-- E2.2 — Monthly Demand, ADR and Cancellation
-- نقارن الطلب والسعر والإلغاء حسب الشهر
-- =========================================================

SELECT 
    MONTH(ArrivalDate) AS MonthNumber,
    ArrivalMonth,
    COUNT(*) AS Booking_Count,
    ROUND(AVG(ADR), 2) AS AverageADR,
    ROUND(100.0 * SUM(CASE
                WHEN IsCanceled = 1 THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS CancellationRate
FROM
    hotel_bookings
WHERE
    ArrivalDate IS NOT NULL
GROUP BY MONTH(ArrivalDate), ArrivalMonth
ORDER BY MonthNumber;


-- =========================================================
-- E2.3 — Yearly Performance and YoY Change
-- نقارن أداء السنوات باستخدام Window Function
-- =========================================================

WITH yearly_performance AS (
    SELECT 
        ArrivalYear,
        COUNT(*) AS BookingCount,
        ROUND(AVG(ADR), 2) AS AverageADR,
        ROUND(
            100.0 * SUM(CASE
                WHEN IsCanceled = 1 THEN 1
                ELSE 0
            END) / COUNT(*),
            2
        ) AS CancellationRate
    FROM hotel_bookings
    GROUP BY ArrivalYear
)

SELECT 
    ArrivalYear,
    BookingCount,
    AverageADR,
    CancellationRate,
    LAG(BookingCount) OVER (
        ORDER BY ArrivalYear
    ) AS PreviousYearBookings,
    ROUND(
        100.0 * 
        (BookingCount - LAG(BookingCount) OVER (ORDER BY ArrivalYear))
        / 
        NULLIF(
            LAG(BookingCount) OVER (ORDER BY ArrivalYear),
            0
        ),
        2
    ) AS BookingYoYGrowth
FROM yearly_performance
ORDER BY ArrivalYear;


-- =========================================================
-- E2.4 — Peak Demand Periods
-- نحدد أقوى 5 فترات من حيث الحجوزات
-- =========================================================

WITH monthly_demand AS (
    SELECT 
        ArrivalYear,
        MONTH(ArrivalDate) AS MonthNumber,
        ArrivalMonth,
        COUNT(*) AS BookingCount
    FROM hotel_bookings
    WHERE ArrivalDate IS NOT NULL
    GROUP BY ArrivalYear, MonthNumber, ArrivalMonth
)

SELECT 
    ArrivalYear,
    ArrivalMonth,
    BookingCount,
    'Peak Demand' AS DemandType
FROM monthly_demand 
ORDER BY BookingCount DESC
LIMIT 5;


-- =========================================================
-- E2.5 — Low Demand Periods
-- نحدد أضعف 5 فترات من حيث الحجوزات
-- =========================================================

WITH monthly_demand AS (
    SELECT
        ArrivalYear,
        MONTH(ArrivalDate) AS MonthNumber,
        ArrivalMonth,
        COUNT(*) AS BookingCount
    FROM hotel_bookings
    WHERE ArrivalDate IS NOT NULL
    GROUP BY
        ArrivalYear,
        MONTH(ArrivalDate),
        ArrivalMonth
)

SELECT
    ArrivalYear,
    ArrivalMonth,
    BookingCount,
    'Low Demand' AS DemandType
FROM monthly_demand
ORDER BY BookingCount ASC
LIMIT 5;


-- =========================================================
-- E3 — Cancellation Analysis
-- =========================================================


-- E3.1 — Cancellation Rate by Hotel
-- نحدد أي فندق لديه معدل إلغاء أعلى
-- =========================================================

SELECT 
    Hotel,
    ROUND(100.0 * SUM(CASE
                WHEN IsCanceled = 1 THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY Hotel;


-- =========================================================
-- E3.2 — Cancellation by Lead Time
-- نرى هل الإلغاء يرتفع كلما زادت مدة الحجز المسبق
-- =========================================================

SELECT 
    LeadTimeGroup,
    COUNT(*) AS TotalBookings,
    SUM(CASE
        WHEN IsCanceled = 1 THEN 1
        ELSE 0
    END) AS CanceledBookings,
    ROUND(100.0 * SUM(CASE
                WHEN IsCanceled = 1 THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY LeadTimeGroup
ORDER BY CASE LeadTimeGroup
    WHEN '0-7' THEN 1
    WHEN '8-30' THEN 2
    WHEN '31-90' THEN 3
    WHEN '91-180' THEN 4
    WHEN '181+' THEN 5
END;


-- =========================================================
-- E3.3 — Cancellation by Market Segment
-- نحدد القطاعات التي لديها معدل إلغاء أعلى
-- =========================================================

SELECT
    MarketSegment,
    COUNT(*) AS TotalBookings,
    SUM(CASE
        WHEN IsCanceled = 1 THEN 1
        ELSE 0
    END) AS CanceledBookings,

    ROUND(
        100.0 * SUM(CASE
            WHEN IsCanceled = 1 THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS CancellationRate
FROM hotel_bookings 
GROUP BY MarketSegment
ORDER BY CancellationRate;


-- =========================================================
-- E3.4 — Cancellation by Distribution Channel
-- نقارن معدل الإلغاء بين قنوات التوزيع
-- =========================================================

SELECT
    DistributionChannel,
    COUNT(*) AS TotalBookings,

    SUM(CASE
        WHEN IsCanceled = 1 THEN 1
        ELSE 0
    END) AS CanceledBookings,

    ROUND(
        100.0 * SUM(CASE
            WHEN IsCanceled = 1 THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS CancellationRate

FROM hotel_bookings

GROUP BY DistributionChannel

ORDER BY CancellationRate DESC;


-- =========================================================
-- E3.5 — Cancellation by Deposit Type
-- نرى اختلاف الإلغاء حسب نوع العربون
-- =========================================================

SELECT
    DepositType,
    COUNT(*) AS TotalBookings,

    SUM(CASE
        WHEN IsCanceled = 1 THEN 1
        ELSE 0
    END) AS CanceledBookings,

    ROUND(
        100.0 * SUM(CASE
            WHEN IsCanceled = 1 THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS CancellationRate

FROM hotel_bookings

GROUP BY DepositType

ORDER BY CancellationRate DESC;


-- =========================================================
-- E3.6 — Cancellation by Guest Type
-- نقارن العملاء الجدد بالعملاء المتكررين
-- =========================================================

SELECT
    GuestType,
    COUNT(*) AS TotalBookings,

    SUM(CASE
        WHEN IsCanceled = 1 THEN 1
        ELSE 0
    END) AS CanceledBookings,

    ROUND(
        100.0 * SUM(CASE
            WHEN IsCanceled = 1 THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS CancellationRate

FROM hotel_bookings

GROUP BY GuestType

ORDER BY CancellationRate DESC;

-- =========================================================
-- E4 — Advanced Booking Behavior
-- =========================================================


-- نقارن مدة الحجز المسبق مع الإلغاء داخل كل فندق

SELECT 
    Hotel,
    LeadTimeGroup,
    COUNT(*) AS TotalBookings,
    SUM(IsCanceled) AS CanceledBookings,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY Hotel , LeadTimeGroup
ORDER BY Hotel , CASE LeadTimeGroup
    WHEN '0-7' THEN 1
    WHEN '8-30' THEN 2
    WHEN '31-90' THEN 3
    WHEN '91-180' THEN 4
    WHEN '181+' THEN 5
END;


-- نحدد القطاعات التي ترتفع فيها الإلغاءات مع مدة الحجز المسبق

SELECT 
    MarketSegment,
    LeadTimeGroup,
    COUNT(*) AS TotalBookings,
    SUM(IsCanceled) AS CanceledBookings,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY MarketSegment , LeadTimeGroup
HAVING COUNT(*) >= 100
ORDER BY CancellationRate DESC;


-- نبحث عن المجموعات ذات الحجم المرتفع ونسبة الإلغاء المرتفعة

SELECT 
    Hotel,
    MarketSegment,
    LeadTimeGroup,
    COUNT(*) AS TotalBookings,
    SUM(IsCanceled) AS CanceledBookings,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY Hotel , MarketSegment , LeadTimeGroup
HAVING COUNT(*) >= 500
    AND AVG(IsCanceled) >= 0.30
ORDER BY TotalBookings DESC;


-- نقارن سلوك الضيوف الجدد والمتكررين

SELECT 
    GuestType,
    COUNT(*) AS TotalBookings,
    ROUND(AVG(LeadTime), 2) AS AvgLeadTime,
    ROUND(AVG(TotalStayNights), 2) AS AvgStayNights,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY GuestType
ORDER BY TotalBookings DESC;



-- =========================================================
-- E5 — Market & Customer Analysis
-- =========================================================


-- نقارن أداء كل Market Segment

WITH segment_data AS (
    SELECT 
        MarketSegment,
        COUNT(*) AS TotalBookings,
        AVG(ADR) AS AvgADR,
        AVG(TotalStayNights) AS AvgStay,
        AVG(IsCanceled) * 100 AS CancellationRate
    FROM hotel_bookings
    GROUP BY MarketSegment
)
SELECT 
    MarketSegment,
    TotalBookings,
    ROUND(
        TotalBookings * 100.0 / 
        SUM(TotalBookings) OVER (),
        2
    ) AS BookingShare,
    ROUND(AvgADR, 2) AS AvgADR,
    ROUND(AvgStay, 2) AS AvgStay,
    ROUND(CancellationRate, 2) AS CancellationRate
FROM segment_data
ORDER BY TotalBookings DESC;


-- نقارن أداء قنوات التوزيع

SELECT 
    DistributionChannel,
    COUNT(*) AS TotalBookings,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS BookingShare,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(TotalGuests), 2) AS AvgGuest,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM hotel_bookings
GROUP BY DistributionChannel
ORDER BY TotalBookings DESC;


-- نحدد أهم الأسواق الجغرافية

SELECT 
    Country,
    COUNT(*) AS TotalBookings,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS BookingShare,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(TotalGuests), 2) AS AvgGuest,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM hotel_bookings
WHERE Country IS NOT NULL
AND Country <> ''
GROUP BY Country
HAVING COUNT(*) >= 100
ORDER BY TotalBookings DESC
LIMIT 15;


-- نقارن أداء أنواع العملاء

SELECT
    CustomerType,
    COUNT(*) AS TotalBookings,
    ROUND(
        COUNT(*) * 100.0 / 
        SUM(COUNT(*)) OVER (),
        2
    ) AS BookingShare,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(TotalGuests), 2) AS AvgGuests,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM hotel_bookings 
GROUP BY CustomerType
ORDER BY TotalBookings DESC;


-- نبحث عن شرائح العملاء ذات الحجم والقيمة المرتفعين

SELECT 
    CustomerType,
    MarketSegment,
    COUNT(*) AS TotalBookings,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(TotalGuests), 2) AS AvgGuests,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY CustomerType , MarketSegment
HAVING COUNT(*) >= 300
ORDER BY AvgADR DESC , TotalBookings DESC;



-- =========================================================
-- E6 — Stay & Room Analysis
-- =========================================================


-- نحلل الحجوزات حسب مدة الإقامة

SELECT
    StayType,
    COUNT(*) AS TotalBookings,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS BookingShare,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM hotel_bookings
GROUP BY StayType
ORDER BY  
    CASE StayType
        WHEN 'No Stay' THEN 1
        WHEN 'Short Stay' THEN 2
        WHEN 'Medium Stay' THEN 3
        WHEN 'Long Stay' THEN 4
    END;


-- نقارن أنماط الإقامة بين الفندقين

SELECT 
    Hotel,
    StayType,
    COUNT(*) AS TotalBookings,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY Hotel , StayType
ORDER BY Hotel , TotalBookings DESC;


-- نحلل الغرف المحجوزة من ناحية الطلب والسعر والإلغاء

SELECT
    ReservedRoomType,
    COUNT(*) AS TotalBookings,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS BookingShare,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM hotel_bookings
GROUP BY ReservedRoomType
ORDER BY TotalBookings DESC;


-- نقارن الحجوزات التي تغير فيها نوع الغرفة مع غيرها

SELECT
    RoomChanged,
    COUNT(*) AS TotalBookings,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS BookingShare,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM hotel_bookings
GROUP BY RoomChanged
ORDER BY TotalBookings DESC;


-- نحدد أين تتركز تغييرات الغرف داخل كل فندق

SELECT 
    Hotel,
    RoomChanged,
    COUNT(*) AS TotalBookings,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY Hotel),
        2
    ) AS ShareWithHotel,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM hotel_bookings
GROUP BY Hotel , RoomChanged
ORDER BY Hotel , TotalBookings DESC;


-- نقارن مدة الإقامة مع ADR باستخدام القيم الصحيحة فقط

SELECT 
    StayType,
    COUNT(*) AS TotalBookings,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM
    hotel_bookings
WHERE
    ADR_Status = 'Valid'
GROUP BY StayType
ORDER BY CASE StayType
    WHEN 'No Stay' THEN 1
    WHEN 'Short Stay' THEN 2
    WHEN 'Medium Stay' THEN 3
    WHEN 'Long Stay' THEN 4
END;


-- نحلل الحجوزات حسب عدد الضيوف

SELECT 
    CASE
        WHEN TotalGuests = 1 THEN '1 Guest'
        WHEN TotalGuests = 2 THEN '2 Guests'
        WHEN TotalGuests = 3 THEN '3 Guests'
        ELSE '4+ Guests'
    END AS GuestGroup,
    COUNT(*) AS TotalBookings,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(IsCanceled) * 100, 2) AS CancellationRate
FROM
    hotel_bookings
GROUP BY CASE
    WHEN TotalGuests = 1 THEN '1 Guest'
    WHEN TotalGuests = 2 THEN '2 Guests'
    WHEN TotalGuests = 3 THEN '3 Guests'
    ELSE '4+ Guests'
END
ORDER BY TotalBookings DESC;


-- =========================================================
-- E7 — ADR & Revenue Analysis
-- =========================================================


-- E7.1 — ADR Quality

SELECT
	ADR_Status,
    COUNT(*) AS TotalBookings,
    ROUND(
		COUNT(*) * 100.0 / 
        SUM(COUNT(*)) OVER (),
        2
    ) AS BookingShare,
    ROUND(MIN(ADR), 2) AS MinADR,
    ROUND(MAX(ADR), 2) AS MaxADR,
    ROUND(AVG(ADR), 2) AS AvgADR
FROM hotel_bookings
GROUP BY ADR_Status
ORDER BY TotalBookings DESC;

-- E7.2 — ADR by Hotel and Year

SELECT 
    Hotel,
    ArrivalYear,
    COUNT(*) AS TotalBookings,
    ROUND(MIN(ADR), 2) AS MinADR,
    ROUND(MAX(ADR), 2) AS MaxADR,
    ROUND(AVG(ADR), 2) AS AvgADR
FROM hotel_bookings
WHERE ADR_Status = 'Valid'
GROUP BY Hotel, ArrivalYear
ORDER BY Hotel, ArrivalYear;

-- E7.3 — ADR by Market Segment

SELECT
	MarketSegment,
    COUNT(*) AS TotalBookings,
    ROUND(
		COUNT(*) * 100.0 / 
        SUM(COUNT(*)) OVER(),
        2
    ) AS BookingShare,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(AVG(IsCanceled), 2) AS CancellationRate
FROM hotel_bookings
WHERE ADR_Status = 'Valid'
GROUP BY MarketSegment
HAVING COUNT(*) >= 100
ORDER BY AvgADR DESC;

-- E7.4 — Estimated Stay Value

SELECT 
    Hotel,
    COUNT(*) AS CompletedBookings,
    ROUND(AVG(ADR), 2) AS AvgADR,
    ROUND(AVG(TotalStayNights), 2) AS AvgStay,
    ROUND(SUM(ADR * TotalStayNights), 2) AS EstimatedStayValue,
    ROUND(SUM(ADR * TotalStayNights) / COUNT(*), 2) AS AvgEstimatedValuePerBooking
FROM hotel_bookings
WHERE
    IsCanceled = 0 AND ADR_Status = 'Valid'
GROUP BY Hotel
ORDER BY EstimatedStayValue;


