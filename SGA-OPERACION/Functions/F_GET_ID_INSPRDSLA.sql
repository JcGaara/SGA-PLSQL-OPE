CREATE OR REPLACE FUNCTION OPERACION.F_GET_ID_INSPRDSLA RETURN NUMBER IS
ln_clave number;
  /************************************************************
  NOMBRE:     F_GET_ID_INSPRDSLA
  PROPOSITO:
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------
  1.0        21/05/2009  Victor Valqui
  ***********************************************************/
BEGIN
  select SQ_ID_INSPRDSLA.nextval into ln_clave from dual;
  return ln_clave;
END;
/


