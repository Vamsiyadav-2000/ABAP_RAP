CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

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
  ENDMETHOD.

ENDCLASS.
