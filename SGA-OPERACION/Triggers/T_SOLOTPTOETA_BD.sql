CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTOETA_BD
BEFORE DELETE
ON OPERACION.SOLOTPTOETA
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
ll_validaestado  number;
BEGIN
select count(*) into ll_validaestado
  from opedd where tipopedd=224  and codigon=:old.esteta;
   if ll_validaestado > 0 then
      RAISE_APPLICATION_ERROR(-20500,'No se puede borrar la etapa estando en este estado.');
   end if;

END;
/



