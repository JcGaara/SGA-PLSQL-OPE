CREATE OR REPLACE TRIGGER OPERACION.T_TRSINSSRV_AIU
 AFTER INSERT OR UPDATE ON TRSINSSRV
FOR EACH ROW
BEGIN
   if :new.esttrs = 2 then  -- SI se ejecuta
      if :new.tiptrs = 1 then
	     pq_inssrv.trs_activacion ( :new.codinssrv, :new.fectrs, :new.codsrvnue, :new.bwnue);
	  elsif :new.tiptrs = 2 then
	     pq_inssrv.trs_upgrade ( :new.codinssrv, :new.fectrs, :new.codsrvnue, :new.bwnue);
	  elsif :new.tiptrs = 3 then
	     pq_inssrv.trs_suspension ( :new.codinssrv, :new.fectrs);
	  elsif :new.tiptrs = 4 then
	     pq_inssrv.trs_reconexion ( :new.codinssrv, :new.fectrs);
	  elsif :new.tiptrs = 5 then
	     pq_inssrv.trs_cancelacion ( :new.codinssrv, :new.fectrs);
   	  elsif :new.tiptrs = 6 then
	     pq_inssrv.trs_creacion ( :new.codinssrv, :new.fectrs);
	  else
	     raise_application_error(-20500,'Tipo de transaccion incorrecta');
	  end if;
   end if;
END;
/



