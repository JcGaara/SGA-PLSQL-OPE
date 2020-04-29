CREATE OR REPLACE VIEW OPERACION.V_INSTANCIAS_DE_SERVICIO
AS 
SELECT inssrv.codinssrv,  
inssrv.codcli,  
vtatabcli.nomcli,  
inssrv.codsrv,  
tystabsrv.dscsrv,  
inssrv.bw,  
inssrv.estinssrv,  
estinssrv.descripcion ESTADO,  
inssrv.tipinssrv,  
tipinssrv.descripcion TIPO,  
inssrv.descripcion,  
inssrv.direccion,  
inssrv.numero,  
inssrv.observacion,  
inssrv.codsuc,  
inssrv.fecini,  
inssrv.fecfin,  
inssrv.fecactsrv,  
inssrv.pop CODIGO_POP,  
v_pop.descripcion POP,  
inssrv.interface,  
tystipsrv.DSCTIPSRV  
FROM inssrv,  
vtatabcli,  
estinssrv,  
tipinssrv,  
tystabsrv,  
tystipsrv,  
v_pop  
WHERE ( inssrv.codcli = vtatabcli.codcli ) and  
( inssrv.estinssrv = estinssrv.estinssrv ) and  
( inssrv.codsrv = tystabsrv.codsrv (+) ) and  
( inssrv.pop = v_pop.pop (+)) and  
( tipinssrv.tipinssrv = inssrv.tipinssrv ) and  
( inssrv.codsrv = tystabsrv.codsrv (+) ) and  
( tystabsrv.tipsrv  = tystipsrv.tipsrv (+) );


