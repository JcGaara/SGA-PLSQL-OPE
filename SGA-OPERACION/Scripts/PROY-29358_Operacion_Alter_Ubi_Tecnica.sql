-- Add/modify columns 
alter table OPERACION.UBI_TECNICA add ubitv_nombre VARCHAR2(80);
alter table OPERACION.UBI_TECNICA add ubitv_direccion VARCHAR2(100);
alter table OPERACION.UBI_TECNICA add ubitv_distrito VARCHAR2(5);
alter table OPERACION.UBI_TECNICA add ubitv_tipo_proyecto VARCHAR2(20);
alter table OPERACION.UBI_TECNICA add ubitv_codigo_site VARCHAR2(30);
alter table OPERACION.UBI_TECNICA add ubitv_tipo_site VARCHAR2(20);
alter table OPERACION.UBI_TECNICA add ubitv_x VARCHAR2(30);
alter table OPERACION.UBI_TECNICA add ubitv_y VARCHAR2(30);
alter table OPERACION.UBI_TECNICA add ubitv_observacion VARCHAR2(80);
alter table OPERACION.UBI_TECNICA add ubitv_estado VARCHAR2(5);
alter table OPERACION.UBI_TECNICA add ubitv_ubigeo VARCHAR2(30);
alter table OPERACION.UBI_TECNICA add ubitv_idreqcab VARCHAR2(5);
alter table OPERACION.UBI_TECNICA add ubitv_flag_nvl4 CHAR(1);
-- Add comments to the columns 
comment on column OPERACION.UBI_TECNICA.ubitv_nombre   is 'Nombre';
comment on column OPERACION.UBI_TECNICA.ubitv_direccion   is 'Direccion';
comment on column OPERACION.UBI_TECNICA.ubitv_distrito  is 'Distrito';
comment on column OPERACION.UBI_TECNICA.ubitv_tipo_proyecto  is 'Tipo proyecto';
comment on column OPERACION.UBI_TECNICA.ubitv_codigo_site  is 'Codigo Site';
comment on column OPERACION.UBI_TECNICA.ubitv_tipo_site  is 'Tipo Site';
comment on column OPERACION.UBI_TECNICA.ubitv_x  is 'X';
comment on column OPERACION.UBI_TECNICA.ubitv_y  is 'Y';
comment on column OPERACION.UBI_TECNICA.ubitv_observacion  is 'Observacion';
comment on column OPERACION.UBI_TECNICA.ubitv_estado  is 'Estado';
comment on column OPERACION.UBI_TECNICA.ubitv_ubigeo  is 'Ubigeo';
comment on column OPERACION.UBI_TECNICA.ubitv_idreqcab  is 'Identificador ReqCab';
comment on column OPERACION.UBI_TECNICA.ubitv_flag_nvl4  is 'Flag de nivel 4';

/
