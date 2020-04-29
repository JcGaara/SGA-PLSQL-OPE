-- Create table
create table OPERACION.BOUQUETXREGINSDTH_LOG
(
  idcupon               NUMBER,
  numregistro           CHAR(10),
  estado                NUMBER,
  fecha_inicio_vigencia DATE,
  fecha_fin_vigencia    DATE,
  tipo                  NUMBER,
  flag                  NUMBER,
  valor                 CHAR(20)
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
comment on column OPERACION.BOUQUETXREGINSDTH_LOG.idcupon
  is 'Identificador del cupón que desencadenó la promoción';
comment on column OPERACION.BOUQUETXREGINSDTH_LOG.numregistro
  is 'Númreo de registro de instalación de DTH';
comment on column OPERACION.BOUQUETXREGINSDTH_LOG.estado
  is 'Estado 0: No activo el servicio, 1: Activo el servicio';
comment on column OPERACION.BOUQUETXREGINSDTH_LOG.fecha_inicio_vigencia
  is 'Fecha Inicio de Vigencia del Bouquet adicional';
comment on column OPERACION.BOUQUETXREGINSDTH_LOG.fecha_fin_vigencia
  is 'Fecha Fin de Vigencia del Bouquet adicional';
comment on column OPERACION.BOUQUETXREGINSDTH_LOG.tipo
  is 'Tipo 0: Servicio Adicional, 1: Servicio Principal, 2: Promociones';
comment on column OPERACION.BOUQUETXREGINSDTH_LOG.flag
  is 'Identificador del flag DTH OPE_GRUPO_BOUQUET_CAB';
comment on column OPERACION.BOUQUETXREGINSDTH_LOG.valor
  is 'Bandera que muestra los estados OK y REGULARIZADO';
/

