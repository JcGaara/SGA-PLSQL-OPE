create or replace package body operacion.pq_control_pin is
    /******************************************************************************
    NAME:       pq_control_pin
    Purpose:    --
     Ver        Date        Author            Solicitado por    Description
    ---------  ----------  ---------------   ----------------  --------------------
    1.0        20/10/2011  Mauro Zegarra
    *******************************************************************************/

     procedure p_envia_reporte_pin is

    /* CORREOS */
    cursor cur_dest is
    select o.descripcion 
        from operacion.tipopedd t, operacion.opedd o 
    where t.tipopedd = o.tipopedd 
        and t.abrev = 'PIN_MIN_DIS';

    vcuerpo varchar2(200); 
    ln_num_pin_dis number;
    lc_valor number;

    begin
        
        /* cantidad de pines disponibles */
        select count(1) 
            into ln_num_pin_dis 
            from sales.trsequi_pin_trs t 
        where t.estado = 0;

        /* cantidad minima de pines(constante)*/
        select valor 
            into lc_valor 
            from operacion.constante 
        where constante = 'CANMINPIN';

        /* CUERPO DEL REPORTE */
        vcuerpo := vcuerpo || 'Quedan menos de ' || lc_valor || ' PINs disponibles' || chr(13);

        /* ENVIO DEL CORREO */
        if ln_num_pin_dis < lc_valor then 
            FOR d IN CUR_dest LOOP
                OPEWF.PQ_SEND_MAIL_JOB.p_send_mail('Cantidad de PINES disponibles', d.descripcion,
                                                   vcuerpo,'SGA');
            END LOOP;
            commit;
        end if;
        
        exception
            when others then 
            dbms_output.put_line('Error al noticiar el reporte: ' || sqlerrm); 
            Rollback;
    end p_envia_reporte_pin;

end;
/