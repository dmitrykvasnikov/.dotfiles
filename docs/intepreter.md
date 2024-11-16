Info about types:
     * in node itself with additional field/attributes
     * in special table
     * in new tree structure

**Lexer**:
    keep positions: start - start of lexem, current - current reading position, line - current line
    match metod - return true and consume char - to check for 2-char tokens after first char scan
    peek and peekNext - return current and next char without consuming it
    advance - consume current char and move position
    isEOF - true if we reach end of file

'And' / 'Or' binary operations are shor-circute

Expression produce a value, Statement produce an effect

Attach scope to code blocks?

Function call has arguments, function declaration has parameter

Reporting Errors - probably return to list or Error in state

**Parser**:
    must take into consideration precedence and associativity
    match - consume and return true / false
    consume - accept a token kind and a part of error message to return? Probably to wrap parsing into Except Monad
    synchronize - find next suitable starting point after an error

Precedence levels:
           expression
           equality
           comparison
           term
           factor
           unary
           primary

unary :: ("!"|"-") unary | primary

An idea of object - which will be attached to Token  and then reattached to Expression
On token-generation stage objects are literals, identifiers and syntax values (literally parts of input string), and during parsing we add more objects to AST
Or may be generate objects on parsing stage only

Statements:
        VAR - is a declaration statemenet - not allowed in then/else branches, only as part of StmtBlock
        = - is assginment as Expression Statement?

Or:
  program : [declaration]
  declararion: varDeclaration | Stmt
  Stmt : exprStmt | printStmt
  IfElse - Cond Then (Maybe Else)

Parser fucntions could be of type ** ExceptT (Token, Message) (State Memory) Stmt ** - in parse  (which itself runs in RWST IO () monad)
  get function depending on first token
  run fucntion
    - right - return expression
    - left - add error (tell method) and synchronize, return ErrorExpression ... (as statement holder in case of errors)

Final values are objects, and we gonna have constants - objects with predefind values (like True, False, Nil)

Object :: BoolObject, IntObject, StringObject, IdentifierObject ...

IfStatement - it's important to decide to which if will be correspond else condition - innermost one or outermost one

In logical operations if we use thruthy / falsy values - what shoud we return - TRUE/FALSE or object itself

For / While loops - needs to implement break; operator

Identifier itself is like call to ID function without parenthesis???


Environment always have link to parent environment (empty map in case of main program - or could be populated with args from command line), when we evalute function call - we create new environment, populated  with call parameters and with link on current environment

Return could be implemented as an exception - so we try / catch function call

Closures - environment should be part of function declaration, which could be modified with each function call
When function declared we add current environment as closure + add declaration of this function to environment too
When we call function - we use this environent instead of globals.
Probably we need in envaronment map of function closures as function can update them

fun makeCounter() {
  var i = 0;
  fun count() {
    i = i + 1;
    print i;
  }
  return count;
}
var counter = makeCounter();
counter(); // "1".
counter(); // "2".
  
Keep variables in map with depth of call chain. So closure just keeps it's depth ... ??? So variable keeps list of possible values depending from depth of calls ... Or transform it to _xVarName,

**Class**
In case of inner classes braeakfest . meal . eggs . qty = 3. only last '.' is a setter, first two a getters
