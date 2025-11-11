#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/kmod.h>   // Para call_usermodehelper

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Equipo 2");
MODULE_DESCRIPTION("Primer módulo de kernel con integración a Telegram");
MODULE_VERSION("1.1");

static char *path_script = "/home/lautaro/laboratorio2025/modulo_kernel/send_telegram.sh";

// Función para ejecutar el script con el mensaje dado
static void enviar_mensaje_telegram(const char *mensaje) {
    char *argv[] = { "/bin/bash", path_script, (char *)mensaje, NULL };
    static char *envp[] = {
        "HOME=/",
        "PATH=/sbin:/bin:/usr/sbin:/usr/bin", 
        NULL
    };

    call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
}

// Al cargar el módulo
static int __init modulo2_init(void) {
    const char *mensaje = "Saludos desde el primer modulo de kernel creado por el equipo 2 para el laboratorio 1 de Sistemas Operativos 2025";
    printk(KERN_INFO "%s\n", mensaje);
    enviar_mensaje_telegram(mensaje);
    return 0;
}

// Al descargar el módulo
static void __exit modulo2_exit(void) {
    const char *mensaje = "El primer modulo de kernel creado por el equipo 2 para el laboratorio 2 de Sistemas Operativos 2025 se encuentra descargado";
    printk(KERN_INFO "%s\n", mensaje);
    enviar_mensaje_telegram(mensaje);
}

module_init(modulo2_init);
module_exit(modulo2_exit);

