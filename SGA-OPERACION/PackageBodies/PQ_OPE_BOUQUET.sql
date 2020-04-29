CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_OPE_BOUQUET is

 /******************************************************************************
     NAME:       PQ_BOUQUET
     PURPOSE:    Paquete para Administrar loa bouquets
     REVISIONS:
     Ver        Date        Author           Solicitado por        Description
     ---------  ----------  --------------   --------------        ------------------------------------
     1.0        27/09/2010  Alex Alamo                             Creacion RQ142944
     2.0        20/12/2010  Alfonso Pérez     Rolando Martinez     REQ 152190: se modifica el tipo de campo a almacenar.
     3.0        07/04/2011  Luis Patiño                            PROY: Suma de Cargos
  ******************************************************************************/

  FUNCTION F_CONCA_BOUQUET(AN_IDGRUPO ope_grupo_bouquet_cab.IDGRUPO %TYPE)
    RETURN ope_grupo_bouquet_cab.DESCRIPCION%TYPE IS
    CURSOR CURS_SRVBOU IS
      select a.idgrupo, B.codbouquet
        from ope_grupo_bouquet_cab A, ope_grupo_bouquet_DET B
       where (A.idgrupo = B.idgrupo)
         AND (A.IDGRUPO = AN_IDGRUPO)
	 and b.flg_activo = 1; --<3.0>

    LC_BOUQ     ope_grupo_bouquet_cab.DESCRIPCION %TYPE := '';
    -- Ini 2.0
    --LC_TEXTBOUQ ope_grupo_bouquet_cab.DESCRIPCION %TYPE := '';
    LC_TEXTBOUQ tystabsrv.CODIGO_EXT %TYPE := '';
    -- Fin 2.0
  BEGIN

    FOR SR IN CURS_SRVBOU LOOP
      LC_BOUQ     := TO_CHAR(SR.codbouquet);
      LC_TEXTBOUQ := TO_CHAR(LC_TEXTBOUQ || ' ' || LC_BOUQ);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(LC_TEXTBOUQ);

    RETURN LC_TEXTBOUQ;

  END;

  FUNCTION F_CONCA_BOUQUET_C(AN_IDGRUPO ope_grupo_bouquet_cab.IDGRUPO %TYPE)
    RETURN ope_grupo_bouquet_cab.DESCRIPCION%TYPE IS
    CURSOR CURS_SRVBOU IS
      select a.idgrupo, B.codbouquet
        from ope_grupo_bouquet_cab A, ope_grupo_bouquet_DET B
       where (A.idgrupo = B.idgrupo)
         AND (A.IDGRUPO = AN_IDGRUPO)
         and b.flg_activo = 1;

    LC_BOUQ     ope_grupo_bouquet_cab.DESCRIPCION %TYPE := '';
    --Ini 2.0
    --LC_TEXTBOUQ ope_grupo_bouquet_cab.DESCRIPCION %TYPE := '';
    LC_TEXTBOUQ tystabsrv.CODIGO_EXT %TYPE := '';
    --Fin 2.0
  BEGIN

    FOR SR IN CURS_SRVBOU LOOP
      LC_BOUQ     := TO_CHAR(SR.codbouquet);
      LC_TEXTBOUQ := TO_CHAR(LC_TEXTBOUQ || ',' || LC_BOUQ);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(LC_TEXTBOUQ);

    LC_TEXTBOUQ := substr(LC_TEXTBOUQ, 2);

    RETURN TRIM(LC_TEXTBOUQ);

  END;

  PROCEDURE PROC_CONCA_BOUQUET(AN_IDGRUPO  ope_grupo_bouquet_cab.IDGRUPO %TYPE,
                               a_resultado out varchar2) IS

    CURSOR CURS_SRVBOU IS
      select a.idgrupo, B.codbouquet
        from ope_grupo_bouquet_cab A, ope_grupo_bouquet_DET B
       where (A.idgrupo = B.idgrupo)
         AND (A.IDGRUPO = AN_IDGRUPO);

    LC_BOUQ     ope_grupo_bouquet_cab.DESCRIPCION %TYPE := '';
    --Ini 2.0
    --LC_TEXTBOUQ ope_grupo_bouquet_cab.DESCRIPCION %TYPE := '';
    LC_TEXTBOUQ tystabsrv.CODIGO_EXT %TYPE := '';
    --Fin 2.0

  BEGIN

    FOR SR IN CURS_SRVBOU LOOP
      LC_BOUQ     := TO_CHAR(SR.codbouquet);
      LC_TEXTBOUQ := TO_CHAR(LC_TEXTBOUQ || ',' || LC_BOUQ);
    END LOOP;

    a_resultado := substr(LC_TEXTBOUQ, 2);

    DBMS_OUTPUT.PUT_LINE(a_resultado);

  END;

  --<ini 3.0
  function f_conca_bouquet_srv_susp(ac_codsrv tystabsrv.codsrv%type)
    return ope_grupo_bouquet_cab.descripcion%type is
    cursor curs_srvbouq is
       select a.idgrupo, b.codbouquet
        from ope_grupo_bouquet_cab  a,
             ope_grupo_bouquet_det  b,
             tys_tabsrvxbouquet_rel c
       where c.codsrv = ac_codsrv
         and c.stsrvb = 1 --primario
         and a.idgrupo = c.idgrupo
         and a.idgrupo = b.idgrupo
         and b.flg_activo = 1
         and not exists (select null
                        from ope_grupo_bouquet_cab  aa,
                             ope_grupo_bouquet_det  bb,
                             tys_tabsrvxbouquet_rel cc
                       where cc.codsrv = c.codsrv
                         and b.codbouquet = bb.codbouquet
                         and cc.stsrvb = 3 --media suspension
                         and aa.idgrupo = cc.idgrupo
                         and aa.idgrupo = bb.idgrupo
                         and bb.flg_activo = 1)
        order by b.codbouquet asc;

    lc_bouq     ope_grupo_bouquet_cab.descripcion %type := '';
    lc_textbouq tystabsrv.codigo_ext %type := '';

  begin

    for c1 in curs_srvbouq loop
      lc_bouq     := TO_CHAR(c1.codbouquet);
      lc_textbouq := TO_CHAR(lc_textbouq || ',' || lc_bouq);
    end loop;

    DBMS_OUTPUT.PUT_LINE(lc_textbouq);

    lc_textbouq := substr(lc_textbouq, 2);

    return trim(lc_textbouq);

  end;

  function f_conca_bouquet_srv(ac_codsrv tystabsrv.codsrv%type)
    return ope_grupo_bouquet_cab.descripcion%type is
    cursor curs_srvbouq is
       select a.idgrupo, b.codbouquet
        from ope_grupo_bouquet_cab  a,
             ope_grupo_bouquet_det  b,
             tys_tabsrvxbouquet_rel c
       where c.codsrv = ac_codsrv
         and c.stsrvb = 1 --primario
         and a.idgrupo = c.idgrupo
         and a.idgrupo = b.idgrupo
         and b.flg_activo = 1
        order by b.codbouquet asc;

    lc_bouq     ope_grupo_bouquet_cab.descripcion %type := '';
    lc_textbouq tystabsrv.codigo_ext %type := '';

  begin

    for c1 in curs_srvbouq loop
      lc_bouq     := TO_CHAR(c1.codbouquet);
      lc_textbouq := TO_CHAR(lc_textbouq || ',' || lc_bouq);
    end loop;

    DBMS_OUTPUT.PUT_LINE(lc_textbouq);

    lc_textbouq := substr(lc_textbouq, 2);

    return trim(lc_textbouq);

  end;
 -- fin 3.0>

END PQ_OPE_BOUQUET;
/


