CREATE OR REPLACE PROCEDURE OPERACION.P_CREAR_EF_ANALOGICAS (a_numslc in char) IS

BEGIN

   -- SE DERIVA A PEX Y PI
	INSERT INTO SOLEFXAREA ( CODDPT, CODEF, NUMSLC, ESTSOLEF, ESRESPONSABLE, NUMDIAPLA)
   VALUES ( '0031  ', TO_NUMBER(A_NUMSLC), A_NUMSLC, 1, 0 , NULL);
	INSERT INTO SOLEFXAREA ( CODDPT, CODEF, NUMSLC, ESTSOLEF, ESRESPONSABLE, NUMDIAPLA )
   VALUES ( '0047  ', TO_NUMBER(A_NUMSLC), A_NUMSLC, 1, 1 , NULL);
	INSERT INTO SOLEFXAREA ( CODDPT, CODEF, NUMSLC, ESTSOLEF, ESRESPONSABLE, NUMDIAPLA )
   VALUES ( '0035  ', TO_NUMBER(A_NUMSLC), A_NUMSLC, 1, 0 , NULL);

   -- SE CARGAN LOS PUNTOS DEL PRY
   P_ACT_EF_DE_SOL(TO_NUMBER(A_NUMSLC));

   -- SE DAN LOS PARAMETROS NECESARIOS AL EF
   UPDATE EF SET NUMDIAPLA = NULL
   WHERE NUMSLC = A_NUMSLC;


   -- SE HARA ALGO MAS

END;
/

