CREATE OR REPLACE PROCEDURE OPERACION.p_llena_otpto_de_solotpto(an_codot otpto.codot%type) IS
--ln_codef ef.codef%type;
ln_codsolot solot.codsolot%type;

cursor cur_del is
 select punto from otpto where codot = an_codot
 and punto not in (select punto from solotpto where codsolot = ln_codsolot );

cursor cur_act is
   SELECT
   		solotpto.PUNTO, solotpto.CODINSSRV, solotpto.POP, solotpto.CODSRVNUE, solotpto.BWNUE,
         solotpto.codsrvant, solotpto.bwant, solotpto.PUERTA, solotpto.TIPOTPTO
    FROM solotpto,
         inssrv
   WHERE ( solotpto.codsolot = ln_codsolot ) and
         ( solotpto.codinssrv = inssrv.codinssrv ) and
         (inssrv.tipinssrv <> 6) and punto in (select punto from otpto where codot = an_codot )
   union all
   SELECT
   		solotpto.PUNTO, solotpto.CODINSSRV, solotpto.POP, solotpto.CODSRVNUE, solotpto.BWNUE,
         solotpto.codsrvant, solotpto.bwant, solotpto.PUERTA, solotpto.TIPOTPTO
    FROM solotpto
   WHERE ( solotpto.codsolot = ln_codsolot ) and solotpto.codinssrv is null and
          punto in (select punto from otpto where codot = an_codot );


cursor cur_new is
   SELECT
   		solotpto.PUNTO, solotpto.CODINSSRV, solotpto.POP, solotpto.CODSRVNUE, solotpto.BWNUE,
         solotpto.codsrvant, solotpto.bwant, solotpto.PUERTA, solotpto.TIPOTPTO
    FROM solotpto,
         inssrv
   WHERE ( solotpto.codsolot = ln_codsolot ) and
         ( solotpto.codinssrv = inssrv.codinssrv ) and
         (inssrv.tipinssrv <> 6) and punto not in (select punto from otpto where codot = an_codot )
   union all
   SELECT
   		solotpto.PUNTO, solotpto.CODINSSRV, solotpto.POP, solotpto.CODSRVNUE, solotpto.BWNUE,
         solotpto.codsrvant, solotpto.bwant, solotpto.PUERTA, solotpto.TIPOTPTO
    FROM solotpto
   WHERE ( solotpto.codsolot = ln_codsolot ) and solotpto.codinssrv is null and
          punto not in (select punto from otpto where codot = an_codot );


BEGIN

   select codsolot into ln_codsolot from ot where codot = an_codot;


 	-- Se borra lo que ya no va
 	for lc_d in cur_del loop
   	P_DEL_DETALLE_OTpto(an_codot, lc_d.punto);
   end loop;

 	-- Se actualizan los existentes
 	for a in cur_act loop
   	update otpto set
          CODINSSRV = a.codinssrv,
          POP = a.pop,
          CODSRVNUE = a.codsrvnue,
          BWNUE = a.bwnue,
          codsrvant = a.codsrvant,
          bwant = a.bwant
       where
       	codot = an_codot and
         punto = a.punto;

   end loop;


 	-- Se agregan los nuevos
 	for l in cur_new loop
      insert into otpto (CODOT, PUNTO, CODINSSRV, ESTOTPTO, POP, CODSRVNUE, BWNUE, codsrvant, bwant, PUERTA, TIPOTPTO )
		values (
      an_CODOT, l.PUNTO, l.CODINSSRV, 1, l.POP, l.CODSRVNUE, l.BWNUE, l.codsrvant, l.bwant, l.PUERTA, l.TIPOTPTO
      );

    	insert into otptoeta(CODOT, PUNTO, CODETA)
		SELECT an_codot, l.punto, etapaxarea.codeta FROM etapaxarea, ot
    	WHERE etapaxarea.coddpt = ot.coddpt and
	      ot.codot = an_codot and etapaxarea.esnormal = 1;

   end loop;

/*
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
       */
END ;
/


