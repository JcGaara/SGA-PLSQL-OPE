CREATE OR REPLACE PROCEDURE OPERACION.P_LLENA_OTEQU_DE_EF (an_codot otpto.codot%type) IS
ln_codef ef.codef%type;
ln_orden otptoequ.orden%type;
tmp number;

cursor cur_equ is
  SELECT otpto.codot,
         otpto.punto,
		 rownum orden,
         efptoequ.codtipequ,
         efptoequ.tipequ,
         efptoequ.tipprp,
         efptoequ.cantidad,
         tipequ.costo,
		 efptoequ.codequcom,
		 efptoequ.codef ,
         efptoequ.punto punto_ef,
         efptoequ.orden orden_ef
    FROM efptoequ,
         otpto,
         efpto,
         tipequ
   WHERE efpto.codef = efptoequ.codef and
         efpto.punto = efptoequ.punto and
         efpto.codinssrv = otpto.codinssrv and
         efptoequ.tipequ = tipequ.tipequ and
		 efpto.codef = ln_codef and
		 otpto.codot = an_codot;-- and
--       otpto.puerta = 1;

cursor cur_equ2 is
  SELECT ot.codot,
         s.punto,
		 rownum orden,
         efptoequ.codtipequ,
         efptoequ.tipequ,
         efptoequ.tipprp,
         efptoequ.cantidad,
         tipequ.costo,
		 efptoequ.codequcom,
		 efptoequ.codef ,
         efptoequ.punto punto_ef,
         efptoequ.orden orden_ef
    FROM efptoequ,
         ot,
         solotpto s,
         efpto,
         tipequ
   WHERE efpto.codef = efptoequ.codef and
         efpto.punto = efptoequ.punto and
         ot.codsolot = s.codsolot and
         efpto.punto = s.efpto and
         efptoequ.tipequ = tipequ.tipequ and
         efpto.codef = ln_codef and
		 ot.codot = an_codot;


BEGIN

   -- Se obtiene el EF asociado al proyecto
   select codef into ln_codef from ef,solot,ot
   where ot.codot = an_codot and ot.codsolot = solot.codsolot and solot.numslc = ef.numslc;

   delete otptoequcmp where codot = an_codot;
   delete otptoequ where codot = an_codot;

   -- Se determina si tiene enlace con el EF
	select count(*) into tmp from solotpto s, ot where
   ot.codsolot = s.codsolot and ot.codot = an_codot and
   s.efpto is not null;

   if tmp > 0 then -- Si se tiene enlace con el proyecto
      for lc1 in cur_equ2 loop
         -- Se insertan los equipos desde el EF
         insert into otptoequ(codot,punto,orden,codtipequ,tipequ,tipprp,cantidad,costo,codequcom)
         values (lc1.codot,lc1.punto,lc1.orden,lc1.codtipequ,lc1.tipequ,lc1.tipprp,lc1.cantidad,lc1.costo,lc1.codequcom);

         insert into otptoequcmp(codot,punto,orden,ordencmp, tipequ,cantidad,costo)
         SELECT lc1.codot,
                lc1.punto,
       		 lc1.orden,
       		 rownum,
                efptoequcmp.tipequ,
                efptoequcmp.cantidad,
                tipequ.costo
           FROM efptoequcmp,
   		     tipequ
          WHERE efptoequcmp.codef = lc1.codef and
                efptoequcmp.punto = lc1.punto_ef and
                efptoequcmp.orden = lc1.orden_ef and
                efptoequcmp.tipequ = tipequ.tipequ;
       end loop;
   else
      for lc1 in cur_equ loop
         -- Se insertan los equipos desde el EF
         insert into otptoequ(codot,punto,orden,codtipequ,tipequ,tipprp,cantidad,costo,codequcom)
         values (lc1.codot,lc1.punto,lc1.orden,lc1.codtipequ,lc1.tipequ,lc1.tipprp,lc1.cantidad,lc1.costo,lc1.codequcom);

         insert into otptoequcmp(codot,punto,orden,ordencmp, tipequ,cantidad,costo)
         SELECT lc1.codot,
                lc1.punto,
       		 lc1.orden,
       		 rownum,
                efptoequcmp.tipequ,
                efptoequcmp.cantidad,
                tipequ.costo
           FROM efptoequcmp,
   		     tipequ
          WHERE efptoequcmp.codef = lc1.codef and
                efptoequcmp.punto = lc1.punto_ef and
                efptoequcmp.orden = lc1.orden_ef and
                efptoequcmp.tipequ = tipequ.tipequ;
       end loop;
   end if;
END;
/


