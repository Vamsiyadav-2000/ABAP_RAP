@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumtion View for Booking'
@Metadata.allowExtensions: true
define view entity ZC_VAM_BOOKING_M
  as projection on ZI_VAM_BOOKING_M
{
  key TravelId,
  key BookingId,
      BookingDate,
      @ObjectModel.text.element: [ 'custName']
      @Consumption.valueHelpDefinition: [{ entity : { name: '/DMO/I_Customer',
                                                  element: 'CustomerID'} }]
      CustomerId,
      _Customer.LastName        as custName,
      @ObjectModel.text.element: [ 'AirlineName' ]
      @Consumption.valueHelpDefinition: [{  entity :{
                                      name : '/DMO/I_Carrier',
                                      element: 'AirlineID'
                                    } }]
      CarrierId,
      _Airline.Name             as AirlineName,
      ConnectionId,
      @Consumption.valueHelpDefinition: [{

                            entity :{
                                      name : '/DMO/I_Carrier',
                                      element: 'AirlineID'
                                    },
                          additionalBinding: [{ element: 'ConnectionId',
                                                localElement: 'ConnectionId' },
                                              { element: 'AirlineId',
                                                localElement: 'CarrierId' },
                                              { element: 'CurrencyCode',
                                                localElement: 'CurrencyCode' },
                                              { element: 'Price',
                                                localElement: 'FlightPrice' }
                                            ]
      }]
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      @Consumption.valueHelpDefinition: [{  entity :{
                                     name : 'I_Currency',
                                     element: 'Currency'
                                   } }]
      CurrencyCode,
      @ObjectModel.text.element: ['statustext']
      @Consumption.valueHelpDefinition: [{ entity : { name: '/DMO/I_Booking_Status_VH',
                                                  element: 'BookingStatus'} }]
      BookingStatus,
      _BookingStatus._Text.Text as statustext : localized,
      LastChangedAt,
      /* Associations */
      _Airline,
      _BookingStatus,
      _BookingSuppl : redirected to composition child ZC_VAM_BOOKSUPPL_M,
      _Connection,
      _Customer,
      _Travel       : redirected to parent ZC_VAM_TRAVEL_M
}
