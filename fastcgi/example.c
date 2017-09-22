#include "fcgi_stdio.h"
#include <stdlib.h>

int main(void)
{
 FCGX_Request request;

 FCGX_Init();
 FCGX_InitRequest(&request, 0, 0);
 //while(FCGI_Accept() >= 0)
 while(FCGX_Accept_r(&request) >= 0)
 {
  const char * uri = FCGX_GetParam("REQUEST_URI", request.envp);
  //printf("Content-type: text/html\r\nStatus: 200 OK\r\n\r\n");
  FCGX_FPrintF(request.out, "Content-type: text/html\r\nStatus: 200 OK\r\n\r\n");


  FCGX_FPrintF(request.out, 
        "\r\n"
        "<html>\n"
        "  <head>\n"
        "    <title>Hello, World!</title>\n"
        "  </head>\n"
        "  <body>\n"
        "    <h1>Hello from %s !</h1>\n"
        "  </body>\n"
        "</html>\n", uri);
  
  // TODO: see remaining example for reading content:
  // http://chriswu.me/code/hello_world_fcgi/main_v2.cpp
  // and: http://chriswu.me/blog/getting-request-uri-and-content-in-c-plus-plus-fcgi/
  

 }

  return 0;
}
