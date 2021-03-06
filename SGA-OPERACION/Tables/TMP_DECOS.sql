CREATE TABLE OPERACION.TMP_DECOS
(
  UNITADDRESS   VARCHAR2(32 BYTE),
  CODCLI        CHAR(8 BYTE),
  NOMCLI        VARCHAR2(200 BYTE),
  TIPDOC        CHAR(3 BYTE),
  NUMDOC        VARCHAR2(15 BYTE),
  TELEFONO1     VARCHAR2(20 BYTE),
  CODSOLOT      NUMBER(8),
  NUMSLC        CHAR(10 BYTE),
  IDPAQ         NUMBER(10),
  FLG_INCLUIDO  NUMBER,
  FECENV        DATE,
  IDENVIO       NUMBER(15),
  CODUSU        VARCHAR2(30 BYTE)               DEFAULT user,
  FECUSU        DATE                            DEFAULT sysdate,
  IDLOTE        NUMBER(10),
  NUMREGINS     VARCHAR2(10 BYTE)
);

COMMENT ON COLUMN OPERACION.TMP_DECOS.IDLOTE IS 'ID lote carga masiva';

COMMENT ON COLUMN OPERACION.TMP_DECOS.NUMREGINS IS 'Numero de Registros';


