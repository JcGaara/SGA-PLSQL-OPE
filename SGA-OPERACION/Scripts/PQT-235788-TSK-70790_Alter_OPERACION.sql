ALTER TABLE operacion.tiptrabajo ADD id_tipo_orden NUMBER(10);
COMMENT ON COLUMN operacion.tiptrabajo.id_tipo_orden is 'Tipo de orden ADC';

ALTER TABLE operacion.agendamiento
ADD idbucket VARCHAR2(100)
ADD contacto_adc VARCHAR2(50)
ADD telefono_adc VARCHAR2(10)
ADD flg_adc NUMBER(2) DEFAULT 0
ADD flg_orden_adc NUMBER(1) DEFAULT 0
ADD rpt_adc NUMBER(2) DEFAULT 0
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
