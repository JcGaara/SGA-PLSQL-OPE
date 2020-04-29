-- CREATE TABLE
CREATE TABLE OPERACION.SGAT_POSTV
(
  IDPROCESS                  NUMBER NOT NULL,
  COD_ID                     CHAR(10),
  CUSTOMER_ID                VARCHAR2(15),
  TIPO_TRANS                 VARCHAR2(30),
  COD_INTERCASO              VARCHAR2(30),
  TIPO_VIA                   NUMBER(2),
  NOM_VIA                    VARCHAR2(60),
  NUM_VIA                    VARCHAR2(50),
  TIP_URB                    NUMBER(4),
  NOMURB                     VARCHAR2(50),
  MANZANA                    VARCHAR2(5),
  LOTE                       VARCHAR2(5),
  UBIGEO                     CHAR(10),
  CODZONA                    NUMBER(3),
  CODPLANO                   VARCHAR2(10),
  CODEDIF                    NUMBER(8),
  REFERENCIA                 VARCHAR2(340),
  OBSERVACION                VARCHAR2(4000),
  FEC_PROG                   DATE,
  FRANJA_HOR                 VARCHAR2(50),
  NUM_CARTA                  NUMBER(15),
  OPERADOR                   NUMBER,
  PRESUSCRITO                NUMBER,
  PUBLICAR                   NUMBER,
  TMCODE                     NUMBER,
  LST_TIPEQU                 VARCHAR2(4000),
  LST_COSER                  VARCHAR2(4000),
  LST_SNCODE                 VARCHAR2(4000),
  LST_SPCODE                 VARCHAR2(4000),
  USUREG                     VARCHAR2(15),
  FECREG                     DATE,
  CARGO                      NUMBER,
  COD_CASO                   VARCHAR2(1),
  TIPTRA                     NUMBER,
  TIPOSERVICIO               VARCHAR2(4),
  FLAG_ACT_DIR_FACT          VARCHAR2(2),
  CODMOTOT                   NUMBER,
  TIPO_PRODUCTO              VARCHAR2(10),
  TRAMA                      CLOB,
  ANOTACION_TOA              VARCHAR2(4000),
  CODSOLOT                   NUMBER,
  IDINTERACCION              VARCHAR2(50),
  CODOCC                     NUMBER,
  NUM_CUOTA                  NUMBER,
  MONTO                      NUMBER,
  COMENT                     VARCHAR2(2000),
  TOPE                       NUMBER,
  CO_SER                     NUMBER,
  FLAG_LC                    NUMBER,
  FLAG_TOPEMENOR             NUMBER,
  RECLAMO_CASO               NUMBER,
  ID_SIAC_POSTVENTA_LTE      NUMBER(10) not null,
  FECPROG	                   DATE,
  FRANJA	                   VARCHAR2(10),
  CENTRO_POBLADO	           VARCHAR2(10),
  TIPOSERVICO	               VARCHAR2(4),
  NUMCARTA	                 NUMBER(15),
  AD_TMCODE	                 VARCHAR2(4000),
  LISTA_COSER	               VARCHAR2(4000),
  LISTA_SPCODE	             VARCHAR2(4000),
  P_ID	                     VARCHAR2(20),
  DECO_OLD	                 VARCHAR2(50),
  TARJETA_OLD	               VARCHAR2(50),
  CANTIDAD	                 NUMBER,
  CODIGO_OCC	               VARCHAR2(6)
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
