CREATE OR REPLACE FUNCTION OPERACION.F_VALIDA_CHG_ESTOT(lv_usuario varchar2,lv_estot NUMBER) return number
/******************************************************************************
   NOMBRE:      F_VALIDA_CHG_ESTOT
   DESCRIPCION:    Valida si el usuario tiene permisos para cambiar al estado 3 (Ejecutado Totalmente) de una Order de trabajo(OT)

   REVISIONES:
   Version     Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------------------
   1.0        09/10/2007  Hector Huaman
******************************************************************************/
is
   l_count number;
   l_return number;

begin

   l_count := 0;

   select count(*) into l_count from usuarioope
                    where
                    codcon is not null and codcon <> 0
                    and usuario=lv_usuario;

    if l_count > 0 and lv_estot=3 then
        l_return := 0;
    else
        l_return := 1;
    end if;

    return l_return;

end;
/


