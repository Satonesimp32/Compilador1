package com.compiler;

public class Simbolo {
    private String tipo;    // fn, var, let, param, record
    private String nombre;  // nombre del identificador
    private String tipoDato; // int, float, bool, string, etc.
    private TablaSimbolos scopeInterno; // Para funciones o records

    public Simbolo(String tipo, String nombre, String tipoDato) {
        this.tipo = tipo;
        this.nombre = nombre;
        this.tipoDato = tipoDato;
        this.scopeInterno = null;
    }

    // Getters y Setters
    public String getTipo() { return tipo; }
    public String getNombre() { return nombre; }
    public String getTipoDato() { return tipoDato; }
    public TablaSimbolos getScopeInterno() { return scopeInterno; }
    public void setScopeInterno(TablaSimbolos scopeInterno) { this.scopeInterno = scopeInterno; }
}