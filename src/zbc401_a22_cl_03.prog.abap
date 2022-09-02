*&---------------------------------------------------------------------*
*& Report ZBC401_A22_CL_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC401_A22_CL_03.

CLASS cl_1 DEFINITION.

  PUBLIC SECTION.
  data: num1 type i.
  METHODS : pro IMPORTING num2 type i.
  events : cutoff.
    endclass  .


 class cl_1 IMPLEMENTATION.

    method pro.
      num1 = num2.
      IF  num2 >= 2.
        RAISE event cutoff.
      ENDIF.
    ENDMETHOD.
   ENDCLASS.


   class cl_event DEFINITION.
     PUBLIC SECTION .
     METHODs : handling_cutoff for event cutoff of cl_1.
     ENDCLASS.


     class cl_event IMPLEMENTATION.
       METHOD : handling_cutoff.

         write : 'Handling the Cutoff' , / 'Event has been processed'.
         ENDMETHOD.
       endclass.



       START-OF-SELECTION.
       data: main1 type REF TO cl_1.
       data : eventh1 type REF TO cl_event.

       CREATE OBJECT main1.
       create OBJECT eventh1.

       set HANDLER eventh1->handling_cutoff for main1.
       main1->pro( 4 ).
