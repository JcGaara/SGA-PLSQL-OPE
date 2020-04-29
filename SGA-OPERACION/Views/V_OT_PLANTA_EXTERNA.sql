CREATE OR REPLACE VIEW OPERACION.V_OT_PLANTA_EXTERNA
AS 
SELECT solot.codsolot codpre,
         solot.codsolot numero_solicitud,
         vtatabcli.codcli codigo_cliente,
         vtatabcli.nomcli nombre_cliente,
         solot.numslc numslc,
         to_number(solot.numslc) numero_proyecto,
         solot.fecapr fecha_aprobacion,
         tystipsrv.dsctipsrv tipo_servicio,
         tiptrabajo.descripcion tipo_ot,
         motot.descripcion  motivo_ot ,
         trunc(solot.feccom,'dd') fecha_compromiso
    FROM motot,
         solot,
         tiptrabajo,
         vtatabcli,
         tystipsrv
   WHERE ( solot.tiptra = tiptrabajo.tiptra (+)) and
         ( solot.codcli = vtatabcli.codcli ) and
         ( solot.codmotot = motot.codmotot (+)) and
         ( tystipsrv.tipsrv (+) = solot.tipsrv);


