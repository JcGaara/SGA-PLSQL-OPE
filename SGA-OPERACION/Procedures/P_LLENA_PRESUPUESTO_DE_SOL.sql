CREATE OR REPLACE PROCEDURE OPERACION.P_Llena_Presupuesto_De_Sol(a_codsolot SOLOT.codsolot%TYPE) IS

l_new NUMBER(1);
l_codpre NUMBER;
l_idubi NUMBER;

CURSOR cur_ubi IS
   SELECT SOLOTPTO.punto, SOLOTPTO.codinssrv codinssrv, SOLOTPTO.cid cid, SOLOTPTO.descripcion, SOLOTPTO.direccion, SOLOTPTO.codubi
    FROM SOLOTPTO,
         INSSRV
   WHERE ( SOLOTPTO.codinssrv = INSSRV.codinssrv ) AND
         ( INSSRV.TIPINSSRV <> 6) AND
         ( SOLOTPTO.codsolot = a_codsolot )
   union all
   SELECT SOLOTPTO.punto, SOLOTPTO.codinssrv, SOLOTPTO.cid, SOLOTPTO.descripcion, SOLOTPTO.direccion, SOLOTPTO.codubi
    FROM SOLOTPTO
   WHERE SOLOTPTO.codINSSRV is null AND
         ( SOLOTPTO.codsolot = a_codsolot );


CURSOR cur_ubi2 IS
   SELECT SOLOTPTO.punto, SOLOTPTO.codinssrv codinssrv, SOLOTPTO.cid cid, SOLOTPTO.descripcion, SOLOTPTO.direccion, SOLOTPTO.codubi
    FROM SOLOTPTO,
         INSSRV
   WHERE ( SOLOTPTO.codinssrv = INSSRV.codinssrv ) AND
         ( INSSRV.TIPINSSRV <> 6) AND
         ( SOLOTPTO.codsolot = a_codsolot ) AND
          SOLOTPTO.punto NOT IN ( SELECT punto FROM PREUBI WHERE codpre = l_codpre )
   union all
   SELECT SOLOTPTO.punto, SOLOTPTO.codinssrv, SOLOTPTO.cid, SOLOTPTO.descripcion, SOLOTPTO.direccion, SOLOTPTO.codubi
    FROM SOLOTPTO
   WHERE SOLOTPTO.codINSSRV is null AND
         ( SOLOTPTO.codsolot = a_codsolot ) and
         SOLOTPTO.punto NOT IN ( SELECT punto FROM PREUBI WHERE codpre = l_codpre );

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
   	UPDATE PRESUPUESTO SET (tipsrv, codcli) = (SELECT tipsrv, codcli FROM SOLOT WHERE codsolot = a_codsolot)
      WHERE codpre = l_codpre;
   -- Se crea el presupuesto
   ELSE
   	l_new := 1;
      SELECT SQ_PRESUPUESTO.NEXTVAL INTO l_codpre FROM dual;

      INSERT INTO PRESUPUESTO(codpre, numslc, fecini, codsolot, tipsrv, estpro, codcli )
         SELECT l_codpre, numslc, SYSDATE, a_codsolot, tipsrv, 1, codcli FROM SOLOT WHERE codsolot = a_codsolot ;
   END IF;

   -- Se llenan las ubi y las etapas
   IF l_new = 1 THEN
   	FOR lc1 IN cur_ubi LOOP
   	   SELECT SQ_PREUBI.NEXTVAL INTO l_idubi FROM dual;

   	   INSERT INTO PREUBI(codpre, idubi, punto, codinssrv, cid, descripcion, dirobra, disobra,fecini, codsolot )
         VALUES ( l_codpre, l_idubi, lc1.punto, lc1.codinssrv, lc1.cid, lc1.descripcion, lc1.direccion, lc1.codubi,SYSDATE , a_codsolot);

   		INSERT INTO PREUBIETA(codpre, idubi, codeta)
   		SELECT DISTINCT l_codpre, l_idubi, ETAPAXAREA.codeta FROM ETAPAXAREA
       	WHERE ETAPAXAREA.coddpt IN ( '0031', '0040', '0041' ) AND ETAPAXAREA.esnormal = 1;

      END LOOP;
   ELSE
   	FOR lc1 IN cur_ubi2 LOOP
   	   SELECT SQ_PREUBI.NEXTVAL INTO l_idubi FROM dual;

   	   INSERT INTO PREUBI(codpre, idubi, punto, codinssrv, cid, descripcion, dirobra, disobra )
         VALUES ( l_codpre, l_idubi, lc1.punto, lc1.codinssrv, lc1.cid, lc1.descripcion, lc1.direccion, lc1.codubi );

   		INSERT INTO PREUBIETA(codpre, idubi, codeta)
   		SELECT DISTINCT l_codpre, l_idubi, ETAPAXAREA.codeta FROM ETAPAXAREA
       	WHERE ETAPAXAREA.coddpt IN ( '0031', '0040', '0041' ) AND ETAPAXAREA.esnormal = 1;

      END LOOP;
      -- Se deberian borrar los SIDs que no se encuentren en solotpto
      -- PENDIENTE

   END IF;

/*
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
       */
END ;
/


