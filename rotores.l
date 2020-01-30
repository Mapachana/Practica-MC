                 /*----- Sección de Declaraciones --------------*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

char rotor1[26] = {'b','c','d','g','h','k','l','o','p','r','t','s','v','u','a','e','f','i','j','m','n','q','w','x','z','y'};
char rotor2[26] = {'b','c','d','g','h','k','l','o','p','r','t','s','v','u','a','e','f','i','j','m','n','q','w','x','z','y'};
char rotor3[26] = {'b','c','d','g','h','k','l','o','p','r','t','s','v','u','a','e','f','i','j','m','n','q','w','x','z','y'};
int rotor_actual = 0;
#define num_rotores 3
int num_giros[num_rotores] = {0,0,0};
char* rotores[3] = {rotor1, rotor2, rotor3};

int aux = 0;
int yr = 0;
int valid = 0;

void escribir_datos (int dato1, int dato2, int dato3, int ncorreoo);
void codificar_fecha (char f [10]);
%}

%%
                 /*----- Sección de Reglas ----------------*/


[A-Z a-z]   {  
          char letra = yytext[0];
          letra = tolower(letra);
          int num_letra = letra-'a';
          for (int i = 0; i < num_rotores; ++i){
            num_letra = rotores[i][num_letra+num_giros[i]]-'a';
          }
          num_giros[0]++;
          if (num_giros[0] == 26){
            num_giros[1]++;
            num_giros[0] = 0;
            if (num_giros[1] == 26){
              num_giros[2]++;
              num_giros[1] = 0;
              if (num_giros[2] == 26){
                num_giros[2] = 0;
              }
            }
          }
          letra = (char) (num_letra+(int)'a');
          printf("%c", letra);

          
        }

        (0[1-9]|[1-2][0-9]|[3][0-1])\/((0(1|3|5|7|8))|(10|12))\/([1-2][0-9][0-9][-0-9])|(0[1-9]|[1-2][0-9]|30)\/((0(4|6|9))|11)\/([1-2][0-9][0-9][0-9])|(0[1-9]|1[0-9]|2[0-8])\/02\/([1-2][0-9][0-9][0-9]) {
          // una fecha hasta                                                           | otra hasta                                                    | y la ultima hasrta el final
          valid=1;
          if (valid==1)
            codificar_fecha(yytext);
            valid = 0;
        } 
  
        
  
        29\/02\/([1-2][0-9][0-9][0-9])  {
          char anio[4];
          for (int i = 0; i < 4; ++i){
            anio[i] = yytext[6+i];
          } 
          yr = atoi(anio);
        if(yr%4==0||(yr%100==0&&yr%400!=0))
        valid=1;
        if (valid==1){
          codificar_fecha(yytext);
          valid = 0;
          }
        } 

        (19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01]) {
          int longitud = 10;
          char fecha[8];
          int contador = 0;
          for (int i = 0; i < longitud; ++i){
            char letra = yytext[i];
            if (letra != '/'){
              fecha[8-contador-1] = letra;
              contador++;
            }
          }
          printf("%s", fecha);

}

[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9] {printf(" ");}

\.|\,  {printf(" ");}

          


%%
                /*----- Sección de Procedimientos --------*/

int main (int argc, char *argv[])
{
  if (argc == 2)
  {
    yyin = fopen (argv[1], "rt");

    if (yyin == NULL)
    {
      printf ("El fichero %s no se puede abrir\n", argv[1]);
      exit (-1);
    }
  }
  else yyin = stdin;

  yylex ();

  return 0;
}

void escribir_datos (int dato1, int dato2, int dato3, int ncorreoo)
{
  printf ("Texto codificado:");
}

void codificar_fecha (char f [10]){
  int longitud = 10;
  char fecha[8];
  int contador = 0;
  for (int i = 0; i < longitud; ++i){
    char letra = yytext[i];
    if (letra != '/'){
      fecha[8-contador-1] = letra;
      contador++;
    }
  }
  printf("%s", fecha);
}
