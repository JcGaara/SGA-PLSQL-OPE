create or replace function operacion.f_get_costop(an_codact number) return number 
/*****************************************************************
* Nombre  : f_get_costop
* Descripción : Devuelve el costo preciario
* Input : an_codact - codigo de actividad
* Output : Devuelve el costo preciario
* Creado por : Miriam Mandujano
* Fec Creación : 29/11/2013
* Fec Actualización : 29/11/2013
*****************************************************************/
is
   ln_costo    number;
   ln_contador number;
   LD_FECHA_MAX DATE;
   
begin

    select count(costo)
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
                               
       select A.COSTO
       into   ln_costo
       from   OPERACION.ACTXPRECIARIO A, OPERACION.PRECIARIO B
       where  A.CODPREC = B.CODPREC
       AND    A.codact  = an_codact
       AND    B.FECMOD  = LD_FECHA_MAX
       AND    ROWNUM =1;

    elsif  ln_contador>1 then--el costo es el ultimo ingresado
    
       SELECT MAX(B.FECMOD)
       INTO   LD_FECHA_MAX
       FROM   OPERACION.ACTXPRECIARIO A, OPERACION.PRECIARIO B
       WHERE  A.CODPREC = B.CODPREC
       AND    A.codact  = an_codact
       AND    A.activo  = '1';
                         
       select A.COSTO
       into   ln_costo
       from   OPERACION.ACTXPRECIARIO A, OPERACION.PRECIARIO B
       where  A.CODPREC = B.CODPREC
       AND    A.codact  = an_codact and    activo = '1'
       AND    B.FECMOD  = LD_FECHA_MAX AND    ROWNUM =1;
        
    else

        select costo
        into   ln_costo
        from   OPERACION.ACTXPRECIARIO
        where  codact = an_codact
        and    activo = '1' ;

    end if;


    if nvl(ln_costo,'0')='0' then
       ln_costo:=0;
    end if;

  return ln_costo;
end;

/