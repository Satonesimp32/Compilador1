package com.compiler;

import java_cup.runtime.Symbol;
import java.util.*;

%%

%class Lexer
%unicode
%line
%column
%cup

%{
  private Symbol token(int tipo) {
    return new Symbol(tipo, yyline + 1, yycolumn + 1);
  }

  private Symbol token(int tipo, Object valor) {
    return new Symbol(tipo, yyline + 1, yycolumn + 1, valor);
  }

  public List<String> errores = new ArrayList<>();

  private void error(String msg) {
    errores.add(msg + " en línea " + (yyline + 1) + ", columna " + (yycolumn + 1));
  }
%}

ENTERO = [0-9]+
FLOTANTE = [0-9]+ \. [0-9]+
CADENA = \" ( [^\"\\\n] | \\. )* \"
BOOLEANO = true|false
TIPO = int|float|bool|string
IDENTIFICADOR = [a-zA-Z_][a-zA-Z0-9_]*
COMENTARIO = "#" [^\n]*
COMENTARIOB = "#|" [^|]* "|"+ ([^|#] [^|]* "|"+)* "#"
ESPACIO = [ \t\r\n]+

/* Excepciones / Errores lexicos */
FLOTANTE_SIN_ENTERO = \. [0-9]+
IDENTIFICADOR_CON_NUM = [0-9]+[a-zA-Z_][a-zA-Z0-9_]*
CADENA_SIN_CERRAR = \" ([^\"\\\n] | \\. )*

%%

/* Reservadas */
"fn"       { return token(sym.FN); }
"if"       { return token(sym.IF); }
"let"      { return token(sym.LET); }
"var"      { return token(sym.VAR); }
"record"   { return token(sym.RECORD); }
"then"     { return token(sym.THEN); }
"elif"     { return token(sym.ELIF); }
"else"     { return token(sym.ELSE); }
"end"      { return token(sym.END); }
"while"    { return token(sym.WHILE); }
"do"       { return token(sym.DO); }
"for"      { return token(sym.FOR); }
"in"       { return token(sym.IN); }
"return"   { return token(sym.RETURN); }
"print"    { return token(sym.PRINT); }
"and"      { return token(sym.AND); }
"or"       { return token(sym.OR); }
"not"      { return token(sym.NOT); }

/* Rangos */
{ENTERO} ".." { yypushback(2); return token(sym.ENTERO, Integer.valueOf(yytext())); }

/* Tipos y literales Primitivos */
{TIPO}          { return token(sym.TIPO, yytext()); }
{BOOLEANO}      { return token(sym.BOOLEANO, Boolean.valueOf(yytext())); }
{ENTERO}        { return token(sym.ENTERO, Integer.valueOf(yytext())); }
{FLOTANTE}      { return token(sym.FLOTANTE, Double.valueOf(yytext())); }
{CADENA}        { return token(sym.CADENA, yytext()); }
{IDENTIFICADOR} { return token(sym.IDENTIFICADOR, yytext()); }

/* Operadores y símbolos */
":=" { return token(sym.ASIG); }
".." { return token(sym.RANGO); }
"="  |
"<>" |
"<=" |
">=" |
"<"  |
">"  { return token(sym.CMP, yytext()); }

"+"  |
"-"  { return token(sym.ADD_SUB, yytext()); }

"*"  |
"/"  |
"%"  { return token(sym.MUL_DIV, yytext()); }

"("  { return token(sym.LPAR); }
")"  { return token(sym.RPAR); }
"["  { return token(sym.LCOR); }
"]"  { return token(sym.RCOR); }
"{"  { return token(sym.LKEY); }
"}"  { return token(sym.RKEY); }
","  { return token(sym.COMMA); }
":"  { return token(sym.COLON); }
"." {return token(sym.DOT);}

/* Ignorados */
{COMENTARIO}  { /* ignorar */ }
{COMENTARIOB} { /* ignorar */ }
{ESPACIO}     { /* ignorar */ }

/* Errores */
{FLOTANTE_SIN_ENTERO}   { error("Float sin parte entera: " + yytext()); }
{IDENTIFICADOR_CON_NUM} { error("Identificador no puede iniciar con número: " + yytext()); }
{CADENA_SIN_CERRAR}     { error("Cadena no cerrada: " + yytext()); }
.                       { error("Carácter no reconocido: " + yytext()); }