create or replace package OPERACION.PKG_MIGRACION_SGA_BSCS is

TYPE CUR_SEC IS REF CURSOR;

TYPE T_DATOSXCLIENTE IS RECORD (
      DATAN_ID             NUMBER,
      DATAC_TIPO_PERSONA   CHAR(1),
      DATAC_CODCLI         CHAR(8),
      DATAV_NOMABR         VARCHAR2(150),
      DATAV_NOMCLI         VARCHAR2(200),
      DATAV_APEPAT         VARCHAR2(40),
      DATAV_APEMAT         VARCHAR2(40),
      DATAC_TIPDOC         CHAR(3),
      DATAV_DESCDOC        VARCHAR2(10),
      DATAV_NUMDOC         VARCHAR2(15),
      DATAD_FECNAC         DATE,
      DATAD_FECHAINI       DATE,
      DATAD_FECHAFIN       DATE,
      DATAV_EMAILPRINC     VARCHAR2(200),
      DATAV_EMAIL1         VARCHAR2(200),
      DATAV_EMAIL2         VARCHAR2(200),
      DATAC_TIPSRV         CHAR(4),
      DATAV_DESCTIPSRV     VARCHAR2(50),
      DATAN_CODCAMP        NUMBER(6),
      DATAV_DESCAMP        VARCHAR2(200),
      DATAN_CODPLAZO       NUMBER(4),
      DATAV_DESCPLAZO      VARCHAR2(80),
      DATAN_IDSOLUCION     NUMBER(10),
      DATAV_SOLUCION       VARCHAR2(100),
      DATAN_IDPAQ          NUMBER(10),
      DATAV_PAQUETE        VARCHAR2(400),
      DATAC_TIPPROD        CHAR(4),
      DATAV_DESCTIPPROD    VARCHAR2(50),
      DATAN_IDPROD         NUMBER(10),
      DATAV_PROD           VARCHAR2(50),
      DATAV_EQ_PROD_SISACT VARCHAR2(4),
      DATAC_CODSRV         CHAR(4),
      DATAV_SERVICIO       VARCHAR2(50),
      DATAV_EQ_SERV_SISACT VARCHAR2(4),
      DATAV_DESCPLAN       VARCHAR2(200),
      DATAV_TIPOSERVICIO   VARCHAR2(50),
      DATAN_IDESTSERV      NUMBER(2),
      DATAV_DESCESTSERV    VARCHAR2(100),
      DATAN_IDTIPINSS      NUMBER(2),
      DATAV_TIPINSS        VARCHAR2(100),
      DATAN_CODINSSRV      NUMBER(10),
      DATAN_PID            NUMBER(10),
      DATAN_IDMARCAEQUIPO  NUMBER(2),
      DATAV_MARCAEQUIPO    VARCHAR2(50),
      DATAC_CODTIPEQU      CHAR(15),
      DATAN_TIPEQU         NUMBER(6),
      DATAV_TIPO_EQUIPO    VARCHAR2(100),
      DATAV_EQU_TIPO       VARCHAR2(30),
      DATAC_COD_EQUIPO     CHAR(4),
      DATAV_MODELO_EQUIPO  VARCHAR2(200),
      DATAV_TIPO           VARCHAR2(10),
      DATAV_NUMERO         VARCHAR2(20),
      DATAN_CONTROL        NUMBER(1) DEFAULT 0,
      DATAC_IDPROYECTO     CHAR(10),
      DATAV_PLAY           VARCHAR2(10),
      DATAN_CARGOFIJO      NUMBER(18,4),
      DATAN_CANTIDAD       NUMBER(10),
      DATAC_PUBLICAR       CHAR(2),
      DATAN_IDCICLO        NUMBER(5),
      DATAV_DESCICLO       VARCHAR2(100),
      DATAN_BW             NUMBER(10,2),
      DATAN_CIDVENTA       NUMBER(10),
      DATAC_CODSUCURSAL    CHAR(10),
      DATAC_CODUBIGEO      CHAR(10),
      DATAV_DIRVENTA       VARCHAR2(480),
      DATAV_CODPOSVENTA    VARCHAR2(30),
      DATAV_DESCVENTA      VARCHAR2(100),
      DATAC_COD_EV         CHAR(8),
      DATAC_IDTIPDOC_EV    CHAR(3),
      DATAV_TIPDOC_EV      VARCHAR2(10),
      DATAV_NUMDOC_EV      VARCHAR2(15),
      DATAV_NOM_EV         VARCHAR2(60),
      DATAC_IDTIPVEN       CHAR(2),
      DATAV_TIPVEN         VARCHAR2(50),
      DATAV_IDCONT         VARCHAR2(15),
      DATAN_NROCART        NUMBER(15),
      DATAC_CODOPE         CHAR(2),
      DATAV_OPERADOR       VARCHAR2(30),
      DATAN_PRESUS         NUMBER(1),
      DATAN_PUBLI          NUMBER(1),
      DATAN_IDTIPENVIO     NUMBER,
      DATAV_TIPENVIO       VARCHAR2(100),
      DATAV_CORELEC        VARCHAR2(100),
      DATAV_IDDEP_DIRCLI   VARCHAR2(3),
      DATAC_IDPROV_DIRCLI  CHAR(3),
      DATAC_IDDIST_DIRCLI  CHAR(3),
      DATAV_DEPA_DIRCLI    VARCHAR2(40),
      DATAV_PROV_DIRCLI    VARCHAR2(40),
      DATAV_DIST_DIRCLI    VARCHAR2(40),
      DATAV_DIRCLI         VARCHAR2(480),
      DATAC_CODUBIDIR      CHAR(10),
      DATAC_UBIGEODIR      CHAR(6),
      DATAC_IDTIPOVIADIR   CHAR(2),
      DATAV_TIPOVIADIR     VARCHAR2(30),
      DATAV_NOMVIADIR      VARCHAR2(60),
      DATAV_NUMVIADIR      VARCHAR2(50),
      DATAN_IDTIPODOMIDIR  NUMBER(2),
      DATAV_TIPODOMIDIR    VARCHAR2(50),
      DATAV_NOMURBDIR      VARCHAR2(50),
      DATAN_IDZONADIR      NUMBER(3),
      DATAV_ZONADIR        VARCHAR2(50),
      DATAV_REFERENCIADIR  VARCHAR2(340),
      DATAV_TELF1DIR       VARCHAR2(50),
      DATAV_TELF2DIR       VARCHAR2(50),
      DATAV_CODPOSDIR      VARCHAR2(20),
      DATAV_MANZANADIR     VARCHAR2(5),
      DATAV_LOTEDIR        VARCHAR2(5),
      DATAV_SECTORDIR      VARCHAR2(5),
      DATAN_CODEDIFDIR     NUMBER(8),
      DATAV_EDIFICDIR      VARCHAR2(50),
      DATAN_PISODIR        NUMBER,
      DATAV_INTERIORDIR    VARCHAR2(60),
      DATAV_NUM_INTERIORDIR VARCHAR2(15),
      DATAV_IDPLANODIR     VARCHAR2(10),
      DATAV_PLANODIR       VARCHAR2(100),
      DATAV_IDDEPI         VARCHAR2(3),
      DATAC_IDPROVI        CHAR(3),
      DATAC_IDDISTI        CHAR(3),
      DATAV_DEPARTAMENTOI  VARCHAR2(40),
      DATAV_PROVINCIAI     VARCHAR2(40),
      DATAV_DISTRITOI      VARCHAR2(40),
      DATAV_DIRSUCI        VARCHAR2(1000),
      DATAV_NOMSUCI        VARCHAR2(100),
      DATAC_UBISUCI        CHAR(10),
      DATAC_UBIGEOI        CHAR(6),
      DATAC_IDTIPOVIAI     CHAR(2),
      DATAV_TIPOVIAI       VARCHAR2(30),
      DATAV_NOMVIAI        VARCHAR2(60),
      DATAV_NUMVIAI        VARCHAR2(50),
      DATAN_IDTIPODOMII    NUMBER(2),
      DATAV_TIPODOMII      VARCHAR2(50),
      DATAN_IDTIPURBI      NUMBER(4),
      DATAV_NOMURBI        VARCHAR2(50),
      DATAN_IDZONAI        NUMBER(3),
      DATAV_ZONAI          VARCHAR2(50),
      DATAV_REFERENCIAI    VARCHAR2(340),
      DATAV_TELF1I         VARCHAR2(50),
      DATAV_TELF2I         VARCHAR2(50),
      DATAV_CODPOSI        VARCHAR2(20),
      DATAV_MANZANAI       VARCHAR2(5),
      DATAV_LOTEI          VARCHAR2(5),
      DATAV_SECTORI        VARCHAR2(5),
      DATAN_CODEDIFI       NUMBER(8),
      DATAV_EDIFICIOI      VARCHAR2(50),
      DATAN_PISOI          NUMBER(3),
      DATAV_INTERIORI      VARCHAR2(60),
      DATAV_NUM_INTERIORI  VARCHAR2(15),
      DATAV_IDPLANOI       VARCHAR2(10),
      DATAV_PLANOI         VARCHAR2(100),
      DATAV_IDDEPF         VARCHAR2(3),
      DATAC_IDPROVF        CHAR(3),
      DATAC_IDDISTF        CHAR(3),
      DATAV_DEPARTAMENTOF  VARCHAR2(40),
      DATAV_PROVINCIAF     VARCHAR2(40),
      DATAV_DISTRITOF      VARCHAR2(40),
      DATAV_DIRSUCF        VARCHAR2(1000),
      DATAV_NOMSUCF        VARCHAR2(100),
      DATAC_UBISUCF        CHAR(10),
      DATAC_UBIGEOF        CHAR(6),
      DATAC_IDTIPOVIAF     CHAR(2),
      DATAV_TIPOVIAF       VARCHAR2(30),
      DATAV_NOMVIAF        VARCHAR2(60),
      DATAV_NUMVIAF        VARCHAR2(50),
      DATAN_IDTIPODOMIF    NUMBER(2),
      DATAV_TIPODOMIF      VARCHAR2(50),
      DATAN_IDTIPURBF      NUMBER(4),
      DATAV_NOMURBF        VARCHAR2(50),
      DATAN_IDZONAF        NUMBER(3),
      DATAV_ZONAF          VARCHAR2(50),
      DATAV_REFERENCIAF    VARCHAR2(340),
      DATAV_TELF1F         VARCHAR2(50),
      DATAV_TELF2F         VARCHAR2(50),
      DATAV_CODPOSF        VARCHAR2(20),
      DATAV_MANZANAF       VARCHAR2(5),
      DATAV_LOTEF          VARCHAR2(5),
      DATAV_SECTORF        VARCHAR2(5),
      DATAN_CODEDIFF       NUMBER(8),
      DATAV_EDIFICIOF      VARCHAR2(50),
      DATAN_PISOF          NUMBER(3),
      DATAV_INTERIORF      VARCHAR2(60),
      DATAV_NUM_INTERIORF  VARCHAR2(15),
      DATAV_IDPLANOF       VARCHAR2(10),
      DATAV_PLANOF         VARCHAR2(100),
      DATAN_SOLOTACTV      NUMBER(8),
      DATAI_TIPOAGENDA     INTEGER,
      DATAN_MONTO_SGA       NUMBER(18,4),
      DATAV_EQ_IDSRV_SISACT VARCHAR2(5),
      DATAN_MONTO_SISACT    NUMBER(18,4),
      DATAN_EQ_PLAN_SISACT  NUMBER,
      DATAV_EQ_IDEQU_SISACT VARCHAR2(10)
      );

TYPE T_DATOSXSOT IS RECORD (
     DATAN_TIPTRA    NUMBER(4),
     DATAV_TIPOSOT   VARCHAR2(200),
     DATAN_SOT       NUMBER(8),
     DATAN_ESTSOL    NUMBER(2)
      );

TYPE T_CLIENTE IS RECORD (
     DATAC_CODCLI    CHAR(8),
     DATAV_NUMDOC    VARCHAR2(15),
     DATAV_NOMABR    VARCHAR2(150)
      );

TYPE T_EQUIV_SISACT IS RECORD (
      DATAN_MONTO_SGA       NUMBER(18,4),
      DATAV_EQ_IDSRV_SISACT VARCHAR2(5),
      DATAN_MONTO_SISACT    NUMBER(18,4),
      DATAN_EQ_PLAN_SISACT  NUMBER,
      DATAV_EQ_IDEQU_SISACT VARCHAR2(10),
      DATAN_TIPEQU          NUMBER(6)
     );

procedure MIGRSS_LISTA_MIGRACION(K_FECHA  DATE,
                                 K_NERROR OUT INTEGER,
                                 K_VERROR OUT VARCHAR2);

procedure MIGRSI_REGISTRA_ERROR(K_ID_CAB      NUMBER,
                                K_DOC_CLIENTE VARCHAR2,
                                K_SOLOT       NUMBER,
                                K_PROCESO     VARCHAR2,
                                K_MENSAJE     VARCHAR2 );

function MIGRFUN_ERRONEO(K_DATOS_CLIENTE  T_DATOSXCLIENTE)
  return BOOLEAN;

procedure MIGRSU_ACT_PREREQ (K_DATOS_CLIENTE  T_DATOSXCLIENTE,
                             K_IDRESULTADO    PLS_INTEGER,
                             K_TIPO           PLS_INTEGER);

procedure MIGRSS_ACT_BLACKLIST (K_DATOS_CLIENTE T_DATOSXCLIENTE,
                                K_TIPO          PLS_INTEGER);

procedure MIGRSU_ACT_BLACKCLI (K_DATOS_CLIENTE  T_DATOSXCLIENTE);

procedure MIGRSU_ACT_BLACKPLAN (K_DATOS_CLIENTE  T_DATOSXCLIENTE);

procedure MIGRSU_ACT_SOT(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                         K_CODSOLOTBAJA  NUMBER,
                         K_FECHA         DATE,
                         K_PROCESO       PLS_INTEGER);

procedure MIGRSS_PRE_REQUISTOS(K_DATOS_CLIENTE  T_DATOSXCLIENTE,
                               K_IDRESULTADO    out PLS_INTEGER,
                               K_RESULTADO      out VARCHAR2 );

procedure MIGRSS_VALIDA_SOT(K_CODCLI    CHAR,
                            K_TIPSRV    CHAR,
                            K_EVAL      out pls_integer,
                            K_DATOS_SOT out T_DATOSXSOT);

function MIGRFUN_VARIAS_SUC(K_DATOS_CLIENTE T_DATOSXCLIENTE)
  return BOOLEAN;

function MIGRFUN_VERIF_PROC(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                            K_PROCESO       PLS_INTEGER)
  return BOOLEAN;

function MIGRFUN_VERIF_MENSAJE(K_MENSAJE VARCHAR2)
  return BOOLEAN;

function MIGRFUN_CLIENTES_MIGRA(K_FECHA DATE )
  return PLS_INTEGER;

function MIGRFUN_CLIENTES_PROC(K_FECHA DATE )
  return PLS_INTEGER;

function MIGRFUN_CANT_PROC(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                           K_PROCESO       PLS_INTEGER)
  return PLS_INTEGER;

function MIGRFUN_CANT_REG(K_DATOS_CLIENTE T_DATOSXCLIENTE)
  return PLS_INTEGER;

function MIGRFUN_CLIENTE(K_CODCLI CHAR )
  return T_CLIENTE;

function MIGRFUN_EVAL_REC(K_TIPTRA NUMBER)
  return PLS_INTEGER;

function MIGRFUN_EST_EVAL
  return NUMBER;

function MIGRFUN_VERIF_SOT(K_TIPTRA NUMBER)
  return PLS_INTEGER;

function MIGRFUN_ULT_SOT(K_CODCLI CHAR,
                         K_TIPSRV CHAR)
  return T_DATOSXSOT;

function MIGRFUN_TIENE_PLAY(K_IDPROYECTO  CHAR,
                            K_CODSUCURSAL CHAR,
                            K_CODCLI      CHAR)
    return NUMBER;

function MIGRFUN_ULTIMA_SOT_ACTV(K_SERVICIO NUMBER)
  return NUMBER;

function MIGRFUN_EXISTE_EN_LISTA(K_CODCLI CHAR)
  return BOOLEAN;

function MIGRFUN_PROCESADO(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                           K_PROCESO       PLS_INTEGER)
  return BOOLEAN;

procedure MIGRSS_BLACKLIST (K_DATOS_CLIENTE T_DATOSXCLIENTE,
                            K_RETORNO       out BOOLEAN,
                            K_TIPO          out PLS_INTEGER);

procedure MIGRSS_BLACKLIST_CLIENTE (K_DATOS_CLIENTE T_DATOSXCLIENTE,
                                    K_RETORNO       out BOOLEAN,
                                    K_TIPO          out PLS_INTEGER);

procedure MIGRSS_BLACKLIST_PLAN (K_DATOS_CLIENTE T_DATOSXCLIENTE,
                                 K_RETORNO       out BOOLEAN,
                                 K_TIPO          out PLS_INTEGER);

function MIGRFUN_BLACKLIST_CLI(K_CODCLI CHAR)
  return BOOLEAN;

function MIGRFUN_BLACKLIST_PLAN(K_CODSRV CHAR)
  return BOOLEAN;

function MIGRFUN_ES_CLIENTE_SGA(K_CODSOLOT NUMBER)
  return BOOLEAN;

function MIGRFUN_EST_APROB
  return NUMBER;

function MIGRFUN_TIPTRA_BAJA
  return NUMBER;

function MIGRFUN_MOTIVO_BAJA
  return NUMBER;

function MIGRFUN_EST_GEN
   return NUMBER;

function MIGRFUN_CODCLIENTE(K_SOT NUMBER)
   return CHAR;

function MIGRFUN_PTO_SOT(K_SOT NUMBER)
   return NUMBER;

function MIGRFUN_VERIF_MIGRAR(K_DATOS_CLIENTE T_DATOSXCLIENTE)
   return BOOLEAN;

function MIGRFUN_VERIF_TOPE(K_DATOS_CLIENTE T_DATOSXCLIENTE)
   return BOOLEAN;

function MIGRFUN_SOTBAJAADM(K_DATOS_CLIENTE T_DATOSXCLIENTE)
   return NUMBER;

function MIGRFUN_MONTO_CIGV(K_MONTO NUMBER)
   return NUMBER;

procedure MIGRSS_PROCESA_SOTBAJA(K_FECHA DATE);

procedure MIGRSU_ACT_AREA_SOT (K_CODSOLOTBAJA  NUMBER );

procedure MIGRSI_REGISTRA_SOTCAB(K_DATOS_CLIENTE OPERACION.MIGRT_CAB_TEMP_SOT%rowtype,
                                 K_CODSOLOTBAJA  out NUMBER );

procedure MIGRSI_REGISTRA_SOTDET(K_CODSOLOTBAJA  NUMBER,
                                 K_DATOS_CLIENTE OPERACION.MIGRT_DET_TEMP_SOT%rowtype);

procedure MIGRSI_REG_SOTEMPCAB(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                               K_FECHA         DATE,
                               K_IDTEMPSOTBAJA OUT NUMBER,
                               K_NERROR        OUT INTEGER,
                               K_VERROR        OUT VARCHAR2  );

procedure MIGRSI_REG_SOTEMPDET(K_IDTEMPSOTBAJA  NUMBER,
                               K_DATOS_CLIENTE  T_DATOSXCLIENTE,
                               K_NERROR         OUT INTEGER,
                               K_VERROR         OUT VARCHAR2);

procedure MIGRSD_DEPURA_BAJA(K_SOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                             K_NERROR OUT INTEGER,
                             K_VERROR OUT VARCHAR2);

procedure MIGRSI_REGULA_BAJA(K_SOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                             K_NERROR OUT INTEGER,
                             K_VERROR OUT VARCHAR2);

procedure MIGRSU_CIERRE_BAJADM(K_SOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                               K_NERROR OUT INTEGER,
                               K_VERROR OUT VARCHAR2);

procedure MIGRSU_ACT_EQUISERV_SOT (K_DATOS_CLIENTE T_DATOSXCLIENTE);

procedure MIGRSU_ACT_EQU_SISACT(K_FECHA  DATE,
                                K_NERROR OUT INTEGER,
                                K_VERROR OUT VARCHAR2);

procedure MIGRSS_EQUIVALENCIAS (K_DATOS_CLIENTE T_DATOSXCLIENTE,
                                K_EQUIV_SISACT  OUT T_EQUIV_SISACT,
                                K_NERROR        OUT INTEGER,
                                K_VERROR        OUT VARCHAR2);

 procedure MIGRSS_PROCESO_SOT_SISACT;

  function MIGRFUN_GET_DATOS_CLIENTE(K_CODSOLOT SOLOT.CODSOLOT%type)
    return OPERACION.MIGRT_CAB_TEMP_SOT%rowtype;

  procedure MIGRSS_GEN_RESERVA_IWAY(K_IDTAREAWF in number,
                                    K_IDWF      in number,
                                    K_TAREA     in number,
                                    K_TAREADEF  in number);

  procedure MIGRSS_EJECUTA_TAREAS_SOT(K_CODSOLOT SOLOT.CODSOLOT%type,
                                      K_ERROR    out number,
                                      K_MENSAJE  out varchar2);

  procedure MIGRSS_VALIDA_SOT_ALTA(K_CODSOLOT     SOLOT.CODSOLOT%type,
                                   K_TIPTRA_MIGRA SOLOT.TIPTRA%type,
                                   K_WF_MIGRA     WF.WFDEF%type,
                                   K_ERROR        out number,
                                   K_MENSAJE      out varchar2);

  function MIGRFUN_GET_IDWF_SOT(K_CODSOLOT SOLOT.CODSOLOT%type)
    return WF.IDWF%type;

  function MIGRFUN_GET_TIPTRA_MIGRA(K_TIPOAGENDA OPERACION.MIGRT_CAB_TEMP_SOT.DATAI_TIPOAGENDA%type)
  return TIPTRABAJO.TIPTRA%type;

  function MIGRFUN_GET_WF_MIGRA(K_TIPOAGENDA OPERACION.MIGRT_CAB_TEMP_SOT.DATAI_TIPOAGENDA%type)
  return WF.WFDEF%type;

  function MIGRFUN_GET_ESTTAREA_CERRADA return OPEDD.CODIGON%type;

  function MIGRFUN_VALIDA_TAREAS_ANT(K_IDWF      WF.IDWF%type,
                                     K_IDTAREAWF TAREAWF.IDTAREAWF%type)
    return boolean;

  function MIGRFUN_GET_TAREA_TAREAWFCPY(K_IDWF      TAREAWFCPY.IDWF%type,
                                        K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type)
    return TAREAWFCPY%rowtype;

  function MIGRFUN_GET_DESC_TAREA(K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type)
    return TAREAWFCPY.DESCRIPCION%type;

  function MIGRFUN_GET_TIPESTTAR_TAREAWF(K_IDWF  TAREAWF.IDWF%type,
                                         K_TAREA varchar2)
    return TAREAWF.ESTTAREA%type;

  function MIGRFUN_VALIDA_TAREA_ACT(K_IDWF      WF.IDWF%type,
                                    K_IDTAREAWF TAREAWF.IDTAREAWF%type)
    return boolean;

  procedure MIGRSS_GENERA_TAREA_WF(K_IDWF      WF.IDWF%type,
                                   K_TAREA     TAREAWF.TAREA%type,
                                   K_IDTAREAWF TAREAWF.IDTAREAWF%type,
                                   K_ERROR     out number,
                                   K_MENSAJE   out varchar2);

  procedure MIGRSS_CERRAR_TAREA_WF(K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type,
                                   K_ERROR     out number,
                                   K_MENSAJE   out varchar2);

  procedure MIGRSS_EVALUA_TAREA_WF(K_IDWF      TAREAWF.IDWF%type,
                                   K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type,
                                   K_ERROR     out number,
                                   K_MENSAJE   out varchar2);

  procedure MIGRSS_EJECUTA_PROC_TAREA(K_NOMPROC   varchar2,
                                      K_IDTAREAWF TAREAWF.IDTAREAWF%type,
                                      K_IDWF      TAREAWF.IDWF%type,
                                      K_TAREA     TAREAWF.TAREA%type,
                                      K_TAREADEF  TAREAWF.TAREADEF%type,
                                      K_ERROR     out number,
                                      K_MENSAJE   out varchar2);

 procedure MIGRSS_ASIGNAR_NUMERO(K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type,
                                   K_IDWF      TAREAWFCPY.IDWF%type,
                                   K_TAREA     TAREAWFCPY.TAREA%type,
                                   K_TAREADEF  TAREAWFCPY.TAREADEF%type);

 procedure MIGRSS_VALIDAR_INSSRV(K_CODSOLOT number default null,
                                 K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type,
                                 K_IDWF      TAREAWFCPY.IDWF%type,
                                 K_TAREA     TAREAWFCPY.TAREA%type,
                                 K_TAREADEF  TAREAWFCPY.TAREADEF%type);

 procedure MIGRSS_ACTUALIZA_NUMERO(K_CODSOLOT_ALTA SOLOT.CODSOLOT%type,
                                   K_IDTAREAWF     TAREAWF.IDTAREAWF%type,
                                   K_IDWF          TAREAWF.IDWF%type,
                                   K_TAREA         TAREAWF.TAREA%type,
                                   K_TAREADEF      TAREAWF.TAREADEF%type);

 procedure MIGRSS_CERRAR_SOT_BAJA(K_CODSOLOT_ALTA SOLOT.CODSOLOT%type);


 procedure MIGRSS_ACTUALIZA_TEMP_SOT(K_CODSOLOT_ALTA SOLOT.CODSOLOT%type,
                                      K_ERROR         out number,
                                      K_MENSAJE       out varchar2);

 procedure MIGRSS_VALIDAR_COD_ID(K_COD_ID  SOLOT.COD_ID%type,
                                K_ERROR   out number,
                                K_MENSAJE out varchar2);

  PROCEDURE SISACTSS_MIG_SISACT_CAB(P_DATAI_PROCIW IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAI_PROCIW%TYPE,--2.0
                                    P_OUT_MIGSISACT OUT SYS_REFCURSOR,
                                    P_OUT_MSG       OUT VARCHAR2,
                                    P_OUT_NRO       OUT VARCHAR2);

  PROCEDURE SISACTSS_MIG_SISACT_DET(P_IN_IDMIGRA    IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ID%TYPE,
                                    P_OUT_MIGSISACT OUT SYS_REFCURSOR,
                                    P_OUT_MSG       OUT VARCHAR2,
                                    P_OUT_NRO       OUT VARCHAR2);

  PROCEDURE SISACTSI_MIG_ERROR(P_IN_IDCAB   IN OPERACION.MIGRT_ERROR_MIGRACION.DATAN_IDCAB%TYPE,
                               P_IN_NUMDOC  IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_NUMDOC%TYPE,
                               P_IN_SOLOT   IN OPERACION.MIGRT_ERROR_MIGRACION.DATAN_SOLOT%TYPE,
                               P_IN_PROCE   IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_PROCESO%TYPE,
                               P_IN_DESTI   IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_DESTINO%TYPE,
                               P_IN_ASUNTO  IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_ASUNTO%TYPE,
                               P_IN_MENSAJE IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_MENSAJE%TYPE,
                               P_IN_USUREG  IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_USUREG%TYPE,
                               P_OUT_MSG    OUT VARCHAR2,
                               P_OUT_NRO    OUT VARCHAR2);

  PROCEDURE SISACTSU_MIG_SEC(P_IN_IDCAB  IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ID%TYPE,
                             P_IN_NROSEC IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_CODSOTBAJAADM%TYPE,
                             P_IN_ESTSEC IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAC_ESTSEC%TYPE,
                             P_OUT_MSG   OUT VARCHAR2,
                             P_OUT_NRO   OUT VARCHAR2);

  PROCEDURE SISACTSS_MIG_SEC(P_IN_IDCAB   IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ID%TYPE,
                             P_OUT_MIGSEC OUT SYS_REFCURSOR,
                             P_OUT_MSG    OUT VARCHAR2,
                             P_OUT_NRO    OUT VARCHAR2);

  PROCEDURE SISACTSU_MIG_SOTALTA(P_IN_IDCAB   IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ID%TYPE,
                                 P_IN_SOTALTA IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_CODSOLOT%TYPE,
                                 P_IN_ESTSOT  IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ESTSOTALTA%TYPE,
                                 P_OUT_MSG    OUT VARCHAR2,
                                 P_OUT_NRO    OUT VARCHAR2);

  PROCEDURE SISACTSU_MIG_EXITO(P_IN_IDCAB   IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ID%TYPE,
                               P_IN_CO_ID   IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_COD_ID%TYPE,
                               P_IN_CUST_ID IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_CUSTOMER_ID%TYPE,
                               P_OUT_MSG    OUT VARCHAR2,
                               P_OUT_NRO    OUT VARCHAR2);




procedure MIGRSS_VALIDA_CLIENTES(K_DATOS_CLIENTE  T_DATOSXCLIENTE,
                               K_IDRESULTADO    out PLS_INTEGER,
                               K_RESULTADO      out VARCHAR2 );


procedure MIGRSS_VALIDA_SERVICIOS(K_DATOS_CLIENTE  T_DATOSXCLIENTE,
                               K_IDRESULTADO    out PLS_INTEGER,
                               K_RESULTADO      out VARCHAR2 );

procedure MIGRSS_CERRAR_BAJAADM(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number,
                               a_tipesttar in number,
                               a_esttarea  in number,
                               a_mottarchg in number,
                               a_fecini    in date,
                               a_fecfin    in date);
end;
/