CREATE OR REPLACE TRIGGER OPERACION.T_EF_BU
BEFORE UPDATE
ON OPERACION.EF
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
fec_actual date;
l_cont number;
ll_row number;
ls_numpsp char(10);
ls_idopc char(2);
l_diascom number;
n_tipo number;
/******************************************************************************
Procedimiento para enviar notificaciones los dias lunes por las SOTs que esten
por vencer(fecha de compromiso) en los proximos 10 dias calendarios
Fecha        Autor           Descripcion
----------  ---------------  ------------------------
06/07/2004 Edilberto Astulle En caso de que se Apruebe o Rechaze un EF de un
		   			 		 Proyecto Interno se notifica por un mail a la lista dl - pe - provisioning
11/07/2005 Carmen Quilca	 Permite que cada vez que existe una actualizacion del proyecto,
		   		  			 la fecini de cada ef de las areas se actualice con la fecha
							 que se ha solicitado actualizar el proyecto.
19/07/2005 Carmen Quilca	 Solo enviara correo para el estado de ef = Rechazado
23/08/2005 Victor Valqui	 Actualizar fecha de aprobacion
******************************************************************************/
BEGIN
   fec_actual := sysdate;
   if UPDATING('ESTEF') then
	    if :new.estef <> :old.estef then
        insert into DOCESTHIS (docid,docest,docestold,fecha) values (:NEW.docid,:NEW.estef,:OLD.estef,fec_actual);

		--Para enviar notificacion en caso un proyecto interno se echaze
         if :new.estef in (2,4) then --ESTEF = RECHAZADO
		    :new.fecapr := sysdate;
			select tipo into n_tipo from vtatabslcfac where numslc = LPAD (:new.codef, 10, '0');
			if n_tipo = 5 AND pq_constantes.f_get_cfg() = 'PER' and :new.estef = 4 then	--tipo = 5 Proyecto Interno
               P_ENVIA_MAIL_CAMBIO_ESTADO_EF(:new.codef,:new.estef,:new.codcli);
			end if;
   	     end if;
         if :new.estef = 3 then
             -- veifico que todos las derivaciones, esten en concluido o aprobado dise?o, si hay algun generado no actualizo nada
             select count(*) into l_cont from solefxarea where codef = :new.codef and estsolef = 1;
             if l_cont = 0 then
                update solefxarea
					   set estsolef = 1,
					   	   fecapr = fecapr,
						   fecini = fec_actual
					   where codef = :new.codef and esresponsable = 1  and estsolef <> 1;
             end if;
	         -- Rentabilidad
            update ar set estar = 5 where codef = :new.codef;

   	   end if;
      end if;
   end if;
   if updating('NUMDIAPLA') then
      select count(*)
      into ll_row
      from vtatabpspcli_v
      where numslc =:new.numslc
      and estpspcli <>'02';
      if ll_row>0 then
         select numpsp, idopc
         into ls_numpsp, ls_idopc
         from vtatabpspcli_v
            where numslc =:new.numslc;
         UPDATE vtatabpspcli
            SET DIACOM = PQ_DIAS_ENTREGA.GET_ENTREGASERVICIO(:new.numslc, :new.numdiapla)
         WHERE NUMPSP =ls_numpsp AND
            IDOPC = ls_idopc;
      end if;
   end if;

   if UPDATING('COSMO') OR UPDATING('COSMAT') OR UPDATING('COSEQU') then
--      :NEW.REQ_AR := NULL;
--      :new.rentable := null;
      :new.frr := null;
      update ar set frr = :new.frr where codef = :new.codef;
   end if;
   if updating('FRR') then
      update ar set frr = :new.frr where codef = :new.codef;
   end if;
   if updating('FLG_CLIPOT') then
		P_ENVIA_CORREO_DE_TEXTO_ATT('Se solicita analisis de Clientes potenciales - Proyecto '||:new.codef,
      	'william.ferrer@attla.com','Mayor Informacion en el modulo de Operaciones' ,'SGA');
   end if;

END;
/



