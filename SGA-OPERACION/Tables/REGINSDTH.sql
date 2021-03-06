CREATE TABLE OPERACION.REGINSDTH
(
  NUMREGISTRO      CHAR(10 BYTE)                NOT NULL,
  NOMCLI           VARCHAR2(200 BYTE),
  TIPDOC           CHAR(3 BYTE),
  NUMDOC           VARCHAR2(15 BYTE),
  NOMCONTACTO      VARCHAR2(200 BYTE),
  TELEFONO1        VARCHAR2(20 BYTE),
  TELEFONO2        VARCHAR2(20 BYTE),
  IDPAQ            NUMBER(10),
  IDEQUIPO         VARCHAR2(32 BYTE),
  IDTARJETA        VARCHAR2(32 BYTE),
  OBSERVACION      VARCHAR2(4000 BYTE),
  CODINSTALADOR    VARCHAR2(200 BYTE),
  CODUSU           VARCHAR2(30 BYTE)            DEFAULT user,
  FECREG           DATE                         DEFAULT sysdate,
  FECACTCONAX      DATE,
  ESTADO           CHAR(2 BYTE),
  CODSOLOT         NUMBER(8),
  NUMSLC           CHAR(10 BYTE),
  CODCLI           CHAR(8 BYTE),
  FECBAJACONAX     DATE,
  FECANULACONAX    DATE,
  UNITADDRESS      VARCHAR2(32 BYTE),
  CODCON           NUMBER(6),
  TIPOPAGODTH      NUMBER(1),
  PAGOINSTAL       NUMBER(1)                    DEFAULT 0,
  PAGOBANCO        NUMBER(1)                    DEFAULT 0,
  PAGOOFICINA      NUMBER(1)                    DEFAULT 0,
  FLG_PREACTIVADO  NUMBER                       DEFAULT 0,
  PID              NUMBER(10),
  CODINSSRV        NUMBER(10),
  FLG_VERIFTEC     NUMBER(1)                    DEFAULT 0,
  FECINIVIG        DATE,
  FECFINVIG        DATE,
  FECALERTA        DATE,
  FECCORTE         DATE,
  MESESSINSRV      NUMBER(3),
  FLG_FACTURABLE   NUMBER(1),
  SERSUT           CHAR(3 BYTE),
  NUMSUT           CHAR(8 BYTE),
  TIPDOCFAC        CHAR(3 BYTE),
  FLG_TIP_PROY     NUMBER(1),
  BOUQUETS         VARCHAR2(200 BYTE),
  CODSUC           CHAR(10 BYTE),
  DIRSUC           VARCHAR2(480 BYTE),
  CODSOL           CHAR(8 BYTE),
  FLG_VALIDADO     NUMBER(1),
  NRODOCCON        VARCHAR2(15 BYTE),
  TIPDOCCON        CHAR(2 BYTE),
  CODUSUMOD        VARCHAR2(32 BYTE)            DEFAULT user,
  FECUSUMOD        DATE                         DEFAULT sysdate,
  CODSUCFAC        CHAR(10 BYTE),
  DIRSUCFAC        VARCHAR2(480 BYTE),
  FLG_RESERVA      NUMBER(1)                    DEFAULT 0,
  PLAZO_SRV        NUMBER(4),
  FLG_RECARGA      NUMBER(1),
  CODMOTIVO_LV     CHAR(3 BYTE),
  CODMOTIVO_TC     CHAR(3 BYTE),
  CODMOTIVO_CO     CHAR(3 BYTE),
  CODMOTIVO_TF     CHAR(3 BYTE),
  VALIDASERIE      NUMBER(1)                    DEFAULT 0,
  CODIGO_RECARGA   VARCHAR2(8 BYTE),
  ESTADO_OBJETIVO  CHAR(2 BYTE)
);

COMMENT ON COLUMN OPERACION.REGINSDTH.FLG_RECARGA IS 'Indica si el registro pertenece o no al sistema recarga (1: Pertenece, 0: No pertenece)';

COMMENT ON COLUMN OPERACION.REGINSDTH.CODMOTIVO_LV IS 'Codigo Motivo de Venta - Lugar de Venta';

COMMENT ON COLUMN OPERACION.REGINSDTH.CODMOTIVO_TC IS 'Codigo Motivo de Venta - Tipo de Cliente';

COMMENT ON COLUMN OPERACION.REGINSDTH.CODMOTIVO_CO IS 'Codigo Motivo de Venta - Competidor';

COMMENT ON COLUMN OPERACION.REGINSDTH.CODMOTIVO_TF IS 'Codigo Motivo de Venta - Tipo Facturacion';

COMMENT ON COLUMN OPERACION.REGINSDTH.VALIDASERIE IS 'Indicada si el usuario valid� el n�mero de serie del equipo';

COMMENT ON COLUMN OPERACION.REGINSDTH.CODSOL IS 'C�digo del consultor';


