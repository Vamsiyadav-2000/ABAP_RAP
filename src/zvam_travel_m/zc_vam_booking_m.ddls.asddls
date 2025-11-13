@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumtion View for Booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_VAM_BOOKING_M as projection on ZI_VAM_BOOKING_M
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _Airline,
    _BookingStatus,
    _BookingSuppl: redirected to composition child ZC_VAM_BOOKSUPPL_M,
    _Connection,
    _Customer,
    _Travel: redirected to parent ZC_VAM_TRAVEL_M
}
