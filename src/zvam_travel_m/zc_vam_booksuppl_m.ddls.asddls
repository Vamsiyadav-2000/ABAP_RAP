@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumtion View for Booking Supplement'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_VAM_BOOKSUPPL_M as projection on ZI_VAM_BOOKSUPPL_M
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    @ObjectModel.text.element: [ 'SupplDesc' ]
    @Consumption.valueHelpDefinition: [{  entity :{
                                     name : '/DMO/I_Supplement',
                                     element: 'SupplementID'
                                   },
                       additionalBinding:[{ element: 'SupplementID',
                                                localElement: 'SupplementId' },
                                              { element: 'CurrencyCode',
                                                localElement: 'CurrencyCode' },
                                              { element: 'Price',
                                                localElement: 'Price' 
                                         }]
                                        }]
    SupplementId,
    _SupplementText.Description as SupplDesc : localized,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    @Consumption.valueHelpDefinition: [{  entity :{
                                     name : 'I_Currency',
                                     element: 'Currency'
                                   } }]
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking: redirected to parent ZC_VAM_BOOKING_M,
    _Supplement,
    _SupplementText,
    _Travel : redirected to ZC_VAM_TRAVEL_M
}
