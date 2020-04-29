CREATE TABLE OPERACION.SGAT_PROCARC_LIC_DET
(
PRARI_SECUENCIA    NUMBER(10) not null,
PRARI_ID_LIC_DET   NUMBER(10) not null,
PRARV_DESCRIPCION  VARCHAR2(100),
PRARV_TIPO         VARCHAR2(20),
PRARV_RUTA         VARCHAR2(1000),
PRARB_ARCHIVO      BLOB,
PRARV_USUREG       VARCHAR2(30) DEFAULT USER,
PRARD_FECREG       DATE DEFAULT SYSDATE,
PRARV_USUMOD       VARCHAR2(30),
PRARD_FECMOD       DATE
)
TABLESPACE OPERACION_DAT
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255
  STORAGE
(
  INITIAL 64K
  NEXT 1M
  MINEXTENTS 1
  MAXEXTENTS UNLIMITED
);

-- Add comments to the columns 
comment on column OPERACION.SGAT_PROCARC_LIC_DET.prari_secuencia
  is 'Secuencia ';
comment on column OPERACION.SGAT_PROCARC_LIC_DET.prari_id_lic_det
  is 'Secuencia de Licencias Equipos';
comment on column OPERACION.SGAT_PROCARC_LIC_DET.prarv_descripcion
  is 'Descripcion del archivo adjunto';
comment on column OPERACION.SGAT_PROCARC_LIC_DET.prarv_tipo
  is 'Tipo de achivo adjunto';
comment on column OPERACION.SGAT_PROCARC_LIC_DET.prarv_ruta
  is 'Ruta del archivo adjunto';
comment on column OPERACION.SGAT_PROCARC_LIC_DET.prarb_archivo
  is 'Archivo adjunto';
comment on column OPERACION.SGAT_PROCARC_LIC_DET.prarv_usureg
  is 'Usuario de registro';
comment on column OPERACION.SGAT_PROCARC_LIC_DET.prard_fecreg
  is 'Fecha de registro';
comment on column OPERACION.SGAT_PROCARC_LIC_DET.prarv_usumod
  is 'Usuario de modificacion';
comment on column OPERACION.SGAT_PROCARC_LIC_DET.prard_fecmod
  is 'Fecha de modificacion';