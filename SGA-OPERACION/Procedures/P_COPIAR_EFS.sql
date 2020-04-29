CREATE OR REPLACE PROCEDURE OPERACION.P_COPIAR_EFS(ef_origen in number, ef_destino in number) IS
tmpVar NUMBER;
l_punto number;
l_numpto vtadetptoenl.numpto%type;
l_codsucant vtadetptoenl.codsuc%type;


cursor cur_ef is
select b.numpto numpto, to_number(b.numpto) nuevo_punto, a.PUNTO punto, b.DESCPTO DESCRIPCION, a.CODINSSRV, a.CODSUC,
a.CODUBI, a.POP, b.DIRPTO DIRECCION, b.CODSRV, a.BW, a.FECINI, a.NUMDIAPLA, a.FECFIN,
a.OBSERVACION, a.COORDX1, a.COORDY1, a.COORDX2, a.COORDY2, a.TIPTRA
from efpto a, vtadetptoenl b where a.codef = ef_origen and b.numslc = ef_destino and a.CODSUC = b.codsuc
order by a.codsuc,to_number(b.numpto) ;


BEGIN

delete from efptomet where codef = ef_destino;
delete from efptoetadat where codef = ef_destino;
delete from efptoetaact where codef = ef_destino;
delete from efptoetamat where codef = ef_destino;
delete from efptoequcmp where codef = ef_destino;
delete from efptoequ where codef = ef_destino;
delete from efptoeta where codef = ef_destino;
delete from efpto where codef = ef_destino;

for lc in cur_ef loop
   l_numpto := lc.numpto;
   l_punto := lc.punto;

   if l_codsucant = lc.codsuc then
      null;
   else
      insert into efpto(CODEF, PUNTO, DESCRIPCION, CODINSSRV, CODSUC, CODUBI, POP, DIRECCION, CODSRV, BW, FECINI, NUMDIAPLA, FECFIN, OBSERVACION, COORDX1, COORDY1, COORDX2, COORDY2, TIPTRA)
      values ( ef_destino, lc.nuevo_punto, lc.DESCRIPCION, lc.CODINSSRV, lc.CODSUC,
      lc.CODUBI, lc.POP, lc.DIRECCION, lc.CODSRV, lc.BW, lc.FECINI, lc.NUMDIAPLA, lc.FECFIN,
      lc.OBSERVACION, lc.COORDX1, lc.COORDY1, lc.COORDX2, lc.COORDY2, lc.TIPTRA );

      insert into efptoeta (CODEF, PUNTO, CODETA, FECINI, FECFIN)
      select ef_destino,  lc.nuevo_punto, CODETA, FECINI, FECFIN
      from efptoeta where codef = ef_origen and punto = l_punto;

      insert into efptoetaact (codef, PUNTO, CODETA, CODACT, COSTO, CANTIDAD, OBSERVACION, MONEDA)
      select ef_destino, lc.nuevo_punto, CODETA, CODACT, COSTO, CANTIDAD, OBSERVACION, MONEDA
      from efptoetaact where codef = ef_origen and punto = l_punto;

      insert into efptoetamat (CODEF, PUNTO, CODETA, CODMAT, CANTIDAD, COSTO)
      select ef_destino, lc.nuevo_punto, CODETA, CODMAT, CANTIDAD, COSTO
      from efptoetamat where codef = ef_origen and punto = l_punto;

      insert into efptoetadat (CODEF, PUNTO, CODETA, TIPDATEF, DATO)
      select ef_destino, lc.nuevo_punto, CODETA, TIPDATEF, DATO
      from efptoetadat where codef = ef_origen and punto = l_punto;

      insert into efptomet( CODEF, PUNTO, ORDEN, TIPMETEF, CODUBI, CANTIDAD, OBSERVACION)
      select ef_destino, lc.nuevo_punto, ORDEN, TIPMETEF, CODUBI, CANTIDAD, OBSERVACION
      from efptomet where codef = ef_origen and punto = l_punto;

   end if;

   l_codsucant := lc.codsuc;

end loop;

-- se insertan los puntos nuevos
insert into efpto (codef, punto, descripcion, direccion, codsuc, codubi, codsrv, bw, codinssrv,tiptra,
	   coordx1, coordy1, coordx2, coordy2, nrolineas, nrofacrec, nrohung, nroigual )
select ef_destino, to_number(numpto), descpto, dirpto, codsuc, ubipto, codsrv, nvl(banwid,0),numckt,tiptra,
	   merabs1, merord1, merabs2, merord2, nrolineas, nrofacrec, nrohung, nroigual
	   from vtadetptoenl
	   where crepto = '1' and numslc = ef_destino and to_number(numpto) not in (select punto from efpto where codef = ef_destino);
/*
   EXCEPTION
     WHEN OTHERS THEN
       Null;
*/
END;
/


