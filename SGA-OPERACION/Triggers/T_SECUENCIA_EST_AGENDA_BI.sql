CREATE OR REPLACE TRIGGER OPERACION.T_SECUENCIA_EST_AGENDA_BI
  BEFORE INSERT
  on OPERACION.SECUENCIA_ESTADOS_AGENDA
  for each row
 /**************************************************************************
   NOMBRE:     T_SECUENCIA_EST_AGENDA_BI
   PROPOSITO:  Genera codigo secuencial de cambios de estagendas

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        06/11/2012  Edilberto Astulle PROY-5513_HFC - Funcionalidad de Bajas de Servicio 3play
   **************************************************************************/
declare
ln_idseq NUMBER(10);
begin
   if :new.IDSEQ is null then
       select operacion.SQ_SEC_EST_AGE.nextval into ln_idseq from dummy_ope;
       :new.IDSEQ := ln_idseq;
   end if;
end;
/