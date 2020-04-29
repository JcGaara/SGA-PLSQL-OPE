CREATE OR REPLACE TRIGGER OPERACION.T_AR_BU
BEFORE UPDATE
ON OPERACION.AR
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
fec_actual date;
n_tipo number;
l_estef number;
l_codcli char(8);

/******************************************************************************
Fecha        Autor           Descripcion
----------  ---------------  ------------------------
17/08/2005	Carmen Quilca 	 Permite enviar el correo de notificacion por un mail
				   			 a la lista dl - pe - provisioning cada vez q el EF
							 de un proyecto interno sea aprobado y su AR cambia
							 a estado finalizado Supervision.
******************************************************************************/

BEGIN
   fec_actual := sysdate;
   if UPDATING('ESTAR') then
	    if :new.estAR <> :old.estAR then
           insert into DOCESTHIS (docid,docest,docestold,fecha) values (:NEW.docid,:NEW.estAR,:OLD.estAR,fec_actual);
           if :new.estAR = 2 or (:new.estAR = 3 and :new.fecapr is null ) then
		      :new.fecapr := sysdate;
   	        end if;

		   --Para enviar notificacion en caso un proyecto interno se apruebe
			if :new.estAR =  3 then -- ESTADO AR= Finalizado Supervisor
			   SELECT ESTEF,CODCLI INTO l_estef,l_codcli FROM EF WHERE CODEF = :new.codef;
			   if l_estef = 2 then --ESTADO EF= APROBADO
			   	  select tipo into n_tipo from vtatabslcfac where numslc = LPAD (:new.codef, 10, '0');
				  if n_tipo = 5 AND pq_constantes.f_get_cfg() = 'PER' then	--tipo = 5 Proyecto Interno
	              	 P_ENVIA_MAIL_CAMBIO_ESTADO_EF(:new.codef,l_estef,l_codcli);
				  end if;
			  end if;
	    	end if;
		end if;
	end if;
END;
/



