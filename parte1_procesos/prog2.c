#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void)
{
    pid_t pid;
    int status;
    char *comando;
    char *argv[2]; // array para execvp: comando + NULL

    // 1. Obtener el valor de la variable de entorno
    comando = getenv("sistoperexec");

    if (comando == NULL)
    {
        fprintf(stderr, "Error: la variable de entorno 'sistoperexec' no está definida.\n");
        fprintf(stderr, "Ejemplo: export sistoperexec=ls\n");
        exit(EXIT_FAILURE);
    }

    printf("Comando obtenido de 'sistoperexec': %s\n", comando);

    // 2. Preparar argumentos para execvp
    argv[0] = comando;
    argv[1] = NULL;

    // 3. Crear proceso hijo
    pid = fork();

    if (pid < 0)
    {
        perror("Error al crear proceso hijo");
        exit(EXIT_FAILURE);
    }

    if (pid == 0)
    {
        // Proceso hijo ejecuta el comando
        execvp(argv[0], argv);

        // Si execvp falla:
        perror("Error al ejecutar el comando");
        exit(EXIT_FAILURE);
    }
    else
    {
        // Proceso padre espera
        wait(&status);
        printf("El proceso hijo finalizó con estado %d\n", WEXITSTATUS(status));
    }

    return 0;
}
