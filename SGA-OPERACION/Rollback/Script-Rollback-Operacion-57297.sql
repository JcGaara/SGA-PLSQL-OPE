delete   opedd where TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG');
delete   opedd where TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev = 'PERCARMASTARJ');
delete   opedd where TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_PARAMETROS');
delete   opedd where TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO');
delete   opedd where TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev = 'CORREO_SOAP_BOUQUET_DTH');
delete   opedd where TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_TIPEQU');
delete tipopedd where ABREV in ('BOUQUET_DTH_MSG', 'PERCARMASTARJ', 'BOUQUET_DTH_PARAMETROS', 'BOUQUET_DTH_ESTADO', 'CORREO_SOAP_BOUQUET_DTH', 'BOUQUET_TIPEQU' );
-- eliminar package y procedures nuevos
drop package OPERACION.pq_revision_bouquets_dth;
drop procedure OPERACION.P_CONSULTA_BOUQUET_DTH;
drop procedure OPERACION.P_CONSULTA_SOT_X_DNI;
/