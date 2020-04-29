CREATE OR REPLACE TRIGGER OPERACION.T_TRANSSACCIONES
  before insert on operacion.transacciones
  REFERENCING OLD AS OLD NEW AS NEW
  for each row
declare
  -- local variables here
begin
  if :new.idtrans is null then
	SELECT SEQ_TRANSACCIONES.NEXTVAL
         INTO :new.idtrans
  FROM DUAL;
  end if;

end T_TRANSSACCIONES;
/



