CREATE OR REPLACE TRIGGER OPERACION.T_SGAT_EQUIPO_SERVICIO_FIJA_BI
  BEFORE INSERT
  on OPERACION.SGAT_EQUIPO_SERVICIO_FIJA
  for each row
 /**************************************************************************
   NOMBRE     :  T_SGAT_EQUIPO_SERVICIO_FIJA_BI
   PROPOSITO  :  Genera codigo secuencial de Tabla
   OUPUT      :  NINGUNA
   CREADO POR :  Luis Flores
   FECHA CREACION     : 18/03/2019
 **************************************************************************/
declare
n_id NUMBER;
begin
   if :new.sgan_id is null then
       select OPERACION.SQ_SGAT_EQUIPO_SERVICIO_FIJA.nextval into n_id from dual;
       :new.sgan_id := n_id;
   end if;
end;
/