import "importUtil"
ensureImport "parser"
ensureImport "parselets"

// Extends the generic Parser class with support for parsing 
// the actual Bantam grammar.

globals.BantamParser = new parser.Parser

BantamParser.init = function(text)
	super.init text
	
	// Register all of the parselets for the grammar.
	
	// Register the ones that need special parselets.
	self.register TokenType.NAME,       new NameParselet
	self.register TokenType.ASSIGN,     new AssignParselet
	self.register TokenType.QUESTION,   new ConditionalParselet
	self.register TokenType.LEFT_PAREN, new GroupParselet
	self.register TokenType.LEFT_PAREN, new CallParselet

	// Register the simple operator parselets.
	self.prefix TokenType.PLUS, Precedence.PREFIX
	self.prefix TokenType.MINUS, Precedence.PREFIX
	self.prefix TokenType.TILDE, Precedence.PREFIX
	self.prefix TokenType.BANG, Precedence.PREFIX
	// For kicks, we'll make "!" both prefix and postfix, kind of like ++.
	self.postfix TokenType.BANG, Precedence.POSTFIX
	// Register the infix parselets (left and right associative).
	self.infixLeft TokenType.PLUS, Precedence.SUM
	self.infixLeft TokenType.MINUS, Precedence.SUM
	self.infixLeft TokenType.ASTERISK, Precedence.PRODUCT
	self.infixLeft TokenType.SLASH, Precedence.PRODUCT
	self.infixRight TokenType.CARET, Precedence.EXPONENT
	
	return self
end function


// self.prefix:
//	Registers a prefix unary operator parselet for the given token and precedence.
BantamParser.prefix = function(tokenType, precedence)
	self.register tokenType, (new PrefixOperatorParselet).init(precedence)
end function

// self.postfix:
//	Registers a postfix unary operator parselet for the given token and precedence.
BantamParser.postfix = function(tokenType, precedence)
	self.register tokenType, (new PostfixOperatorParselet).init(precedence)
end function

// self.infixLeft
//  Registers a left-associative binary operator parselet for the given token and
//	precedence.
BantamParser.infixLeft = function(tokenType, precedence)
	self.register tokenType, (new BinaryOperatorParselet).init(precedence, false)
end function

// self.infixRight
//  Registers a right-associative binary operator parselet for the given token and
//	precedence.
BantamParser.infixRight = function(tokenType, precedence)
	self.register tokenType, (new BinaryOperatorParselet).init(precedence, true)
end function
