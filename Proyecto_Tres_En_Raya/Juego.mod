MODULE Juego

    PROC Juega_Verde()

        ! La primera pieza verde la busca por Rastreo
        IF veces=1 THEN
            pieza_v{1}:=Rastreo(Cubo_Verde);
            ref_verde:=pieza_v{1};
            saltar{veces}:=FALSE;
            busqueda{veces}:=TRUE;

            ! El resto de veces se asigna dependiendo de la posicion especificada en el fichero
            ! Caso en el que la pieza a encontrar esté definida en el fichero:
        ELSEIF verdes{veces}=1 THEN
            
            pieza_v{veces}:=Offs(ref_verde,(veces-primera_verde)*dist_verd,0,0);
            ! En los casos en los que la primera pieza esté más alejada de lo normal
            IF pieza_v{veces}.trans.x > Fin_Cubo_Verde.trans.x THEN
                pieza_v{veces}:=Fin_Cubo_Verde;
            ENDIF
            
            saltar{veces}:=FALSE;
            busqueda{veces}:=FALSE;

            ! Si la pieza no se encuentra en el fichero se salta
        ELSE
            saltar{veces}:=TRUE;

        ENDIF

        ! Si la pieza se encuentra en el fichero y no hay salto:
        IF (saltar{veces}=FALSE) THEN
            ! Pone pieza verde
            PonerDado pieza_v{veces},busqueda{veces};
            ! Numero de piezas en el tablero aumenta
            n_piezas:=n_piezas+1;
        ENDIF

    ENDPROC


    PROC Juega_Rojo()

        VAR robtarget deja;

        IF repetir=FALSE THEN

            IF empieza=1 THEN

                IF veces=1 THEN
                    ! Busca la primera pieza roja
                    pieza_r{veces}:=Rastreo(punto_r);
                    ! Pone pieza roja
                    PonerDado pieza_r{veces},TRUE;
                    ! Empieza a buscar a partir de donde ha encontrado la última
                    punto_r:=pieza_r{veces};
                    ! Numero de piezas en el tablero aumenta
                    n_piezas:=n_piezas+1;
                ELSEIF (saltar{veces-1}=FALSE) THEN
                    ! Busca pieza roja
                    pieza_r{veces}:=Rastreo(punto_r);
                    ! Pone pieza roja
                    PonerDado pieza_r{veces},TRUE;
                    ! Empieza a buscar a partir de donde ha encontrado la última
                    punto_r:=pieza_r{veces};
                    ! Numero de piezas en el tablero aumenta
                    n_piezas:=n_piezas+1;
                ENDIF

            ELSE
                pieza_r{veces}:=Rastreo(punto_r);
                PonerDado pieza_r{veces},TRUE;
                punto_r:=pieza_r{veces};
                n_piezas:=n_piezas+1;

            ENDIF

        ELSE
            ! Inicializo la variable de interrupcion
            repetir:=FALSE;
            deja:=Menu(1);

            IWatch interrupcion;

            ! Movemos el robot a donde debe dejar la pieza
            MoveJ offs(deja,0,0,20),v300,fine,Pinza_Neumatica\WObj:=mesanegra;

            IF repetir=FALSE THEN
                MoveL deja,v100,fine,Pinza_Neumatica\WObj:=mesanegra;
            ENDIF

            ! Desactivo la interrupción
            ISleep interrupcion;

            IF repetir=FALSE THEN
                ! Dejamos la pieza y nos vamos a reposo
                AbrirPinza;
                MoveL offs(deja,0,0,20),v100,z10,Pinza_Neumatica\WObj:=mesanegra;
                MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;

                Comprueba;
                Ganado;
            ENDIF

        ENDIF

    ENDPROC

ENDMODULE