CREATE OR REPLACE TRIGGER OPERACION.T_TRSOAC_BI
  BEFORE INSERT
  on OPERACION.TRSOAC
  for each row
 /**************************************************************************
   NOMBRE     :  T_TRSOAC_BI
   PROPOSITO  :  Genera codigo secuencial de Tabla
   OUPUT      :  NINGUNA
   CREADO POR :  Edilberto Astulle
   FECHA CREACION     : 19/04/2013
 **************************************************************************/
declare
n_id_seq NUMBER;
begin
   if :new.IDTRSOAC is null then
       select OPERACION.SQ_IDTRSOAC.nextval into n_id_seq from dummy_ope;
       :new.IDTRSOAC := n_id_seq;
   end if;
end;
/