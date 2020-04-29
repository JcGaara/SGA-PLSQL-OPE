/*Insertamos en la tabla constante*/
insert into OPERACION.CONSTANTE
  (CONSTANTE, DESCRIPCION, TIPO, CODUSU, FECUSU, VALOR, OBS)
values
  ('PROD_CLOUD_FAC',
   'Parametro de validacion fecfin producto Cloud',
   'N',
   SUBSTR(USER, 1, 30) ,
   SYSDATE,
   '1',
   null);

/*Creamos parametros en la tipopedd y opedd*/
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(TIPOPEDD) + 1 from tipopedd), 'Estados de Conciliacion Cloud', 'DATAV_ESTADO');

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '01',null, 'No Concilicar', null,
(select MAX(tipopedd) from tipopedd where upper(abrev)='DATAV_ESTADO'), null);
        
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '02',null, 'Concilicar', null,
(select MAX(tipopedd) from tipopedd where upper(abrev)='DATAV_ESTADO'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '03',null, 'Actualizar', null,
(select MAX(tipopedd) from tipopedd where upper(abrev)='DATAV_ESTADO'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), null,1, 'Activo', 'ESTINSPRD',
(select c.tipopedd from tipopedd c where c.abrev = 'CONFAC_CLOUD'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), null,2, 'Suspendido', 'ESTINSPRD',
(select c.tipopedd from tipopedd c where c.abrev = 'CONFAC_CLOUD'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), NULL,1, 'Activo', 'ESTPID',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
commit;
/