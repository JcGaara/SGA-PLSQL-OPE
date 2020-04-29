CREATE OR REPLACE TRIGGER OPERACION.T_VIGRESUMEN_AI
AFTER INSERT
ON OPERACION.VIGRESUMEN
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE

BEGIN

	if :new.idetapa = 16 then

	   delete vigresumen_det where id = :new.id;

	   insert into vigresumen_det (id,area)
	   select distinct :new.ID, area from tareawf, wf
	      where tareawf.idwf = wf.idwf and
	   	  		valido = 1 and
				tipesttar in (1,2,3) and
				area is not null and
				wf.codsolot = :new.codsolot;
	else
		insert into vigresumen_det (id,area) values (:new.ID, :new.AREAOPE);
	end if;

end;
/



