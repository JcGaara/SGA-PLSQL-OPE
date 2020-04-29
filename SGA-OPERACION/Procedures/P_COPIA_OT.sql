CREATE OR REPLACE PROCEDURE OPERACION.p_copia_ot(an_codot_origen otpto.codot%type, an_codot_destino otpto.codot%type) IS
BEGIN
   -- Se copiaran todos los datos de otra ot

   -- Se borra el detalle
   P_DEL_DETALLE_OT(an_codot_destino);

   -- Se inserta todos los detalles
   insert into otpto (CODOT, PUNTO, ESTOTPTO, POP, FECINI, FECFIN, FECCOM, FECINISRV, CODSRVNUE, BWNUE, CODSRVANT, BWANT, OBSERVACION, DIRECCION, COSEQU, COSMAT, COSMO, COSMOCLI, COSMATCLI)
   select an_codot_destino, PUNTO, ESTOTPTO, POP, FECINI, FECFIN, FECCOM, FECINISRV, CODSRVNUE, BWNUE, CODSRVANT, BWANT, OBSERVACION, DIRECCION, COSEQU, COSMAT, COSMO, COSMOCLI, COSMATCLI
   from otpto where codot = an_codot_origen;

   insert into otptoequ (CODOT, PUNTO, ORDEN, CANTIDAD, CODTIPEQU, OBSERVACION, TIPPRP, COSTO, ENACTA, NUMSERIE, FECINS, INSTALADO, CODEQUCOM)
   select an_codot_destino, PUNTO, ORDEN, CANTIDAD, CODTIPEQU, OBSERVACION, TIPPRP, COSTO, ENACTA, NUMSERIE, FECINS, INSTALADO, CODEQUCOM
   from otptoequ where codot = an_codot_origen;

   insert into otptoeta (CODOT, PUNTO, CODETA, COSMAT, COSMO, COSMOCLI, COSMATCLI, FECINI, FECFIN, FECCOM, PORCONTRATA, OBSERVACION)
   select an_codot_destino, PUNTO, CODETA, COSMAT, COSMO, COSMOCLI, COSMATCLI, FECINI, FECFIN, FECCOM, PORCONTRATA, OBSERVACION
   from otptoeta where codot = an_codot_origen;

   insert into otptoetaact (CODOT, PUNTO, CODETA, CODACT, OBSERVACION, FECINI, FECFIN, CANTIDAD, COSTO, PORCONTRATA, CODCON)
   select an_codot_destino, PUNTO, CODETA, CODACT, OBSERVACION, FECINI, FECFIN, CANTIDAD, COSTO, PORCONTRATA, CODCON
   from otptoetaact where codot = an_codot_origen;

   insert into otptoetacon (CODOT, PUNTO, CODETA, CODCON, COSMAT, COSMO)
   select an_codot_destino, PUNTO, CODETA, CODCON, COSMAT, COSMO
   from otptoetacon where codot = an_codot_origen;

   insert into otptoetafor (CODOT, PUNTO, CODETA, CODFOR, CANTIDAD, PORCONTRATA)
   select an_codot_destino, PUNTO, CODETA, CODFOR, CANTIDAD, PORCONTRATA
   from otptoetafor where codot = an_codot_origen;

   insert into otptoetamat (CODOT, PUNTO, CODETA, CODMAT, CANTIDAD, OBSERVACION, COSTO, PORCONTRATA, CODCON)
   select an_codot_destino, PUNTO, CODETA, CODMAT, CANTIDAD, OBSERVACION, COSTO, PORCONTRATA, CODCON
   from otptoetamat where codot = an_codot_origen;

   insert into otptoetaper (CODOT, PUNTO, CODETA, CODTRA, OBSERVACION)
   select an_codot_destino, PUNTO, CODETA, CODTRA, OBSERVACION
   from otptoetaper where codot = an_codot_origen;

END ;
/


