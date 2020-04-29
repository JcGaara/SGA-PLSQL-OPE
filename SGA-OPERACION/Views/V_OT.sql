CREATE OR REPLACE VIEW OPERACION.V_OT
AS 
SELECT ot.codot,
ot.codsolot,
ot.estot,
estot.descripcion,
ot.fecini,
ot.fecfin,
ot.feccom,
ot.cosmo,
ot.cosmat,
ot.cosequ,
ot.codusu,
ot.fecusu,
ot.coddpt,
ot.observacion,
OT.TIPTRA,
tiptrabajo.descripcion,
OT.CODMOTOT,
motot.descripcion,
pertabdpt.desdpt,
solot.numslc,
solot.recosi,
solot.fecapr,
solot.codcli,
vtatabcli.nomcli,
F_GET_TIPO_CONTRATO(solot.numslc),
tystipsrv.DSCTIPSRV
FROM ot,
motot,
pertabdpt,
tiptrabajo,
solot,
vtatabcli,
estot,
tystipsrv
WHERE ( solot.codcli = vtatabcli.codcli (+)) and
( solot.tipsrv = tystipsrv.tipsrv (+)) and
( ot.tiptra = tiptrabajo.tiptra ) and
( ot.codmotot = motot.codmotot ) and
( ot.coddpt = pertabdpt.coddpt ) and
( ot.codsolot = solot.codsolot ) and
( estot.estot = ot.estot );


