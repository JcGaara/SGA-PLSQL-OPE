CREATE OR REPLACE PACKAGE OPERACION.PKG_CONSULTA_UNIFICADA_SGA IS

  TYPE TCUR_SER_EQU_PRI IS REF CURSOR;
  TYPE TCUR_SER_EQU_ADI IS REF CURSOR;
  TYPE TCUR_EQU_CABLE IS REF CURSOR;
  -- INI 1.0
  CV_INTERNET  CONSTANT CHAR(4) := '0006';
  CV_TELEFONIA CONSTANT CHAR(4) := '0004';
  CV_CABLE     CONSTANT CHAR(4) := '0062';

  CV_INT CONSTANT CHAR(3) := 'INT';
  CV_TEL CONSTANT CHAR(3) := 'TLF';
  CV_CTV CONSTANT CHAR(3) := 'CTV';

  TEC_HFC CONSTANT VARCHAR2(5) := 'HFC';

  TYPE VALORES_SRV IS RECORD(
    LN_VAL_CTV_OLD NUMBER,
    LN_VAL_INT_OLD NUMBER,
    LN_VAL_TLF_OLD NUMBER,
    LN_CNT_CTV_OLD NUMBER,
    LN_VAL_CTV_NEW NUMBER,
    LN_VAL_INT_NEW NUMBER,
    LN_VAL_TLF_NEW NUMBER,
    LN_CNT_CTV_NEW NUMBER,
    LN_TEC_CTV_NEW VARCHAR2(20),
    LN_TEC_INT_NEW VARCHAR2(20),
    LN_TEC_TLF_NEW VARCHAR2(20),
    LN_DES_CTV_OLD VARCHAR2(300),
    LN_DES_INT_OLD VARCHAR2(300),
    LN_DES_TLF_OLD VARCHAR2(300),
    LN_DES_CTV_NEW VARCHAR2(300),
    LN_DES_INT_NEW VARCHAR2(300),
    LN_DES_TLF_NEW VARCHAR2(300));

  CV_ABUSCAR     CONSTANT VARCHAR2(1) := '_';
  CV_AREEMPLAZAR CONSTANT VARCHAR2(1) := ' ';
  -- FIN 1.0

  PROCEDURE SGASS_CONS_SERV_EQU_PRI(P_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                                    P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                                    P_COD_RESP    OUT NUMBER,
                                    P_MSJ_RESP    OUT VARCHAR2,
                                    P_TECNOLOGIA  OUT NUMBER, -- 3.0
                                    P_CODPLAN     OUT NUMBER, -- 3.0
                                    P_DAT_SERV    OUT TCUR_SER_EQU_PRI);

  PROCEDURE SGASS_CONS_SERV_EQU_ADI(P_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                                    P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                                    P_COD_RESP    OUT NUMBER,
                                    P_MSJ_RESP    OUT VARCHAR2,
                                    P_DAT_SERV    OUT TCUR_SER_EQU_ADI);

  PROCEDURE SGASS_CONS_EQU_CABLE(P_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                                 P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                                 P_COD_RESP    OUT NUMBER,
                                 P_MSJ_RESP    OUT VARCHAR2,
                                 P_DAT_EQUI    OUT TCUR_EQU_CABLE);
  -- INI 1.0
  PROCEDURE SGASS_CONS_VIS_TEC(P_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                               P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                               P_TRAMA       IN VARCHAR2,
                               P_TIPTRA      OUT OPERACION.SOLOT.TIPTRA%TYPE,
                               P_SUBTIPO     OUT VARCHAR2,
                               P_MOTOT       OUT OPERACION.MOTOT.CODMOTOT%TYPE,
                               P_ANOTAC      OUT VARCHAR2,
                               P_FLG_VT      OUT NUMBER,
                               P_COD_RESP    OUT NUMBER,
                               P_MSJ_RESP    OUT VARCHAR2);

  PROCEDURE SGASS_CONS_SOT_MAX(P_COD_ID   IN OPERACION.SOLOT.COD_ID%TYPE,
                               P_CODSOLOT OUT OPERACION.SOLOT.CODSOLOT%TYPE,
                               P_COD_RESP OUT NUMBER,
                               P_MSJ_RESP OUT VARCHAR2);

  PROCEDURE SGASS_CONS_SUBTIPO(P_TIPTRABAJO IN NUMBER,
                               P_FLAG_CE    IN NUMBER,
                               P_CUR_SUBTIP OUT SYS_REFCURSOR,
                               P_COD_RESP   OUT NUMBER,
                               P_MSJ_RESP   OUT VARCHAR2);

  PROCEDURE SGASS_VELOCIDAD_HFC(P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE,
                                P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                P_VEL_INT  OUT NUMBER,
                                P_COD_RESP OUT NUMBER,
                                P_MSJ_RESP OUT VARCHAR2);

  PROCEDURE SGASS_VELOCIDAD_LTE(P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE,
                                P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                P_VEL_INT  OUT NUMBER,
                                P_COD_RESP OUT NUMBER,
                                P_MSJ_RESP OUT VARCHAR2);

  PROCEDURE SGASS_DESC_INTERNET(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                P_CODSRV   SALES.TYSTABSRV.CODSRV%TYPE,
                                P_FLAG     OUT NUMBER,
                                P_COD_RESP OUT NUMBER,
                                P_MSJ_RESP OUT VARCHAR2);

  PROCEDURE SGASI_TRS_VIS_TEC(P_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                              P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                              P_TRAMA       IN VARCHAR2,
                              P_COD_RESP    OUT NUMBER,
                              P_MSJ_RESP    OUT VARCHAR2);

  FUNCTION SGAFUN_INICIA_VALORES(P_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                 P_COD_ID   IN OPERACION.SGAT_TRS_VISITA_TECNICA.TRSN_COD_ID%TYPE)
    RETURN VALORES_SRV;

  FUNCTION SGAFUN_CANTEQU_OLD(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                              P_TIPSRV   TYSTIPSRV.TIPSRV%TYPE) RETURN NUMBER;

  FUNCTION SGAFUN_TIPSRV_OLD(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                             P_TIPSRV   TYSTIPSRV.TIPSRV%TYPE) RETURN NUMBER;

  FUNCTION SGAFUN_DES_TIPSRV_OLD(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                 P_TIPSRV   TYSTIPSRV.TIPSRV%TYPE)
    RETURN VARCHAR2;

  FUNCTION SGAFUN_CANTEQU_NEW(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE,
                              P_SRV    VARCHAR2) RETURN NUMBER;

  FUNCTION SGAFUN_TIPSRV_NEW(P_COD_ID   OPERACION.SGAT_TRS_VISITA_TECNICA.TRSN_COD_ID%TYPE,
                             P_TIPO_SRV OPERACION.SGAT_TRS_VISITA_TECNICA.TRSV_TIPO_SRV%TYPE)
    RETURN NUMBER;

  FUNCTION SGAFUN_DES_TIPSRV_NEW(P_COD_ID   OPERACION.SGAT_TRS_VISITA_TECNICA.TRSN_COD_ID%TYPE,
                                 P_TIPO_SRV OPERACION.SGAT_TRS_VISITA_TECNICA.TRSV_TIPO_SRV%TYPE)
    RETURN VARCHAR2;

  FUNCTION SGAFUN_COUNT_ROWS(P_STRING VARCHAR2) RETURN NUMBER;

  FUNCTION SGAFUN_DIVIDE_CADENA(P_CADENA IN OUT VARCHAR2) RETURN VARCHAR2;

  FUNCTION SGAFUN_VAL_RECUPERABLE(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                  P_TIPSRV   SALES.TYSTIPSRV.TIPSRV%TYPE)
    RETURN NUMBER;

  FUNCTION SGAFUN_CONVERT_MB_KB(P_ABREV OPERACION.TIPOPEDD.ABREV%TYPE)
    RETURN NUMBER;

  FUNCTION SGAFUN_VAL_MATRIZ_CP(P_VELOCIDAD SALES.TYSTABSRV.BANWID%TYPE,
                                P_PORTADORA SALES.SGAT_PORTADORA.SGAN_ID_PORTADORA%TYPE)
    RETURN NUMBER;

  FUNCTION SGAFUN_VAL_TIPDECO(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                              P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE)
    RETURN NUMBER;

  FUNCTION SGAFUN_VAL_CFG_CODEQUCOM(P_CODEQUCOM_NEW VARCHAR2,
                                    P_CODEQUCOM_OLD VARCHAR2) RETURN NUMBER;

  FUNCTION SGAFUN_VAL_CFG_VAL(P_PARAM VARCHAR2) RETURN NUMBER;

  FUNCTION SGAFUN_GET_TECNOLOGIA(P_COD_ID IN OPERACION.SOLOT.COD_ID%TYPE,
                                 P_SERV   IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_TIPO(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_TIPTRA(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE) RETURN NUMBER;

  FUNCTION SGAFUN_GET_CODMOTOT(P_TIPO VARCHAR2, P_OPCION NUMBER)
    RETURN NUMBER;

  FUNCTION SGAFUN_GET_SUBTIPO(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                              P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE,
                              P_TIPTRA   OPERACION.TIPTRABAJO.TIPTRA%TYPE)
    RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_ANOTACION(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE)
    RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_CODEQU_OLD(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_NOMBRE_EQU(P_CODEQUCOM SALES.VTAEQUCOM.CODEQUCOM%TYPE)
    RETURN SALES.VTAEQUCOM.DSCEQU%TYPE;

  FUNCTION SGAFUN_GET_CODEQU_NEW(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_SRVSNCODE(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE,
                                P_CODSRV SALES.TYSTABSRV.CODSRV%TYPE)
    RETURN FLOAT;

  FUNCTION SGAFUN_FORMAT_VACIO(LV_CAD VARCHAR2) RETURN VARCHAR2;

  FUNCTION SGAFUN_CHANGE_CADENA(PI_CADENA    VARCHAR2,
                                PI_A_BUSCAR  VARCHAR2,
                                PI_A_CAMBIAR VARCHAR2) RETURN VARCHAR2;
  -- INI 1.0
  
   procedure sgass_cons_centro_poblado(iv_ubigeo          in  varchar2,--ubigeo
                                      iv_idpoblado       in  varchar2,--poblado
                                      oc_cen_poblados    out sys_refcursor,
                                      on_codResp         out number,
                                      ov_msjResp         out varchar2);
                                      
  procedure sgass_cons_ubicacion(iv_codpai          in  varchar2,--pais
                                 oc_ubicaciones     out sys_refcursor,
                                 on_codResp         out number,
                                 ov_msjResp         out varchar2);
                                 
  procedure sgass_cons_tip_urb(iv_idtipurb        in  number,
                               oc_tip_urbs        out sys_refcursor,
                               on_codResp         out number,
                               ov_msjResp         out varchar2);
                               
  procedure sgass_cons_tip_via(iv_codvia          in  number,
                               oc_tip_vias        out sys_refcursor,
                               on_codResp         out number,
                               ov_msjResp         out varchar2);
                               
  procedure sgass_cons_plano(iv_codubi          in  varchar2,
                             oc_planos          out sys_refcursor,
                             on_codResp         out number,
                             ov_msjResp         out varchar2);
                             
  procedure sgass_cons_edificio(iv_codubi          in  varchar2,
                                iv_idplano         in  varchar2,
                                oc_edificios       out sys_refcursor,
                                on_codResp         out number,
                                ov_msjResp         out varchar2);
                                
  procedure sgass_cons_tipo(iv_tipo            in  varchar2,
                            oc_lista_tipo      out sys_refcursor,
                            on_codResp         out number,
                            ov_msjResp         out varchar2);
  
  
END;
/