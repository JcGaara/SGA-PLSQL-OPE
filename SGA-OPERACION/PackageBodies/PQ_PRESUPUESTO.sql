CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_PRESUPUESTO AS

/*  PROCEDIMIENTO QUE CREA UN REGISTRO PRESUPUESTO A PARTIR DE LA GENERACION DE UN SOLOT */
PROCEDURE P_Llena_Presupuesto_De_Solot(a_codsolot solot.CODSOLOT%type, a_codcli solot.CODCLI%type, a_numslc solot.NUMSLC%type, a_tipsrv solot.TIPSRV%type) IS

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


/* PROCEDIMIENTO QUE CREA UN REGISTRO PREUBI A PARTIR DE LA GENERACION DE UN SOLOTPTO */
PROCEDURE P_Llena_Presu_De_Solotpto(a_codsolot solotpto.CODSOLOT%type, a_punto solotpto.PUNTO%type,
a_codinssrv solotpto.CODINSSRV%type, a_cid solotpto.CID%type, a_descripcion solotpto.DESCRIPCION%type,
a_direccion solotpto.DIRECCION%type, a_codubi solotpto.CODUBI%type) IS

l_codpre NUMBER;
l_idubi NUMBER;

BEGIN
   BEGIN
   SELECT codpre INTO l_codpre FROM PRESUPUESTO WHERE codsolot = a_codsolot;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       l_codpre := NULL;
   END;
   SELECT SQ_PREUBI.NEXTVAL INTO l_idubi FROM dual;
   INSERT INTO PREUBI(codpre, idubi, punto, codinssrv, cid, descripcion, dirobra, disobra,fecini, codsolot )
   VALUES ( l_codpre, l_idubi, a_punto, a_codinssrv, a_cid, a_descripcion, a_direccion, a_codubi, SYSDATE , a_codsolot);


   --ESTO SE VA A HACER CUANDO SE GENERE UNA OT
  /* INSERT INTO PREUBIETA(codpre, idubi, codeta)
   SELECT DISTINCT l_codpre, l_idubi, ETAPAXAREA.codeta FROM ETAPAXAREA
   where ETAPAXAREA.esnormal = 1;*/
/*
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
       */
END ;


END;
/


