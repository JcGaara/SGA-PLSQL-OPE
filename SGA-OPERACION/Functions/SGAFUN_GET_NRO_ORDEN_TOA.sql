CREATE OR REPLACE FUNCTION OPERACION.SGAFUN_GET_NRO_ORDEN_TOA RETURN NUMBER IS
/**************************************************
'* Nombre FUN        : SGAFUN_GET_NRO_ORDEN_TOA
'* Propósito         : Obtener numero autogenerado para las ordenes de TOA
'* Output            : Nro de orden
'* Creado por        : Obed Ortiz
'* Fec Creación      : 24/09/18
'* Fec Actualización : 
*********************************************/
ln_clave number;
BEGIN
  select nvl(max(RESTN_SECUENCIA),0) + 1
  into ln_clave
  from operacion.SGAT_RESERVA_TOA;
  return ln_clave;
END;
/