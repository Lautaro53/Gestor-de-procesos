#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
    pid_t pid;
    int status;

    // Verifica que se haya pasado un argumento (el comando a ejecutar)
    if (argc < 2)
    {
        fprintf(stderr, "Uso: %s <comando>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    // Crea un proceso hijo
    pid = fork();

    if (pid < 0)
    {
        perror("Error al crear el proceso hijo");
        exit(EXIT_FAILURE);
    }

    if (pid == 0)
    {
        // Proceso hijo: ejecuta el comando recibido
        execvp(argv[1], &argv[1]);

        // Si exec falla, muestra error
        perror("Error al ejecutar el comando");
        exit(EXIT_FAILURE);
    }
    else
    {
        // Proceso padre: espera que el hijo termine
        wait(&status);
        printf("Proceso hijo finalizado con código de salida: %d\n", WEXITSTATUS(status));
    }

    return 0;
}
