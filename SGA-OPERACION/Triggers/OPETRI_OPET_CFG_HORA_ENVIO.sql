CREATE OR REPLACE TRIGGER "OPERACION"."OPETRI_OPET_CFG_HORA_ENVIO"
  BEFORE INSERT
  on OPERACION.OPET_CFG_HORA_ENVIO
  for each row
 /**************************************************************************
   NOMBRE     :  OPETRI_OPET_CFG_HORA_ENVIO
   PROPOSITO  :  Genera codigo secuencial de Tabla
   OUPUT      :  NINGUNA
   CREADO POR :  Miriam Mandujano
   FECHA CREACION     : 19/01/2013
   FECHA ACTUALIZACION: 19/01/2013
 **************************************************************************/
declare
v_idcfgenv NUMBER;
begin
   if :new.CFGHN_IDCFGENV is null then
       select SQ_OPET_CFG_HORA_ENVIO.nextval into v_idcfgenv from dummy_ope;
       :new.CFGHN_IDCFGENV := v_idcfgenv;
   end if;
end;
/