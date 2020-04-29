CREATE OR REPLACE FUNCTION OPERACION.F_Get_Clave_Preciario RETURN NUMBER IS
ln_clave NUMBER;
/*********************************************************************************
   	NOMBRE:       		OPERACION.F_GET_CLAVE_PRECIARIO
   	PROPOSITO:    		Obtiene el codigo de la tabla preciario
	PROGRAMADO EN JOB:	NO

   	REVISIONES:
   	Ver        Fecha        Autor           Descripción
   	---------  ----------  ---------------  ------------------------
    1.0        23-09-2004  Carmen Quilca
*********************************************************************************/
BEGIN
  SELECT NVL(MAX(codprec),0)+1 INTO ln_clave FROM PRECIARIO;
  RETURN ln_clave;
END;
/


