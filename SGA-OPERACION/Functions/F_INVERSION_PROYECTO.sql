CREATE OR REPLACE FUNCTION OPERACION.f_inversion_proyecto( a_codef in number) RETURN NUMBER IS
SALIDA NUMBER(15,2);
l_tipsrv ef.tipsrv%type;
l_numlinea number;
l_prelinea number;
l_costo number;
BEGIN
select tipsrv into l_tipsrv from ef where codef = a_codef;
select nvl((cosmo + cosmat + cosequ),0) + nvl(COSMO_S / 3.6, 0 ) into l_costo from ef where codef = a_codef;
if l_tipsrv = '0004' and l_costo <> 0 then
select nvl(sum(nrocanal),0) into l_numlinea from efpto where codef = a_codef;
select valor into l_prelinea from constante where constante = 'PRELINEA';
if l_numlinea <> 0 then
l_costo := l_costo + l_prelinea * l_numlinea;
else
l_costo := 0;
end if;
end if;
salida := l_costo;
RETURN SALIDA;
exception
when others then
return null;
END;
/


