-- Create table
create table OPERACION.SGAT_MATRIZ_SERV
(
  servn_id              NUMBER(10) not null,
  servv_descripcion     VARCHAR2(400),
  servn_tiptra          NUMBER(4),
  servn_id_tipored      NUMBER(2),
  servv_tipored         VARCHAR2(30),
  servn_id_tiposerv     NUMBER(2),
  servv_tiposerv        VARCHAR2(80),
  servn_id_tipo_trabajo NUMBER(2),
  servv_tipo_trabajo    VARCHAR2(30),
  servn_cant_fotos      NUMBER(10),
  servn_flag_activo     NUMBER(1),
  servv_usureg          VARCHAR2(30),
  servd_fecreg          DATE,
  servv_usumod          VARCHAR2(30),
  servd_fecmod_fecmod   DATE
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
-- Add comments to the columns 
comment on column OPERACION.SGAT_MATRIZ_SERV.servn_id
  is 'ID del servicio a ejecutarse';
comment on column OPERACION.SGAT_MATRIZ_SERV.servv_descripcion
  is 'Descripcion del servicio a ejecutar';
comment on column OPERACION.SGAT_MATRIZ_SERV.servn_tiptra
  is 'Codigo del tipo de trabajo';
comment on column OPERACION.SGAT_MATRIZ_SERV.servn_id_tipored
  is 'Codigo de tipo de RED';
comment on column OPERACION.SGAT_MATRIZ_SERV.servv_tipored
  is 'Tipo de RED : HFC , FTTH';
comment on column OPERACION.SGAT_MATRIZ_SERV.servn_id_tiposerv
  is 'Codigo de tipo de servicio';
comment on column OPERACION.SGAT_MATRIZ_SERV.servv_tiposerv
  is 'Tipo de servicio: Residencial , Claro Empresas , Claro Empresas + IP , CATV Analogico';
comment on column OPERACION.SGAT_MATRIZ_SERV.servn_id_tipo_trabajo
  is 'Codigo de tipo de trabajo';
comment on column OPERACION.SGAT_MATRIZ_SERV.servv_tipo_trabajo
  is 'Tipo de trabajo : Instalacion, Mantto , Postventa, Cambio de TAP';
comment on column OPERACION.SGAT_MATRIZ_SERV.servn_cant_fotos
  is 'Cantidad de fotos';
comment on column OPERACION.SGAT_MATRIZ_SERV.servn_flag_activo
  is '1: activo  0: Inactivo';
comment on column OPERACION.SGAT_MATRIZ_SERV.servv_usureg
  is 'Usuario que creo el registro';
comment on column OPERACION.SGAT_MATRIZ_SERV.servd_fecreg
  is 'Fecha que se creo el registro';
comment on column OPERACION.SGAT_MATRIZ_SERV.servv_usumod
  is 'Usuario que modifico el registro';
comment on column OPERACION.SGAT_MATRIZ_SERV.servd_fecmod_fecmod
  is 'Fecha que se modifico el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_MATRIZ_SERV
  add constraint PK_SGAT_MATRIZ_SERV primary key (SERVN_ID)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

  
-- Create table
create table OPERACION.SGAT_MATRIZ_FOTO
(
  foton_id          NUMBER(10) not null,
  fotov_cod_matriz  VARCHAR2(10) not null,
  fotov_desc_matriz VARCHAR2(400),
  foton_flag_carga  NUMBER(1) default 0,
  foton_flag_deco   NUMBER(1) default 0,
  foton_flag_emp    NUMBER(1) default 0,
  fotov_desc_img    VARCHAR2(100),
  fotob_img         BLOB,
  fotov_desc_img2   VARCHAR2(100),
  fotob_img_2       BLOB,
  fotov_desc_img3   VARCHAR2(100),
  fotob_img_3       BLOB,
  foton_flag_activo NUMBER(1),
  fotov_usureg      VARCHAR2(30),
  fotod_fecreg      DATE,
  fotov_usumod      VARCHAR2(30),
  fotod_fecmod      DATE
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
-- Add comments to the columns 
comment on column OPERACION.SGAT_MATRIZ_FOTO.foton_id
  is 'Id de la foto secuencial';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotov_cod_matriz
  is 'Codigo de la foto en la matriz (Gestion Fotografica)';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotov_desc_matriz
  is 'Descripcion de la foto en la matriz (Gestion Fotografica)';
comment on column OPERACION.SGAT_MATRIZ_FOTO.foton_flag_carga
  is 'Flag de imagen cargada';
comment on column OPERACION.SGAT_MATRIZ_FOTO.foton_flag_deco
  is 'Flag Deco, por cada deco una imagen';
comment on column OPERACION.SGAT_MATRIZ_FOTO.foton_flag_emp
  is 'Flag si el tipo de foto solo es para empresas';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotov_desc_img
  is 'Descripcion del nombre del archivo de la foto 1';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotob_img
  is 'Imagen ejemplo 1';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotov_desc_img2
  is 'Descripcion del nombre del archivo de la foto 2';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotob_img_2
  is 'Imagen ejemplo 2';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotov_desc_img3
  is 'Descripcion del nombre del archivo de la foto 3';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotob_img_3
  is 'Imagen ejemplo 3';
comment on column OPERACION.SGAT_MATRIZ_FOTO.foton_flag_activo
  is '1: activo  0: Inactivo';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotov_usureg
  is 'Usuario que creo el registro';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotod_fecreg
  is 'Fecha que se creo el registro';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotov_usumod
  is 'Usuario que modifico el registro';
comment on column OPERACION.SGAT_MATRIZ_FOTO.fotod_fecmod
  is 'Fecha que se modifico el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_MATRIZ_FOTO
  add constraint PK_SGAT_MATRIZ_FOTO primary key (FOTON_ID)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );


 -- Create table
create table OPERACION.SGAT_MATRIZ_REPORT
(
  reportn_id          NUMBER(10) not null,
  reportn_id_serv     NUMBER(10),
  reportn_id_foto     NUMBER(10),
  reportn_flag_activo NUMBER(1),
  reportv_usureg      VARCHAR2(30),
  reportd_fecreg      DATE,
  reportv_usumod      VARCHAR2(30),
  reportd_fecmod      DATE
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
-- Add comments to the columns 
comment on column OPERACION.SGAT_MATRIZ_REPORT.reportn_id
  is 'Id del reporte secuencial';
comment on column OPERACION.SGAT_MATRIZ_REPORT.reportn_id_serv
  is 'ID del servicio a ejecutarse';
comment on column OPERACION.SGAT_MATRIZ_REPORT.reportn_id_foto
  is 'Codigo de la foto en la matriz (Gestion Fotografica)';
comment on column OPERACION.SGAT_MATRIZ_REPORT.reportn_flag_activo
  is '1: activo  0: Inactivo';
comment on column OPERACION.SGAT_MATRIZ_REPORT.reportv_usureg
  is 'Usuario que creo el registro';
comment on column OPERACION.SGAT_MATRIZ_REPORT.reportd_fecreg
  is 'Fecha que se creo el registro';
comment on column OPERACION.SGAT_MATRIZ_REPORT.reportv_usumod
  is 'Usuario que modifico el registro';
comment on column OPERACION.SGAT_MATRIZ_REPORT.reportd_fecmod
  is 'Fecha que se modifico el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_MATRIZ_REPORT
  add constraint PK_SGAT_MATRIZ_REPORT primary key (REPORTN_ID)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table OPERACION.SGAT_MATRIZ_REPORT
  add foreign key (REPORTN_ID_SERV)
  references OPERACION.SGAT_MATRIZ_SERV (SERVN_ID);
alter table OPERACION.SGAT_MATRIZ_REPORT
  add foreign key (REPORTN_ID_FOTO)
  references OPERACION.SGAT_MATRIZ_FOTO (FOTON_ID);
