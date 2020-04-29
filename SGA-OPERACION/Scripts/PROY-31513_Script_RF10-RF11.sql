-- ALTER A LA TABLA
ALTER TABLE operacion.zona_adc ADD SERVICIO VARCHAR2(5);
-- Add comments to the columns 
comment on column OPERACION.ZONA_ADC.SERVICIO
  is 'CAMPO AÑADIDO PROY-31513 servicio HFC - LTE';
-- ADD PARA LA ANOTACION
alter table operacion.siac_postventa_proceso add (ANOTACION_TOA	VARCHAR2(4000), CODSOLOT NUMBER);
comment on column operacion.siac_postventa_proceso.codsolot is 'PROY-31513 SOT Generada';
comment on column operacion.siac_postventa_proceso.ANOTACION_TOA is 'PROY-31513 ANOTACION';  
/ 