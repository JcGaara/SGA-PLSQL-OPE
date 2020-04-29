CREATE OR REPLACE PROCEDURE OPERACION.P_PE_BORRAR_CID_DE_SOLOT (
a_codsolot IN NUMBER,
a_cid IN NUMBER )
IS
/******************************************************************************
NAME:       P_PE_BORRAR_CID_DE_SOLOT
PURPOSE:    Desasignar un CID mal asignado a una SOT.

REVISIONS:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        06/10/2004  C.Corrales
******************************************************************************/
l_cid NUMBER ;
l_solot NUMBER ;
l_ori NUMBER;
l_creador NUMBER;
CURSOR cur IS
   SELECT distinct codinssrv FROM solotpto WHERE codsolot = l_solot AND cid = l_cid;
BEGIN
   l_solot := a_codsolot;
   l_cid := a_cid;
   FOR c IN cur LOOP
      SELECT codinssrv INTO l_creador FROM acceso WHERE cid = l_cid;
      -- No debe ser la IS que creo el CID
      IF c.codinssrv <> l_creador THEN
         UPDATE inssrv   SET cid = NULL, numero = NULL WHERE codinssrv = c.codinssrv;
         UPDATE solotpto SET cid = NULL  WHERE codsolot = l_solot AND codinssrv = c.codinssrv;
      ELSE
         SELECT codinssrv INTO l_creador FROM acceso WHERE cid = l_cid;
         IF l_creador = c.codinssrv THEN -- es el unico y el SID creador de CID
            UPDATE inssrv   SET cid = NULL, numero = NULL WHERE codinssrv = c.codinssrv;
            UPDATE solotpto SET cid = NULL  WHERE codsolot = l_solot AND codinssrv = c.codinssrv;
            DELETE acceso WHERE cid = l_cid;
         END IF;
      END IF;
   END LOOP;
END;
/


