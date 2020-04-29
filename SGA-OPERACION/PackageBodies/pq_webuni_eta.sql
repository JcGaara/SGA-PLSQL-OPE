create or replace package body OPERACION.pq_webuni_eta is
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
                                   cod_respuesta    OUT NUMBER) IS
  
  BEGIN
    INSERT INTO OPERACION.PARAMETRO_VTA_PVTA_ADC
      (codsolot,
       idpoblado,
       subtipo_orden,
       fecha_progra,
       franja,
       idbucket,
       ipcre,
       ipmod,
       usucre,
       usumod,
       feccre,
       fecmod,
       flg_puerta)
    VALUES
      (re_codsolot,
       re_idpoblado,
       re_subtipo_orden,
       to_date(re_fecha_progra, 'dd/mm/yyyy'),
       re_franja,
       re_idbucket,
       re_ipcre,
       re_ipmod,
       re_usucre,
       re_usumod,
       sysdate,
       sysdate,
       re_flg_puerta);
    COMMIT;
  
    cod_respuesta := 0;
    msj_respuest  := 'OK Registro Correcto en el SGA';
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        ROLLBACK;
        cod_respuesta := 1;
        msj_respuest  := 'error al registrar en SGA' || ' ' || TO_CHAR(SQLCODE) ||
                         SQLERRM;
      end;
    
  END sp_reg_parametro_vta_pvta_adc;

END;
/