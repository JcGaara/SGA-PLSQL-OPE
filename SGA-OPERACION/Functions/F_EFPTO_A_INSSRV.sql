CREATE OR REPLACE FUNCTION OPERACION.F_EFPTO_A_INSSRV(AN_CODEF IN EFPTO.CODEF%TYPE, AN_PUNTO IN EFPTO.PUNTO%TYPE)
RETURN NUMBER IS

ln_inssrv inssrv.codinssrv%type;

BEGIN

  SELECT inssrv.codinssrv into ln_inssrv
    FROM efpto,
         inssrv,
         vtadetptoenl,
         vtatabslcfac,
         ef
   WHERE ( vtadetptoenl.numslc = vtatabslcfac.numslc ) and
         ( efpto.punto = vtadetptoenl.numpto ) and
         ( vtadetptoenl.codsuc = inssrv.codsuc ) and
         ( vtatabslcfac.codcli = inssrv.codcli ) and
         ( ef.codef = efpto.codef ) and
         ( ef.numslc = vtatabslcfac.numslc ) and
         ( vtadetptoenl.codsrv = inssrv.codsrv ) and
         ( efpto.codef = an_codef ) AND
         ( efpto.punto = an_punto );

   return ln_inssrv;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
	   return null;
END F_EFPTO_A_INSSRV;
/


