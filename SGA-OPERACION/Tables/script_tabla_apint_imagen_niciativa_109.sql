-- Create table
create table OPERACION.SGAT_APINT_IMAGEN
(
  apintn_idimagen       NUMBER(10) not null,
  apintn_codsolot       NUMBER(8),
  apintd_fecha          DATE,
  apintv_dnitecnico     VARCHAR2(8),
  apintn_codcontrata    NUMBER(6),
  apintn_idactividades  NUMBER(10),
  apintn_codservicio    NUMBER(2),
  apintn_cantiatencion  NUMBER(10),
  apintv_idescenario    VARCHAR2(8),
  apintn_idestadoimagen NUMBER(10),
  apintn_idstatusimagen NUMBER(10),
  apintd_fecini         DATE,
  apintd_fecfin         DATE,
  apintc_tipoimagen     CHAR(1),
  apintn_borrado        NUMBER(1) default (0),
  apintd_fecre          DATE default sysdate,
  apintv_usucre         VARCHAR2(30),
  apintd_fecmod         DATE,
  apintv_usumod         VARCHAR2(30)
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
comment on column OPERACION.SGAT_APINT_IMAGEN.apintn_idimagen
  is 'Id Secuencial de la Imagen';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintn_codsolot
  is 'Código de la solicitud de orden de trabajo ';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintd_fecha
  is 'Fecha Carga ';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintv_dnitecnico
  is 'DNI del Tecnico ';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintn_codcontrata
  is 'Codigo de la Contrata';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintn_idactividades
  is 'Codigo de Actividad de Trabajo a Realizar';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintn_codservicio
  is 'Codigo de Servicio (1 Instalacion, 2 Mantenimiento,3 PostVenta)';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintn_cantiatencion
  is 'Cantidad de Equipos Instalados)';  
comment on column OPERACION.SGAT_APINT_IMAGEN.apintv_idescenario
   is 'Codigo de Escenario de Trabajo a Realizar';  
comment on column OPERACION.SGAT_APINT_IMAGEN.apintn_idestadoimagen 
  is 'Estado Imagen  (Observada, Aprobada, etc)';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintn_idstatusimagen 
  is ' Sub Status Imagen  (Foto Aceptada, Datos Incompletos, etc.)';  
comment on column OPERACION.SGAT_APINT_IMAGEN.apintd_fecini  
  is 'Fecha Inicio ';  
comment on column OPERACION.SGAT_APINT_IMAGEN.apintd_fecfin   
  is 'Fecha Fin ';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintc_tipoimagen 
  is '(F) foto, (A) acta';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintn_borrado   
  is 'flag borrado logico:0 no borrado, 1 borrado ';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintd_fecre   
  is 'fecha que de creacion del registro ';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintv_usucre
  is 'usuario de la pc que creo el registro ';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintd_fecmod
  is 'fecha que se modifico el registro ';
comment on column OPERACION.SGAT_APINT_IMAGEN.apintv_usumod
  is 'usuario de la pc que modifico el registro ';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_APINT_IMAGEN
  add constraint PK_SGAT_APINT_IMAGEN primary key (apintn_idimagen)
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