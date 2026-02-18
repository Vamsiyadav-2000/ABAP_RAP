CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS approve_travel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~approve_travel RESULT result.

    METHODS copyTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~copyTravel.

    METHODS reCalcTotPrice FOR MODIFY
      IMPORTING keys FOR ACTION Travel~reCalcTotPrice.

    METHODS reject_travel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~reject_travel RESULT result.

    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE Travel\_Booking.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING

            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )

          IMPORTING
            number            =  DATA(lv_latest_num)
            returncode        =  DATA(lv_code)
            returned_quantity =  DATA(lv_qty)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).

      LOOP AT lt_entities INTO DATA(ls_entities).
      APPEND VALUE #( %cid = ls_entities-%cid
                       %key = ls_entities-%key
                     ) TO failed-travel.

      APPEND VALUE #( %cid = ls_entities-%cid
                       %key = ls_entities-%key
                       %msg = lo_error
                     ) TO reported-travel.

      ENDLOOP.
      EXIT.  "exit after handling error.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).

*    DATA : lt_vam_travel_m  type TABLE for mapped early zi_vam_travel_m,
*           ls_vam_travel_m like line of lt_vam_travel_m.

    DATA(lv_curr_num) = lv_latest_num - 1.

    LOOP AT lt_entities INTO ls_entities.

        lv_curr_num += 1. " lv_curr_num = lv_curr_num + 1.

*        ls_vam_travel_m = VALUE #( %cid = ls_entities-%cid
*                                    TravelId = lv_curr_num
*                                    ).
*        APPEND ls_vam_travel_m TO mapped-travel.

        APPEND VALUE #( %cid = ls_entities-%cid
                        TravelId = lv_curr_num
                       ) TO mapped-travel.

    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

  DATA : lv_max_booking TYPE /dmo/booking_id.

  READ ENTITIES OF zi_vam_travel_m IN LOCAL MODE
       ENTITY TRAVEL BY \_Booking
       FROM CORRESPONDING #( entities )
       LINK DATA(lt_link_data).


  LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>)
                             GROUP BY <ls_group_entity>-TravelId.


       lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_Id( '0' )
                                  FOR ls_link in lt_link_data USING KEY entity
                                 WHERE ( source-TravelId = <ls_group_entity>-TravelId )
                                 NEXT lv_max = COND /dmo/booking_Id( WHEN lv_max < ls_link-target-BookingId
                                                                     THEN ls_link-target-BookingId
                                                                     ELSE lv_max  )
                                    ).


      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                                 FOR ls_entity IN entities USING KEY entity
                                 WHERE ( TravelId = <ls_group_entity>-TravelId )
                                 FOR ls_booking in ls_entity-%target
                                 NEXT lv_max = COND /dmo/booking_Id( WHEN lv_max < ls_booking-BookingId
                                                                     THEN ls_booking-BookingId
                                                                     ELSE lv_max  )  ).




  LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>)
                   USING KEY entity
                   WHERE TravelId = <ls_group_entity>-TravelId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).

        APPEND CORRESPONDING #( <ls_booking> ) TO MAPPED-booking
                                          ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).

            IF <ls_booking>-BookingId IS INITIAL.

                    lv_max_booking += 10.

                   <ls_new_map_book>-BookingId = lv_max_booking.

            ENDIF.

        ENDLOOP.
  ENDLOOP.


  ENDLOOP.

  ENDMETHOD.

  METHOD approve_travel.
  ENDMETHOD.

  METHOD copyTravel.


   DATA: it_travel TYPE TABLE FOR CREATE ZI_VAM_TRAVEL_M,
         it_booking_cba TYPE TABLE FOR CREATE ZI_VAM_TRAVEL_M\_Booking,
         it_booksupp_cba TYPE TABLE FOR CREATE ZI_VAM_BOOKING_M\_BookingSuppl.

    READ TABLE Keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ' '.
    IF sy-subrc = '0'.
        ASSERT <ls_without_cid> IS INITIAL.
    ENDIF.

    READ ENTITIES OF ZI_VAM_TRAVEL_M IN LOCAL MODE
    ENTITY Travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_r)
    FAILED DATA(lt_failed).

    READ ENTITIES OF ZI_VAM_TRAVEL_M IN LOCAL MODE
    ENTITY Travel BY \_Booking
    ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
    RESULT DATA(lt_booking_r).

    READ ENTITIES OF ZI_VAM_TRAVEL_M IN LOCAL MODE
    ENTITY Booking BY \_BookingSuppl
    ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
    RESULT DATA(lt_booksupp_r).


    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).

*        APPEND INITIAL LINE TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*
*        <ls_travel>-%cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid.   ---> appending empty record and assigning values
*        <ls_travel>-%data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ).

        APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
                        %data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ) )        "single step
                      TO  it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).


           <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date( ).
           <ls_travel>-EndDate   = cl_abap_context_info=>get_system_date( ) + 30.
           <ls_travel>-OverallStatus = 'O'.

           APPEND VALUE #( %cid_ref = <ls_travel>-%cid )
                         TO it_booking_cba ASSIGNING FIELD-SYMBOL(<ls_booking>).

           LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
                                USING KEY entity
                                WHERE TravelId = <ls_travel_r>-TravelId.


              APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId
                              %data = CORRESPONDING #( <ls_booking_r> EXCEPT TravelId  ) )
                              TO <ls_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).

                 <ls_booking_n>-BookingStatus = 'N'.


                 APPEND VALUE #( %cid_ref = <ls_booking_n>-%cid ) TO it_booksupp_cba ASSIGNING FIELD-SYMBOL(<ls_booksupp>).

                 LOOP AT lt_booksupp_r ASSIGNING FIELD-SYMBOL(<ls_booksupp_r>)
                                       USING KEY entity
                                       WHERE TravelId  = <ls_travel_r>-TravelId
                                       AND   BookingId = <ls_booking_r>-BookingId.

                 APPEND VALUE #( %cid = <ls_travel>-TravelId && <ls_booking_r>-BookingId && <ls_booksupp_r>-BookingSupplementId
                                 %data = CORRESPONDING #( <ls_booksupp_r> EXCEPT TravelId BookingId ) )
                                 TO <ls_booksupp>-%target.

                 ENDLOOP.

           ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF ZI_VAM_TRAVEL_M IN LOCAL MODE
    ENTITY Travel
    CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
    WITH it_travel

    ENTITY Travel
    CREATE BY \_Booking
    FIELDS ( BookingId CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
    WITH it_booking_cba


    ENTITY Booking
    CREATE BY \_BookingSuppl
    FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
    WITH it_booksupp_cba

    FAILED DATA(lt_failed1)
    MAPPED DATA(lt_mapped)
    REPORTED DATA(lt_result).

    mapped-travel = lt_mapped-travel.



  ENDMETHOD.

  METHOD reCalcTotPrice.
  ENDMETHOD.

  METHOD reject_travel.
  ENDMETHOD.

ENDCLASS.
