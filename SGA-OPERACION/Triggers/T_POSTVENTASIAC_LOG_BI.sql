CREATE OR REPLACE TRIGGER OPERACION.T_POSTVENTASIAC_LOG_BI
  BEFORE INSERT
  on OPERACION.POSTVENTASIAC_LOG
  REFERENCING NEW AS NEW 
  for each row
 /**************************************************************************
   NOMBRE     :  T_POSTVENTASIAC_LOG_BI
   PROPOSITO  :  Genera codigo secuencial de Tabla
   OUPUT      :  NINGUNA
 **************************************************************************/
declare
n_id_seq NUMBER := 0;
begin
   if :new.IDLOG is null then
       select OPERACION.SQ_POSTVENTASIAC_LOG.nextval into n_id_seq from DUMMY_OPE;
       :new.IDLOG := n_id_seq;
   end if;
end;
/