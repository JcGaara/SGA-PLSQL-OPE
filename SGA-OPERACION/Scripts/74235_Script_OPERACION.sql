alter table OPERACION.ID_SITIO add cid number;
comment on column OPERACION.ID_SITIO.cid  is 'CID';

alter table OPERACION.PEP add genera_reserva NUMBER default 0;
comment on column OPERACION.PEP.genera_reserva is 'Indica si el PEP N3 puede generar Reserva';

alter table OPERACION.TIPROY_SINERGIA add asigna_pep number default 0;
alter table OPERACION.TIPROY_SINERGIA_PEP add pep_etapa number default 0;
comment on column OPERACION.TIPROY_SINERGIA.asigna_pep is '1:Por Etapa 2:Por Clasif Obra';
comment on column OPERACION.TIPROY_SINERGIA_PEP.pep_etapa is 'Asigna el PEP por defecto cuando es asignaacion de PEP por Etapa';

alter table OPERACION.PROYECTO_SAP add manparno VARCHAR2(30);
comment on column OPERACION.PROYECTO_SAP.manparno  is 'Código ID de Sitio';

alter table OPERACION.PEP add manparno VARCHAR2(30);
comment on column OPERACION.PEP.manparno  is 'Código ID de Sitio';

alter table OPERACION.RESERVA_DET add FLG_PROCESADO NUMBER;
alter table OPERACION.RESERVA_DET add ESTADO_SAP    NUMBER;
comment on column OPERACION.RESERVA_DET.FLG_PROCESADO is '0: sin procesar 1: procesado';
comment on column OPERACION.RESERVA_DET.ESTADO_SAP    is 'Estados que se manejan en SAP para las reservas 1: Generado,2: Salida Final,3: Salida Parcial,9: Borrado';


ALTER TABLE operacion.agendamiento
ADD idbucket VARCHAR2(100)
ADD contacto_adc VARCHAR2(50)
ADD telefono_adc VARCHAR2(10)
ADD flg_adc NUMBER(2)
ADD flg_orden_adc NUMBER(1)
ADD rpt_adc NUMBER(2)
ADD id_subtipo_orden NUMBER(10);

-- Comentarios de los nuevos campos de la tabla agendamiento
COMMENT ON COLUMN operacion.agendamiento.idbucket is 'Identificador de Bucket asignado al agendamiento';
COMMENT ON COLUMN operacion.agendamiento.contacto_adc is 'Contacto de Reenvio de Agenda para el Oracle Field Service(ADC)';
COMMENT ON COLUMN operacion.agendamiento.telefono_adc is 'Telefono de Reenvio de Agenda para el Oracle Field Service(ADC)';
COMMENT ON COLUMN operacion.agendamiento.id_subtipo_orden is 'Identificador del SubTipo de Orden de Oracle Field Service(ADC) de la tabla operacion.subtipo_orden_adc';
COMMENT ON COLUMN operacion.agendamiento.flg_adc is 'Flag Indicador si pertenece la flujo de Oracle Field Service(ADC)';
COMMENT ON COLUMN operacion.agendamiento.flg_orden_adc is 'Flag Indicador de la creacion de Orden de Trabajo en Oracle Field Service(ADC)';
COMMENT ON COLUMN operacion.agendamiento.rpt_adc is 'Indicador de estados de la Orden de Trabajo de Oracle Field Service(ADC): 1 - Genero OT, 2 - Genero OT No Programada, 3 - Genero OT con Bucket de Error, 4 - Error de Conexion, 5 - Error Generación OT por Consistencia de Datos, 6 - Error en la Generación de OT';

ALTER TABLE operacion.agendamientochgest 
ADD idestado_adc NUMBER(8);
COMMENT ON COLUMN operacion.agendamientochgest.idestado_adc IS 'ID Estado Adm de Cuadrillas';



alter table OPERACION.OPE_SP_MAT_EQU_DET add sin_cod_sap VARCHAR2(30);
alter table OPERACION.OPE_SP_MAT_EQU_DET add sin_solicitante VARCHAR2(30);
alter table OPERACION.OPE_SP_MAT_EQU_DET add sin_fondo VARCHAR2(30);
alter table OPERACION.OPE_SP_MAT_EQU_DET add sin_pep VARCHAR2(30);
alter table OPERACION.OPE_SP_MAT_EQU_DET add sin_ceco VARCHAR2(30);
alter table OPERACION.OPE_SP_MAT_EQU_DET add sin_pospre VARCHAR2(30);
alter table OPERACION.OPE_SP_MAT_EQU_DET add sin_valoracion VARCHAR2(100);
alter table OPERACION.OPE_SP_MAT_EQU_DET add sin_planificador VARCHAR2(4);
alter table OPERACION.OPE_SP_MAT_EQU_DET add sin_nro_activo VARCHAR2(100);
alter table OPERACION.OPE_SP_MAT_EQU_DET add sin_orden_interna VARCHAR2(30);
alter table OPERACION.OPE_SP_MAT_EQU_DET add IND_GESTOR CHAR(1);
alter table OPERACION.OPE_SP_MAT_EQU_DET add CENTRO_GESTOR_ADM VARCHAR2(25);
alter table OPERACION.OPE_SP_MAT_EQU_DET add FLG_SINERGIA CHAR(1);
comment on column OPERACION.OPE_SP_MAT_EQU_DET.sin_cod_sap is 'SINERGIA Codigo  SAP';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.sin_solicitante is 'SINERGIA Solicitante';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.sin_fondo is 'SINERGIA Fondo';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.sin_pep is 'SINERGIA PEP';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.sin_ceco is 'SINERGIA Centro Costo';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.sin_pospre is 'SINERGIA Posicion Presupuesto';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.sin_valoracion is 'SINERGIA Valoracion';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.sin_planificador is 'SINERGIA Planificador';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.sin_nro_activo is 'SINERGIA Nro Activo';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.sin_orden_interna is 'SINERGIA Orden Interna';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.IND_GESTOR is 'SINERGIA Indicador tipo de gestor';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.CENTRO_GESTOR_ADM is 'SINERGIA Codigo Centro Gestor Administrativo';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.FLG_SINERGIA is 'SINERGIA Flag para identificar registro';