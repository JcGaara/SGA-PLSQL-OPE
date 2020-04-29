CREATE OR REPLACE PROCEDURE OPERACION.P_COPIAR_EFPTOS(ef_origen in number, PTO_ORIGEN IN NUMBER, ef_destino in number, PTO_DESTINO IN NUMBER) IS

BEGIN

delete from efptoetafor where codef = ef_destino AND PUNTO = PTO_DESTINO;
delete from efptoetadat where codef = ef_destino AND PUNTO = PTO_DESTINO;
delete from efptoetaact where codef = ef_destino AND PUNTO = PTO_DESTINO;
delete from efptoetamat where codef = ef_destino AND PUNTO = PTO_DESTINO;
delete from efptoequcmp where codef = ef_destino AND PUNTO = PTO_DESTINO;
delete from efptoequ where codef = ef_destino AND PUNTO = PTO_DESTINO;
delete from efptoeta where codef = ef_destino AND PUNTO = PTO_DESTINO;
delete from efptoMET where codef = ef_destino AND PUNTO = PTO_DESTINO;
delete from efpto where codef = ef_destino AND PUNTO = PTO_DESTINO;


      INSERT INTO EFPTO (CODEF, PUNTO, DESCRIPCION, CODINSSRV, CODSUC, CODUBI, POP, DIRECCION, CODSRV,
       BW, COSMO, COSMAT, COSEQU, COSMOCLI, COSMATCLI, FECINI, NUMDIAPLA, FECFIN, OBSERVACION, COORDX1,
       COORDY1, COORDX2, COORDY2, TIPTRA, NROLINEAS,
       NROFACREC, NROHUNG, NROIGUAL, COSMO_S, COSMAT_S, CODTIPFIBRA, LONFIBRA, ACTCAD, NROCANAL )
      SELECT EF_DESTINO, PTO_DESTINO, DESCRIPCION, CODINSSRV, CODSUC, CODUBI, POP, DIRECCION, CODSRV,
       BW, COSMO, COSMAT, COSEQU, COSMOCLI, COSMATCLI, FECINI, NUMDIAPLA, FECFIN, OBSERVACION, COORDX1,
       COORDY1, COORDX2, COORDY2, TIPTRA, NROLINEAS,
       NROFACREC, NROHUNG, NROIGUAL, COSMO_S, COSMAT_S, CODTIPFIBRA, LONFIBRA, ACTCAD, NROCANAL
      from efpto where codef = ef_origen and punto = PTO_ORIGEN;

      insert into efptoeta (CODEF, PUNTO, CODETA, FECINI, FECFIN)
      select ef_destino,  PTO_DESTINO, CODETA, FECINI, FECFIN
      from efptoeta where codef = ef_origen and punto = PTO_ORIGEN;

      insert into efptoetaact (codef, PUNTO, CODETA, CODACT, COSTO, CANTIDAD, MONEDA, OBSERVACION)
      select ef_destino, PTO_DESTINO, CODETA, CODACT, COSTO, CANTIDAD, MONEDA, OBSERVACION
      from efptoetaact where codef = ef_origen and punto = PTO_ORIGEN;

      insert into efptoetamat (CODEF, PUNTO, CODETA, CODMAT, CANTIDAD, COSTO)
      select ef_destino, PTO_DESTINO, CODETA, CODMAT, CANTIDAD, COSTO
      from efptoetamat where codef = ef_origen and punto = PTO_ORIGEN;

      insert into efptoetadat (CODEF, PUNTO, CODETA, TIPDATEF, DATO)
      select ef_destino, PTO_DESTINO, CODETA, TIPDATEF, DATO
      from efptoetadat where codef = ef_origen and punto = PTO_ORIGEN;

      insert into efptoetafor (CODEF, PUNTO, CODETA, CODFOR, CANTIDAD)
      select ef_destino, PTO_DESTINO, CODETA, CODFOR, CANTIDAD
      from efptoetafor where codef = ef_origen and punto = PTO_ORIGEN;

		INSERT INTO EFPTOMET ( CODEF, PUNTO, ORDEN, TIPMETEF, CODUBI, CANTIDAD, OBSERVACION )
      select ef_destino, PTO_DESTINO, ORDEN, TIPMETEF, CODUBI, CANTIDAD, OBSERVACION
        from efptomet where codef = ef_origen and punto = PTO_ORIGEN;
/*
   EXCEPTION
     WHEN OTHERS THEN
       Null;
*/

END;
/


