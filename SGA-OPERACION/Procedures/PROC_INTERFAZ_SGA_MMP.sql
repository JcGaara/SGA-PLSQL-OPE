CREATE OR REPLACE PROCEDURE OPERACION.PROC_INTERFAZ_SGA_MMP( snb VARCHAR2, tipoSOT NUMBER, motivoSOT NUMBER,code VARCHAR2, a_idwf NUMBER)
AS LANGUAGE JAVA
NAME 'InterfazTelefonia.ejecutaProcesoInterfaz(java.lang.String, int, int, java.lang.String,int)';
/


