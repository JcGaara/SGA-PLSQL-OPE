-- Create table
create table OPERACION.SGAT_ERROR_CAM_CICLO
(
  erccn_contrato    number not null,
  erccv_producto    varchar2(20) not null,
  erccv_descripcion varchar2(1000),
  erccv_usuario     varchar2(50) default user not null,
  erccd_fecha       date default sysdate not null,
  erccv_ip_app      varchar2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS') not null
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the columns 
comment on column OPERACION.SGAT_ERROR_CAM_CICLO.erccn_contrato
  is 'Código de contrato';
comment on column OPERACION.SGAT_ERROR_CAM_CICLO.erccv_producto
  is 'Producto';
comment on column OPERACION.SGAT_ERROR_CAM_CICLO.erccv_descripcion
  is 'Descripción del error';
comment on column OPERACION.SGAT_ERROR_CAM_CICLO.erccv_usuario
  is 'Usuario de registro';
comment on column OPERACION.SGAT_ERROR_CAM_CICLO.erccd_fecha
  is 'Fecha de Registro';
comment on column OPERACION.SGAT_ERROR_CAM_CICLO.erccv_ip_app
  is 'IP de aplicación';