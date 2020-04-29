CREATE OR REPLACE FUNCTION OPERACION.is_number(a_number IN varchar2)
/******************************************************************************
     NOMBRE:       is_number
     DESCRIPCION:
     Función que recibe un valor numerico en formato char y devuelve un valor numerico en 1 o 0 1


  ver   Date        Author           Description
  ----  ----------  ---------------  ------------------------------------
  1.0   15/10/2009  Alfonso Pérez    Req. 123135 - Se modifica la forma de obtener valor numerico en char
  ******************************************************************************/
 return number is
  l_number number;
  v_number varchar2(100); --1.0
begin
  --l_number := to_number(a_number); -- <1.0>
  v_number := replace(a_number, 'E', 'X'); -- Solo se considera la mayuscula a pedido de EAstulle paa que no afecte la velocidad del proceso
  l_number := to_number(v_number);

  return 1;
exception
  when others then
    return 0;
end is_number;
/


