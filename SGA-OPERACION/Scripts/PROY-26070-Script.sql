/*********  Insertar Constantes ************/
insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('PORT_CP_EST_CP', 'ESTADO PROCESO CP.', 'C', '00A07');

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('PORT_CP_EST_POR', 'ESTADO PORTABILIDAD.', 'C', '00A08');

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('PORT_CP_FEC_PRG', 'No puede realizarse la anulación de esta SEC por tener una fecha de programación. Comunicarse con Mesa de Portabilidad.', 'C', '');

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('PORT_CP_MAX', 'Maximo Numero de CP a realizar al Dia.', 'N', '1');

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('PORT_CP_MAX_MSJ', 'Se ha ejecutado la cantidad Maxima de Consultas Previas del dia por Proyecto.', 'C', 'Mensaje Maximo Numero');


insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('PORT_CP_PRO_ROL', 'PROCESO ROLLBACK.', 'C', 'CP');

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('PORT_CP_REC_TO', 'Rechazo de Time OUT.', 'C', 'REC01ABD11');

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('PORT_CP_TIME_OU', 'Maximo Numero de Envios por Time OUT', 'N', '3');

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('PORT_CP_URL', 'URL DE CONSULTA PREVIA DE PORTAILIDAD.', 'C', 'http://172.19.74.222:8903/EnvioPortaWS/ebsEnvioPortaSB11?wsdl');

commit;

/*********  Insertar Tipos y Estados  ************/

insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('CONF. CAMPANHAS PORTABILIDAD', 'CAMP_PORT_CORP');

insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('CONF. RECHAZOS PORTABILIDAD', 'CON_REC_VAL_PORT');

insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('CONF. ESTADOS PORTABILIDAD', 'CONF_EST_PORT');

commit;

insert into operacion.opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 79, 'Portabilidad Fija', '79', ( select tipopedd from operacion.tipopedd where abrev = 'CAMP_PORT_CORP' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 93, 'Licitación - Portabilidad Fija', '93', ( select tipopedd from operacion.tipopedd where abrev = 'CAMP_PORT_CORP' ));
commit;

insert into operacion.opedd ( CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 'REC01ABD04', 'La numeración no pertenece al operador cedente', 'REC_PORT', ( select tipopedd from operacion.tipopedd where abrev = 'CON_REC_VAL_PORT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 'REC01PRT08', 'El número telefónico no corresponde a la modalidad indicada (Prepago/PostPago)', 'REC_PORT', ( select tipopedd from operacion.tipopedd where abrev = 'CON_REC_VAL_PORT' ));
commit;


insert into operacion.opedd ( CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( '05A03', 'En Proceso de Envío CP', 'ENVIO_CP', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_EST_PORT' ));
commit;
/