CLASS zcl_read_ops DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_read_ops IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

****************************** short form read - %CONTROL **********************************

*    READ ENTITY zi_vam_travel_m
*     FROM VALUE #( ( %key-TravelId = '00005002'
*                     %control = VALUE #( AgencyId   = if_abap_behv=>mk-on
*                                         CustomerId = if_abap_behv=>mk-on
*                                         BeginDate  = if_abap_behv=>mk-on
*                                       )
*
*                     )
*                     )   " field control using %control
*                   RESULT DATA(lt_result_short)
*                   FAILED DATA(lt_failed_short).

****************************** short form read - %FIELDS **********************************

*    READ ENTITY zi_vam_travel_m
*    FIELDS ( AgencyId CustomerId BeginDate BookingFee Description )
*    WITH VALUE  #( ( %key-TravelId = '00005002' ) )
*     RESULT DATA(lt_result_short)
*     FAILED DATA(lt_failed_short).

****************************** short form read - allfields **********************************

    READ ENTITY zi_vam_travel_m
    ALL FIELDS
    WITH VALUE  #( ( %key-TravelId = '00005002' )
                   ( %key-TravelId = '00005001' ) )
     RESULT DATA(lt_result_short)
     FAILED DATA(lt_failed_short).


     IF lt_failed_short IS NOT INITIAL.

      out->write( 'Read failed' ).

    ELSE.

      out->write( lt_result_short ).

    ENDIF.


****************************** short form read - ASSOCIATION  **********************************

  READ ENTITY zi_vam_travel_m
  BY \_Booking
  ALL FIELDS
  WITH VALUE #( ( %key-TravelId = '00005002' )  "don't have booking
                ( %key-TravelId = '00005001' ) )  "have booking
     RESULT DATA(lt_result_assoc)
     FAILED DATA(lt_failed_assoc).



    IF lt_failed_assoc IS NOT INITIAL.

      out->write( 'Read failed' ).

    ELSE.

      out->write( lt_result_assoc ).

    ENDIF.

****************************** long form read - multiple entities  **********************************

  READ ENTITIES OF zi_vam_travel_m
  ENTITY Travel
  ALL FIELDS
  WITH VALUE #( ( %key-TravelId = '00005002' )  "don't have booking
                ( %key-TravelId = '00005001' ) )  "have booking
     RESULT DATA(lt_result_travel)

  ENTITY Booking
  ALL FIELDS
  WITH VALUE #( ( %key-TravelId = '00005001'
                 %key-BookingId = '5101' ) )
     RESULT DATA(lt_result_booking)
     FAILED DATA(lt_failed_long).


    IF lt_failed_long IS NOT INITIAL.

      out->write( 'Read failed' ).

    ELSE.

      out->write( lt_result_travel ).
      out->write( lt_result_booking ).

    ENDIF.


****************************** dynamic read *********************************************

  DATA : it_optab             TYPE abp_behv_retrievals_tab,
         it_travel            TYPE TABLE FOR READ IMPORT zi_vam_travel_m,
         it_travel_result     TYPE TABLE FOR READ RESULT zi_vam_travel_m,
         it_booking           TYPE TABLE FOR READ IMPORT zi_vam_travel_m\_Booking,
         it_booking_result    TYPE TABLE FOR READ RESULT zi_vam_travel_m\_Booking.



    it_travel  = VALUE #( ( %key-TravelId = '00004325'
                            %control = VALUE #( AgencyId   = if_abap_behv=>mk-on
                                                CustomerId = if_abap_behv=>mk-on
                                                BeginDate  = if_abap_behv=>mk-on
                                              )
                        ) ).

   it_booking = VALUE #( ( %key-TravelId = '00004325'
                           %control = VALUE #(
                                      BookingDate   = if_abap_behv=>mk-on
                                      BookingStatus = if_abap_behv=>mk-on
                                      BookingId     = if_abap_behv=>mk-on
                                      )
                           ) ).


    it_optab = VALUE #( (
                             op = if_abap_behv=>op-r-read
                             entity_name = 'ZI_VAM_TRAVEL_M'
                             instances = Ref #( it_travel )
                             results    = REF #( it_travel_result ) )

                         (
                             op = if_abap_behv=>op-r-read_ba
                             entity_name = 'ZI_VAM_TRAVEL_M'
                             sub_name   = '_BOOKING'
                             instances  =  REF #( it_booking )
                             results    = REF #( it_booking_result ) )

                         ).

    READ ENTITIES
    OPERATIONS it_optab
    FAILED DATA(lt_failed_dyn).


    IF lt_failed_dyn IS NOT INITIAL.

      out->write( 'Read failed' ).

    ELSE.

      out->write( it_travel_result ).
      out->write( it_booking_result ).

    ENDIF.





  ENDMETHOD.
ENDCLASS.
