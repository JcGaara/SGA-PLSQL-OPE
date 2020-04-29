CREATE OR REPLACE VIEW OPERACION.V_ASIG_CORREO_CONTRATA
AS 
SELECT 0 SOT,
      EF.NUMSLC PROYECTO,
      VTATABCLI.NOMCLI cliente,
      VTATABCLI.codcli codcli,
      EFPTO.DIRECCION direccion,
      VTATABDST.NOMDST distrito,
      'FCT' FASE,
      EFPTO.DESCRIPCION descripcion,
      TYSTABSRV.DSCSRV tipo_Servicio,
      '' obs_sot,
      (SELECT b.nombre FROM operacion.EFPTO_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codef = EFPTO.codef and a.punto = EFPTO.punto
      and orden = (select min(orden) from operacion.EFPTO_LOG c where c.codef = EFPTO.codef and c.punto = EFPTO.punto)) con_asig,
      (SELECT a.fecreagenda FROM operacion.EFPTO_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codef = EFPTO.codef and a.punto = EFPTO.punto
      and orden = (select min(orden) from operacion.EFPTO_LOG c where c.codef = EFPTO.codef and c.punto = EFPTO.punto)) fec_Asig,
      (SELECT a.usureagenda FROM operacion.EFPTO_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codef = EFPTO.codef and a.punto = EFPTO.punto
      and orden = (select min(orden) from operacion.EFPTO_LOG c where c.codef = EFPTO.codef and c.punto = EFPTO.punto)) usu_Asig,
      (SELECT b.nombre FROM operacion.EFPTO_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codef = EFPTO.codef and a.punto = EFPTO.punto
      and orden = (select max(orden) from operacion.EFPTO_LOG c where c.codef = EFPTO.codef and c.punto = EFPTO.punto)) con_reagenda,
      (SELECT a.fecreagenda FROM operacion.EFPTO_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codef = EFPTO.codef and a.punto = EFPTO.punto
      and orden = (select max(orden) from operacion.EFPTO_LOG c where c.codef = EFPTO.codef and c.punto = EFPTO.punto)) fec_reagenda,
      (SELECT a.usureagenda FROM operacion.EFPTO_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codef = EFPTO.codef and a.punto = EFPTO.punto
      and orden = (select max(orden) from operacion.EFPTO_LOG c where c.codef = EFPTO.codef and c.punto = EFPTO.punto)) usu_reagenda,
      efpto.codcon codcon
   FROM EFPTO, VTATABDST, EF, VTATABCLI, TYSTABSRV, vtatabslcfac, contrata
  WHERE (efpto.codubi = vtatabdst.codubi(+))
    AND (efpto.codsrv = tystabsrv.codsrv(+))
    AND (EFPTO.CODEF = EF.CODEF)
    AND (EF.CODCLI = VTATABCLI.CODCLI)
    AND ef.codef = vtatabslcfac.numslc(+)
    and efpto.codcon = contrata.codcon
union
 SELECT preubi.codsolot sot,
        solot.numslc proyecto,
        vtatabcli.nomcli cliente,
        vtatabcli.codcli codcli,
        preubi.dirobra direccion,
        vtatabdst.nomdst distrito,
        'DSN' FASE,
        preubi.descripcion descripcion,
        tystabsrv.dscsrv observacion,
        '' obs_sot,
      (SELECT b.nombre FROM operacion.PREUBI_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codsolot = PREUBI.codsolot and a.punto = PREUBI.punto
      and orden = (select min(orden) from operacion.PREUBI_LOG c where c.codsolot = PREUBI.codsolot and c.punto = PREUBI.punto)) con_asig,
      (SELECT a.fecreagenda FROM operacion.PREUBI_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codsolot = PREUBI.codsolot and a.punto = PREUBI.punto
     and orden = (select min(orden) from operacion.PREUBI_LOG c where c.codsolot = PREUBI.codsolot and c.punto = PREUBI.punto)) fec_Asig,
      (SELECT a.usureagenda FROM operacion.PREUBI_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codsolot = PREUBI.codsolot and a.punto = PREUBI.punto
      and orden = (select min(orden) from operacion.PREUBI_LOG c where c.codsolot = PREUBI.codsolot and c.punto = PREUBI.punto)) usu_Asig,
      (SELECT b.nombre FROM operacion.PREUBI_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codsolot = PREUBI.codsolot and a.punto = PREUBI.punto
      and orden = (select max(orden) from operacion.PREUBI_LOG c where c.codsolot = PREUBI.codsolot and c.punto = PREUBI.punto)) con_reagenda,
      (SELECT a.fecreagenda FROM operacion.PREUBI_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codsolot = PREUBI.codsolot and a.punto = PREUBI.punto
      and orden = (select max(orden) from operacion.PREUBI_LOG c where c.codsolot = PREUBI.codsolot and c.punto = PREUBI.punto)) fec_reagenda,
      (SELECT a.usureagenda FROM operacion.PREUBI_LOG a, contrata b
      where a.codconreagenda = b.codcon and a.codsolot = PREUBI.codsolot and a.punto = PREUBI.punto
      and orden = (select max(orden) from operacion.PREUBI_LOG c where c.codsolot = PREUBI.codsolot and c.punto = PREUBI.punto)) usu_reagenda,
      preubi.codcon
   FROM preubi, solot, vtatabcli, VTATABDST, solotpto, tystabsrv, contrata
  WHERE preubi.codsolot = solot.codsolot
    AND solot.codcli = vtatabcli.codcli
    AND preubi.disobra = vtatabdst.codubi
    AND preubi.punto = solotpto.punto
    AND solotpto.codsolot = solot.codsolot
    AND solotpto.codsrvnue = tystabsrv.codsrv
    and preubi.codcon = contrata.codcon
UNION
SELECT solotptoeta.codsolot sot,
   solot.numslc proyecto,
   vtatabcli.nomcli cliente,
   vtatabcli.codcli codcli,
   solotpto.direccion direccion,
   vtatabdst.nomdst distrito,
   FASE.FASE FASE,
   tiptrabajo.descripcion,
   '' dsctystipsrv,
   solot.observacion obs_sot,
  (SELECT b.nombre FROM operacion.Solotptoeta_Agendamiento_Log a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTOETA.codsolot and a.punto = SOLOTPTOETA.punto and a.orden = SOLOTPTOETA.orden
  and a.orden_log = (select min(c.orden_log) from operacion.Solotptoeta_Agendamiento_Log c where c.codsolot = SOLOTPTOETA.codsolot and c.punto = SOLOTPTOETA.punto and c.orden = SOLOTPTOETA.orden)) con_asig,
  (SELECT a.fecreagenda FROM operacion.Solotptoeta_Agendamiento_Log a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTOETA.codsolot and a.punto = SOLOTPTOETA.punto and a.orden = SOLOTPTOETA.orden
  and a.orden_log = (select min(c.orden_log) from operacion.Solotptoeta_Agendamiento_Log c where c.codsolot = SOLOTPTOETA.codsolot and c.punto = SOLOTPTOETA.punto and c.orden = SOLOTPTOETA.orden)) fec_Asig,
  (SELECT a.usureagenda FROM operacion.Solotptoeta_Agendamiento_Log a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTOETA.codsolot and a.punto = SOLOTPTOETA.punto and a.orden = SOLOTPTOETA.orden
  and a.orden_log = (select min(c.orden_log) from operacion.Solotptoeta_Agendamiento_Log c where c.codsolot = SOLOTPTOETA.codsolot and c.punto = SOLOTPTOETA.punto and c.orden = SOLOTPTOETA.orden)) usu_Asig,
  (SELECT b.nombre FROM operacion.Solotptoeta_Agendamiento_Log a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTOETA.codsolot and a.punto = SOLOTPTOETA.punto and a.orden = SOLOTPTOETA.orden
  and a.orden_log = (select max(c.orden_log) from operacion.Solotptoeta_Agendamiento_Log c where c.codsolot = SOLOTPTOETA.codsolot and c.punto = SOLOTPTOETA.punto and c.orden = SOLOTPTOETA.orden)) con_reagenda,
  (SELECT a.fecreagenda FROM operacion.Solotptoeta_Agendamiento_Log a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTOETA.codsolot and a.punto = SOLOTPTOETA.punto and a.orden = SOLOTPTOETA.orden
  and a.orden_log = (select max(c.orden_log) from operacion.Solotptoeta_Agendamiento_Log c where c.codsolot = SOLOTPTOETA.codsolot and c.punto = SOLOTPTOETA.punto and c.orden = SOLOTPTOETA.orden)) fec_reagenda,
  (SELECT a.usureagenda FROM operacion.Solotptoeta_Agendamiento_Log a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTOETA.codsolot and a.punto = SOLOTPTOETA.punto and a.orden = SOLOTPTOETA.orden
  and a.orden_log = (select max(c.orden_log) from operacion.Solotptoeta_Agendamiento_Log c where c.codsolot = SOLOTPTOETA.codsolot and c.punto = SOLOTPTOETA.punto and c.orden = SOLOTPTOETA.orden)) usu_reagenda,
  solotptoeta.codcon
  FROM solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo, contrata,
  (SELECT DISTINCT ABREVIACION CODETA, CODIGOC FASE FROM OPEDD WHERE TIPOPEDD =214 and operacion.is_number(ABREVIACION) = 1) FASE
 WHERE solotptoeta.codsolot = solotpto.codsolot
   AND solotptoeta.punto = solotpto.punto
   AND solotptoeta.codsolot = solot.codsolot
   AND solot.codcli = vtatabcli.codcli
   and solotptoeta.codcon = contrata.codcon
   AND solotpto.codubi = vtatabdst.codubi
   AND solot.tiptra = tiptrabajo.tiptra
   AND solotptoeta.codeta = FASE.CODETA
union
   select distinct SOLOTPTO_ID.codsolot,
   solot.numslc proyecto,
   vtatabcli.nomcli cliente,
   vtatabcli.codcli codcli,
   solotpto.direccion direccion,
   vtatabdst.nomdst distrito,
   'PINT' FASE,
   tiptrabajo.descripcion,
   '' dsctystipsrv,
   solot.observacion obs_sot,
  (SELECT b.nombre FROM operacion.SOLOTPTO_ID_LOG_AGE a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTO_ID.codsolot and a.punto = SOLOTPTO_ID.punto
  and orden = (select min(orden) from operacion.SOLOTPTO_ID_LOG_AGE c where c.codsolot = SOLOTPTO_ID.codsolot and c.punto = SOLOTPTO_ID.punto)) con_asig,
  (SELECT a.fecreagenda FROM operacion.SOLOTPTO_ID_LOG_AGE a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTO_ID.codsolot and a.punto = SOLOTPTO_ID.punto
  and orden = (select min(orden) from operacion.SOLOTPTO_ID_LOG_AGE c where c.codsolot = SOLOTPTO_ID.codsolot and c.punto = SOLOTPTO_ID.punto)) fec_Asig,
  (SELECT a.usureagenda FROM operacion.SOLOTPTO_ID_LOG_AGE a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTO_ID.codsolot and a.punto = SOLOTPTO_ID.punto
  and orden = (select min(orden) from operacion.SOLOTPTO_ID_LOG_AGE c where c.codsolot = SOLOTPTO_ID.codsolot and c.punto = SOLOTPTO_ID.punto)) usu_Asig,
  (SELECT b.nombre FROM operacion.SOLOTPTO_ID_LOG_AGE a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTO_ID.codsolot and a.punto = SOLOTPTO_ID.punto
  and orden = (select max(orden) from operacion.SOLOTPTO_ID_LOG_AGE c where c.codsolot = SOLOTPTO_ID.codsolot and c.punto = SOLOTPTO_ID.punto)) con_reagenda,
  (SELECT a.fecreagenda FROM operacion.SOLOTPTO_ID_LOG_AGE a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTO_ID.codsolot and a.punto = SOLOTPTO_ID.punto
  and orden = (select max(orden) from operacion.SOLOTPTO_ID_LOG_AGE c where c.codsolot = SOLOTPTO_ID.codsolot and c.punto = SOLOTPTO_ID.punto)) fec_reagenda,
  (SELECT a.usureagenda FROM operacion.SOLOTPTO_ID_LOG_AGE a, contrata b
  where a.codconreagenda = b.codcon and a.codsolot = SOLOTPTO_ID.codsolot and a.punto = SOLOTPTO_ID.punto
  and orden = (select max(orden) from operacion.SOLOTPTO_ID_LOG_AGE c where c.codsolot = SOLOTPTO_ID.codsolot and c.punto = SOLOTPTO_ID.punto)) usu_reagenda,
  solotpto_id.codcon
   from SOLOTPTO_ID, solot, vtatabcli, vtatabdst, solotpto, contrata, tiptrabajo
   where solotpto_id.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solot.tiptra = tiptrabajo.tiptra
   AND solotpto.codubi = vtatabdst.codubi
   and solotpto_id.codsolot = solotpto.codsolot
   and solotpto_id.punto = solotpto.punto
   and solotpto_id.codcon = contrata.codcon;


