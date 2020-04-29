CREATE OR REPLACE PACKAGE OPERACION.PQ_VISITA_SGA_SIAC IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_VISITA_SGA_SIAC
  PROPOSITO:  PAQUETIZADO DE VISITA

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      15/05/2018  -                    -    		 PROY-
   2.0	    25/10/2018	Equipo TOA				 Juan Cuya			proy-32581_sga12
   3.0      14/11/2018  Marleny Teque        Luis FLores         PROY-32581_SGA12
   4.0      22/11/2018  Luis FLores          Luis FLores         PROY-32581_SGA14
   5.0      16/01/2019  Abel Ojeda           Luis FLores         PROY-32581_SGA20
  /************************************************************************************************/
  CN_OPCION            CONSTANT NUMBER := 14;
  CV_INTERNET          CONSTANT CHAR(4) := '0006';
  CV_TELEFONIA         CONSTANT CHAR(4) := '0004';
  CV_CABLE             CONSTANT CHAR(4) := '0062';
  CN_IDINTERFASE_CM    CONSTANT NUMBER := 620;
  CN_IDINTERFASE_MTA   CONSTANT NUMBER := 820;
  CN_IDINTERFASE_EP    CONSTANT NUMBER := 824;
  CN_IDINTERFASE_FAC   CONSTANT NUMBER := 830;
  CN_IDINTERFASE_STB   CONSTANT NUMBER := 2020;
  CN_IDINTERFASE_CANAL CONSTANT NUMBER := 2030;
  CN_IDINTERFASE_VOD   CONSTANT NUMBER := 2050;
  
  CV_ABUSCAR           CONSTANT VARCHAR2(1) := '_'; --5.0
  CV_AREEMPLAZAR       CONSTANT VARCHAR2(1) := ' '; --5.0
  
  TYPE VALORES_SRV IS RECORD(
                ln_val_ctv_old NUMBER,
                ln_val_int_old NUMBER,
                ln_val_tlf_old NUMBER,
                ln_val_ctv_new NUMBER,
                ln_val_int_new NUMBER,
                ln_val_tlf_new NUMBER
				--ini v2.0
				,ln_des_ctv_old VARCHAR2(300),
                ln_des_int_old VARCHAR2(300),
                ln_des_tlf_old VARCHAR2(300),
                ln_des_ctv_new VARCHAR2(300),
                ln_des_int_new VARCHAR2(300),
                ln_des_tlf_new VARCHAR2(300)) ;
				--fin v2.0

  --TYPE VALORES_SRV IS TABLE OF VALORES_SRV INDEX BY PLS_INTEGER;

  -- servicios_Val VALORES_SRV;
  -- Funciones de Visita Tecnica
  function SGAFUN_obt_codequcom(av_tipequ varchar2) return varchar2 ;

  FUNCTION SGAFUN_val_cfg_val(av_param varchar2) RETURN NUMBER;

  function SGAFUN_val_cfg_codequcom(av_codequcom_new varchar2,
                                    av_codequcom_old varchar2) return number;

  FUNCTION SGAFUN_val_tipsrv_old(an_codsolot operacion.solot.codsolot%TYPE,
                                 av_tipsrv   tystipsrv.tipsrv%TYPE) RETURN NUMBER;

  FUNCTION SGAFUN_val_tipsrv_new(av_cod_id operacion.sga_visita_tecnica_siac.co_id%TYPE,
                                 av_tipsrv sales.tystabsrv.tipsrv%type) RETURN NUMBER;

  FUNCTION SGAFUN_count_rows(p_string VARCHAR2) RETURN NUMBER;

  FUNCTION SGAFUN_divide_cadena(p_cadena IN OUT VARCHAR2) RETURN VARCHAR2;

  function SGAFUN_get_codmotot_visit(av_tipo varchar2, av_visita varchar2) return number;

  procedure SGASI_log_post_siac(an_cod_id      operacion.postventasiac_log.co_id%type,
                                       an_customer_id operacion.postventasiac_log.customer_id%type,
                                       av_proceso     operacion.postventasiac_log.proceso%type,
                                       av_msgerror    operacion.postventasiac_log.msgerror%type);

  FUNCTION sgafun_val_cantequ(an_codsolot operacion.solot.codsolot%TYPE,
                              av_tipsrv   tystipsrv.tipsrv%TYPE) RETURN NUMBER;

  FUNCTION sgafun_val_cantequ_new(av_cod_id operacion.sga_visita_tecnica_siac.co_id%type)
    RETURN NUMBER ;

  function sgafun_val_recuperable(an_codsolot operacion.solot.codsolot%type,
                                  av_tipsrv   tystipsrv.tipsrv%type) return number;

  FUNCTION sgafun_val_tipdeco(an_codsolot operacion.solot.codsolot%TYPE,
                              av_cod_id   operacion.sga_visita_tecnica_siac.co_id%type)
    RETURN NUMBER;

  PROCEDURE SGASS_GET_VAL_INTERNET_EQ(AN_CODSOLOT   OPERACION.SOLOT.CODSOLOT%TYPE,
                                  AV_CODSRV_PVU VARCHAR2,
                                  AV_IDEQUIPO   VARCHAR2,
                                      AN_CO_ID      NUMBER,
                                      AN_FLAG       OUT NUMBER,
                                      AN_ERROR      OUT NUMBER,
                                      AV_ERROR      OUT VARCHAR2);

  FUNCTION SGAFUN_GET_NOMBRE_EQU(AV_CODEQUCOOM VTAEQUCOM.CODEQUCOM%TYPE)
    RETURN VTAEQUCOM.DSCEQU%TYPE ;

  FUNCTION SGAFUN_FORMAT_VACIO(LV_CAD VARCHAR2) RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_CODEQU_OLD (AN_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
     RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_CODEQU_NEW (av_cod_id OPERACION.SOLOT.COD_ID%TYPE)
     RETURN VARCHAR2;

  function SGAFUN_INICIA_VALORES (AN_CODSOLOT   in OPERACION.SOLOT.CODSOLOT%TYPE,
                                  AV_COD_ID     in OPERACION.SGA_VISITA_TECNICA_SIAC.CO_ID%TYPE)
                                  RETURN  VALORES_SRV;

  FUNCTION SGAFUN_GET_INST_DESIN(AN_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                 AV_COD_ID   OPERACION.SGA_VISITA_TECNICA_SIAC.CO_ID%TYPE)
   RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_SUBTIPO(AN_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                              AV_COD_ID   OPERACION.SGA_VISITA_TECNICA_SIAC.CO_ID%TYPE,
                              LN_TIPTRA   operacion.tiptrabajo.tiptra%type)
    RETURN VARCHAR2;

  procedure SGASS_ORDEN_VISITA(an_cod_id          in number,
                               an_customer_id     in number,
                               an_tmcode          in number,
                               an_cod_plan_sisact in number,
                               av_trama           in varchar2,
                               an_flg_visita      out number,
                               an_codmotot        out number,
                               an_error           out number,
                               av_error           out varchar2,
                               av_anotacion       out varchar2,
                               av_subtipo         out varchar2
                               );
  -- PROY-32581.CAMBIO_PLAN
  FUNCTION SGAFUN_GET_TIPO_TEC (pi_cod_id operacion.solot.cod_id%type) RETURN VARCHAR2;

  PROCEDURE SGASS_PROC_SRV_COMPARA (K_IDTAREAWF IN NUMBER,
                                    K_IDWF      IN NUMBER,
                                    K_TAREA     IN NUMBER,
                                    K_TAREADEF  IN NUMBER);

--ini v2.0
  FUNCTION SGAFUN_DES_TIPSRV_NEW(AV_COD_ID OPERACION.SGA_VISITA_TECNICA_SIAC.CO_ID%TYPE,
                                 AV_TIPSRV SALES.TYSTABSRV.TIPSRV%TYPE) RETURN VARCHAR2;

  FUNCTION SGAFUN_DES_TIPSRV_OLD(AN_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                 AV_TIPSRV   TYSTIPSRV.TIPSRV%TYPE) RETURN VARCHAR2;

  PROCEDURE SGASS_EVAL_INTERNET(AN_CODSOLOT   OPERACION.SOLOT.CODSOLOT%TYPE,
								AV_CODSRV_PVU VARCHAR2,
								AN_FLAG       OUT NUMBER,
								AN_ERROR      OUT NUMBER,
								AV_ERROR      OUT VARCHAR2);
--fin v2.0
--3.0 Ini
  FUNCTION SGAFUN_CONVERT_MB_KB(PI_ABREV operacion.tipopedd.abrev%type)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_VAL_VISITA_TEC(PI_COD_ID OPERACION.SOLOT.COD_ID%TYPE,
                               PI_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_VAL_MATRIZ_CP(PI_VELOCIDAD SALES.TYSTABSRV.BANWID%TYPE,
                                PI_PORTADORA SALES.SGAT_PORTADORA.SGAN_ID_PORTADORA%TYPE)
  RETURN NUMBER;
--3.0 Fin
--5.0 Ini
  FUNCTION SGAFUN_CHANGE_CADENA(PI_CADENA VARCHAR2,
                                PI_A_BUSCAR VARCHAR2,
                                PI_A_CAMBIAR VARCHAR2) 
  RETURN VARCHAR2;
--5.0 Fin
END;
/