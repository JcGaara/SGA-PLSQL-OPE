CREATE OR REPLACE FUNCTION OPERACION.F_CUPONERA (s_Contrato Char) RETURN CHAR IS
cn_Fecha VarChar2(10);
ln_pid number;
BEGIN

 /* -- Cuponera
 Begin
  select TO_CHAR(a.fecfinvig,'MM/DD/YYYY') Into cn_Fecha
   from reginsdth a,contrato b
           where a.codcli=b.codcli
             and substr(b.nrodoc_contrato,1,1)='D'
             and Substr(b.nrodoc_contrato,2)= s_Contrato
             And a.fecfinvig is not null;
     EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cn_Fecha := 'ERROR';
 END;
 Return cn_Fecha;*/
 Begin
  select pid
    into ln_pid
    from reginsdth a, contrato b
   where a.codcli = b.codcli
     and substr(b.nrodoc_contrato, 1, 1) = 'D'
     and Substr(b.nrodoc_contrato, 2) = s_Contrato
     And a.fecfinvig is not null;

  select to_char(max(fecven), 'MM/DD/YYYY')
    Into cn_Fecha
    from cxctabfac
   where idfac in
         (select idfaccxc
            from bilfac
           where idbilfac in
                 (select idbilfac
                    from cr
                   where idinstprod in (select idinstprod
                                          from instxproducto
                                         where pid in (ln_pid))))
     and estfac in ('02', '04');
 EXCEPTION
    WHEN NO_DATA_FOUND THEN
      cn_Fecha := 'ERROR';
 END;

 Return cn_Fecha;
END;
/


