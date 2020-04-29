CREATE OR REPLACE TRIGGER "OPERACION"."T_SOLOTPTOETAACT_BI" 
BEFORE INSERT
ON OPERACION.SOLOTPTOETAACT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
declare
n_validaestado number;
n_esteta number;
BEGIN
    
  select esteta into n_esteta from solotptoeta where codsolot=:new.codsolot and punto=:new.punto and orden=:new.orden;
  select count(1) into n_validaestado
  from opedd where tipopedd=224  and codigon=n_esteta;
  if n_validaestado >0 then
    RAISE_APPLICATION_ERROR(-20500,'No se puede Insertar información estando en este estado.');
  end if;
 
  if :new.idact is null then
    select nvl(max(idact),0) + 1 into :new.idact from solotptoetaact;
  end if;
 
  
exception
when others then
  RAISE_APPLICATION_ERROR(-20500,'No se creo el id de la actividad');
END;
/
