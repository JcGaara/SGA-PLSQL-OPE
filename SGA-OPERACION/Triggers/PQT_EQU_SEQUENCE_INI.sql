CREATE OR REPLACE TRIGGER OPERACION.PQT_EQU_SEQUENCE_INI
BEFORE INSERT ON operacion.PQT_EQU_SEQUENCE
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
DECLARE

BEGIN
--Juan Tinoco creacion de la tabla
if :new.CODSEQUENCE is null then
  select nvl(max(codsequence),0) + 1 into :new.codsequence from PQT_EQU_SEQUENCE
  where idpaq = :new.idpaq;
end if;
END;
/



