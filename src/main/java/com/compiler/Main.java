package com.compiler;

import java_cup.runtime.Symbol;
import java.lang.reflect.Field;
import java.io.FileReader;

public class Main {
    public static void main(String[] args) throws Exception {
        String archivo = args.length > 0 ? args[0] : "entrada.txt";

        // Comentar y descomentar para desbichar
        probarLexer(archivo);
        // probarParser(archivo);
    }

    public static void probarLexer(String archivo) {
        try (FileReader reader = new FileReader(archivo)) {
            Lexer lexer = new Lexer(reader);
            Symbol token;

            while ((token = lexer.next_token()).sym != sym.EOF) {
                String nombreToken = obtenerNombreToken(token.sym);
                String valor = (token.value != null) ? token.value.toString() : "-";

                System.out.printf("Línea %-3d | Col %-3d | Token: %-15s | Valor: %s%n",
                        token.left, token.right, nombreToken, valor);
            }

            for (String err : lexer.errores) {
                System.err.println("[ERROR LÉXICO] " + err);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String obtenerNombreToken(int id) {
        for (Field f : sym.class.getFields()) {
            try {
                if (f.getInt(null) == id) {
                    return f.getName();
                }
            } catch (Exception ignored) {}
        }
        return "DESCONOCIDO (" + id + ")";
    }

    public static void probarParser(String archivo) {
        try (FileReader reader = new FileReader(archivo)) {
            Lexer lexer = new Lexer(reader);
            Parser parser = new Parser(lexer);

            parser.parse();

            for (String err : lexer.errores) {
                System.err.println("[ERROR LÉXICO] " + err);
            }
        } catch (Exception e) {
            System.err.println("[ERROR SINTÁCTICO] " + e.getMessage());
        }
    }
}