-- Eliminacion de la configuracion de los Tipos de Trabajo
delete from opedd t
 where t.abreviacion in('TIPTRA_OV','TIPTRA_VAL_OV')
   and t.tipopedd =
       (select t.tipopedd from tipopedd t where t.abrev = 'PRC_HFC_OPT_OV')
   and t.codigon_aux = 0;


-- Eliminacion de la configuracion de EST_SOT
delete from opedd t
 where t.abreviacion = 'EST_SOT'
   and t.tipopedd =
       (select t.tipopedd from tipopedd t where t.abrev = 'PRC_HFC_OPT_OV')
   and t.descripcion = 'GENERADA';

  
-- Eliminacion de la configuracion Mejoras Reclamos
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd from operacion.tipopedd where abrev = ('reclamos'));

delete from operacion.tipopedd where abrev = ('reclamos');


-- Eliminacion de la configuracion de Tipos de Trabajo
delete from operacion.opedd t
 where t.codigon in(725,726,790)
   and t.descripcion in('HFC - RECLAMO CLARO EMPRESAS','WIMAX - RECLAMO MANTENIMIENTO CLARO EMPRESAS','DTH - RECLAMO CLARO EMPRESAS')
   and t.tipopedd = 1235;

delete from operacion.opedd t
 where t.codigon = 791
   and t.descripcion = 'WLL/SIAC - RECLAMO CLARO EMPRESAS'
   and t.tipopedd = 1466;


-- Eliminacion de los Motivos de Trabajo
delete from operacion.mototxtiptra
where TIPTRA = 407 and CODMOTOT in (28,35,41,45,49,50,115,116,117,120,121,122,123,131,141,142,143,144,145,146,147,148,149,150,151,152,153,
                                    154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,174,175,176,177,178,179,181,182,
                                    183,185,186,188,201,204,205,206,247,249,250,251,254,257,258,259,263,264,268,273,274,275,277,278,283,294,
                                    297,301,305,306,307,311,313,315,316,320,321,324,325,326,328,329,334,335,336,339,341,343,345,346,349,350,
                                    351,357,359,364,365,366,369,370,379,380,381,382,385,386,390,391,392,397,399,400,401,522,524,525,526,527,
                                    533,534,535,541,596,597,603,611,646,647,648,650,651,652,653,656,659,660,661,662,663,664,665,666,667,668,
                                    670,671,673,674,675,677,678,679,684,824,826,831,839,843,845,846,854,855,862,863,864,865,866,869,870,877,
                                    931,935,937,961,969,976,977,978,979,980,986);

delete from  operacion.mototxtiptra
where TIPTRA = 725 and CODMOTOT in (28,35,41,45,49,50,58,59,60,61,62,63,65,67,91,97,115,116,117,120,121,122,123,131,141,142,143,144,145,146,
                                    147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,174,
                                    175,176,177,178,179,181,182,183,185,186,188,201,204,205,206,213,217,229,247,249,250,251,254,257,258,259,
                                    263,264,268,273,274,275,277,278,283,294,297,301,305,306,307,311,313,315,316,320,321,324,325,326,328,329,
                                    334,335,336,339,341,343,345,346,349,350,351,357,359,364,365,366,369,370,379,380,381,382,385,386,390,391,
                                    392,397,399,400,401,408,410,411,412,414,417,423,426,435,454,472,473,522,524,525,526,527,533,534,535,541,
                                    556,567,572,575,593,596,597,603,605,611,646,647,648,650,651,652,653,656,659,660,661,662,663,664,665,666,
                                    667,668,670,671,673,674,675,677,678,679,684,824,826,831,839,843,845,846,851,854,855,862,863,864,865,866,
                                    869,870,877,902,907,916,917,926,931,935,937,961,969,976,977,978,979,980,986);

delete from operacion.mototxtiptra
where TIPTRA = 726 and CODMOTOT in (38,149,167,168,186,188,441,847,866);

delete from operacion.mototxtiptra
where TIPTRA = 727 and CODMOTOT in (151,152,154,155,156,157,159,189,190,191,192,193,194,196,197,198,199,200,613,615,616,617,618,619,676);

delete from operacion.mototxtiptra
where TIPTRA = 752 and CODMOTOT in (132,141,142,144,146,147,148,149,155,162,164,167,168,175,178,181,183,186,188,205,206,248,251,254,376,
                                    379,382,385,386,401,541,547,626,639,664,701,703,704,705,706,708,711,713,830,866,976,986,995,999);

delete from operacion.mototxtiptra
where TIPTRA = 790 and CODMOTOT in (151,152,154,155,156,157,159,189,190,191,192,193,194,196,197,198,199,200,613,615,616,617,618,619,676);

delete from operacion.mototxtiptra
where TIPTRA = 791 and CODMOTOT in (132,141,142,144,146,147,148,149,155,162,164,167,168,175,178,181,183,186,188,205,206,248,251,254,376,379,
                                    382,385,386,401,541,547,626,639,664,701,703,704,705,706,708,711,713,830,866,976,986,995,999);


-- Eliminacion de Estados de Agendamientos
delete from operacion.SECUENCIA_ESTADOS_AGENDA t
 where t.tiptra = 725
   and t.estagendaini || '-' || t.estagendafin = ('64-2');

delete from operacion.SECUENCIA_ESTADOS_AGENDA t
 where t.tiptra = 752
   and t.estagendaini || '-' || t.estagendafin in ('1-36','1-34','4-2','4-34','16-2','16-34','22-2','22-34','36-2','36-34','40-2','41-2',
                                                   '43-2','44-2','45-2','51-2','51-34','64-2','68-2','86-2');

update operacion.SECUENCIA_ESTADOS_AGENDA t
   set t.tipo = null
 where t.tiptra = 407
   and t.estagendaini || '-' || t.estagendafin in
       ('1-2','1-36','1-34','4-2','4-34','16-2','16-34','22-2','22-34','36-2','36-34','40-2','41-2',
        '43-2','44-2','45-2','51-2','51-34','64-2','68-2','86-2');

delete from operacion.SECUENCIA_ESTADOS_AGENDA t where t.tiptra = 791;

delete from operacion.SECUENCIA_ESTADOS_AGENDA t where t.tiptra = 727;

delete from operacion.SECUENCIA_ESTADOS_AGENDA t where t.tiptra = 790;

-- Eliminacion de Motivos de Solucion
delete from operacion.mot_solucionxtiptra t where t.tiptra in (752, 791, 727, 790);

-- Eliminacion de Tablas
DROP TABLE OPERACION.SGAT_TIPTRA_RECLA;
DROP TABLE OPERACION.SGAT_TIPTRA_RECLA_SOT;
DROP TABLE OPERACION.SGAT_RECLAMO_SOT;
DROP TABLE OPERACION.SGAT_REGLAS_CIERRE;

commit;
