#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdlib.h>
#include "curl/curl.h"

struct MemoryStruct {
  char *memory;
  size_t size;
};

size_t writeMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp) {
  size_t realsize = size * nmemb;
  struct MemoryStruct *mem = (struct MemoryStruct *)userp;

  char *ptr = realloc(mem->memory, mem->size + realsize + 1);
  if(ptr == NULL) {
    printf("error: not enough memory\n");
    return 0;
  }

  mem->memory = ptr;
  memcpy(&(mem->memory[mem->size]), contents, realsize);
  mem->size += realsize;
  mem->memory[mem->size] = 0;

  return realsize;
}

int main(void) {
  CURL *curl_handle;
  CURLcode res;

  struct MemoryStruct chunk;
  chunk.memory = malloc(1);  
  chunk.size = 0;

  curl_handle = curl_easy_init();
  if(curl_handle) {
    struct curl_slist *hs=NULL;
    hs = curl_slist_append(hs, "Accept: text/plain");
    hs = curl_slist_append(hs, "User-Agent: nix-c-example (https://github.com/omega-800/nix-c-example)");
    curl_easy_setopt(curl_handle, CURLOPT_HTTPHEADER, hs);
    curl_easy_setopt(curl_handle, CURLOPT_URL, "https://icanhazdadjoke.com");
    curl_easy_setopt(curl_handle, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, writeMemoryCallback);
    curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, (void *)&chunk);

    res = curl_easy_perform(curl_handle);

    if(res != CURLE_OK) {
      fprintf(stderr, "error: %s\n", curl_easy_strerror(res));
    } else {
      printf("%s\n", chunk.memory);
    }
    curl_easy_cleanup(curl_handle);
    curl_slist_free_all(hs);
    free(chunk.memory);
  }
  return 0;
}
