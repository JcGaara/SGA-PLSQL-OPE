CREATE OR REPLACE PROCEDURE OPERACION.P_Llena_Presupuesto_De_Solot(a_codsolot solot.CODSOLOT%type, a_codcli solot.CODCLI%type, a_numslc solot.NUMSLC%type, a_tipsrv solot.TIPSRV%type) IS

l_new NUMBER(1);
l_codpre NUMBER;
l_idubi NUMBER;

BEGIN
   BEGIN
      SELECT codpre INTO l_codpre FROM PRESUPUESTO WHERE codsolot = a_codsolot;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       l_codpre := NULL;
   END ;

   -- se actualiza el presupuesto
   IF l_codpre IS NOT NULL THEN
   	l_new := 0;
   	UPDATE PRESUPUESTO SET tipsrv=a_tipsrv, codcli=a_codcli
      WHERE codpre = l_codpre;
   -- Se crea el presupuesto
   ELSE
   	l_new := 1;
      SELECT SQ_PRESUPUESTO.NEXTVAL INTO l_codpre FROM dual;

      INSERT INTO PRESUPUESTO(codpre, numslc, fecini, codsolot, tipsrv, estpro, codcli)
         values(l_codpre, a_numslc, SYSDATE, a_codsolot, a_tipsrv, 1, a_codcli);
   END IF;

END ;
/


