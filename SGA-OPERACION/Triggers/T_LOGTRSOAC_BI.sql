CREATE OR REPLACE TRIGGER OPERACION.T_LOGTRSOAC_BI
  BEFORE INSERT
  on OPERACION.LOGTRSOAC
  for each row
 /**************************************************************************
   NOMBRE     :  T_LOGTRSOAC_BI
   PROPOSITO  :  Genera codigo secuencial de Tabla
   OUPUT      :  NINGUNA
   CREADO POR :  Edilberto Astulle
   FECHA CREACION     : 19/04/2013
 **************************************************************************/
declare
n_id_seq NUMBER;
begin
   if :new.IDLOG is null then
       select OPERACION.SQ_IDLOGTRSOAC.nextval into n_id_seq from DUMMY_OPE;
       :new.IDLOG := n_id_seq;
   end if;
end;
/