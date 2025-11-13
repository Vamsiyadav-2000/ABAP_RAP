 @AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumtion View for Travel'
@Metadata.allowExtensions: true
define root view entity ZC_VAM_TRAVEL_M
provider contract transactional_query
 as projection on ZI_VAM_TRAVEL_M
{
    key TravelId,
    AgencyId,
    _Agency.Name as AgencyName,
    CustomerId,
    _Customer.LastName as CustomerName,  
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    Description,
    OverallStatus,
    _Status._Text.Text : localized,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _Agency,
    _Booking: redirected to composition child ZC_VAM_BOOKING_M,
    _Currency,
    _Customer,
    _Status
}
