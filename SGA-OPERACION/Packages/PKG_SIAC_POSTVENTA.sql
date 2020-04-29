CREATE OR REPLACE PACKAGE OPERACION.PKG_SIAC_POSTVENTA IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_SIAC_POSTVENTA
  PROPOSITO:  Generacion de Post Venta Automatica PARA LOS DIFERENTES TIPOS DE TRANSACCION
              1 - CAMBIO NUMERO

  REVISIONES:
  Version  Fecha       Autor             Solicitado por     Descripcion
  -------  ----------  ----------------  ----------------   -----------
    1.0    16/05/2017  Juan Gonzales      Alfredo YI       Cambio de numero SIAC UNICO
                       Lidia Quispe
  *******************************************************************************/
  G_TIPOTRANS  VARCHAR2(100);
  G_ID_TRANS   NUMBER;
  G_P_ID       NUMBER;
  /*** PROCEDIMIENTO PRINCIPAL INVOCADO DESDE BIPEL ***/
  PROCEDURE SIACSI_GENERAR_TRANS(K_ID_TRANS      IN NUMBER,
                                 K_CODSOLOT      OUT SOLOT.CODSOLOT%TYPE,
                                 K_ERROR_CODE    OUT NUMBER,
                                 K_ERROR_MSG     OUT VARCHAR2);

  /*** FUNCION QUE REALIZA EL EXPLODE DE LA TRAMA ENVIADA Y RECUPERA EL VALOR DEL CAMPO ***/
  FUNCTION SIACFUN_GET_PARAMETER(K_CAMPO VARCHAR2,
                                 K_TRAMA SALES.SIACT_UTIL_TRAMA.TRAMV_TRAMA%TYPE)
                                 RETURN VARCHAR2;
  /*** FUNCION QUE MODIFICA EL CAMPO TRAMA Y DEVUELVE LA TRAMA MODIFICADA ***/
  FUNCTION SIACFUN_SET_PARAMETER(K_CAMPO    VARCHAR2,
                                 K_VALUE    VARCHAR2,
                                 K_ID_TRANS SALES.SIACT_UTIL_TRAMA.TRAMN_IDTRANSACCION%TYPE) RETURN VARCHAR2;
  /*** PROCEDIMIENTO PARA REALIZACION DEL INSERT A LA TABLA QUE CONTIENE LA TRAMA ***/
  PROCEDURE SIACSI_UTIL_TRAMA( K_ID_INTERACCION VARCHAR2,
                               K_ID_TRANS       VARCHAR2,
                               K_CO_ID          VARCHAR2,
                               K_CUSTOMER_ID    VARCHAR2,
                               K_CODSOLOT       VARCHAR2,
                               K_TRAMA          VARCHAR2);
  /*** ACTUALIZA LOS VALORES DE LA TRAMA GENERADOS DEL PROCEDURE ***/
  PROCEDURE SIACSU_UTIL_TRAMA(K_ID_TRANS VARCHAR2,
                              K_TRAMA_NEW SALES.SIACT_UTIL_TRAMA.TRAMV_TRAMA%TYPE);
  /*** PROCEDIMIENTO QUE INSERTA LOS DATOS EN LA TABLA LOG ***/
  PROCEDURE SIACSI_TRAZABILIDAD_LOG(K_ID_TRANSACCION     NUMBER,
                                   K_ID_INTERACCION     NUMBER,
                                   K_TIPO_TRANSACCION   VARCHAR2,
                                   K_CODSOLOT           NUMBER,
                                   K_ID_TAREA           NUMBER,
                                   K_MSG_ERR            OPERACION.SIAC_NEGOCIO_ERR.ORA_TEXT%TYPE,
                                   K_RESULTADO          VARCHAR2);
  /*** PROCEDIMIENTO PARA REGISTRAR EN LA SOT_SIAC TRANSACCIONES ANTERIORES ***/
  PROCEDURE SIACSI_SOT_SIAC (K_COD_ID       SALES.SOT_SISACT.COD_ID%TYPE,
                             K_CODSOLOT     OPERACION.SOLOT.CODSOLOT%TYPE,
                             K_CUSTOMER_ID  OPERACION.SOLOT.CUSTOMER_ID%TYPE);

  FUNCTION SIACFUN_VALIDA_SGA( K_COD_ID OPERACION.SOLOT.COD_ID%TYPE,
                               K_NUMERO OPERACION.INSSRV.NUMERO%TYPE)   RETURN NUMBER;

  procedure SIACSS_validad_transaccion(v_customer_id in NUMBER,
                                       v_error_code  out number,
                                       v_error_msg   out varchar2);

 procedure SIACSS_PLANOS(po_lstplano out sys_refcursor,
                         po_coderror out integer,
                         po_msgerror out varchar2);

END;
/