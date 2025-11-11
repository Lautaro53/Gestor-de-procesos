#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void)
{
    char *valor_env;
    int n;
    pid_t pid1, pid2;

    // 1. Leer variable de entorno sistopernro
    valor_env = getenv("sistopernro");

    if (valor_env == NULL)
    {
        fprintf(stderr, "Error: la variable de entorno 'sistopernro' no está definida.\n");
        fprintf(stderr, "Ejemplo: export sistopernro=5\n");
        exit(EXIT_FAILURE);
    }

    n = atoi(valor_env);
    if (n <= 0)
    {
        fprintf(stderr, "Error: el valor de 'sistopernro' debe ser un entero positivo.\n");
        exit(EXIT_FAILURE);
    }

    // 2. Verificar si el usuario es root
    if (getuid() != 0)
    {
        printf("Faltan privilegios para ejecutar el programa.\n");
        exit(EXIT_SUCCESS);
    }

    printf("Usuario root detectado. Ejecutando acciones...\n");

    // 3. Crear primer proceso (mensaje)
    pid1 = fork();

    if (pid1 < 0)
    {
        perror("Error al crear proceso hijo 1");
        exit(EXIT_FAILURE);
    }

    if (pid1 == 0)
    {
        printf("Proceso 1 -> PID: %d | Mensaje: Apagando el equipo...\n", getpid());
        exit(EXIT_SUCCESS);
    }

    // 4. Crear segundo proceso (espera y apaga)
    pid2 = fork();

    if (pid2 < 0)
    {
        perror("Error al crear proceso hijo 2");
        exit(EXIT_FAILURE);
    }

    if (pid2 == 0)
    {
        printf("Proceso 2 -> PID: %d | Esperando %d segundos antes de apagar...\n", getpid(), n);
        sleep(n);
        printf("Ejecutando apagado del sistema ahora.\n");

        // Apagar sistema
        system("shutdown -h now");

        exit(EXIT_SUCCESS);
    }

    // 5. Esperar a ambos procesos
    wait(NULL);
    wait(NULL);

    printf("Ambos procesos finalizaron correctamente.\n");
    return 0;
}
