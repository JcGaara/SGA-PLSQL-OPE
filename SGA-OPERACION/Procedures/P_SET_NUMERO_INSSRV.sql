CREATE OR REPLACE PROCEDURE OPERACION.P_SET_NUMERO_INSSRV (
a_codinssrv in number,
a_formato in number,
a_param1 in varchar2 default null,
a_param2 in varchar2 default null
) IS
/******************************************************************************
Asigna el # de designacion a la IS
******************************************************************************/

BEGIN

   CUSBRA.P_BR_SET_NUMERO_INSSRV ( a_codinssrv , a_formato, 1, a_param1, a_param2 ) ;

END;
/


