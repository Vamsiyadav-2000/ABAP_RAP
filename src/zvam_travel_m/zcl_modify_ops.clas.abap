CLASS zcl_modify_ops DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MODIFY_OPS IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

*    MODIFY entity zi_vam_travel_m
*    CREATE FROM VALUE #(
*                           ( %cid = 'cid1'
*                             %data-BeginDate = '20260218'
*                             %control-BeginDate = if_abap_behv=>mk-on
*                            )
*                        )
*
*    CREATE BY \_Booking
*           FROM VALUE #(
*                           ( %cid_ref = 'cid1'
*                             %target = VALUE #(
*                                                 ( %cid = 'cid11'
*                                                  BookingDate = '20260218'
*                                                  %control-BookingDate =  if_abap_behv=>mk-on )
*
*                                               )
*                           )
*
*                       )
*
*    FAILED FINAL(lt_failed)
*    MAPPED FINAL(lt_mapped)
*    REPORTED FINAL(lt_result).
*
*    IF lt_failed IS NOT INITIAL.
*
*    out->write( lt_failed ).
*
*    ELSE.
*         out->write( |Entries successfully written { lt_mapped-travel[ 1 ]-TravelId }.| ).
*             COMMIT ENTITIES.         "must do to commit changes to DB
*    ENDIF.
*
*
*  MODIFY ENTITY ZI_VAM_TRAVEL_M
*  DELETE FROM VALUE #( ( %key-TravelId = '4421' )  )
*  FAILED FINAL(lt_delfailed)
*  MAPPED FINAL(lt_mapfailed)
*  REPORTED FINAL(lt_resfailed).
*
*  IF lt_resfailed IS NOT INITIAL.
*
*    out->write( lt_resfailed ).
*
*    ELSE.
*         out->write( 'Entry succesfully deleted .' ).
*         COMMIT ENTITIES.         "must do to commit changes to DB
*    ENDIF.


**********************************************************************
* {AUTO FILL CID WITH FIELDS}

*MODIFY ENTITY ZI_VAM_TRAVEL_M
*CREATE AUTO FILL CID WITH VALUE  #(
*                                    (
*                                      %data-BeginDate = '20260219'
*                                      %control-BeginDate = if_abap_behv=>mk-on
*
*                                    ) )
*
*    FAILED FINAL(lt_failed)
*    MAPPED FINAL(lt_mapped)
*    REPORTED FINAL(lt_result).
*
*    IF lt_failed IS NOT INITIAL.
*
*    out->write( lt_failed ).
*
*    ELSE.
*         out->write( |Entries successfully written { lt_mapped-travel[ 1 ]-TravelId }.| ).
*             COMMIT ENTITIES.         "must do to commit changes to DB
*    ENDIF.
**********************************************************************
* {AUTO FILL CID  FIELDS(comp1, comp2 , ......) WITH fields tab}

*MODIFY ENTITIES OF ZI_VAM_TRAVEL_M
* ENTITY Travel
* UPDATE FIELDS ( Begindate )
* WITH VALUE #( ( %key-TravelId = '00004433'
*                 Begindate = '20260220' ) ).

* {AUTO FILL CID  SET FIELDS WITH fields tab}

MODIFY ENTITY ZI_VAM_TRAVEL_M
UPDATE SET FIELDS WITH VALUE #( ( %key-TravelId = '00004433'
                                  Begindate = '20260218'   "-----------> This version has performance issues with
                                  AgencyId = '70002'       " more fields
                                  CustomerId = '15' )  ).
  COMMIT ENTITIES.


ENDMETHOD.
ENDCLASS.
