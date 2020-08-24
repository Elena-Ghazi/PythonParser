import org.antlr.runtime.*;

public class TestT {
    public static void main(String[] args) throws Exception {

        // Create an TLexer that feeds from that stream
        //TLexer lexer = new TLexer(new ANTLRInputStream(System.in));
        Project_AntlrLexer lexer = new Project_AntlrLexer(new ANTLRFileStream("input.txt"));

        // Create a stream of tokens fed by the lexer
        CommonTokenStream tokens = new CommonTokenStream(lexer);

        // Create a parser that feeds off the token stream
        Project_AntlrParser parser = new Project_AntlrParser(tokens);

        // Begin parsing at rule prog
        parser.prog();
    }
}
