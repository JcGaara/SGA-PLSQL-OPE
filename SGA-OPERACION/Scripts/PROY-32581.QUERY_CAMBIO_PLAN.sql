  --------------------------------------------------------------------------------
  -- Insercion de la configuracion para SOt de Baja automatica
  --------------------------------------------------------------------------------
insert into  OPERACION.opedd  (codigon,descripcion,tipopedd,codigon_aux) 
                               values (753,'HFC - CAMBIO DE PLAN',402,0);
COMMIT;
--------------------------------------------------------------------------------
ALTER TABLE OPERACION.TIPEQU ADD TIPO_ABREV CHAR(3);
-- Add comments to the columns 
comment on column OPERACION.TIPEQU.TIPO_ABREV
  is 'Tipo de Decodificador: SD / HD /DVR';  
--------------------------------------------------------------------------------
update TIPEQU set tipo_abrev = 'DVR' WHERE CODTIPEQU = '018465';
update TIPEQU set tipo_abrev = 'SD' WHERE CODTIPEQU = '015804';
update TIPEQU set tipo_abrev = 'DVR' WHERE CODTIPEQU = '016667';
update TIPEQU set tipo_abrev = 'SD' WHERE CODTIPEQU = '017903';
update TIPEQU set tipo_abrev = 'HD' WHERE CODTIPEQU = '020928';
update TIPEQU set tipo_abrev = 'DVR' WHERE CODTIPEQU = '020976';
update TIPEQU set tipo_abrev = 'SD' WHERE CODTIPEQU = '020288';
update TIPEQU set tipo_abrev = 'HD' WHERE CODTIPEQU = '021790';
update TIPEQU set tipo_abrev = 'HD' WHERE CODTIPEQU = '024495';
update TIPEQU set tipo_abrev = 'DVR' WHERE CODTIPEQU = '024072';
update TIPEQU set tipo_abrev = 'DVR' WHERE CODTIPEQU = '024802';
update TIPEQU set tipo_abrev = 'HD' WHERE CODTIPEQU = '024803';
update TIPEQU set tipo_abrev = 'HD' WHERE CODTIPEQU = '023808';
COMMIT;  
--------------------------------------------------------------------------------
---CABECERA
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV)
      VALUES((SELECT MAX(tipopedd)+1 FROM OPERACION.TIPOPEDD),'CONFIGURACION TIPOS DECOS', 'CONF_TIPO_DECOS');
---DETALLE
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('SD', 'TIPO DECO STANDAR', 'CONF_TIPO_DECOS', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_TIPO_DECOS'));

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('DVR', 'TIPO DECO DVR', 'CONF_TIPO_DECOS', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_TIPO_DECOS'));

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('HD', 'TIPO DECO HD', 'CONF_TIPO_DECOS', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_TIPO_DECOS'));
commit;
