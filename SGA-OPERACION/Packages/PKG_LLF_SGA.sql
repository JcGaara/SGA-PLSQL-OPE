CREATE OR REPLACE PACKAGE OPERACION.PKG_LLF_SGA AS

  C_NOK                 CONSTANT NUMBER := 0;
  C_OK                  CONSTANT NUMBER := 1;
  C_RSRVDO_SSTMA        CONSTANT NUMBER := 6;
  C_ESTSOL_CERRADA      CONSTANT NUMBER := 12;
  C_ESTSOL_ANULADA      CONSTANT NUMBER := 13;
  C_ESTSOL_RECHAZADA    CONSTANT NUMBER := 15;
  C_ESTSOL_ATENDIDA     CONSTANT NUMBER := 29;
  C_ESTNUMTEL_ASIGN     CONSTANT NUMBER := 2;
  C_ESTINSSRV_CANCELADO  CONSTANT NUMBER := 3;
  C_ESTINSSRV_SINACTIV  CONSTANT NUMBER := 4;
  C_BCLIMIT             CONSTANT NUMBER := 1000;
  C_CONFIG_OPEDD_TIPTRA CONSTANT VARCHAR2(15) := 'TIPOS_TRABAJO';
  C_CONFIG_OPEDD_TIPLIN CONSTANT VARCHAR2(15) := 'TIPOS_LINEAS';
  C_CODUSUMOD           CONSTANT VARCHAR2(15) := 'USRLIBERACION';
  C_TIPTRA_CAMBNUM_LTE  CONSTANT NUMBER := 809;
  C_TIPTRA_CAMBNUM_HFC  CONSTANT NUMBER := 810;
  C_TIPTRA_DESC_LTE     CONSTANT VARCHAR2(20) := 'LTE_BAJA_ANULA';
  C_ERR_ERROR           CONSTANT VARCHAR2(5) := 'ERROR'; 
  C_ERR_OK              CONSTANT VARCHAR2(5) := 'OK'; 
  C_TRAMA_NRO_TLFN      CONSTANT VARCHAR2(12) := 'NRO_TELEF:';
  C_TRAMA_TIPOTRANS     CONSTANT VARCHAR2(18) := 'TIPO_TRANSACCION:';
  C_TRAMA_TIPONUM       CONSTANT VARCHAR2(12) := 'TIPO_NUMERO:';
  C_VAR_HFC             CONSTANT VARCHAR2(3) := 'HFC';
  C_VAR_LTE             CONSTANT VARCHAR2(3) := 'LTE';
  C_HFC_CORP            CONSTANT VARCHAR2(8) := 'HFC_Corp';
  C_TPI_MAS             CONSTANT VARCHAR2(8) := 'TPI_Mas';
  C_HFC_MAS             CONSTANT VARCHAR2(8) := 'HFC_Mas';
  C_LTE_MAS             CONSTANT VARCHAR2(8) := 'LTE_Mas';
  C_VAR_CAMBIONUMERO    CONSTANT VARCHAR2(12) := 'CAMBIONUMERO';
  C_BSCS_RESERVADO      CONSTANT CHAR(1) := 'r';
  /*****************************************************************************************************
    NAME:       PKG_LLF_SGA
    PURPOSE:    Creacion y reutilizacion de objetos para realizar consulta de las lineas para
                lineas que tienen que ser evaluadas para la liberacion en SGA.
  
    REVISIONS:
    Ver        Date        Author           Solicitado por                  Description
    ---------  ----------  ---------------  --------------                  ----------------------
    1.0        01/02/2018  Jose Arriola     Carlos Lazarte                  version inicial
  /*****************************************************************************************************/

  PROCEDURE SGASS_LIBERACION_LINEAS_FIJAS(K_RESPUESTA  OUT VARCHAR2,
                                          K_MENSAJE    OUT VARCHAR2,
                                          K_CURSOR_MAS OUT SYS_REFCURSOR,
                                          K_CURSOR_LIB OUT SYS_REFCURSOR);

  PROCEDURE SGASS_LIBERAR_SGA(K_NUMERO    NUMTEL.NUMERO%TYPE,
                              K_CODNUMTEL TELEFONIA.RESERVATEL.CODNUMTEL%TYPE,
                              K_RESPUESTA OUT VARCHAR2,
                              K_MENSAJE   OUT VARCHAR2);

  PROCEDURE SGASS_LIBERAR_LINEAS_ANULASOT(K_RESPUESTA  OUT VARCHAR2,
                                          K_MENSAJE    OUT VARCHAR2,
                                          K_CURSOR_LIB OUT SYS_REFCURSOR);

  PROCEDURE SGASS_LIBERA_CAMBIONUMERO_HFC(K_RESPUESTA  OUT VARCHAR2,
                                          K_MENSAJE    OUT VARCHAR2,
                                          K_CURSOR_LIB OUT SYS_REFCURSOR);

  PROCEDURE SGASS_LIBERA_CAMBIONUMERO_LTE(K_RESPUESTA  OUT VARCHAR2,
                                          K_MENSAJE    OUT VARCHAR2,
                                          K_CURSOR_LIB OUT SYS_REFCURSOR);

  FUNCTION SGAFUN_VALIDA_LINEA(P_CODZONA TELEFONIA.SERIETEL.CODZONA%TYPE)
    RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_PARAMETER(K_CAMPO VARCHAR2, K_TRAMA VARCHAR2)
    RETURN VARCHAR2;

END PKG_LLF_SGA;
/