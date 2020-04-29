CREATE OR REPLACE TRIGGER OPERACION.T_OPE_EQU_IW_BI
  BEFORE INSERT
  on OPERACION.OPE_EQU_IW
  for each row
 /**************************************************************************
   NOMBRE     :  T_OPE_EQU_IW_BI
   PROPOSITO  :  Genera codigo secuencial de Tabla
   OUPUT      :  NINGUNA
   CREADO POR :  Edilberto Astull
   FECHA CREACION     : 19/02/2013
 **************************************************************************/
declare
n_id_seq NUMBER;
begin
   if :new.ID_SEQ is null then
       select OPERACION.SQ_OPE_EQU_IW.nextval into n_id_seq from dummy_ope;
       :new.ID_SEQ := n_id_seq;
   end if;
end;
/