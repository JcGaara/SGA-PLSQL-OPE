--1.- CODIGO AUXILIAR PARA DESHABILITAR LA OPCION DE TIPO DE TRABAJO
alter table operacion.siac_negocio_err
drop column flg_lte;

delete from operacion.opedd 
      where codigoc='0004' 
	    and abreviacion=(select codsrv from sales.tystabsrv where dscsrv='Inst. WLL - Servicios Adicionales - Telefonía Fija') 
		and tipopedd=(select tipopedd from operacion.tipopedd where abrev='PUNTO_ADIC_LTE' and descripcion='Config. Punto Adicional LTE');

delete from operacion.tipopedd where abrev='PUNTO_ADIC_LTE' and descripcion='Config. Punto Adicional LTE';

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('1',
   (select TIPTRA
    from TIPTRABAJO
    WHERE DESCRIPCION = 'WLL/SIAC - TRASLADO EXTERNO'),
   'WLL/SIAC - TRASLADO EXTERNO',
   'WLL/SIAC - TRASLADO EXTERNO',
   (select T.TIPOPEDD
    from OPERACION.TIPOPEDD T
    WHERE T.ABREV = 'TIPO_TRANS_SIAC_LTE'),
   1);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('1',
   (select TIPTRA
    from TIPTRABAJO
    WHERE DESCRIPCION = 'WLL/SIAC - TRASLADO INTERNO'),
   'WLL/SIAC - TRASLADO INTERNO',
   'WLL/SIAC - TRASLADO INTERNO',
   (select T.TIPOPEDD
    from OPERACION.TIPOPEDD T
    WHERE T.ABREV = 'TIPO_TRANS_SIAC_LTE'),
   1);

UPDATE opedd d
   SET d.codigon_aux = 5
 WHERE d.tipopedd = (SELECT tipopedd
                       FROM tipopedd t
                      WHERE t.abrev = 'TIPO_TRANS_SIAC_LTE')
   AND d.descripcion IN
       ('WLL/SIAC - SUSPENSION A SOLIC. DEL CLIENTE',
        'WLL/SIAC - RECONEXION A SOLIC. DEL CLIENTE');

UPDATE opedd d
   SET d.codigon_aux = 1
 WHERE d.tipopedd = (SELECT tipopedd
                       FROM tipopedd t
                      WHERE t.abrev = 'TIPO_TRANS_SIAC_LTE')
   AND d.descripcion IN ('WLL/SIAC - DECO ADICIONAL');

commit;

--2.- CODIGO AUXILIAR PARA RETENCION-ASISTENCIA TECNICA

UPDATE opedd d
   SET d.codigon_aux = 5, d.codigoc = ''
 WHERE d.tipopedd = (SELECT tipopedd
                       FROM tipopedd t
                      WHERE t.abrev = 'TIPO_TRANS_SIAC_LTE')
   AND d.descripcion IN ('WLL/SIAC - RETENCION');

commit;

-- 3.- Deco Adicional
delete from operacion.opedd where tipopedd = ( select tipopedd from operacion.tipopedd where abrev = 'TIPEQU_LTE_ADICIONAL' );
delete from operacion.opedd where tipopedd = ( select tipopedd from operacion.tipopedd where abrev = 'TIPEQU_DECO_LTE' );
delete from operacion.opedd where tipopedd = ( select tipopedd from operacion.tipopedd where abrev = 'TIPTRAVALIDECO' );
delete from operacion.opedd where tipopedd in (select tipopedd from tipopedd where abrev = 'CONF_LTE_JANUS') and abreviacion = 'SIAC';
delete from operacion.opedd where tipopedd in ( select tipopedd from tipopedd where abrev = 'CON_EST_SGA_LTE' );
commit;

delete from operacion.tipopedd where abrev = 'TIPEQU_LTE_ADICIONAL';
delete from operacion.tipopedd where abrev = 'TIPEQU_DECO_LTE';
delete from operacion.tipopedd where abrev = 'TIPTRAVALIDECO';
delete from operacion.tipopedd where abrev = 'CON_EST_SGA_LTE';
commit;

delete from operacion.opedd where tipopedd in (select tipopedd from operacion.tipopedd where abrev = 'TIPO_SLTD_ENV_CONAX') and codigoc in ('8','9');
commit;
/