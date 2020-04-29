CREATE OR REPLACE PROCEDURE OPERACION.p_cambiar_sid_ot(an_codot otpto.codot%type,  an_punto_origen otpto.punto%type,  an_punto_destino otpto.punto%type) IS
l_codcli char(8);
l_sid inssrv.codinssrv%type;
l_sol solot.codsolot%type;



BEGIN

   -- SE HARAN UNAS VALIDACIONES PORSIACA
   SELECT A.CODCLI into l_codcli FROM SOLOT a, ot b where a.codsolot = b.codsolot and b.codot = an_codot and rownum = 1 ;

/*   begin
      select codinssrv into l_sid from inssrv where codinssrv = an_punto_origen and codcli = l_codcli;
   exception
      when others then
         raise_application_error(-20500, 'Punto origen no corresponde');
   end;
*/
   begin
      select codinssrv into l_sid from inssrv  where codinssrv = an_punto_destino and codcli = l_codcli;
   exception
      when others then
         raise_application_error(-20500, 'Punto destino no corresponde');
   end;
   -- Se inserta todos los detalles
   insert into otpto (CODOT, PUNTO, ESTOTPTO, POP, FECINI, FECFIN, FECCOM, FECINISRV, CODSRVNUE, BWNUE, CODSRVANT, BWANT, OBSERVACION, DIRECCION, COSEQU, COSMAT, COSMO, COSMOCLI, COSMATCLI, CODUSU, FECUSU, COSMO_S, COSMAT_S,  PUERTA, TIPOTPTO, CODINSSRV)
   select an_codot, an_punto_destino, ESTOTPTO, POP, FECINI, FECFIN, FECCOM, FECINISRV, CODSRVNUE, BWNUE, CODSRVANT, BWANT, OBSERVACION, DIRECCION, COSEQU, COSMAT, COSMO, COSMOCLI, COSMATCLI, CODUSU, FECUSU, COSMO_S, COSMAT_S,  PUERTA, TIPOTPTO, CODINSSRV
   from otpto where codot = an_codot and punto = an_punto_origen;

   insert into otptoequ (CODOT, PUNTO, ORDEN, CANTIDAD, CODTIPEQU, TIPEQU, OBSERVACION, TIPPRP, COSTO, ENACTA, NUMSERIE, FECINS, INSTALADO, CODEQUCOM, CODUSU, FECUSU)
   select an_codot, an_punto_destino, ORDEN, CANTIDAD, CODTIPEQU, TIPEQU, OBSERVACION, TIPPRP, COSTO, ENACTA, NUMSERIE, FECINS, INSTALADO, CODEQUCOM, CODUSU, FECUSU
   from otptoequ where codot = an_codot and punto = an_punto_origen;

   insert into otptoequCMP (CODOT, PUNTO, ORDEN, ORDENCMP, TIPEQU, CANTIDAD, COSTO, NUMSERIE, FECINS, INSTALADO, OBSERVACION, CODUSU, FECUSU)
   select an_codot, an_punto_destino, ORDEN, ORDENCMP, TIPEQU, CANTIDAD, COSTO, NUMSERIE, FECINS, INSTALADO, OBSERVACION, CODUSU, FECUSU
   from otptoequcmp where codot = an_codot and punto = an_punto_origen;

   insert into otptoeta (CODOT, PUNTO, CODETA, COSMAT, COSMO, COSMOCLI, COSMATCLI, FECINI, FECFIN, FECCOM, PORCONTRATA, OBSERVACION, FECUSU, CODUSU, COSMO_S, COSMAT_S )
   select an_codot, an_punto_destino, CODETA, COSMAT, COSMO, COSMOCLI, COSMATCLI, FECINI, FECFIN, FECCOM, PORCONTRATA, OBSERVACION, FECUSU, CODUSU, COSMO_S, COSMAT_S
   from otptoeta where codot = an_codot and punto = an_punto_origen;

   insert into otptoetaact (CODOT, PUNTO, CODETA, CODACT, OBSERVACION, FECINI, FECFIN, CANTIDAD, COSTO, PORCONTRATA, CODUSU, FECUSU, CODCON, MONEDA)
   select an_codot, an_punto_destino, CODETA, CODACT, OBSERVACION, FECINI, FECFIN, CANTIDAD, COSTO, PORCONTRATA, CODUSU, FECUSU, CODCON, MONEDA
   from otptoetaact where codot = an_codot and punto = an_punto_origen;

   insert into otptoetacon (CODOT, PUNTO, CODETA, CODCON, COSMAT, COSMO, FECUSU, CODUSU)
   select an_codot, an_punto_destino, CODETA, CODCON, COSMAT, COSMO, FECUSU, CODUSU
   from otptoetacon where codot = an_codot and punto = an_punto_origen;

   insert into otptoetafor (CODOT, PUNTO, CODETA, CODFOR, CANTIDAD, PORCONTRATA, FECUSU, CODUSU)
   select an_codot, an_punto_destino, CODETA, CODFOR, CANTIDAD, PORCONTRATA, FECUSU, CODUSU
   from otptoetafor where codot = an_codot and punto = an_punto_origen;

   insert into otptoetainf (CODOT, PUNTO, CODETA, ORDEN, TIPINFOT, FECINI, FECFIN, FECTENSOL, OBSERVACION, CODUSU, FECUSU)
   select an_codot, an_punto_destino, CODETA, ORDEN, TIPINFOT, FECINI, FECFIN, FECTENSOL, OBSERVACION, CODUSU, FECUSU
   from otptoetainf where codot = an_codot and punto = an_punto_origen;

   insert into otptoetamat (CODOT, PUNTO, CODETA, CODMAT, CANTIDAD, OBSERVACION, COSTO, PORCONTRATA, CODCON, FECUSU, CODUSU)
   select an_codot, an_punto_destino, CODETA, CODMAT, CANTIDAD, OBSERVACION, COSTO, PORCONTRATA, CODCON, FECUSU, CODUSU
   from otptoetamat where codot = an_codot and punto = an_punto_origen;

   insert into otptoetaper (CODOT, PUNTO, CODETA, CODTRA, OBSERVACION, FECUSU, CODUSU)
   select an_codot, an_punto_destino, CODETA, CODTRA, OBSERVACION, FECUSU, CODUSU
   from otptoetaper where codot = an_codot and punto = an_punto_origen;

   -- se borra todo rastro del cid anterior
   delete otptoetaact where codot = an_codot and punto = an_punto_origen;
   delete otptoetaper where codot = an_codot and punto = an_punto_origen;
   delete otptoetamat where codot = an_codot and punto = an_punto_origen;
   delete otptoetainf where codot = an_codot and punto = an_punto_origen;
   delete otptoetafor where codot = an_codot and punto = an_punto_origen;
   delete otptoetacon where codot = an_codot and punto = an_punto_origen;
   delete otptoequcmp where codot = an_codot and punto = an_punto_origen;
   delete otptoequ where codot = an_codot and punto = an_punto_origen;
   delete otptoeta where codot = an_codot and punto = an_punto_origen;
   delete otpto where codot = an_codot and punto = an_punto_origen;

   -- Se actualiza la transaccion
--   update trsinssrv set codinssrv = an_punto_destino, esttrs = 2 where codot = an_codot and codinssrv = an_punto_origen;

   -- Se actualiza las NUEVAS transacciones
   select codsolot into l_sol from ot where codot = an_codot ;
   update trssolot set codinssrv = an_punto_destino, esttrs = 2 where codsolot = l_sol and codinssrv = an_punto_origen;


END ;
/


