CREATE OR REPLACE VIEW OPERACION.V_SOLOT_TIEMPO_ATENCION_REC
AS 
SELECT solot.codsolot,
    etapaxarea.area,
    solot.recosi,
    solot.tiprec,
    motot.codmotot,
    nvl(motot.grupodesc,'Varios') grupo,
    motot.descripcion as motivo,
    vtatabcli.nomcli,
    solot.fecusu,--
	solotpto.punto,
    solotpto.codinssrv,
    to_char(inssrv.CID) CID,
    solotpto.descripcion PUNTO_DESCRIPCION,
	 solotpto.direccion PUNTO_DIRECCION,
    tystipsrv.nomabr producto,
	nvl((sum(solotptoetainf.fecfin - solotptoetainf.fecini))*24, 0 ) as duracion_inf,
    nvl((sum(solotptoetainf.fecfin - solotptoetainf.fecini) + decode(sign(min(solotptoetainf.fecini) - solot.fecusu),-1,0, min(solotptoetainf.fecini) - solot.fecusu ))*24 ,
    (nvl(max(solotptoetainf.fecfin), solot.fecfin) - solot.fecusu)*24 ) as duracion,
    max(solotptoetainf.fecfin)
    FROM
	solot,
    solotpto,
    solotptoeta,
	vtatabcli,
    etapaxarea,
    solotptoetainf,
	motot,  --
    inssrv,
    tystabsrv,
    tystipsrv
    WHERE
    ( solotpto.codsolot = solotptoetainf.codsolot (+)) and
    ( solot.codmotot = motot.codmotot (+)) and
    ( solot.codcli = vtatabcli.codcli ) and
    ( solot.recosi is not null )  and
    ( solot.codsolot = solotpto.codsolot) and
    ( solotpto.codsolot = solotptoeta.codsolot ) and
    ( solotpto.punto = solotptoeta.punto ) and
    ( solotptoeta.codeta = etapaxarea.codeta ) and --
    ( solotpto.punto = solotptoetainf.punto (+)) and
    ( solotpto.codinssrv = inssrv.codinssrv (+)) and
    ( inssrv.codsrv = tystabsrv.codsrv (+)) and
    ( tystabsrv.tipsrv = tystipsrv.tipsrv (+))
	GROUP BY
	solot.codsolot,
    etapaxarea.area,
    solot.recosi,
    solot.tiprec,
    motot.codmotot,
    motot.grupodesc,
    motot.descripcion,
    vtatabcli.nomcli,
    solot.fecusu,
    solotpto.fecfin,  --
    solotpto.punto,
    solotpto.codinssrv,
    to_char(inssrv.CID),
    solotpto.descripcion,
	solotpto.direccion,
    tystipsrv.nomabr,
	solot.fecfin;


