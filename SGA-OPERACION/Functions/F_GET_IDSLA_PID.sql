CREATE OR REPLACE FUNCTION OPERACION.F_GET_IDSLA_PID(A_PID IN NUMBER) RETURN NUMBER IS
ln_clave number;
  /************************************************************
  NOMBRE:     F_GET_IDSLA_PID
  PROPOSITO:
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------
  1.0        21/05/2009  Victor Valqui
  ***********************************************************/
BEGIN
  SELECT IDSLA INTO ln_clave FROM INSPRDSLA WHERE PID = A_PID AND VALIDO = 1;
  return ln_clave;
END;
/


