package com.compiler;

import java.util.LinkedHashMap;
import java.util.Map;

public class TablaSimbolos {
    private Map<String, Simbolo> simbolos;
    private TablaSimbolos padre;

    public TablaSimbolos(TablaSimbolos padre) {
        // LinkedHashMap mantiene el orden de inserción
        this.simbolos = new LinkedHashMap<>();
        this.padre = padre;
    }

    public void define(Simbolo sym) throws Exception {
        if (simbolos.containsKey(sym.getNombre())) {
            throw new Exception("El símbolo '" + sym.getNombre() + "' ya existe en este ámbito.");
        }
        simbolos.put(sym.getNombre(), sym);
    }

    public void remover(String nombre) {
        simbolos.remove(nombre);
    }

    public Simbolo lookup(String nombre) {
        if (simbolos.containsKey(nombre)) {
            return simbolos.get(nombre);
        }
        if (padre != null) {
            return padre.lookup(nombre);
        }
        return null;
    }

    public Map<String, Simbolo> getSimbolos() {
        return simbolos;
    }

    // MÉTODO AGREGADO: Permite recuperar el ámbito padre tras salir de una función/record en CUP
    public TablaSimbolos getPadre() {
        return padre;
    }
}