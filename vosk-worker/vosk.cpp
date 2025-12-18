#include <vosk_api.h>
#include <portaudio.h>
#include <stdio.h>
#include <string.h>
#include <cstdint>

#define SAMPLE_RATE 16000
#define FRAMES_PER_BUFFER 1600

int main() {
  // Inicializar Vosk
  VoskModel* model = vosk_model_new("vosk-worker/model/vosk-model-small-es-0.42");
  VoskRecognizer* recognizer = vosk_recognizer_new(model, SAMPLE_RATE);

  // Inicializar PortAudio
  Pa_Initialize();
  PaStream* stream;
  Pa_OpenDefaultStream(&stream, 1, 0, paInt16, SAMPLE_RATE, FRAMES_PER_BUFFER, nullptr, nullptr);
  Pa_StartStream(stream);

  int16_t buffer[FRAMES_PER_BUFFER];

  // Limpiar el archivo antes de comenzar
  FILE* clear = fopen("vosk-worker/instrucciones.txt", "w");
  if (clear) {
    fclose(clear);
  }

  while (true) {
    Pa_ReadStream(stream, buffer, FRAMES_PER_BUFFER);
    if (vosk_recognizer_accept_waveform(recognizer, (const char*)buffer, sizeof(buffer))) {
      const char* result = vosk_recognizer_result(recognizer);
      printf("%s\n", result);
      // Guardar resultado en un archivo
      FILE* out = fopen("vosk-worker/instrucciones.txt", "a");
      if (out) {
        fprintf(out, "%s\n", result);
        fclose(out);
      }
      // Salir si se dice palabra clave
      if (strstr(result, "finalizar") != nullptr) {
        printf("Se detecto la palabra clave 'finalizar'. Reconocimiento terminado\n");
        break;
      }
  } else {
      const char* partial = vosk_recognizer_partial_result(recognizer);
      printf("%s\r", partial);
      fflush(stdout);
    }
  }

  Pa_StopStream(stream);
  Pa_CloseStream(stream);
  Pa_Terminate();

  vosk_recognizer_free(recognizer);
  vosk_model_free(model);

  return 0;
}
