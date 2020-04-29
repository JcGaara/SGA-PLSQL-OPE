create or replace trigger "OPERACION"."T_SOLOTPTOETAACT_BD" 
 before delete ON solotptoetaact
FOR EACH ROW
DECLARE
n_validaestado number;
n_esteta number;

BEGIN
  select esteta into n_esteta from solotptoeta where codsolot=:old.codsolot and punto=:old.punto and orden=:old.orden;
  select count(1) into n_validaestado
  from opedd where tipopedd=224  and codigon=n_esteta;
  if n_validaestado > 0 then
    RAISE_APPLICATION_ERROR(-20500,'No se puede borrar la etapa estando en este estado.');
  end if;
END;
/
