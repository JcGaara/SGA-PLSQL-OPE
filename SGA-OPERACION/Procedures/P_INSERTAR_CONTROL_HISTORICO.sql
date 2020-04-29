CREATE OR REPLACE PROCEDURE OPERACION.P_INSERTAR_CONTROL_HISTORICO(solicitud in number, pto in number, a_codot in number) is

HISTORICO NUMBER (8);
ESTADO VARCHAR2 (30);
FECASIG_PI DATE;
RESPONSABLE_PI VARCHAR2 (30);
FECPEX DATE;
FECFIN_PI DATE;
FECCFG_VOZ DATE;
FECINS_EQU_DEF DATE;
FECDOC DATE;
FLGDOC NUMBER (1);
RESPONSABLE_DOC VARCHAR2 (30);
ESTDOCOPE1 NUMBER (2);
FLGDOC_CONF NUMBER (1);
FLGDOC_DESC NUMBER (1);
FLGDOC_GRAF NUMBER (1);
FECDOC_CONF DATE;
FECDOC_DESC DATE;
FECDOC_GRAF DATE;
FECPROG DATE;
PRIORIZADO VARCHAR2 (30);
FECPRIOR DATE;
NROREQ VARCHAR2 (100);
OBSERVACION CHAR (400);
ln_codot number(8);
ln_orden number(8);
ln_cid number(8);
ln_idtareawf number(8);
/*****************************************************************************************

*****************************************************************************************/
begin

	select solotpto_id.estado,
		   solotpto_id.fecasig_pi,
	   	   solotpto_id.responsable_pi,
	   	   solotpto_id.fecpex,
		   solotpto_id.fecfin_pi,
		   solotpto_id.FECCFG_VOZ,
		   solotpto_id.FECINS_EQU_DEF,
		   solotpto_id.FECDOC,
		   solotpto_id.FLGDOC,
		   solotpto_id.RESPONSABLE_DOC,
		   solotpto_id.ESTDOCOPE,
		   solotpto_id.FLGDOC_CONF,
		   solotpto_id.FLGDOC_DESC,
		   solotpto_id.FLGDOC_GRAF,
		   solotpto_id.FECDOC_CONF,
		   solotpto_id.FECDOC_DESC,
		   solotpto_id.FECPROG,
		   solotpto_id.PRIORIZADO,
		   solotpto_id.FECPRIOR,
		   solotpto_id.NROREQ,
		   solotpto_id.Observacion
	   into
		    estado,
		    fecasig_pi,
		    responsable_pi,
		    fecpex,
	 		fecfin_pi,
			FECCFG_VOZ,
			FECINS_EQU_DEF,
			FECDOC,
			FLGDOC,
			RESPONSABLE_DOC,
			ESTDOCOPE1,
			FLGDOC_CONF,
			FLGDOC_DESC,
			FLGDOC_GRAF,
			FECDOC_CONF,
			FECDOC_DESC,
			FECPROG,
			PRIORIZADO,
			FECPRIOR,
			NROREQ,
			OBSERVACION
		from solotpto_id
		where solotpto_id.codsolot=solicitud and solotpto_id.PUNTO=pto;

	select nvl(max(historico),0) + 1 into historico
		from solotpto_id_historico
		where solotpto_id_historico.codsolot=solicitud and solotpto_id_historico.punto=pto;

	insert into solotpto_id_historico(codsolot, punto, historico, estado, fecasig_pi,
		   				   responsable_pi, fecpex, fecfin_pi, FECCFG_VOZ,
		   				   FECINS_EQU_DEF, FECDOC, FLGDOC,
						   RESPONSABLE_DOC, ESTDOCOPE, FLGDOC_CONF, FLGDOC_DESC,
	   					   FLGDOC_GRAF, FECDOC_CONF, FECDOC_DESC, FECPROG, PRIORIZADO,
						   FECPRIOR, NROREQ, OBSERVACION)
				   values (solicitud, pto, historico, estado, fecasig_pi,
				   		  responsable_pi, fecpex, fecfin_pi, FECCFG_VOZ,
		  				  FECINS_EQU_DEF, FECDOC, FLGDOC,
						  RESPONSABLE_DOC, ESTDOCOPE1, FLGDOC_CONF, FLGDOC_DESC,
						  FLGDOC_GRAF, FECDOC_CONF, FECDOC_DESC, FECPROG, PRIORIZADO,
						  FECPRIOR, NROREQ, OBSERVACION);

     select codot, cid into ln_codot, ln_cid
 		from ot, solotpto
		where ot.codsolot = solotpto.codsolot and
			  solotpto.punto = pto and
			  -- ot.tiptra = trabajo and
			  -- ot.codsolot = solicitud and
			  ot.codot = a_codot;
			  -- area = 21 and
			  -- ot.estot not in (5,6);

      select nvl(max(orden),0) + 1 into ln_orden
  		 from otinforme
		 where codot = ln_codot;


	  begin
    	   select nvl(idtareawf,0) into ln_idtareawf
  		   from tareawf, wf, ot
		   where tareawf.idwf = wf.idwf and
			   	 wf.codsolot = ot.codsolot and
			   	 tareadef = 298 and
			  	 wf.valido = 1 and
			   	 ot.codot = ln_codot;

 		   exception
 		   when others then
		  	   ln_idtareawf :=0;
	 end;
	 if observacion is not null then
	 	insert into otinforme(codot, orden, observacion)
			   values (ln_codot, ln_orden, 'Punto-CID: ' || to_char(pto) || '-' || to_char(ln_cid) || ': ' || observacion );

		if ln_idtareawf > 0 then
	 	   insert into tareawfseg(idtareawf, observacion, flag)
		      values (ln_idtareawf, 'Punto-CID: ' || to_char(pto) || '-' || to_char(ln_cid) || ': ' || observacion, 1 );
		end if;

     end if;
/*	 exception
		  when others then
		  raise_application_error(-20500, 'No se ingreso correctamente la informacion historica');
*/
end;
/


