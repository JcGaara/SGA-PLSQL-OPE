CREATE OR REPLACE PROCEDURE OPERACION.P_Llena_Presu_De_Solotpto(
   a_codsolot solotpto.CODSOLOT%type,
   a_punto solotpto.PUNTO%type,
   a_codinssrv solotpto.CODINSSRV%type,
   a_cid solotpto.CID%type,
   a_descripcion solotpto.DESCRIPCION%type,
   a_direccion solotpto.DIRECCION%type,
   a_codubi solotpto.CODUBI%type
) IS

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

END ;
/


