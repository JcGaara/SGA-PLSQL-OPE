CREATE OR REPLACE PACKAGE operacion.pkg_indicadores_procesos IS

  TYPE cursor_salida IS REF CURSOR;

  PROCEDURE ipcss_solot(pi_fecha_ini     IN DATE,
                        pi_fecha_fin     IN DATE,
                        po_coderror      OUT PLS_INTEGER,
                        po_msgerr        OUT VARCHAR2,
                        po_cur_resultado OUT cursor_salida);

  PROCEDURE ipcss_solotpto(pi_fecha_ini     IN DATE,
                           pi_fecha_fin     IN DATE,
                           po_coderror      OUT PLS_INTEGER,
                           po_msgerr        OUT VARCHAR2,
                           po_cur_resultado OUT cursor_salida);

  PROCEDURE ipcss_inssrv(pi_fecha_ini     IN DATE,
                         pi_fecha_fin     IN DATE,
                         po_coderror      OUT PLS_INTEGER,
                         po_msgerr        OUT VARCHAR2,
                         po_cur_resultado OUT cursor_salida);

  PROCEDURE ipcss_ope_tvsat_archivo_cab(pi_fecha_ini     DATE,
                                        pi_fecha_fin     DATE,
                                        po_coderror      OUT PLS_INTEGER,
                                        po_msgerr        OUT VARCHAR2,
                                        po_cur_resultado OUT cursor_salida);

  PROCEDURE ipcss_ope_tvsat_archivo_det(pi_fecha_ini     DATE,
                                        pi_fecha_fin     DATE,
                                        po_coderror      OUT PLS_INTEGER,
                                        po_msgerr        OUT VARCHAR2,
                                        po_cur_resultado OUT cursor_salida);

  PROCEDURE ipcss_ope_tvsat_sltd_cab(pi_fecha_ini     DATE,
                                     pi_fecha_fin     DATE,
                                     po_coderror      OUT PLS_INTEGER,
                                     po_msgerr        OUT VARCHAR2,
                                     po_cur_resultado OUT cursor_salida);

  PROCEDURE ipcss_ope_tvsat_lote_sltd_aux(pi_fecha_ini     DATE,
                                          pi_fecha_fin     DATE,
                                          po_coderror      OUT PLS_INTEGER,
                                          po_msgerr        OUT VARCHAR2,
                                          po_cur_resultado OUT cursor_salida);

  PROCEDURE ipcss_int_envio_log(pi_fecha_ini     IN DATE,
                                pi_fecha_fin     IN DATE,
                                po_codigo_error  OUT NUMBER,
                                po_mensaje_error OUT VARCHAR2,
                                po_cur_resultado OUT SYS_REFCURSOR);

  PROCEDURE ipcss_paquete_venta(po_cur_resultado OUT SYS_REFCURSOR,
                                po_codigo_error  OUT NUMBER,
                                po_mensaje_error OUT VARCHAR2);
END;
/