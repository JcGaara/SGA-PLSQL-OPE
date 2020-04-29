CREATE TABLE OPERACION.OPE_ENVIO_CONAX
(
  IDENVIO        NUMBER                         NOT NULL,
  CODSOLOT       NUMBER,
  CODINSSRV      NUMBER,
  NUMREGISTRO    CHAR(10 BYTE)                  NOT NULL,
  TIPO           NUMBER,
  ESTADO         NUMBER,
  USUREG         VARCHAR2(30 BYTE)              DEFAULT user                  NOT NULL,
  FECREG         DATE                           DEFAULT sysdate               NOT NULL,
  USUMOD         VARCHAR2(30 BYTE)              DEFAULT user                  NOT NULL,
  FECMOD         DATE                           DEFAULT sysdate               NOT NULL,
  UNITADDRESS    VARCHAR2(50 BYTE),
  SERIE          VARCHAR2(50 BYTE),
  CODIGO         NUMBER,
  BOUQUET        CHAR(3 BYTE),
  CODSRV         CHAR(4 BYTE),
  NUMTRANS       NUMBER,
  FLG_VERIF_TEC  NUMBER(1)                      DEFAULT 0
);

COMMENT ON COLUMN OPERACION.OPE_ENVIO_CONAX.NUMREGISTRO IS 'Registro DTH';

COMMENT ON COLUMN OPERACION.OPE_ENVIO_CONAX.TIPO IS '1:Alta; 2:Baja;';

COMMENT ON COLUMN OPERACION.OPE_ENVIO_CONAX.ESTADO IS '0:Sin Procesar; 1:Procesado OK; 2:Error;';

COMMENT ON COLUMN OPERACION.OPE_ENVIO_CONAX.FECMOD IS ' ';

COMMENT ON COLUMN OPERACION.OPE_ENVIO_CONAX.FLG_VERIF_TEC IS 'Flag de verificación tecnica';


