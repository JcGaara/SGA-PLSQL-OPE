-- Create table
create table OPERACION.OPE_SINERGIA_FILTROS_TMP
(
  idvalor    NUMBER not null,
  tipo       char(3),
  codsolot   NUMBER(8),
  usureg     VARCHAR2(30) default USER,
  fecreg     DATE default SYSDATE
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.OPE_SINERGIA_FILTROS_TMP
  is 'Tabla que guarda los valores a filtrar en SINERGIA';
-- Add comments to the columns 
comment on column OPERACION.OPE_SINERGIA_FILTROS_TMP.idvalor
  is 'Numero identificador del valor a filtrar en una ventana';
comment on column OPERACION.OPE_SINERGIA_FILTROS_TMP.tipo
  is 'Tipo de filtro --> DTH: DTH, COR: Coorporativo, TPI: TPI, WMX: Wimax, HFC: Masivo';
comment on column OPERACION.OPE_SINERGIA_FILTROS_TMP.codsolot
  is 'Numero de la Solicitud de Orden de Trabajo';
comment on column OPERACION.OPE_SINERGIA_FILTROS_TMP.usureg
  is 'Usuario que insertó el registro';
comment on column OPERACION.OPE_SINERGIA_FILTROS_TMP.fecreg
  is 'Fecha que inserto el registro';

