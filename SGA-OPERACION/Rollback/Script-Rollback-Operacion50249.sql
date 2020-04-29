delete opedd where tipopedd = (select tipopedd from tipopedd where abrev = 'REPORTE_HFC_RVENTA');
delete tipopedd where abrev = 'REPORTE_HFC_RVENTA';

delete opedd where tipopedd = (select tipopedd from tipopedd where abrev = 'REPORTE_HFC_TIPTRAVENA');
delete tipopedd where abrev = 'REPORTE_HFC_TIPTRAVENA';

delete opedd where tipopedd = (select tipopedd from tipopedd where abrev = 'REPORTE_HFC_FPSERVICIO');
delete tipopedd where abrev = 'REPORTE_HFC_FPSERVICIO';

delete opedd where tipopedd = (select tipopedd from tipopedd where abrev = 'REPORTE_HFC_CLEXCLUYENTES');
delete tipopedd where abrev = 'REPORTE_HFC_CLEXCLUYENTES';

delete opedd where tipopedd = (select tipopedd from tipopedd where abrev = 'REPORTE_HFC_CORREOSOAP');
delete tipopedd where abrev = 'REPORTE_HFC_CORREOSOAP';

delete opedd where tipopedd = (select tipopedd from tipopedd where abrev = 'REPORTE_HFC_CORREOUSU');
delete tipopedd where abrev = 'REPORTE_HFC_CORREOUSU';
commit;

Drop procedure operacion.p_reporte_ventas_hfc;
