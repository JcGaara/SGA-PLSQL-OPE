/*Creamos type*/
create or replace type operacion.split_tbl as table of varchar2(32767)
/

/*creamos parametros*/
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, (select wfdef from wfdef where descripcion = 'HFC/SIAC - BAJA DECO ALQUILER'), 'WORK FLOW SOLOT BAJA DECO ADICIONAL', 'WFBDECADIC', (select tipopedd 
                                                                           from tipopedd 
                                                                          where abrev = 'DECO_ADICIONAL'), 0);
                                                                          
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 667, 'SOLICITUD DE INSTALACION - BAJA', 'SOLINSBAJA', (select tipopedd 
                                                                           from tipopedd 
                                                                          where abrev = 'DECO_ADICIONAL'), 0);
                                                                          
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('705', null, 'REGISTRO BAJA DECO ADICIONAL TIPTRA', 'RBTIPTRA', (select tipopedd 
                                                                           from tipopedd 
                                                                          where abrev = 'DECO_ADICIONAL'), null);

/*Insertamos Data en la tabla operacion.TAB_DEC_ADI_MODELO*/

insert into operacion.TAB_DEC_ADI_MODELO (MODELO, COD_SGA, COD_SIAC, FECUSU, CODUSU, ESTADO)
values ('DCT3416-TWOWAY', '6968', null, SYSDATE, USER, 1);

insert into operacion.TAB_DEC_ADI_MODELO (MODELO, COD_SGA, COD_SIAC, FECUSU, CODUSU, ESTADO)
values ('DCT700-TWOWAY', 'AAOU', null, SYSDATE, USER, 1);

insert into operacion.TAB_DEC_ADI_MODELO (MODELO, COD_SGA, COD_SIAC, FECUSU, CODUSU, ESTADO)
values ('DCX3400', 'AAQG', null, SYSDATE, USER, 1);

insert into operacion.TAB_DEC_ADI_MODELO (MODELO, COD_SGA, COD_SIAC, FECUSU, CODUSU, ESTADO)
values ('DCX3500', 'AAKL', null, SYSDATE, USER, 1);

insert into operacion.TAB_DEC_ADI_MODELO (MODELO, COD_SGA, COD_SIAC, FECUSU, CODUSU, ESTADO)
values ('DCX700-TWOWAY', '8262', null, SYSDATE, USER, 1);

insert into operacion.TAB_DEC_ADI_MODELO (MODELO, COD_SGA, COD_SIAC, FECUSU, CODUSU, ESTADO)
values ('DTA 101 HD', 'AAXD', null, SYSDATE, USER, 1);

insert into operacion.TAB_DEC_ADI_MODELO (MODELO, COD_SGA, COD_SIAC, FECUSU, CODUSU, ESTADO)
values ('DTA100', 'AAOY', null, SYSDATE, USER, 1);


/*creamos parametro para el codigo de motivo*/

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 689, 'HFC/SIAC DECO ADICIONAL', 'SIAC-HFC-DECO_ADICIONAL', (select tipopedd 
                               from tipopedd 
                              where abrev = 'TRANS_POSTVENTA'), 2);

/*creamos una constante para el tipo de busqueda*/
insert into constante (CONSTANTE, DESCRIPCION, TIPO, VALOR, OBS)
values ('BAJADECO_SIAC  ', 'Constante para consulta de Baja de Deco Adicional', 'N', '1', null);

COMMIT;
/