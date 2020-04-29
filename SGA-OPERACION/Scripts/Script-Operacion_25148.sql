-----------------------------------------------------------------------------------
--Adicionar columnas a la Tabla OPERACION.PARAMETRO_VTA_PVTA_ADC
ALTER TABLE OPERACION.PARAMETRO_VTA_PVTA_ADC
      ADD PVPAC_FLAG_SOL_CLI CHAR(1) DEFAULT 0;
            
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.PVPAC_FLAG_SOL_CLI
 IS 'flag a solicitud del cliente 0 : DEFAUL ; 1 : SOLICITADO POR EL CLIENTE';
 
 commit;
-----------------------------------------------------------------------------------
--Adicionar parametros etadirect
insert into opedd ( DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'Agendamiento automático: ', 'mensaje_agen_default', (Select tipopedd from tipopedd where abrev = 'etadirect'), 1);

insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 1, 'Estado Agendamiento automático', 'estado_agen_default', (Select tipopedd from tipopedd where abrev = 'etadirect'), 1);

insert into opedd (DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('Reagendamiento automático: ', 'mensaje_reagen_default', (Select tipopedd from tipopedd where abrev = 'etadirect'), 1);

insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'PM4', 'Time slot 6pm a 7pm', 'Time_slot_franja', (Select tipopedd from tipopedd where abrev = 'etadirect'), 1);

commit;
-----------------------------------------------------------------------------------
-- creacion de parametros tipo, subtipo, skill, franja
insert into OPERACION.TIPO_ORDEN_ADC (COD_TIPO_ORDEN, DESCRIPCION, TIPO_TECNOLOGIA, ESTADO, TIPO_SERVICIO, FLG_TIPO)
values ('HFCME', 'HFC MANTENIMIENTO ESPECIAL', 'HFC', 1,'Mantenimiento', 1);

insert into OPERACION.WORK_SKILL_ADC (COD_WORK_SKILL, DESCRIPCION, ESTADO)
values ('HFCME', 'HFC - MANTENIMIENTO ESPECIAL', 1);

insert into OPERACION.SUBTIPO_ORDEN_ADC (COD_SUBTIPO_ORDEN, DESCRIPCION, TIEMPO_MIN, ID_TIPO_ORDEN, ESTADO,ID_WORK_SKILL, GRADO_DIFICULTAD)
values ('HFCME', 'MANTENIMIENTO HFC ESPECIAL', 60,(select t.Id_Tipo_Orden from operacion.tipo_orden_adc t where  t.cod_tipo_orden = 'HFCME' and t.descripcion = 'HFC MANTENIMIENTO ESPECIAL' and T.TIPO_TECNOLOGIA = 'HFC'), 1, (select t.id_work_skill from operacion.work_skill_adc t where t.cod_work_skill = 'HFCME' and t.descripcion = 'HFC - MANTENIMIENTO ESPECIAL'), 1);

insert into operacion.franja_horaria (CODIGO, DESCRIPCION, FRANJA, FRANJA_INI, IND_MERID_FI, FRANJA_FIN, IND_MERID_FF, FLG_AP_CTR)
values ('PM4', 'Time slot 6pm a 7pm', '06:00 - 07:00', '06:00', 'PM', '07:00', 'PM', 1);

commit;
-----------------------------------------------------------------------------------


