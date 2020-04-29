create or replace package OPERACION.pq_webuni_eta is
/****************************************************************************************************
     NOMBRE:        pq_webuni_eta
     DESCRIPCION:   Administración y Manejo de Cuadrillas (TOA
  
     Ver        Date        Author          Solicitado por       Descripcion
     ---------  ----------  --------------- ----------------   ------------------------------------
     1.0        28/11/2015  Augusto Chacon     Hector Huaman     
  ****************************************************************************************************/
  PROCEDURE sp_reg_parametro_vta_pvta_adc(re_codsolot      IN NUMBER,
                                   re_idpoblado     IN VARCHAR2,
                                   re_subtipo_orden IN VARCHAR2,
                                   re_fecha_progra  IN VARCHAR2,
                                   re_franja        IN VARCHAR2,
                                   re_idbucket      IN VARCHAR2,
                                   re_ipcre         IN VARCHAR2,
                                   re_ipmod         IN VARCHAR2,
                                   re_usucre        IN VARCHAR2,
                                   re_usumod        IN VARCHAR2,
                                   re_flg_puerta    IN NUMBER,
                                   msj_respuest     OUT VARCHAR2,
                                   cod_respuesta    OUT NUMBER);

END;
/