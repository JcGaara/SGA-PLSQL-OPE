CREATE OR REPLACE FUNCTION OPERACION.F_VALIDACION_EFAUTOMATICO(lv_tipsrv varchar2,lv_idcampanha NUMBER,lv_acceso NUMBER,lv_tiptra NUMBER,lv_idproducto NUMBER) return number
/******************************************************************************
   NOMBRE:			F_VALIDACION_EFAUTOMATICO
   DESCRIPCION:		Valida si se repite la combinacion en cada registro de la tabla EFAUTOMATICO.

   REVISIONES:
   Version     Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------------------
   1.0        19/10/2007  Roy Concepcion
******************************************************************************/
is
   l_count number;
   l_return number;

begin

   l_count := 0;

   select count(*) into l_count from efautomatico
                    where (tipsrv=lv_tipsrv   OR lv_tipsrv is null)
                    and (idcampanha=lv_idcampanha  OR lv_idcampanha is null)
                    and (acceso =lv_acceso  OR lv_acceso is null)
                    and (tiptra =lv_tiptra   OR lv_tiptra is null)
                    and idproducto=lv_idproducto;

    if l_count = 0 then
        l_return := 0;
    else
        l_return := 1;
    end if;

    return l_return;

end;
/


