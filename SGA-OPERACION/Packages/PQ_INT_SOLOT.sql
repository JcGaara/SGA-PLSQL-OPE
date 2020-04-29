CREATE OR REPLACE PACKAGE OPERACION.PQ_INT_SOLOT IS

procedure p_exe_proceso (
   a_proceso in number
   ) ;

function f_get_id_proceso return number ;

procedure p_insert_int_solot (
   ar_int_solot in int_solot%rowtype
) ;

procedure p_agrupa_proceso (
   a_proceso in number
   ) ;


procedure p_crear_solot (
   a_proceso in number
   ) ;

procedure p_crear_solotpto (
   a_proceso in number,
   a_codsolot in number
) ;

END ;
/


