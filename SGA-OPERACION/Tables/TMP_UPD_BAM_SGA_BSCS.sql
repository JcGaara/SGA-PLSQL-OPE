create table OPERACION.TMP_UPD_BAM_SGA_BSCS
(
  CODINSSRV  NUMBER(10) not null,
  CODSRV     CHAR(4) not null,
  TIPINSSRV  NUMBER(2) not null,
  DSCSRV     VARCHAR2(50),
  NUMERO     VARCHAR2(20),
  CODCLI     CHAR(8) not null,
  NOMCLI     VARCHAR2(200) not null,
  TIPDIDE    VARCHAR2(3),
  DSCDID     VARCHAR2(30),
  NTDIDE     VARCHAR2(15),
  COMENTARIO VARCHAR2(255)
);
/