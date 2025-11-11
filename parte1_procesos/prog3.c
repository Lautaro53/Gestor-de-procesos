#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <time.h>

int main(void)
{
    char *valor_env;
    int n, i;
    pid_t pid;
    time_t t;
    struct tm *info;
    char buffer[80];

    // 1. Obtener la variable de entorno sistopernro
    valor_env = getenv("sistopernro");

    if (valor_env == NULL)
    {
        fprintf(stderr, "Error: la variable de entorno 'sistopernro' no está definida.\n");
        fprintf(stderr, "Ejemplo: export sistopernro=3\n");
        exit(EXIT_FAILURE);
    }

    // 2. Convertir a entero
    n = atoi(valor_env);
    if (n <= 0)
    {
        fprintf(stderr, "Error: el valor de 'sistopernro' debe ser un entero positivo.\n");
        exit(EXIT_FAILURE);
    }

    printf("Creando %d procesos hijos...\n\n", n);

    // 3. Crear n procesos hijos
    for (i = 1; i <= n; i++)
    {
        pid = fork();

        if (pid < 0)
        {
            perror("Error al crear proceso hijo");
            exit(EXIT_FAILURE);
        }
        else if (pid == 0)
        {
            // Código del hijo
            t = time(NULL);
            info = localtime(&t);
            strftime(buffer, sizeof(buffer), "%d/%m/%Y %H:%M:%S", info);

            printf("Hijo %d -> PID: %d | Fecha y hora: %s\n", i, getpid(), buffer);
            exit(EXIT_SUCCESS); 
        }
        else
        {
            // Padre espera a que cada hijo termine antes de continuar
            wait(NULL);
        }
    }

    printf("\nTodos los procesos hijos han finalizado.\n");

    return 0;
}
