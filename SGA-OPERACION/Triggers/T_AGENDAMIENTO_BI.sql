CREATE OR REPLACE TRIGGER OPERACION.T_agendamiento_BI
  BEFORE INSERT
  on OPERACION.agendamiento
  for each row
 /**************************************************************************
   NOMBRE:     T_AGENDAMIENTO_AIUD
   PROPOSITO:  Genera codigo secuencial de agendamiento

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/03/2010  Marcos Echevarria REQ. 107706: Se Inserta el codigo secuencial en agendamiento
   **************************************************************************/
declare
ln_idagenda NUMBER(10);
begin
   if :new.idagenda is null then
       select sq_agendamiento.nextval into ln_idagenda from dummy_ope;
       :new.idagenda := ln_idagenda;
   end if;
end;
/



