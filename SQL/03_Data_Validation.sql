USE hotel_booking_analytics;

SELECT 
    COUNT(*) AS staging_rows
FROM
    stg_hotel_bookings;

SELECT 
    *
FROM
    stg_hotel_bookings
LIMIT 5;

SELECT 
    *
FROM
    stg_hotel_bookings
ORDER BY ArrivalDate DESC
LIMIT 5;

SELECT 
    *
FROM
    stg_hotel_bookings
LIMIT 1;

SELECT 
    COUNT(*) AS TotalRows, COUNT(DISTINCT Hotel) AS Hotels
FROM
    stg_hotel_bookings;

SELECT 
    Hotel, COUNT(*) AS BookingCount
FROM
    stg_hotel_bookings
GROUP BY Hotel
ORDER BY BookingCount DESC;

SELECT 
    IsCanceled, COUNT(*) AS BookingCount
FROM
    stg_hotel_bookings
GROUP BY IsCanceled
ORDER BY IsCanceled;

SELECT 
    COUNT(*) AS NegativeADR
FROM
    stg_hotel_bookings
WHERE
    ADR < 0;

SELECT 
    COUNT(*) AS ZeroADR
FROM
    stg_hotel_bookings
WHERE
    ADR = 0;

SELECT 
    MIN(ADR) AS MinADR, MAX(ADR) AS MaxADR, AVG(ADR) AS AvgADR
FROM
    stg_hotel_bookings;

SELECT 
    COUNT(*) AS InvalidStayCalculations
FROM
    stg_hotel_bookings
WHERE
    TotalStayNights <> WeekendNights + WeekNights;

SELECT 
    COUNT(*) AS InvalidGuestCalculations
FROM
    stg_hotel_bookings
WHERE
    TotalGuests <> Adults + Children + Babies;

SELECT 
    RoomChanged, COUNT(*) AS BookingCount
FROM
    stg_hotel_bookings
GROUP BY RoomChanged;

SELECT 
    COUNT(*) AS InvalidRoomChanged
FROM
    stg_hotel_bookings
WHERE
    (ReservedRoomType = AssignedRoomType
        AND RoomChanged <> 'No')
        OR (ReservedRoomType <> AssignedRoomType
        AND RoomChanged <> 'Yes');
    
SELECT 
    GuestType, COUNT(*) AS BookingCount
FROM
    stg_hotel_bookings
GROUP BY GuestType;


SELECT 
    COUNT(*) AS InvalidGuestType
FROM
    stg_hotel_bookings
WHERE
    (IsRepeatedGuest = 1
        AND GuestType <> 'Repeated Guest')
        OR (IsRepeatedGuest = 0
        AND GuestType <> 'New Guest');
    
    
SELECT 
    BookingStatus, COUNT(*) AS BookingCount
FROM
    stg_hotel_bookings
GROUP BY BookingStatus;

SELECT 
    COUNT(*) AS InvalidBookingStatus
FROM
    stg_hotel_bookings
WHERE
    (IsCanceled = 1
        AND BookingStatus <> 'Canceled')
        OR (IsCanceled = 0
        AND BookingStatus <> 'Not Canceled');
    
    
SELECT 
    MIN(ArrivalDate) AS MinArrivalDate,
    MAX(ArrivalDate) AS MaxArrivalDate
FROM
    stg_hotel_bookings;


SELECT 
    COUNT(*) AS MissingArrivalDate
FROM
    stg_hotel_bookings
WHERE
    ArrivalDate IS NULL;

SELECT 
    ArrivalYear, ArrivalMonth, ArrivalDay, ArrivalDate
FROM
    stg_hotel_bookings
WHERE
    ArrivalDate IS NOT NULL
LIMIT 10;

SELECT 
    COUNT(*) AS InvalidArrivalDateLogic
FROM
    stg_hotel_bookings
WHERE
    ArrivalDate IS NOT NULL
        AND (YEAR(ArrivalDate) <> ArrivalYear
        OR DAY(ArrivalDate) <> ArrivalDay);

SELECT 
    COUNT(*) AS NoGuestRecords
FROM
    stg_hotel_bookings
WHERE
    Adults = 0 AND Children = 0
        AND Babies = 0;
  

SELECT 
    COUNT(*) AS RoomChangedCount
FROM
    stg_hotel_bookings
WHERE
    RoomChanged = 'Yes';


SELECT 
    SUM(CASE
        WHEN Hotel IS NULL THEN 1
        ELSE 0
    END) AS Hotel_Null,
    SUM(CASE
        WHEN Children IS NULL THEN 1
        ELSE 0
    END) AS Children_Null,
    SUM(CASE
        WHEN Agent IS NULL THEN 1
        ELSE 0
    END) AS Agent_Null,
    SUM(CASE
        WHEN Company IS NULL THEN 1
        ELSE 0
    END) AS Company_Null,
    SUM(CASE
        WHEN Country IS NULL THEN 1
        ELSE 0
    END) AS Country_Null,
    SUM(CASE
        WHEN ArrivalDate IS NULL THEN 1
        ELSE 0
    END) AS ArrivalDate_Null
FROM
    stg_hotel_bookings;
    
    
SELECT COUNT(*) AS FinalRows
FROM hotel_bookings;

SELECT
    MIN(BookingID) AS MinBookingID,
    MAX(BookingID) AS MaxBookingID,
    COUNT(DISTINCT BookingID) AS UniqueBookingIDs,
    COUNT(*) AS TotalRows
FROM hotel_bookings;

