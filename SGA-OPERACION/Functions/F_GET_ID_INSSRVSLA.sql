CREATE OR REPLACE FUNCTION OPERACION.F_GET_ID_INSSRVSLA RETURN NUMBER IS
ln_clave number;
  /************************************************************
  NOMBRE:     F_GET_ID_INSSRVSLA
  PROPOSITO:
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------
  1.0        21/05/2009  Victor Valqui
  ***********************************************************/
BEGIN
  select SQ_ID_INSSRVSLA.nextval into ln_clave from dual;
  return ln_clave;
END;
/


