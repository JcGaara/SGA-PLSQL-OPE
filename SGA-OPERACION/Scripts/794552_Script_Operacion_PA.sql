-- Insercion de parametros para la configuracion de Punto adicional para LTE
insert into OPERACION.tipopedd (DESCRIPCION, ABREV)
VALUES ('Config. Punto Adicional LTE', 'PUNTO_ADIC_LTE');

insert into operacion.opedd (CODIGOC, ABREVIACION, DESCRIPCION, TIPOPEDD)
values ('0004', (select codsrv from sales.tystabsrv where dscsrv='Inst. WLL - Servicios Adicionales - Telefonía Fija'),'TELEFONIA LTE',(select tipopedd from operacion.tipopedd where ABREV = 'PUNTO_ADIC_LTE'));

insert into operacion.opedd
  (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values
  ((select tiptra from tiptrabajo where descripcion='WLL/SIAC - PUNTO ADICIONAL'),
   'TIPO DE TRABAJO DE PTO. ADIC. LTE',
   'TIPTRA_PTO_ADIC_LTE',
   (select tipopedd from tipopedd t where t.abrev = 'PUNTO_ADIC_LTE'));

--1.- CODIGO AUXILIAR PARA DESHABILITAR LA OPCION DE TIPO DE TRABAJO
UPDATE opedd d
   SET d.codigon_aux = 0
 WHERE d.tipopedd = (SELECT tipopedd
                       FROM tipopedd t
                      WHERE t.abrev = 'TIPO_TRANS_SIAC_LTE')
   AND d.descripcion IN
       ('WLL/SIAC - DECO ADICIONAL',
        'WLL/SIAC - SUSPENSION A SOLIC. DEL CLIENTE',
        'WLL/SIAC - RECONEXION A SOLIC. DEL CLIENTE');
		
--2.- CODIGO AUXILIAR PARA RETENCION-ASISTENCIA TECNICA
UPDATE opedd d
   SET d.codigon_aux = 1
 WHERE d.tipopedd = (SELECT tipopedd
                       FROM tipopedd t
                      WHERE t.abrev = 'TIPO_TRANS_SIAC_LTE')
   AND d.descripcion='WLL/SIAC - RETENCION';
COMMIT;
/