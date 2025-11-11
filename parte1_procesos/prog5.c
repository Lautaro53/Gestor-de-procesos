#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(void)
{
    char *mensaje;
    char *token;
    char *chat_id;
    char comando[512];

    // 1. Leer la variable de entorno
    mensaje = getenv("sistopermsg");
    token = getenv("telegram_token");
    chat_id = getenv("telegram_chatid");

	if (mensaje == NULL || token == NULL || chat_id == NULL)
	{
    		fprintf(stderr, "Error: faltan variables de entorno requeridas.\n");
    		fprintf(stderr, "Debe definir:\n");
    		fprintf(stderr, "  export sistopermsg=\"Texto del mensaje\"\n");
    		fprintf(stderr, "  export telegram_token=\"8389227483:AAH8nG_kJ0Ql31-17ynvSzLU-NYBqEyV-58\"\n");
    		fprintf(stderr, "  export telegram_chatid=\"-1003403977612\"\n");
    		exit(EXIT_FAILURE);
	}


    // 2. Construir el comando curl
    snprintf(comando, sizeof(comando),
             "curl -s -X POST https://api.telegram.org/bot%s/sendMessage -d chat_id=%s -d text=\"%s\" > /dev/null",
             token, chat_id, mensaje);

    // 3. Ejecutar el comando
    int result = system(comando);

    if (result == -1)
    {
        perror("Error al ejecutar el comando curl");
        exit(EXIT_FAILURE);
    }

    printf("Mensaje enviado correctamente a Telegram.\n");
    return 0;
}
