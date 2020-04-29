CREATE OR REPLACE TRIGGER OPERACION.T_TRSINSSRV_BU
 BEFORE UPDATE ON TRSINSSRV
FOR EACH ROW
BEGIN
   if :old.esttrs in(3) then
      raise_application_error(-20500,'No se puede modificar una transaccion anulada');
   end if;
   If :new.esttrs in (2,3) then -- Ejecutado o anulado
      :new.feceje := sysdate;
	  if :new.fectrs is null then
	     :new.fectrs := :new.feceje;
	  end if;
   end if;
END;
/



