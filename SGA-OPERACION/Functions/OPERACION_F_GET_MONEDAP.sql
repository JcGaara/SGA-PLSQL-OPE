create or replace function operacion.f_get_monedap(an_codact number) return varchar2 
/*****************************************************************
* Nombre  : f_get_monedap
* Descripción : Devuelve la moneda del costo preciario
* Input : an_codact - codigo de actividad
* Output : Devuelve la moneda del costo preciario
* Creado por : Miriam Mandujano
* Fec Creación : 03/12/2013
* Fec Actualización : 03/12/2013
*****************************************************************/
is
   ls_moneda    varchar2(5);
   ln_contador  number;
   LD_FECHA_MAX DATE;
   
begin

    select count(1)
    into   ln_contador
    from   OPERACION.ACTXPRECIARIO
    where  codact = an_codact
    and    activo = '1' ;

    if  ln_contador=0 then-- el costo es el ultimo ingresado
      
       SELECT MAX(B.FECMOD)
       INTO   LD_FECHA_MAX
       FROM   OPERACION.ACTXPRECIARIO A, OPERACION.PRECIARIO B
       WHERE  A.CODPREC = B.CODPREC
       AND    A.codact  = an_codact;
                               
       select C.SBLMON
       into   ls_moneda
       from   OPERACION.ACTXPRECIARIO A, OPERACION.PRECIARIO B,PRODUCCION.CTBTABMON C
       where  A.CODPREC = B.CODPREC
       AND    A.MONEDA_ID= C.MONEDA_ID
       AND    A.codact   = an_codact
       AND    B.FECMOD   = LD_FECHA_MAX
       AND    ROWNUM =1;

    elsif  ln_contador>1 then--el costo es el ultimo ingresado
    
       SELECT MAX(B.FECMOD)
       INTO   LD_FECHA_MAX
       FROM   OPERACION.ACTXPRECIARIO A, OPERACION.PRECIARIO B
       WHERE  A.CODPREC = B.CODPREC
       AND    A.codact  = an_codact
       AND    A.activo  = '1';
                         
       select  C.SBLMON
       into   ls_moneda
       from   OPERACION.ACTXPRECIARIO A, OPERACION.PRECIARIO B,PRODUCCION.CTBTABMON C
       where  A.CODPREC  = B.CODPREC
       AND    A.MONEDA_ID= C.MONEDA_ID
       AND    A.codact   = an_codact and activo = '1'
       AND    B.FECMOD   = LD_FECHA_MAX AND ROWNUM =1;
        
    else        

        select C.SBLMON
        into   ls_moneda
        from   OPERACION.ACTXPRECIARIO A,PRODUCCION.CTBTABMON C
        where  A.codact = an_codact
        AND    A.MONEDA_ID= C.MONEDA_ID
        and    A.activo = '1' ;

    end if;


    if nvl(ls_moneda,'0')='0' then
       ls_moneda:=' ';
    end if;

  return ls_moneda;
end;

/
