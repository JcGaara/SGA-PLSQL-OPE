CREATE OR REPLACE FUNCTION OPERACION.F_VALIDACION_TIPTRA_PRODUCTO(p_codsolot in number)
return number
/*********************
 Funcion que retorna cero si se encontraron todos los productos de la SOT correctamente configurados
 Roy Concepcion  -  12/06/2008
*******************/
is
l_count number;
l_retorno number;
l_countpro number;
cursor c1 is
 select t.idproducto,s.codsrvnue, p.tiptra
 from solotpto s,inssrv i,tystabsrv t, solot p
 where s.codsolot = p.codsolot and
       i.codinssrv = s.codinssrv and
       i.codsrv = t.codsrv and
       p.estsol = 10 and
       s.codsolot = p_codsolot;
BEGIN
    l_retorno := 0;
    for cn1 in c1 loop
        select count(1) into l_count from operacion.opetiptraproducto where idproducto = cn1.idproducto and tiptra = cn1.tiptra;
        select count(1) into l_countpro from operacion.opetiptraproducto where idproducto = cn1.idproducto;
        if l_count = 0 and l_countpro > 0 then
           l_retorno := 1;
           exit;
        end if;
    end loop;
    return l_retorno;
end;
/


