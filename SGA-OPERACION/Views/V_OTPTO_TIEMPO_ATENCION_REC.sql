CREATE OR REPLACE VIEW OPERACION.V_OTPTO_TIEMPO_ATENCION_REC
AS 
SELECT ot.codot,
ot.coddpt,
ot.area,
solotpto.punto,
solotpto.codinssrv,
to_char(inssrv.CID),
inssrv.descripcion,
solot.recosi,
solot.tiprec,
motot.codmotot,
nvl(motot.grupodesc,'Varios') grupo,
motot.descripcion as motivo,
vtatabcli.nomcli,
tystipsrv.nomabr,
ot.fecusu,
nvl((sum(solotptoetainf.fecfin - solotptoetainf.fecini))*24, 0 ) as duracion
FROM ot,
solot,
solotpto,
solotptoetainf,
vtatabcli,
inssrv,
motot,
tystabsrv,
tystipsrv
WHERE
( ot.codsolot = solot.codsolot) and
( solot.codsolot = solotpto.codsolot) and
( solotpto.codsolot = solotptoetainf.codsolot (+)) and
( solotpto.punto = solotptoetainf.punto (+)) and
( solotpto.codinssrv = inssrv.codinssrv (+)) and
( inssrv.codsrv = tystabsrv.codsrv (+)) and
( tystabsrv.tipsrv = tystipsrv.tipsrv (+)) and
( ot.codmotot = motot.codmotot ) and
( solot.codcli = vtatabcli.codcli ) and
( solot.recosi is not null )
GROUP BY ot.codot,
ot.coddpt,
ot.area,
solotpto.punto,
solotpto.codinssrv,
to_char(inssrv.CID),
inssrv.descripcion,
solot.recosi,
solot.tiprec,
motot.codmotot,
motot.grupodesc,
motot.descripcion,
vtatabcli.nomcli,
tystipsrv.nomabr,
ot.fecusu,
solotpto.fecfin;


