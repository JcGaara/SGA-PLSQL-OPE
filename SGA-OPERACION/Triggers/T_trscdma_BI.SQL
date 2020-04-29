CREATE OR REPLACE TRIGGER OPERACION.T_trscdma_BI
  BEFORE INSERT
  on OPERACION.trscdma
  for each row
 /**************************************************************************
   NOMBRE:     T_trscdma_AIUD
   PROPOSITO:  Genera codigo secuencial de trscdma

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/03/2013  Edilberto Astulle
   **************************************************************************/
declare
ln_idcdma NUMBER;
begin
   if :new.idcdma is null then
       select sq_idcdma.nextval into ln_idcdma from dummy_ope;
       :new.idcdma := ln_idcdma;
   end if;
end;
/