CREATE OR REPLACE PROCEDURE OPERACION.p_copia_ot_permisos(an_codot_origen otpto.codot%type, an_codot_destino otpto.codot%type) IS
BEGIN
   -- Se copiaran todos los datos de otra ot

   -- Se borra el detalle
   P_DEL_DETALLE_OT(an_codot_destino);

   -- Se inserta todos los detalles
   insert into otpto (CODOT, PUNTO, ESTOTPTO, POP, FECINI, FECFIN, FECCOM, FECINISRV, CODSRVNUE, BWNUE, CODSRVANT, BWANT, OBSERVACION, DIRECCION, COSEQU, COSMAT, COSMO, COSMOCLI, COSMATCLI)
   select an_codot_destino, PUNTO, ESTOTPTO, POP, FECINI, FECFIN, FECCOM, FECINISRV, CODSRVNUE, BWNUE, CODSRVANT, BWANT, OBSERVACION, DIRECCION, COSEQU, COSMAT, COSMO, COSMOCLI, COSMATCLI
   from otpto where codot = an_codot_origen;

   insert into otptoeta (CODOT, PUNTO, CODETA, COSMAT, COSMO, COSMOCLI, COSMATCLI, FECINI, FECFIN, FECCOM, PORCONTRATA, OBSERVACION)
   select an_codot_destino, PUNTO, CODETA, COSMAT, COSMO, COSMOCLI, COSMATCLI, FECINI, FECFIN, FECCOM, PORCONTRATA, OBSERVACION
   from otptoeta where codot = an_codot_origen and codeta in (22,201);

   insert into otptoetaact (CODOT, PUNTO, CODETA, CODACT, OBSERVACION, FECINI, FECFIN, CANTIDAD, COSTO, PORCONTRATA, CODCON)
   select an_codot_destino, PUNTO, CODETA, CODACT, OBSERVACION, FECINI, FECFIN, CANTIDAD, COSTO, PORCONTRATA, CODCON
   from otptoetaact where codot = an_codot_origen and codeta in (22,201);

END ;
/


