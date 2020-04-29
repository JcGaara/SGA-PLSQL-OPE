CREATE OR REPLACE PROCEDURE OPERACION.P_GEN_SOL_BT_RETIRO_EQU (a_fecha in date) IS
/*
Genera las Solot sin aprobar de solicitude de retiro de equipos
para las Ot con suspensiones despues de 3 dias
*/

 ln_tmp number;
 ln_codsolot number;
 ln_generar number(1);
 ln_cont number;
 ld_fecha date;
 ln_dias number;

cursor cur_sol is
SELECT /*+ RULE */ ot.codot,
       ot.fecfin,
       SOLOT.CODSOLOT,
       SOLOT.FECAPR,
       SOLOt.CODMOTOT,
       SOLOT.CODUSU,
       SOLOT.FECUSU,
       SOLOT.CODCLI,
       ot.area
  FROM SOLOT,
       OT
 WHERE solot.estsol = 11
   and solot.tiptra = 2
   and SOLOT.CODDPT = '0017  '
   and solot.codmotot in (4, 13)
   AND OT.CODSOLOT = SOLOT.CODSOLOT
   and ot.area = 41
   and ot.estot in (3, 4)
   and ot.fecfin > a_fecha - 360;

cursor cur_sid is
 	select inssrv.codinssrv from inssrv, solotpto
   where inssrv.codinssrv = solotpto.codinssrv and inssrv.estinssrv = 2 and codsolot = ln_tmp;


BEGIN
	ln_dias := 3;
	for lc in cur_sol loop
   	ln_generar := 0;
   	-- Se valida si se genera la solicitud en base a esta

      select count(*) into ln_cont from SOLOTXSOLOT where codsolot_P = lc.codsolot and tipo = 'R';

      if ln_cont = 0 then
      	-- Se valida que siga suspendido y que haya sido suspendido en los ultimos 3 dias
         -- basta que tenga uno y genero la sol

         ln_tmp := lc.codsolot;
         for ls in cur_sid loop
         	select max(fectrs) into ld_fecha from trssolot where codinssrv = ls.codinssrv and tiptrs = 3;
         	if a_fecha - ld_fecha > ln_dias then
            	ln_generar := 1;
               exit;
            end if;

         end loop;
      else
	      ln_generar := 0;
      end if;

   	if ln_generar = 1 then

			select F_GET_CLAVE_SOLOT() into ln_codsolot from DUMMY_OPE;

      	insert into solot
         (CODSOLOT, TIPTRA, ESTSOL, TIPSRV, OBSERVACION,
           CODCLI, NUMSLC, CODDPT, CODMOTOT, ORIGEN)
         select ln_codsolot, 115, 10, TIPSRV, 'Solicitud generada automaticamente en base a Sol. Ot '||lc.codsolot,
           CODCLI, NUMSLC, CODDPT, CODMOTOT, ORIGEN from solot where codsolot = lc.codsolot;

         insert into solotpto (CODSOLOT, PUNTO, TIPTRS, CODSRVNUE, BWNUE, CODINSSRV)
         select ln_CODSOLOT, PUNTO, TIPTRS, CODSRVNUE, BWNUE, CODINSSRV from solotpto where codsolot = lc.codsolot;

         -- Se guarda en el log
         insert into solotxsolot ( CODSOLOT_P, CODSOLOT_H, TIPO, OBSERVACION )
         values ( lc.codsolot, ln_codsolot, 'R', '' ); --'Prod. auto Retiro Equipos');

      end if;

   end loop;

END;
/


