#!/bin/bash
# 6_menu_dialog.sh
# Menú principal del laboratorio para ejecutar los scripts 1–5.

while true; do
    opcion=$(dialog --title "Laboratorio SO 2025" \
        --menu "Seleccione una opción" 20 60 8 \
        1 "Verificar archivo ejecutable" \
        2 "Descargar usuarios y fotos" \
        3 "Autenticar usuario" \
        4 "Filtrar descargas (token)" \
        5 "Autenticar y notificar a Telegram" \
        6 "Salir" 3>&1 1>&2 2>&3)

    clear

    case $opcion in
        1)
            RUTA=$(dialog --inputbox "Ingrese la ruta del archivo ejecutable:" 10 60 3>&1 1>&2 2>&3)
            clear
            bash 1_verificar_ejecutable.sh "$RUTA"
            read -p "Presione Enter para continuar..."
            ;;
        2)
            N=$(dialog --inputbox "Ingrese la cantidad de usuarios a generar:" 10 60 3>&1 1>&2 2>&3)
            clear
            bash 2_descargar_usuarios.sh "$N"
            read -p "Presione Enter para continuar..."
            ;;
        3)
            USR=$(dialog --inputbox "Ingrese el nombre de usuario:" 10 60 3>&1 1>&2 2>&3)
            PASS=$(dialog --passwordbox "Ingrese la contraseña:" 10 60 3>&1 1>&2 2>&3)
            clear
            bash 3_autenticar_usuario.sh "$USR" "$PASS"
            read -p "Presione Enter para continuar..."
            ;;
        4)
            URL=$(dialog --inputbox "Ingrese la URL:" 10 60 3>&1 1>&2 2>&3)
            TOKEN=$(dialog --inputbox "Ingrese el token a buscar:" 10 60 3>&1 1>&2 2>&3)
            clear
            bash 4_filtrar_descargas.sh "$URL" "$TOKEN"
            read -p "Presione Enter para continuar..."
            ;;
        5)
            USR=$(dialog --inputbox "Ingrese el nombre de usuario:" 10 60 3>&1 1>&2 2>&3)
            PASS=$(dialog --passwordbox "Ingrese la contraseña:" 10 60 3>&1 1>&2 2>&3)
            clear
            bash 5_autenticar_y_notificar.sh "$USR" "$PASS"
            read -p "Presione Enter para continuar..."
            ;;
        6)
            clear
            echo "Saliendo..."
            break
            ;;
    esac
done

clear
