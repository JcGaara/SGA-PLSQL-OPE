CREATE OR REPLACE FUNCTION OPERACION.F_GET_DIAS_PLAZO(a_codsolot number)
return number is
  ln_result number;
/*  ln_num_dias_PEX number(3);
  ln_num_dias_PIN number(3);
  ln_num_dias_PRO number(3);
  ln_num_dias_TRA number(3);*/
begin
  ln_result := 0;
 /* if(A_CODEF <> 0) then
		begin
    */
    select nvl(max(ef.numdiapla),0)
    into ln_result
    from solot s, ef
    where
    s.numslc = ef.numslc and
    s.codsolot = a_codsolot;
/*			  SELECT SUM(SOLEFXAREA.NUMDIAPLA) INTO ln_num_dias_PEX
        FROM SOLEFXAREA, AREAOPE
        WHERE ( AREAOPE.AREA = SOLEFXAREA.AREA ) and  ( ( solefxarea.codef = A_CODEF) )
              and TRIM(AREAOPE.AREA_OF_OPERA) = 'PEX';

        if (ln_num_dias_PEX is null) then
           ln_num_dias_PEX := 1;
        else
           ln_num_dias_PEX := ln_num_dias_PEX + 1;
        end if;*/

 /*       SELECT SUM(SOLEFXAREA.NUMDIAPLA) INTO ln_num_dias_PIN
        FROM SOLEFXAREA, AREAOPE
        WHERE ( AREAOPE.AREA = SOLEFXAREA.AREA ) and  ( ( solefxarea.codef = A_CODEF) )
              and TRIM(AREAOPE.AREA_OF_OPERA) = 'PIN';

        if (ln_num_dias_PIN is null) then
           ln_num_dias_PIN := 0;
        end if;

        SELECT SUM(SOLEFXAREA.NUMDIAPLA) INTO ln_num_dias_PRO
        FROM SOLEFXAREA, AREAOPE
        WHERE ( AREAOPE.AREA = SOLEFXAREA.AREA ) and  ( ( solefxarea.codef = A_CODEF) )
              and TRIM(AREAOPE.AREA_OF_OPERA) = 'PRO';

        if (ln_num_dias_PRO is null) then
           ln_num_dias_PRO := 0;
        end if;

        SELECT SUM(SOLEFXAREA.NUMDIAPLA) INTO ln_num_dias_TRA
        FROM SOLEFXAREA, AREAOPE
        WHERE ( AREAOPE.AREA = SOLEFXAREA.AREA ) and  ( ( solefxarea.codef = A_CODEF) )
              and TRIM(AREAOPE.AREA_OF_OPERA) = 'TRA';

        if (ln_num_dias_TRA is null) then
           ln_num_dias_TRA := 0;
        end if;

        if ln_num_dias_PEX > ln_num_dias_PIN then
           begin
                if ln_num_dias_PRO> ln_num_dias_TRA then
                   if ln_num_dias_pex > ln_num_dias_PRO then
                      ln_result := ln_num_dias_pex;
                    else
                      ln_result := ln_num_dias_pro;
                    end if;
                 else
                     if ln_num_dias_pex > ln_num_dias_tra then
                       ln_result := ln_num_dias_pex;
                     else
                       ln_result := ln_num_dias_tra;
                     end if;
                end if;
           end;
        else
            begin
                 if ln_num_dias_PRO> ln_num_dias_TRA then
                   if ln_num_dias_pin > ln_num_dias_PRO then
                      ln_result := ln_num_dias_pin;
                    else
                      ln_result := ln_num_dias_pro;
                    end if;
                 else
                     if ln_num_dias_pin > ln_num_dias_tra then
                       ln_result := ln_num_dias_pin;
                     else
                       ln_result := ln_num_dias_tra;
                     end if;
                end if;
            end;
        end if;
       */
/*		end;
	end if;*/
  return ln_result;
end ;
/


