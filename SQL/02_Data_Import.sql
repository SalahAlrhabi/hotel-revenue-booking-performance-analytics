LOAD DATA LOCAL INFILE 'C:/Users/salah/Desktop/Hotel-Revenue-Booking-Analytics/data/hotel_bookings_cleaned.csv'
INTO TABLE stg_hotel_bookings
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    Hotel,
    IsCanceled,
    LeadTime,
    ArrivalYear,
    ArrivalMonth,
    ArrivalWeekNumber,
    ArrivalDay,
    WeekendNights,
    WeekNights,
    Adults,
    Children,
    Babies,
    Meal,
    Country,
    MarketSegment,
    DistributionChannel,
    IsRepeatedGuest,
    PreviousCancellations,
    PreviousBookingsNotCanceled,
    ReservedRoomType,
    AssignedRoomType,
    BookingChanges,
    DepositType,
    Agent,
    Company,
    WaitingListDays,
    CustomerType,
    ADR,
    ParkingSpaces,
    SpecialRequests,
    ReservationStatus,
    @ReservationStatusDate,
    ADR_Status,
    @ArrivalDate,
    TotalStayNights,
    TotalGuests,
    BookingStatus,
    RoomChanged,
    GuestType,
    StayType,
    LeadTimeGroup
)
SET
    ReservationStatusDate =
        CASE
            WHEN @ReservationStatusDate = '' THEN NULL
            WHEN @ReservationStatusDate LIKE '%-%'
                THEN STR_TO_DATE(@ReservationStatusDate, '%Y-%m-%d')
            ELSE STR_TO_DATE(@ReservationStatusDate, '%m/%d/%Y')
        END,

    ArrivalDate =
        CASE
            WHEN @ArrivalDate = '' THEN NULL
            WHEN @ArrivalDate LIKE '%-%'
                THEN STR_TO_DATE(@ArrivalDate, '%Y-%m-%d')
            ELSE STR_TO_DATE(@ArrivalDate, '%m/%d/%Y')
        END;
        
INSERT INTO hotel_bookings (
    Hotel,
    IsCanceled,
    LeadTime,
    ArrivalYear,
    ArrivalMonth,
    ArrivalWeekNumber,
    ArrivalDay,
    ArrivalDate,
    WeekendNights,
    WeekNights,
    TotalStayNights,
    Adults,
    Children,
    Babies,
    TotalGuests,
    Meal,
    Country,
    MarketSegment,
    DistributionChannel,
    IsRepeatedGuest,
    PreviousCancellations,
    PreviousBookingsNotCanceled,
    ReservedRoomType,
    AssignedRoomType,
    RoomChanged,
    BookingChanges,
    DepositType,
    Agent,
    Company,
    WaitingListDays,
    CustomerType,
    ADR,
    ADR_Status,
    ParkingSpaces,
    SpecialRequests,
    ReservationStatus,
    ReservationStatusDate,
    BookingStatus,
    GuestType,
    StayType,
    LeadTimeGroup
)
SELECT
    Hotel,
    IsCanceled,
    LeadTime,
    ArrivalYear,
    ArrivalMonth,
    ArrivalWeekNumber,
    ArrivalDay,
    ArrivalDate,
    WeekendNights,
    WeekNights,
    TotalStayNights,
    Adults,
    Children,
    Babies,
    TotalGuests,
    Meal,
    Country,
    MarketSegment,
    DistributionChannel,
    IsRepeatedGuest,
    PreviousCancellations,
    PreviousBookingsNotCanceled,
    ReservedRoomType,
    AssignedRoomType,
    RoomChanged,
    BookingChanges,
    DepositType,
    Agent,
    Company,
    WaitingListDays,
    CustomerType,
    ADR,
    ADR_Status,
    ParkingSpaces,
    SpecialRequests,
    ReservationStatus,
    ReservationStatusDate,
    BookingStatus,
    GuestType,
    StayType,
    LeadTimeGroup
FROM stg_hotel_bookings;