CREATE OR REPLACE TRIGGER OPERACION.T_CANDIDATO_ROLLOUT_BI 
  BEFORE INSERT
  on OPERACION.CANDIDATO_ROLLOUT
  for each row
 /**************************************************************************
   NOMBRE:     T_CANDIDATO_ROLLOUT_AIUD
   PROPOSITO:  Genera codigo secuencial de Candidato

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        6/02/2014  Edilberto Astulle	PROY-12517 IDEA-15929 Implantacion de Proyectos SGA
   **************************************************************************/
declare
ln_idseq NUMBER;
begin
   if :new.idseq is null then
       select sq_candidatO_roll.nextval into ln_idseq from dummy_ope;
       :new.idseq := ln_idseq;
   end if;
end;
/