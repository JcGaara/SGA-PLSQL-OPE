CREATE OR REPLACE VIEW OPERACION.V_NODO
AS 
SELECT CODUBIRED, DESCRIPCION, TIPO, CODIGO, direccion FROM UBIRED where tipo = 1;


