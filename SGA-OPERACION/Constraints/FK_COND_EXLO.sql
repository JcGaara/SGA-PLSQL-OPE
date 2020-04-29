ALTER TABLE operacion.sgat_df_condicion_det
    ADD CONSTRAINT fk_cond_exlo FOREIGN KEY ( condn_idexplog )
        REFERENCES operacion.sgat_df_expresion_logica ( exlon_idexplog );
