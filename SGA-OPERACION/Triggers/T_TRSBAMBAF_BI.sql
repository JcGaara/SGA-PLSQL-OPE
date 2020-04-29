CREATE OR REPLACE TRIGGER OPERACION.T_trsbambaf_BI
  BEFORE INSERT
  on OPERACION.trsbambaf
  for each row
 /**************************************************************************
   NOMBRE:     T_trsbambaf_BI
   PROPOSITO:  Genera codigo secuencial de BAM

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        06/08/2010  Edilberto Astulle PROY-4386 Gestión automática de Cobranza entre los planes BAM y BAF
   **************************************************************************/
declare
ln_idbam NUMBER(10);
begin
   if :new.idbam is null then
       select operacion.sq_idbam.nextval into ln_idbam from dummy_ope;
       :new.idbam := ln_idbam;
   end if;
end;
/