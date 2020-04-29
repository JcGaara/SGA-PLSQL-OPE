CREATE OR REPLACE FUNCTION OPERACION.F_GET_OBSERVA_OT (cod_solot in number) RETURN varchar2 IS
tmpVar varchar2(4000);

BEGIN

  tmpVar :='';

  SELECT OT.observacion into tmpVar FROM PRESUPUESTO,OT
  WHERE	( PRESUPUESTO.codsolot =  OT.codsolot) AND (ot.coddpt = 0031) and (ot.codsolot = cod_solot );

  RETURN tmpVar;

END;
/


