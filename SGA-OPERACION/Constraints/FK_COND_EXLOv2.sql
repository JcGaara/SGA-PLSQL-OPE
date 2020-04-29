ALTER TABLE operacion.sgat_df_condicion_det
    ADD CONSTRAINT fk_cond_exlov2 FOREIGN KEY ( condn_idexppost )
        REFERENCES operacion.sgat_df_expresion_logica ( exlon_idexplog );
