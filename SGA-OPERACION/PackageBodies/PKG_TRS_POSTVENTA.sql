CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_TRS_POSTVENTA IS

  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_TRS_POSTVENTA
  PROPOSITO:  Ejecución de las transacciones Postventa
  
  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      23/01/2020  Felipe Maguiña       Dante Sunohara      INICIATIVA-193 Reingeniería de Venta y PostVenta Fija   
  /************************************************************************************************/

  FUNCTION SGAFUN_GET_SERVICES(P_IDPROCESS NUMBER)
    RETURN OPERACION.PQ_SIAC_CAMBIO_PLAN.SERVICES_TYPE IS
    L_SERVICES      OPERACION.PQ_SIAC_CAMBIO_PLAN.SERVICES_TYPE;
    L_SERVICIOS     OPERACION.PQ_SIAC_CAMBIO_PLAN.SERVICIOS_TYPE;
    L_IDX           NUMBER := 0;
    V_IDINTERACCION NUMBER;
    V_ERROR         NUMBER;
    V_MSJERR        VARCHAR2(3000);
  
    CURSOR SERVICIOS(P_ID VARCHAR2) IS
      SELECT T.*
        FROM OPERACION.SGAT_POSTV_SERV T
       WHERE T.IDINTERACCION = P_ID;
  
  BEGIN
    SELECT DBMS_UTILITY.FORMAT_CALL_STACK INTO V_MSJERR FROM DUAL;
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'IDINTERACCION',
                                                   'POSTV',
                                                   V_IDINTERACCION,
                                                   V_ERROR,
                                                   V_MSJERR);
  
    FOR SRV IN SERVICIOS(V_IDINTERACCION) LOOP
    
      L_IDX := L_IDX + 1;
    
      L_SERVICIOS(L_IDX).SERVICIO := SRV.SERVICIO;
      L_SERVICIOS(L_IDX).IDGRUPO_PRINCIPAL := SRV.IDGRUPO_PRINCIPAL;
      L_SERVICIOS(L_IDX).IDGRUPO := SRV.IDGRUPO;
      L_SERVICIOS(L_IDX).CANTIDAD_INSTANCIA := SRV.CANTIDAD_INSTANCIA;
      L_SERVICIOS(L_IDX).DSCSRV := SRV.DSCSRV;
      L_SERVICIOS(L_IDX).BANDWID := SRV.BANDWID;
      L_SERVICIOS(L_IDX).FLAG_LC := SRV.FLAG_LC;
      L_SERVICIOS(L_IDX).CANTIDAD_IDLINEA := SRV.CANTIDAD_IDLINEA;
    
      IF TRIM(SRV.TIPEQU) = '0' OR LENGTH(TRIM(SRV.TIPEQU)) = 0 THEN
        L_SERVICIOS(L_IDX).TIPEQU := NULL;
      ELSE
        L_SERVICIOS(L_IDX).TIPEQU := SRV.TIPEQU;
      END IF;
    
      IF TRIM(SRV.CODTIPEQU) = '0' OR LENGTH(TRIM(SRV.CODTIPEQU)) = 0 THEN
        L_SERVICIOS(L_IDX).CODTIPEQU := NULL;
      ELSE
        L_SERVICIOS(L_IDX).CODTIPEQU := SRV.CODTIPEQU;
      END IF;
    
      L_SERVICIOS(L_IDX).CANTIDAD := SRV.CANTIDAD;
      L_SERVICIOS(L_IDX).DSCEQU := SRV.DSCEQU;
      L_SERVICIOS(L_IDX).CODIGO_EXT := SRV.CODIGO_EXT;
    
    END LOOP;
    L_SERVICES := OPERACION.PQ_SIAC_CAMBIO_PLAN.GET_SERVICES(L_SERVICIOS);
  
    RETURN L_SERVICES;
  END;

  PROCEDURE SGASS_VALIDACION_INICIAL_CP(P_IDPROCESS NUMBER,
                                        P_ERROR     OUT NUMBER,
                                        P_MENSAJE   OUT VARCHAR2) IS
  
    L_SERVICES OPERACION.PQ_SIAC_CAMBIO_PLAN.SERVICES_TYPE;
  BEGIN
  
    L_SERVICES := SGAFUN_GET_SERVICES(P_IDPROCESS); --legado
  
    OPERACION.PQ_SIAC_CAMBIO_PLAN.UPDATE_NEGOCIO_PROCESO(L_SERVICES); --legado
  
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_VALIDACION_INICIAL_CP] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_GENERA_VENTA_MENOR(P_IDPROCESS NUMBER,
                                     P_ERROR     OUT NUMBER,
                                     P_MENSAJE   OUT VARCHAR2) IS
    V_ERROR  NUMBER;
    V_MSJERR VARCHAR2(3000);
    V_CO_ID  NUMBER;
  BEGIN
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'COD_ID',
                                                   'POSTV',
                                                   V_CO_ID,
                                                   V_ERROR,
                                                   V_MSJERR);
    OPERACION.PQ_SIAC_CAMBIO_PLAN.CREATE_REGVTAMENTAB(V_CO_ID);
  
    OPERACION.PKG_SOT_UNIFICADA.SGASI_ACT_PARAMETRO('POSTV',
                                                    P_IDPROCESS,
                                                    'NUMREGISTRO',
                                                    OPERACION.PQ_SIAC_CAMBIO_PLAN.G_NUMREGISTRO);
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_GENERA_VENTA_MENOR] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_GENERA_VENTA_MENOR_DET(P_IDPROCESS NUMBER,
                                         P_ERROR     OUT NUMBER,
                                         P_MENSAJE   OUT VARCHAR2) IS
    L_SERVICES OPERACION.PQ_SIAC_CAMBIO_PLAN.SERVICES_TYPE;
  BEGIN
    L_SERVICES := SGAFUN_GET_SERVICES(P_IDPROCESS);
    OPERACION.PQ_SIAC_CAMBIO_PLAN.CREATE_SALES_DETAIL(L_SERVICES);
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_GENERA_VENTA_MENOR_DET] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_GENERA_VENTA(P_IDPROCESS NUMBER,
                               P_ERROR     OUT NUMBER,
                               P_MENSAJE   OUT VARCHAR2) IS
    V_ERROR       NUMBER;
    V_MSJERR      VARCHAR2(3000);
    V_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE;
  BEGIN
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'NUMREGISTRO',
                                                   'POSTV',
                                                   V_NUMREGISTRO,
                                                   V_ERROR,
                                                   V_MSJERR);
    OPERACION.PQ_SIAC_CAMBIO_PLAN.GENERAR_SEF(V_NUMREGISTRO);
    OPERACION.PKG_SOT_UNIFICADA.SGASI_ACT_PARAMETRO('POSTV',
                                                    P_IDPROCESS,
                                                    'NUMSLC',
                                                    OPERACION.PQ_SIAC_CAMBIO_PLAN.G_NUMSLC_NEW);
    OPERACION.PKG_SOT_UNIFICADA.SGASI_ACT_PARAMETRO('POSTV',
                                                    P_IDPROCESS,
                                                    'NUMSLC_OLD',
                                                    OPERACION.PQ_SIAC_CAMBIO_PLAN.G_NUMSLC_OLD);
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_GENERA_VENTA] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_GENERA_VENTA_DET(P_IDPROCESS NUMBER,
                                   P_ERROR     OUT NUMBER,
                                   P_MENSAJE   OUT VARCHAR2) IS
    V_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE;
    V_NUMSLC      VTATABSLCFAC.NUMSLC%TYPE;
    P_PRECON      OPERACION.PQ_SIAC_CAMBIO_PLAN.PRECON_TYPE;
    V_ERROR       NUMBER;
    V_MSJERR      VARCHAR2(3000);
    V_EXCEPTION EXCEPTION;
  BEGIN
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'NUMREGISTRO',
                                                   'POSTV',
                                                   V_NUMREGISTRO,
                                                   V_ERROR,
                                                   V_MSJERR);
    IF V_ERROR <> 0 THEN
      RAISE V_EXCEPTION;
    END IF;
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'NUMSLC',
                                                   'POSTV',
                                                   V_NUMSLC,
                                                   V_ERROR,
                                                   V_MSJERR);
    IF V_ERROR <> 0 THEN
      RAISE V_EXCEPTION;
    END IF;
    P_PRECON := SGAFUN_GET_PRECON(P_IDPROCESS);
    OPERACION.PQ_SIAC_CAMBIO_PLAN.GENERAR_PTOENL_CAMBIO(V_NUMREGISTRO,
                                                        V_NUMSLC,
                                                        P_PRECON);
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN V_EXCEPTION THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_GENERA_VENTA_DET] => ' ||
                   V_MSJERR;
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_GENERA_VENTA_DET] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_ACT_NUMSLC(P_IDPROCESS NUMBER,
                             P_ERROR     OUT NUMBER,
                             P_MENSAJE   OUT VARCHAR2) IS
  BEGIN
    OPERACION.PQ_SIAC_CAMBIO_PLAN.UPDATE_NUMSLC_NEW();
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_ACT_NUMSLC] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_REG_PIDBAJA(P_IDPROCESS NUMBER,
                              P_ERROR     OUT NUMBER,
                              P_MENSAJE   OUT VARCHAR2) IS
  
    V_NUMSLC_OLD VTATABSLCFAC.NUMSLC%TYPE;
    V_CO_ID      NUMBER;
    V_ERROR      NUMBER;
    V_MSJERR     VARCHAR2(3000);
    V_EXCEPTION EXCEPTION;
  BEGIN
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'NUMSLC_OLD',
                                                   'POSTV',
                                                   V_NUMSLC_OLD,
                                                   V_ERROR,
                                                   V_MSJERR);
    IF V_ERROR <> 0 THEN
      RAISE V_EXCEPTION;
    END IF;
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'COD_ID',
                                                   'POSTV',
                                                   V_CO_ID,
                                                   V_ERROR,
                                                   V_MSJERR);
    IF V_ERROR <> 0 THEN
      RAISE V_EXCEPTION;
    END IF;
    OPERACION.PQ_SIAC_CAMBIO_PLAN.CREATE_REGINSPRDBAJA(V_NUMSLC_OLD,
                                                       V_CO_ID);
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_REG_BAJA] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_LOAD_INSTANCIA_CAMBIO(P_IDPROCESS NUMBER,
                                        P_ERROR     OUT NUMBER,
                                        P_MENSAJE   OUT VARCHAR2) IS
    V_ERROR  NUMBER;
    V_MSJERR VARCHAR2(3000);
    V_NUMSLC VTATABSLCFAC.NUMSLC%TYPE;
    V_EXCEPTION EXCEPTION;
  BEGIN
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'NUMSLC',
                                                   'POSTV',
                                                   V_NUMSLC,
                                                   V_ERROR,
                                                   V_MSJERR);
    IF V_ERROR <> 0 THEN
      RAISE V_EXCEPTION;
    END IF;
    OPERACION.PQ_SIAC_CAMBIO_PLAN.LOAD_INSTANCIA_CAMBIO(V_NUMSLC);
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_REG_BAJA] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_REG_PRECON(P_IDPROCESS NUMBER,
                             P_ERROR     OUT NUMBER,
                             P_MENSAJE   OUT VARCHAR2) IS
    V_ERROR  NUMBER;
    V_MSJERR VARCHAR2(3000);
    V_NUMSLC VTATABSLCFAC.NUMSLC%TYPE;
    P_PRECON OPERACION.PQ_SIAC_CAMBIO_PLAN.PRECON_TYPE;
    V_EXCEPTION EXCEPTION;
  BEGIN
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'NUMSLC',
                                                   'POSTV',
                                                   V_NUMSLC,
                                                   V_ERROR,
                                                   V_MSJERR);
    IF V_ERROR <> 0 THEN
      RAISE V_EXCEPTION;
    END IF;
    P_PRECON := SGAFUN_GET_PRECON(P_IDPROCESS);
    IF P_PRECON.OBSAPROFE = 'ERROR' THEN
      RAISE V_EXCEPTION;
    END IF;
    OPERACION.PQ_SIAC_CAMBIO_PLAN.CREATE_VTATABPRECON(V_NUMSLC, P_PRECON);
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN V_EXCEPTION THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_REG_PRECON] => ' ||
                   'No existe información para el IDPROCESS: ' ||
                   P_IDPROCESS;
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_REG_PRECON] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_VALIDAR_TIPOSOL(P_IDPROCESS NUMBER,
                                  P_ERROR     OUT NUMBER,
                                  P_MENSAJE   OUT VARCHAR2) IS
    V_ERROR  NUMBER;
    V_MSJERR VARCHAR2(3000);
    V_NUMSLC VTATABSLCFAC.NUMSLC%TYPE;
    V_EXCEPTION EXCEPTION;
  BEGIN
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'NUMSLC',
                                                   'POSTV',
                                                   V_NUMSLC,
                                                   V_ERROR,
                                                   V_MSJERR);
    IF V_ERROR <> 0 THEN
      RAISE V_EXCEPTION;
    END IF;
  
    OPERACION.PQ_SIAC_CAMBIO_PLAN.VALIDAR_TIPOSOLUCION(V_NUMSLC);
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_VALIDAR_TIPOSOL] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_VALIDAR_PROYECTO(P_IDPROCESS NUMBER,
                                   P_ERROR     OUT NUMBER,
                                   P_MENSAJE   OUT VARCHAR2) IS
    V_ERROR  NUMBER;
    V_MSJERR VARCHAR2(3000);
    V_NUMSLC VTATABSLCFAC.NUMSLC%TYPE;
    V_EXCEPTION EXCEPTION;
  BEGIN
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'NUMSLC',
                                                   'POSTV',
                                                   V_NUMSLC,
                                                   V_ERROR,
                                                   V_MSJERR);
    IF V_ERROR <> 0 THEN
      RAISE V_EXCEPTION;
    END IF;
  
    IF OPERACION.PQ_SIAC_CAMBIO_PLAN.VALIDAR_CHECKPROY(V_NUMSLC) <> 'OK' THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'ERROR AL VERIFICAR PROYECTO DE VENTA');
    END IF;
  
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_REG_BAJA] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_PROYECTO_PREVENTA(P_IDPROCESS NUMBER,
                                    P_ERROR     OUT NUMBER,
                                    P_MENSAJE   OUT VARCHAR2) IS
    V_ERROR  NUMBER;
    V_MSJERR VARCHAR2(3000);
    V_NUMSLC VTATABSLCFAC.NUMSLC%TYPE;
    V_EXCEPTION EXCEPTION;
  BEGIN
    OPERACION.PKG_SOT_UNIFICADA.SGASS_OBTENER_DATO(P_IDPROCESS,
                                                   'NUMSLC',
                                                   'POSTV',
                                                   V_NUMSLC,
                                                   V_ERROR,
                                                   V_MSJERR);
    IF V_ERROR <> 0 THEN
      RAISE V_EXCEPTION;
    END IF;
  
    IF OPERACION.PQ_SIAC_CAMBIO_PLAN.PROYECTO_PREVENTA(V_NUMSLC) <> 1 THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'ERROR EN LA INTERFAZ VENTAS/OPERACIONES');
    
    END IF;
    OPERACION.PKG_SOT_UNIFICADA.SGASI_ACT_PARAMETRO('POSTV',
                                                    P_IDPROCESS,
                                                    'CODSOLOT',
                                                    OPERACION.PQ_SIAC_CAMBIO_PLAN.G_CODSOLOT);
    P_ERROR   := 0;
    P_MENSAJE := 'ÉXITO';
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: [PQ_SIAC_CAMBIO_PLAN_FM.P_PROYECTO_PREVENTA] => ' ||
                   TO_CHAR(SQLERRM);
  END;

  FUNCTION SGAFUN_GET_PRECON(P_IDPROCESS NUMBER)
    RETURN OPERACION.PQ_SIAC_CAMBIO_PLAN.PRECON_TYPE IS
    L_PRECON OPERACION.PQ_SIAC_CAMBIO_PLAN.PRECON_TYPE;
  BEGIN
    SELECT T.OBSERVACION,
           T.NUM_CARTA,
           T.OPERADOR,
           T.PRESUSCRITO,
           T.PUBLICAR
      INTO L_PRECON.OBSAPROFE,
           L_PRECON.CARTA,
           L_PRECON.CARRIER,
           L_PRECON.PRESUSC,
           L_PRECON.PUBLICAR
      FROM OPERACION.SGAT_POSTV T
     WHERE T.IDPROCESS = P_IDPROCESS;
  
    RETURN L_PRECON;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      L_PRECON.OBSAPROFE := 'ERROR';
      RETURN L_PRECON;
  END;
END;
/