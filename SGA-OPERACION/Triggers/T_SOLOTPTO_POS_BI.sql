CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTO_POS_BI
BEFORE INSERT
ON OPERACION.SOLOTPTO_POS
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
tmpVar NUMBER;
ln_idtareawf number(8);
ls_observacion varchar2(400);
BEGIN
	begin
		select idtareawf into ln_idtareawf
  		from tareawf, wf
		where tareawf.idwf = wf.idwf and
			  wf.codsolot = :new.codsolot and
			  tareadef = 298 and
			  wf.valido = 1;

	    exception
 		   when others then
		  	   ln_idtareawf :=0;

	end;
	if :new.motivo is not null and ln_idtareawf > 0 then

	/* Requerimiento 31878 	   26/10/2005		VAVILA */

	    select sot.observacion into ls_observacion
		from   solotpto_id sot
		where  sot.codsolot = :new.codsolot
		and	   sot.punto = :new.punto;

	 	insert into tareawfseg(idtareawf, observacion, flag)
		values(ln_idtareawf, ls_observacion, 1);
		/*	values (ln_idtareawf, 'Fecha Postergacion: ' || to_char(:new.fecpos, 'dd/mm/yyyy') || chr(13) ||
		   				  		  'Fecha Tentativa: ' || to_char(:new.fecten, 'dd/mm/yyyy') || chr(13) ||
								  'Motivo: ' || :new.motivo, 1 );*/

	end if;

END;
/



