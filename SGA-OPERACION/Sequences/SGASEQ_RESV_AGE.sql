/*-- 
'****************************************************************
'* Nombre Secuencia : SGASEQ_RESV_AGE
'* Propósito : Generar un id de transaccion para CURSORES DE SALIDA
'* Output : -
'* Creado por : José Calle
'* Fec Creación : 05/03/2020
'* Fec Actualización : -
'****************************************************************
--*/

create sequence OPERACION.SGASEQ_RESV_AGE
minvalue 0
maxvalue 999999999999999999999999999
start with 4
increment by 1
nocache;
