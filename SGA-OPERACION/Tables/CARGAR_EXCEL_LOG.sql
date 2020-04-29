-- Create table
create global temporary table OPERACION.CARGAR_EXCEL_LOG
(
  LINEA       VARCHAR2(30),
  CAMPO       VARCHAR2(30),
  OBSERVACION VARCHAR2(500)
)
on commit preserve rows;