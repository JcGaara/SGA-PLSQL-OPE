CREATE TABLE OPERACION.SGAT_APROVISION_LOG
(
  SGAN_CODSOLOT           NUMBER(8),
  SGAV_TIPTRA             VARCHAR(4),
  SGAV_DSCTIPTRA          VARCHAR(200),
  SGAN_ID_TAREA           NUMBER(6),
  SGAN_CID                NUMBER(10),
  SGAV_TAREA              VARCHAR2(100),
  SGAV_MENSAJE            VARCHAR2(4000),
  SGAV_USUARIO            VARCHAR2(50) DEFAULT USER,
  SGAD_FECREG             DATE DEFAULT SYSDATE
);
tablespace OPERACION_DAT ;

comment on column OPERACION.SGAT_APROVISION_LOG.SGAN_CODSOLOT
  is 'Codigo de Solicitud';
comment on column OPERACION.SGAT_APROVISION_LOG.SGAV_TIPTRA
  is 'Tipo de trabajo (Tabla Tiptrabajo)';
comment on column OPERACION.SGAT_APROVISION_LOG.SGAV_DSCTIPTRA
  is 'Descripción del tipo de trabajo';  
comment on column OPERACION.SGAT_APROVISION_LOG.SGAN_ID_TAREA
  is 'ID Tarea (Tabla tareawfdef)';
comment on column OPERACION.SGAT_APROVISION_LOG.SGAV_TAREA
  is 'Descripción de la Tarea';
comment on column OPERACION.SGAT_APROVISION_LOG.SGAV_MENSAJE
  is 'Mensaje de Error';
comment on column OPERACION.SGAT_APROVISION_LOG.SGAN_CID
  is 'Circuito ID, inssrv.cid';