@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumtion View for Booking Supplement'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_VAM_BOOKSUPPL_M as projection on ZI_VAM_BOOKSUPPL_M
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking: redirected to parent ZC_VAM_BOOKING_M,
    _Supplement,
    _SupplementText,
    _Travel
}
