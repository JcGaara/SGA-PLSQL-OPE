CREATE OR REPLACE PROCEDURE OPERACION.P_CLONAR_PAQUETE_ALL(an_idpaq number,an_idpaqdest number) is
  --Etapa rellena las tablas de etapa
 ------------------------------------------------------------------

  cursor cur_efptoeta_std(an_idpaq number) is
  select efptoeta_std.idpaq,
         efptoeta_std.punto,
         efptoeta_std.codeta,
         efptoeta_std.fecini,
         efptoeta_std.fecfin,
         efptoeta_std.cosmo,
         efptoeta_std.cosmocli,
         efptoeta_std.cosmat,
         efptoeta_std.cosmatcli,
         efptoeta_std.cosmo_s,
         efptoeta_std.cosmat_s,
         efptoeta_std.pccodtarea
    from efptoeta_std
   where efptoeta_std.idpaq = an_idpaq;
   -----------------------------------------------------------------
   cursor cur_efptoetaact_std(an_idpaq number,an_punto number,an_codeta number) is
   select  efptoetaact_std.idpaq ,
           efptoetaact_std.punto ,
           efptoetaact_std.codeta ,
           efptoetaact_std.codact ,
           efptoetaact_std.costo ,
           efptoetaact_std.cantidad ,
           efptoetaact_std.observacion ,
           efptoetaact_std.moneda ,
           efptoetaact_std.moneda_id ,
		   efptoetaact_std.codprec
      from efptoetaact_std
      where ( ( efptoetaact_std.idpaq = an_idpaq )
		and ( efptoetaact_std.punto = an_punto)
		and ( efptoetaact_std.codeta = an_codeta ) );
  -----------------------------------------------------------------
  --Etapa rellena las tablas de componentes
  cursor cur_efptoequ_std(an_idpaq number) is
  select efptoequ_std.idpaq,
         efptoequ_std.punto,
		 efptoequ_std.codeta,
         efptoequ_std.orden,
         efptoequ_std.codtipequ,
         efptoequ_std.tipprp,
         efptoequ_std.observacion,
         efptoequ_std.costear,
         efptoequ_std.cantidad,
         efptoequ_std.costo,
         efptoequ_std.codequcom,
         efptoequ_std.tipequ
    from efptoequ_std
   where efptoequ_std.idpaq = an_idpaq ;
   -----------------------------------------------------------------
   cursor cur_efptoequcmp_std(an_idpaq number,an_punto number,an_orden number) is
   select efptoequcmp_std.idpaq,
         efptoequcmp_std.punto,
         efptoequcmp_std.orden,
         efptoequcmp_std.codeta,
         efptoequcmp_std.observacion,
         efptoequcmp_std.cantidad,
         efptoequcmp_std.codtipequ,
         efptoequcmp_std.costo,
         efptoequcmp_std.ordencmp,
         efptoequcmp_std.tipequ,
         efptoequcmp_std.costear
    from efptoequcmp_std
   where ( ( efptoequcmp_std.idpaq = an_idpaq ) and
         ( efptoequcmp_std.punto = an_punto ) and
         ( efptoequcmp_std.orden = an_orden ) );
   -----------------------------------------------------------------
begin
/*--insertando cabecera
  insert into paquete_venta
  (idsolucion, estado,observacion)
    values
  (an_idsoluciondest, 1,as_observacion);

  select max(idpaq)
  into ln_idpaq
  from paquete_venta;

  for c_cndcom in cur_cndcom loop
      --condiciones x paquete
      insert into condicionxpaquete
      (idpaq, idcndcom, flgedi)
      values
      (ln_idpaq, c_cndcom.idcndcom, c_cndcom.flgedi);
  end loop;*/

--insertando a las etapas y su actividades
----------------------------------------------------------------- -----------------------------------------------------------------
   for c_1 in cur_efptoeta_std(an_idpaq) loop
   begin

    insert into efptoeta_std
	(idpaq,punto,codeta,fecini,fecfin,cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,cosmat_s,pccodtarea)
    values
    (an_idpaqdest,c_1.punto,c_1.codeta,c_1.fecini,c_1.fecfin,c_1.cosmo,c_1.cosmocli,c_1.cosmat,c_1.cosmatcli,c_1.cosmo_s,c_1.cosmat_s,c_1.pccodtarea);

     /*select max(iddet)
     into ln_iddet
     from detalle_paquete;*/

     /*inserto por punto*/
      for c_1act in cur_efptoetaact_std(an_idpaq,c_1.punto,c_1.codeta) loop
         --Servicios
         insert into efptoetaact_std
		 (idpaq,punto,codeta,codact,costo,cantidad,observacion,moneda,moneda_id,codprec)
    	 values
		 (an_idpaqdest,c_1.punto,c_1.codeta,c_1act.codact,c_1act.costo,c_1act.cantidad,c_1act.observacion,c_1act.moneda,c_1act.moneda_id,c_1act.codprec);
      end loop;
   end;
   end loop;
   ----------------------------------------------------------------- -----------------------------------------------------------------
   --insertando en los equipos y sus componentes
   for c_2 in cur_efptoequ_std(an_idpaq) loop
   begin
    insert into efptoequ_std
	(idpaq,punto,orden,codtipequ,tipprp,observacion,costear,cantidad,costo,codequcom,tipequ,codeta)
    values
	(an_idpaqdest,c_2.punto,c_2.orden,c_2.codtipequ,c_2.tipprp,c_2.observacion,c_2.costear,c_2.cantidad,c_2.costo,c_2.codequcom,c_2.tipequ,c_2.codeta);

     /*select max(iddet)
     into ln_iddet
     from detalle_paquete;*/

     /*inserto por punto*/
      for c_2cmp in cur_efptoequcmp_std(an_idpaq,c_2.punto,c_2.orden) loop
         --Servicios
         insert into efptoequcmp_std
		 (idpaq,punto,orden,ordencmp,observacion,cantidad,codtipequ,costo,tipequ,costear,codeta)
    	 values
		 (an_idpaqdest,c_2.punto,c_2.orden,c_2cmp.ordencmp,c_2cmp.observacion,c_2cmp.cantidad,c_2cmp.codtipequ,c_2cmp.costo,c_2cmp.tipequ,c_2cmp.costear,c_2cmp.codeta);
      end loop;
   end;
   end loop;
   ----------------------------------------------------------------- -----------------------------------------------------------------

end P_CLONAR_PAQUETE_ALL;
/


