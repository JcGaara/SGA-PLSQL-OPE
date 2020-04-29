CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_EF_DATOS(a_proyecto in char) IS
tmpVar NUMBER;
BEGIN
  update ef set estef = 3 where numslc = a_proyecto;

  update solefxarea set estsolef = 1 where numslc = a_proyecto and esresponsable = 1 and estsolef <> 1;
END;
/


