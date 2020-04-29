CREATE OR REPLACE VIEW OPERACION.V_DATOS_ASIG_POP_CLIENTE
AS 
SELECT distinct EF.CODCLI, C.NOMCLI, H.DIRECCION, H.DESCRIPCION, TA.DSCSRV, E.DESCRIPCION, I.NUMERO,
    N.NUMERO telefono,
    EF.NUMSLC,
    S.CODSOLOT,
    I.CODINSSRV,
    I.CID
FROM EF, SOLOT S, SOLOTPTO SP, INSSRV I, VTATABCLI C, EFPTO H, TYSTABSRV TA, ESTINSSRV E, NUMTEL N
WHERE EF.NUMSLC = S.NUMSLC (+)
AND S.CODSOLOT = SP.CODSOLOT (+)
AND SP.CODINSSRV = I.CODINSSRV (+)
AND I.CODSRV = TA.CODSRV (+)
AND E.ESTINSSRV(+) = I.ESTINSSRV
AND EF.CODCLI = C.CODCLI
AND EF.CODEF= H.CODEF
AND S.ESTSOL(+) NOT IN (13,15)
AND N.NUMERO (+) = I.NUMERO;

