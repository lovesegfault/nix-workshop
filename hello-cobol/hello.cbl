       IDENTIFICATION DIVISION.
       PROGRAM-ID. Hello.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 ArgLen PIC 9(4).
       01 Name PIC X(32).

       PROCEDURE DIVISION.

       ACCEPT ArgLen FROM ARGUMENT-NUMBER.
       IF ArgLen = 0 THEN
         MOVE "Cobol world" TO Name
       ELSE
         ACCEPT Name FROM ARGUMENT-VALUE
       END-IF

       DISPLAY "Hello, " FUNCTION TRIM(Name) "!".

       EXIT PROGRAM.

