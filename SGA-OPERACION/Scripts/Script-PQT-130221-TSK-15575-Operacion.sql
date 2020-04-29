--1.- CONFIGURACION DE PARAMETROS - Desact Contrato BAM - ATC
declare
ln_tipopedd number;
begin

select max(tipopedd) 
  into ln_tipopedd 
  from operacion.tipopedd;

insert into operacion.tipopedd
  (tipopedd,descripcion, abrev )
  values
  (ln_tipopedd + 1, 'Desact Contrato BAM - ATC','DESACT_CONT_BAMBAF_ATC');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'SGA', null, 'Aplicación', 'APP_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '172.19.24.102', null, 'IP Aplicación', 'IP_APP_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'POSTPAGO', null, 'Tipo de servicio del contrato en BSCS', 'TIPSRV_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '', 29, 'Motivo de desactivacion en BSCS', 'MOT_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'BAJA SOLICITADA DESDE EL SGA', null, 'Observación de la solicitud de desactivación', 'OBS_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '', 0, 'Flag OCC APADECE', 'FLGOCC_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '', 0, 'Flag ND Pcs', 'FLGND_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'NULL', null, 'Nd Área', 'NDAREA_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'NULL', null, 'ndMotivo', 'NDMOT_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'NULL', null, 'ndSubmotivo', 'NDSUBMOT_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'NULL', null, 'cacDac', 'CAC_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '', 0, 'montoPCS', 'MONPCS_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '', 0, 'montoFidelizacion', 'MONFID_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '', 1, 'trace', 'TRACE_DESAC_BAM_BSCS');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'USRSGA', null, 'Usuario de la Aplicacion que genera la desactivación', 'USR_APP_DESAC');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'SGA', null, 'Password de la Aplicacion que genera la desactivación', 'PWD_APP_DESAC');
commit;

end;
/
--2.- CONFIGURACION DE PARAMETROS - Reac Contrato BAM - ATC
declare
ln_tipopedd number;
begin

select max(tipopedd) 
  into ln_tipopedd 
  from operacion.tipopedd;

insert into operacion.tipopedd
  (tipopedd,descripcion, abrev )
  values
  (ln_tipopedd + 1, 'Reac Contrato BAM - ATC','REACT_CONT_BAMBAF_ATC');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '', 0, 'Costo de la reconexión', 'MON_REC_BAM');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '', 15, 'Número de días de reconexión', 'NRO_DIAS_REC');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'SGA', null, 'Password de la Aplicacion que genera reconexión', 'PWD_APP_REC');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'USRSGA', null, 'Usuario de la Aplicacion que genera reconexión', 'USR_APP_REC');

insert into opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'SGA', null, 'Aplicacion que genera la reconexión', 'APP_REC');
commit;

end;
/
--3.- CONFIGURACION DE PARAMETROS - Susp Contrato BAM - ATC
declare
ln_tipopedd number;
begin

select max(tipopedd) 
  into ln_tipopedd 
  from operacion.tipopedd;

insert into operacion.tipopedd
  (tipopedd,descripcion, abrev )
  values
  (ln_tipopedd + 1, 'Susp Contrato BAM - ATC','SUSP_CONT_BAMBAF_ATC');

insert into operacion.opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '', 15, 'Número de días de suspensión.', 'NDIAS_SUSP_BAM_BSCS');

insert into operacion.opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '', 60, 'Motivo por la cual se genera la suspensión', 'MOT_SUSP_BAM_BSCS');

insert into operacion.opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'SGA', null, 'Password de la Aplicacion que genera suspensiones', 'PWD_APP_SUSP');

insert into operacion.opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'USRSGA', null, 'Usuario de la Aplicacion que genera suspensiones', 'APP_SUSP');

insert into operacion.opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, 'SGA', null, 'Aplicacion que genera suspensiones', 'COD_USU_SUSP');

insert into operacion.opedd (TIPOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION)
values (ln_tipopedd + 1, '0', null, 'Fidelización', 'FID_SUSP');
commit;

end;
/
--4.-Adicionar campo TIPOPEDD en Tipos de acciones post venta
alter table OPERACION.TIPACCIONPV add TIPOPEDD NUMBER;
comment on column OPERACION.TIPACCIONPV.TIPOPEDD
  is 'Identificador único de la tabla OPERACION.TIPOPEDD';
  
--5.- Actualizar datos de TIPOPEDD
update operacion.tipaccionpv
   set tipopedd =
       (select t.tipopedd
          from operacion.tipopedd t
         where t.abrev = 'SUSP_CONT_BAMBAF_ATC')
 where idaccpv = 6;
update operacion.tipaccionpv
   set tipopedd =
       (select t.tipopedd
          from operacion.tipopedd t
         where t.abrev = 'REACT_CONT_BAMBAF_ATC')
 where idaccpv = 9;
update operacion.tipaccionpv
   set tipopedd =
       (select t.tipopedd
          from operacion.tipopedd t
         where t.abrev = 'DESACT_CONT_BAMBAF_ATC')
 where idaccpv = 12;
commit;

--6.- Actualizar datos de TIPO y FLG_CNR
update operacion.tipaccionpv set tipo = 1, flg_cnr = 0  where idaccpv in (6,9,12);
update operacion.tipaccionpv set tipo = 2, flg_cnr = 0  where idaccpv in (7,10);
update operacion.tipaccionpv set tipo = 3, flg_cnr = 0  where idaccpv in (8,11,20,21);
update operacion.tipaccionpv set flg_cnr = 1  where idaccpv in (6,7,8);
commit;
  
--7.-Insertamos los estados en la tabla cabecera y detalle
insert into tipopedd (descripcion) values ('Estados Bam-Baf');

insert into opedd
  (codigon, descripcion, tipopedd)
values
  (1, 'Pendiente', (select tipopedd from tipopedd where descripcion = 'Estados Bam-Baf'));

insert into opedd
  (codigon, descripcion, tipopedd)
values
  (2, 'En Ejecución', (select tipopedd from tipopedd where descripcion = 'Estados Bam-Baf'));

insert into opedd
  (codigon, descripcion, tipopedd)
values
  (3, 'Terminado OK', (select tipopedd from tipopedd where descripcion = 'Estados Bam-Baf'));

insert into opedd
  (codigon, descripcion, tipopedd)
values
  (4, 'Anulado', (select tipopedd from tipopedd where descripcion = 'Estados Bam-Baf'));
commit;

--8.-Adicionar campo NRODIAS en operacion.trsbambaf
alter table operacion.trsbambaf add NRODIAS NUMBER default 0;
comment on column operacion.trsbambaf.NRODIAS
  is 'Núrmero de Días';