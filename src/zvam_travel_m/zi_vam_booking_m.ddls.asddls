@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Interface view Managed'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_VAM_BOOKING_M as select from zvam_booking_m
association to parent ZI_VAM_TRAVEL_M as _Travel on $projection.TravelId = _Travel.TravelId
composition [0..*] of ZI_VAM_BOOKSUPPL_M as _BookingSuppl 
association [1..1] to /DMO/I_Carrier as _Airline on $projection.CarrierId = _Airline.AirlineID
association [1..1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID
association [1..1] to /DMO/I_Connection as _Connection on $projection.CarrierId = _Connection.AirlineID and $projection.ConnectionId = _Connection.ConnectionID
association [1..1] to /DMO/I_Booking_Status_VH as _BookingStatus on $projection.BookingStatus = _BookingStatus.BookingStatus


{
    key travel_id as TravelId,
    key booking_id as BookingId,
    booking_date as BookingDate,
    customer_id as CustomerId,
    carrier_id as CarrierId,
    connection_id as ConnectionId,
    flight_date as FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    flight_price as FlightPrice,
    currency_code as CurrencyCode,
    booking_status as BookingStatus,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true /*annotation to enble etag field*/
    last_changed_at as LastChangedAt,
 
//Composition
_BookingSuppl, 
//Associations -------->
_Travel , /*parent child relation*/
_Airline,
_Customer,
_Connection,
_BookingStatus
}
