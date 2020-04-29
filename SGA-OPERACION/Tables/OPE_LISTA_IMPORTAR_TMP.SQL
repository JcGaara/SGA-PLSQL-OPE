-- Create table
create table OPERACION.OPE_LISTA_IMPORTAR_TMP
(
  codsolot           NUMBER(8),
  tipo_trabajo       VARCHAR2(200),
  mac                VARCHAR2(30),
  contract_number    VARCHAR2(30),
  number_of_flow     NUMBER(20),
  service_profile    VARCHAR2(100),
  service_group_1    VARCHAR2(100),
  service_group_2    VARCHAR2(100),
  service_group_3    VARCHAR2(100),
  service_group_4    VARCHAR2(100),
  service_group_5    VARCHAR2(100),
  ip_radiobase       VARCHAR2(20),
  comunidad          VARCHAR2(8) default 'claro',
  mac_1              VARCHAR2(30),
  service_profile_ea VARCHAR2(100),
  service_group_1_ea VARCHAR2(100),
  service_group_2_ea VARCHAR2(100),
  service_group_3_ea VARCHAR2(100),
  service_group_4_ea VARCHAR2(100),
  service_profile_es VARCHAR2(100),
  service_group_1_es VARCHAR2(100),
  usureg             VARCHAR2(30) default USER,
  fecreg             DATE default SYSDATE,
  usumod             VARCHAR2(30) default USER,
  fecmod             DATE default SYSDATE
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 480K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table OPERACION.OPE_LISTA_IMPORTAR_TMP
  is 'Listado de Solot a suspender';
-- Add comments to the columns 
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.codsolot
  is 'Código de la SOT';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.tipo_trabajo
  is 'Tipo de Trabajo (Suspensión/Reconexión)';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.mac
  is 'Código de MAC';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.contract_number
  is 'Campo de Concatenación de CID y Número de CID';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.number_of_flow
  is 'Campo que es el doble de la suma de los service group';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_profile
  is 'Perfil Activo';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_group_1
  is 'Service_Group_1';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_group_2
  is 'Service_Group_2';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_group_3
  is 'Service_Group_3';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_group_4
  is 'Service_Group_4';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_group_5
  is 'Service_Group_5';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.ip_radiobase
  is 'IP de la radiobase donde se encuentra aprovisionado el servicio';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.comunidad
  is 'Nombre de la Comunidad';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.mac_1
  is 'Código de MAC, es lo mismo del campo 3';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_profile_ea
  is 'Service Profile del estado activo,cuando es SOT reconexión es igual al campo 6';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_group_1_ea
  is 'Service Group 1 del estado activo,cuando es SOT reconexión es igual al campo 7';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_group_2_ea
  is 'Service Group 2 del estado activo,cuando es SOT reconexión es igual al campo 8';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_group_3_ea
  is 'Service Group 3 del estado activo,cuando es SOT reconexión es igual al campo 9';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_group_4_ea
  is 'Service Group 4 del estado activo,cuando es SOT reconexión es igual al campo 10';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_profile_es
  is 'Service Group 4 del estado suspendido,cuando es SOT suspensión es igual al campo 6';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.service_group_1_es
  is 'Service Group 1 del estado suspendido,cuando es SOT suspensión es igual al campo 7';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.usureg
  is 'Usuario que realizo el registro';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.fecreg
  is 'Fecha de creación del registro';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.usumod
  is 'Usuario que modifico el registro';
comment on column OPERACION.OPE_LISTA_IMPORTAR_TMP.fecmod
  is 'Fecha que se modifico el registro';
