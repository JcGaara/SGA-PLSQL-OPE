CREATE OR REPLACE PACKAGE BODY operacion.pkg_indicadores_procesos AS
  /****************************************************************
  * Nombre Package      : PKG_INDICADORES_PROCESOS
  * Propósito           : Permite realizar consultas/extracción de datos de EAI para la base de datos IPCT
  * Input               : No Aplica
  * Output              : No Aplica
  * Creado por          : TS - OCR
  * Féc. Creación       : 09/11/2016 12:23:23 p.m.
  * Féc. Actualización  :
  '****************************************************************/

  PROCEDURE ipcss_solot(pi_fecha_ini     IN DATE,
                        pi_fecha_fin     IN DATE,
                        po_coderror      OUT PLS_INTEGER,
                        po_msgerr        OUT VARCHAR2,
                        po_cur_resultado OUT cursor_salida) IS
    /****************************************************************
    * Nombre SP           : IPCSS_SOLOT
    * Propósito           : Obtener y EXTRAE los registros de la tabla OPERACION.SOLOT   de acuerdo a la fecha actual
    * Input               : No aplica
    * Output              :
         PO_CODERROR      : Código de ERROR
         PO_MSGERR        : Mensaje del ERROR
         PO_CUR_RESULTADO : Cursor que obtiene la selección de registros a procesar
    * Creado por          : TS - OCR
    * Fec Creación        : 10/12/2016 10:17:00 p.m.
    * Fec Actualización   :
    '****************************************************************/
  
  BEGIN
  
    OPEN po_cur_resultado FOR
    
      SELECT s.codsolot,
             s.tiptra,
             s.estsol,
             s.tipsrv,
             s.fecapr,
			 SUBSTR(TO_CHAR(REPLACE(REPLACE(REPLACE(s.observacion, chr(10), ''), chr(13), ''),chr(9),'')),1,250) observacion,
             s.codcli,
             s.numslc,
             s.fecusu,
             s.codusu,
             s.customer_id,
             s.cod_id
        FROM operacion.solot s, historico.int_int_envio_log t
       WHERE s.codsolot = t.codsolot
             AND t.fecha_creacion >= pi_fecha_ini
             AND t.fecha_creacion <= pi_fecha_fin;
  
    po_coderror := 0;
  
  EXCEPTION
    WHEN OTHERS THEN
      po_msgerr   := 'Package:PKG_INDICADORES_PROCESOS.IPCSS_SOLOT :' ||
                     SQLERRM;
      po_coderror := 1;
  END;

  PROCEDURE ipcss_solotpto(pi_fecha_ini     IN DATE,
                           pi_fecha_fin     IN DATE,
                           po_coderror      OUT PLS_INTEGER,
                           po_msgerr        OUT VARCHAR2,
                           po_cur_resultado OUT cursor_salida) IS
    /****************************************************************
    * Nombre SP           : IPCSS_SOLOTPTO
    * Propósito           : Obtener y EXTRAE los registros de la tabla OPERACION.SOLOT   de acuerdo a la fecha actual
    * Input               : No aplica
    * Output              :
         PO_CODERROR      : Código de ERROR
         PO_MSGERR        : Mensaje del ERROR
         PO_CUR_RESULTADO : Cursor que obtiene la selección de registros a procesar
    * Creado por          : TS - OCR
    * Fec Creación        : 10/12/2016 10:17:00 p.m.
    * Fec Actualización   :
    '****************************************************************/
  BEGIN
    OPEN po_cur_resultado FOR
    
      SELECT sl.codsolot,
             sl.codusu,
             sl.fecusu,
             sl.codinssrv,
             sl.cid,
             sl.descripcion,
             sl.direccion,
             sl.codubi
        FROM operacion.solotpto          sl,
             operacion.solot             s,
             historico.int_int_envio_log t
       WHERE s.codsolot = sl.codsolot
             AND t.codsolot = s.codsolot
             AND t.fecha_creacion >= pi_fecha_ini
             AND t.fecha_creacion <= pi_fecha_fin;
  
    po_coderror := 0;
  
  EXCEPTION
    WHEN OTHERS THEN
      po_msgerr   := 'Package:PKG_INDICADORES_PROCESOS.IPCSS_SOLOTPTO :' ||
                     SQLERRM;
      po_coderror := 1;
  END;

  PROCEDURE ipcss_inssrv(pi_fecha_ini     IN DATE,
                         pi_fecha_fin     IN DATE,
                         po_coderror      OUT PLS_INTEGER,
                         po_msgerr        OUT VARCHAR2,
                         po_cur_resultado OUT cursor_salida) IS
    /****************************************************************
    * Nombre SP           : IPCSS_INSSRV
    * Propósito           : Obtener y EXTRAE los registros de la tabla OPERACION.SOLOT   de acuerdo a la fecha actual
    * Input               : No aplica
    * Output              :
         PO_CODERROR      : Código de ERROR
         PO_MSGERR        : Mensaje del ERROR
         PO_CUR_RESULTADO : Cursor que obtiene la selección de registros a procesar
    * Creado por          : TS - OCR
    * Fec Creación        : 10/12/2016 10:17:00 p.m.
    * Fec Actualización   :
    '****************************************************************/
  BEGIN
    OPEN po_cur_resultado FOR
      SELECT s.codinssrv,
             s.codcli,
             s.codsrv,
             s.estinssrv,
             s.numero,
             s.numslc,
             s.tipcli,
             s.co_id,
             s.customer_id,
             s.idpaq
        FROM operacion.inssrv s, historico.int_int_envio_log t
       WHERE s.codinssrv = t.codinssrv
             AND t.fecha_creacion >= pi_fecha_ini
             AND t.fecha_creacion <= pi_fecha_fin;
  
    po_coderror := 0;
  
  EXCEPTION
    WHEN OTHERS THEN
      po_msgerr   := 'Package:PKG_INDICADORES_PROCESOS.ipcss_inssrv :' ||
                     SQLERRM;
      po_coderror := 1;
  END;

  PROCEDURE ipcss_ope_tvsat_archivo_cab(pi_fecha_ini     DATE,
                                        pi_fecha_fin     DATE,
                                        po_coderror      OUT PLS_INTEGER,
                                        po_msgerr        OUT VARCHAR2,
                                        po_cur_resultado OUT cursor_salida) IS
    /****************************************************************
    * Nombre SP           : IPCSS_OPE_TVSAT_ARCHIVO_CAB
    * Propósito           : Obtener y EXTRAE los registros de la tabla OPERACION.SOLOT   de acuerdo a la fecha actual
    * Input               : No aplica
    * Output              :
         PO_CODERROR      : Código de ERROR
         PO_MSGERR        : Mensaje del ERROR
         PO_CUR_RESULTADO : Cursor que obtiene la selección de registros a procesar
    * Creado por          : TS - OCR
    * Fec Creación        : 10/12/2016 10:17:00 p.m.
    * Fec Actualización   :
    '****************************************************************/
    fecha_actual CHAR(10);
  BEGIN
    SELECT to_char(SYSDATE, 'DDMMYYYY') INTO fecha_actual FROM dual;
  
    OPEN po_cur_resultado FOR
      SELECT /*+ index(t) */
       cab.idlote, cab.archivo, cab.estado, cab.usureg, cab.fecreg
        FROM operacion.ope_tvsat_archivo_cab cab --Manda el error de la cabecera de archivo
       WHERE to_char(cab.fecreg, 'YYYYMMDD') >=
             to_char(pi_fecha_ini, 'YYYYMMDD')
             AND to_char(cab.fecreg, 'YYYYMMDD') <=
             to_char(pi_fecha_fin, 'YYYYMMDD');
  
    po_coderror := 0;
  
  EXCEPTION
    WHEN OTHERS THEN
      po_msgerr   := 'Package:PKG_INDICADORES_PROCESOS.ipcss_ope_tvsat_archivo_cab :' ||
                     SQLERRM;
      po_coderror := 1;
  END;

  PROCEDURE ipcss_ope_tvsat_archivo_det(pi_fecha_ini     DATE,
                                        pi_fecha_fin     DATE,
                                        po_coderror      OUT PLS_INTEGER,
                                        po_msgerr        OUT VARCHAR2,
                                        po_cur_resultado OUT cursor_salida) IS
    /****************************************************************
    * Nombre SP           : IPCSS_OPE_TVSAT_ARCHIVO_DET
    * Propósito           : Obtener y EXTRAE los registros de la tabla OPERACION.SOLOT   de acuerdo a la fecha actual
    * Input               : No aplica
    * Output              :
         PO_CODERROR      : Código de ERROR
         PO_MSGERR        : Mensaje del ERROR
         PO_CUR_RESULTADO : Cursor que obtiene la selección de registros a procesar
    * Creado por          : TS - OCR
    * Fec Creación        : 10/12/2016 10:17:00 p.m.
    * Fec Actualización   :
    '****************************************************************/
  BEGIN
    OPEN po_cur_resultado FOR
      SELECT det.idlote, det.serie, det.usureg, det.fecreg, det.estado
        FROM operacion.ope_tvsat_archivo_det det
       WHERE to_char(det.fecreg, 'YYYYMMDD') >=
             to_char(pi_fecha_ini, 'YYYYMMDD')
             AND to_char(det.fecreg, 'YYYYMMDD') <=
             to_char(pi_fecha_fin, 'YYYYMMDD');
  
    po_coderror := 0;
  
  EXCEPTION
    WHEN OTHERS THEN
      po_msgerr   := 'Package:PKG_INDICADORES_PROCESOS.IPCSS_OPE_TVSAT_ARCHIVO_DET :' ||
                     SQLERRM;
      po_coderror := 1;
  END;

  PROCEDURE ipcss_ope_tvsat_sltd_cab(pi_fecha_ini     DATE,
                                     pi_fecha_fin     DATE,
                                     po_coderror      OUT PLS_INTEGER,
                                     po_msgerr        OUT VARCHAR2,
                                     po_cur_resultado OUT cursor_salida) IS
    /****************************************************************
    * Nombre SP           : IPCSS_OPE_TVSAT_SLTD_CAB
    * Propósito           : Obtener y EXTRAE los registros de la tabla OPERACION.SOLOT   de acuerdo a la fecha actual
    * Input               : No aplica
    * Output              :
         PO_CODERROR      : Código de ERROR
         PO_MSGERR        : Mensaje del ERROR
         PO_CUR_RESULTADO : Cursor que obtiene la selección de registros a procesar
    * Creado por          : TS - OCR
    * Fec Creación        : 10/12/2016 10:17:00 p.m.
    * Fec Actualización   :
    '****************************************************************/
  BEGIN
    OPEN po_cur_resultado FOR
      SELECT tb.idsol,
             tb.idlote,
             tb.codinssrv,
             tb.codcli,
             tb.codsolot,
             tb.estado,
             tb.usureg,
             tb.fecreg,
             tb.tiposolicitud --2: RECONEXION 1: SUSPENSION
            ,
             tb.flg_recarga
        FROM operacion.ope_tvsat_sltd_cab tb
       WHERE to_char(tb.fecreg, 'YYYYMMDD') >=
             to_char(pi_fecha_ini, 'YYYYMMDD')
             AND to_char(tb.fecreg, 'YYYYMMDD') <=
             to_char(pi_fecha_fin, 'YYYYMMDD');
  
    po_coderror := 0;
  
  EXCEPTION
    WHEN OTHERS THEN
      po_msgerr   := 'Package:PKG_INDICADORES_PROCESOS.IPCSS_OPE_TVSAT_SLTD_CAB :' ||
                     SQLERRM;
      po_coderror := 1;
  END;

  PROCEDURE ipcss_ope_tvsat_lote_sltd_aux(pi_fecha_ini     DATE,
                                          pi_fecha_fin     DATE,
                                          po_coderror      OUT PLS_INTEGER,
                                          po_msgerr        OUT VARCHAR2,
                                          po_cur_resultado OUT cursor_salida) IS
    /****************************************************************
    * Nombre SP           : IPCSS_OPE_TVSAT_LOTE_SLTD_AUX
    * Propósito           : Obtener y EXTRAE los registros de la tabla OPERACION.SOLOT   de acuerdo a la fecha actual
    * Input               : No aplica
    * Output              :
         PO_CODERROR      : Código de ERROR
         PO_MSGERR        : Mensaje del ERROR
         PO_CUR_RESULTADO : Cursor que obtiene la selección de registros a procesar
    * Creado por          : TS - OCR
    * Fec Creación        : 10/12/2016 10:17:00 p.m.
    * Fec Actualización   :
    '****************************************************************/
  BEGIN
    OPEN po_cur_resultado FOR
      SELECT ta.idlote, ta.estado, ta.usureg, ta.fecreg
        FROM operacion.ope_tvsat_lote_sltd_aux ta
       WHERE to_char(ta.fecreg, 'YYYYMMDD') >=
             to_char(pi_fecha_ini, 'YYYYMMDD')
             AND to_char(ta.fecreg, 'YYYYMMDD') <=
             to_char(pi_fecha_fin, 'YYYYMMDD');
  
    po_coderror := 0;
  
  EXCEPTION
    WHEN OTHERS THEN
      po_msgerr   := 'Package:PKG_INDICADORES_PROCESOS.ipcss_ope_tvsat_lote_sltd_aux :' ||
                     SQLERRM;
      po_coderror := 1;
  END;

  PROCEDURE ipcss_int_envio_log(pi_fecha_ini     IN DATE,
                                pi_fecha_fin     IN DATE,
                                po_codigo_error  OUT NUMBER,
                                po_mensaje_error OUT VARCHAR2,
                                po_cur_resultado OUT SYS_REFCURSOR) IS
    /****************************************************************
    * Nombre SP           : IPCSS_INT_ENVIO
    * Propósito           : Obtener y EXTRAE los registros de la tabla OPERACION.SOLOT   de acuerdo a la fecha actual
    * Input               : No aplica
    * Output              :
         PO_CODERROR      : Código de ERROR
         PO_MSGERR        : Mensaje del ERROR
         PO_CUR_RESULTADO : Cursor que obtiene la selección de registros a procesar
    * Creado por          : TS - OCR
    * Fec Creación        : 10/12/2016 10:17:00 p.m.
    * Fec Actualización   :
    '****************************************************************/
  BEGIN
    OPEN po_cur_resultado FOR
      SELECT t.codsolot,
             t.codinssrv,
             t.id_lote,
             t.id_cliente,
             t.proceso,
             t.id_estado,
             t.id_producto,
             t.id_error,
             REPLACE(REPLACE(t.id_mensaje, chr(10), ''), chr(13), ''),
             t.fecha_creacion,
             t.fecreg,
             t.fecha_frecuencia,
             t.est_envio,
             t.codcli
        FROM historico.int_int_envio_log t
       WHERE t.fecha_creacion >= pi_fecha_ini
             AND t.fecha_creacion <= pi_fecha_fin;
  
    po_codigo_error  := 0;
    po_mensaje_error := 'OK';
  
  EXCEPTION
    WHEN OTHERS THEN
      po_mensaje_error := 'Package:PKG_INDICADORES_PROCESOS.ipcss_int_envio_log :' ||
                          SQLERRM;
      po_codigo_error  := 1;
  END;
  /******************************************************************************************************************************/
  PROCEDURE ipcss_paquete_venta(po_cur_resultado OUT SYS_REFCURSOR,
                                po_codigo_error  OUT NUMBER,
                                po_mensaje_error OUT VARCHAR2) IS
    /****************************************************************
    * Nombre SP           : IPCSS_INT_ENVIO
    * Propósito           : Obtener y EXTRAE los registros de la tabla OPERACION.SOLOT   de acuerdo a la fecha actual
    * Input               : No aplica
    * Output              :
         PO_CODERROR      : Código de ERROR
         PO_MSGERR        : Mensaje del ERROR
         PO_CUR_RESULTADO : Cursor que obtiene la selección de registros a procesar
    * Creado por          : TS - OCR
    * Fec Creación        : 10/12/2016 10:17:00 p.m.
    * Fec Actualización   :
    '****************************************************************/
  BEGIN
    OPEN po_cur_resultado FOR
      SELECT p.idpaq, p.observacion, p.estado
        FROM sales.paquete_venta p
       WHERE p.estado > 0;
  
    po_codigo_error  := 0;
    po_mensaje_error := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      po_mensaje_error := 'Package:PKG_INDICADORES_PROCESOS.ipcss_paquete_venta :' ||
                          SQLERRM;
      po_codigo_error  := 1;
  END;
END;
/