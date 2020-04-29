alter table OPERACION.UBI_TECNICA add ubitv_direccion_nro    VARCHAR2(20);
alter table OPERACION.UBI_TECNICA add ubitv_pais             VARCHAR2(50);
alter table OPERACION.UBI_TECNICA add ubitv_zona_horaria     VARCHAR2(50);
alter table OPERACION.UBI_TECNICA add ubitv_nom_departamento VARCHAR2(100);
alter table OPERACION.UBI_TECNICA add ubitv_nom_provincia    VARCHAR2(100);
alter table OPERACION.UBI_TECNICA add ubitv_nom_distrito     VARCHAR2(100);
alter table OPERACION.UBI_TECNICA add ubitv_codigo_postal    VARCHAR2(10);
alter table OPERACION.UBI_TECNICA add ubitv_poblacion        VARCHAR2(20);
alter table OPERACION.UBI_TECNICA add ubitv_provincia VARCHAR2(5);
alter table OPERACION.UBI_TECNICA add ubitv_departamento VARCHAR2(5);

comment on column OPERACION.UBI_TECNICA.ubitv_direccion_nro  is 'Numero de direccion';
comment on column OPERACION.UBI_TECNICA.ubitv_pais  is 'Pais';
comment on column OPERACION.UBI_TECNICA.ubitv_zona_horaria  is 'Zona Horaria';
comment on column OPERACION.UBI_TECNICA.ubitv_nom_departamento  is 'Nombre Departamento';
comment on column OPERACION.UBI_TECNICA.ubitv_nom_provincia  is 'Nombre Provincia';
comment on column OPERACION.UBI_TECNICA.ubitv_nom_distrito is 'Nombre Distrito';
comment on column OPERACION.UBI_TECNICA.ubitv_codigo_postal is 'Codigo Postal';
comment on column OPERACION.UBI_TECNICA.ubitv_poblacion  is 'Poblacion';
comment on column OPERACION.UBI_TECNICA.ubitv_provincia  is 'Provincia';
comment on column OPERACION.UBI_TECNICA.ubitv_departamento  is 'Departamento';
/