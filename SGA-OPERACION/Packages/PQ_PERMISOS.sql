CREATE OR REPLACE PACKAGE OPERACION.PQ_PERMISOS IS
/******************************************************************************
 Funciones para detectar permisos para las diferentes transacciones
 Se basa en el usuario conectado a la base de datos

 0 no tiene permiso
 1 tiene permiso
******************************************************************************/
FUNCTION seg_concluir_ot(a_codot in Number ) Return Number;
FUNCTION seg_anular_ot(a_codot in Number ) Return Number;
FUNCTION seg_aprobar_solot(a_codsolot in Number ) Return Number;
FUNCTION seg_anular_solot(a_codsolot in Number ) Return Number;

END PQ_PERMISOS;
/


