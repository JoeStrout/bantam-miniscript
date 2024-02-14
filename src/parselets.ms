// Parslets: mini-parsers that each handle just one type of parsing.

import "importUtil"
ensureImport "tokens"
ensureImport "expressions"
ensureImport "precedence"

// PrefixParslet:
// One of the two interfaces used by the Pratt parser. A PrefixParselet is
// associated with a token that appears at the beginning of an expression. Its
// parse() method will be called with the consumed leading token, and the
// parselet is responsible for parsing anything that comes after that token.
// This interface is also used for single-token expressions like variables, in
// which case parse() simply doesn't consume any more tokens.
globals.PrefixParselet = {}
PrefixParselet.parse = null	// function(parser, token)
PrefixParselet.init = function(precedence)
	self.precedence = precedence
	return self
end function

// InfixParslet:
// The other of two parselet interfaces used by the Pratt parser. An
// InfixParselet is associated with a token that appears in the middle of the
// expression it parses. Its parse() method will be called after the left-hand
// side has been parsed, and it in turn is responsible for parsing everything
// that comes after the token. This is also used for postfix expressions, in
// which case it simply doesn't consume any more tokens in its parse() call.
globals.InfixParselet = {}
InfixParselet.parse = null		// function(parser, token)
InfixParselet.precedence = null
InfixParselet.init = function(precedence)
	self.precedence = precedence
	return self
end function

// AssignParslet:
// Parses assignment expressions like "a = b". The left side of an assignment
//    expression must be a simple name like "a", and expressions are
//    right-associative. (In other words, "a = b = c" is parsed as "a = (b = c)").
globals.AssignParselet = new InfixParselet
AssignParselet.parse = function(parser, left, token)
	right = parser.parseExpression(Precedence.BELOW_ASSIGNMENT)
	if not left isa NameExpression then
		self.throwError "The left-hand side of an assignment must be a name."
		return null
	end if
	return (new AssignExpression).init(left.name, right)
end function
AssignParselet.precedence = Precedence.ASSIGNMENT

// BinaryOperatorParselet
//	Generic infix parselet for a binary arithmetic operator.
//	
//	The only difference when parsing, "+", "-", "*", "/", and "^" is precedence and
//	associativity, so we can use a single parselet class for all of those.
globals.BinaryOperatorParselet = new InfixParselet
BinaryOperatorParselet.isRight = false
BinaryOperatorParselet.init = function(precedence, isRight)
	super.init precedence
	self.isRight = isRight
	return self
end function
BinaryOperatorParselet.parse = function(parser, left, token)
	// To handle right-associative operators like "^", we allow a slightly
	// lower precedence when parsing the right-hand side. This will let a
	// parselet with the same precedence appear on the right, which will then
	// take *this* parselet's result as its left-hand argument.
	precedence = self.precedence - self.isRight
	right = parser.parseExpression(precedence)
	return (new OperatorExpression).init(left, token.type, right)
end function

// CallParselet:
//	Parselet to parse a function call like "a(b, c, d)"
globals.CallParselet = new InfixParselet
CallParselet.precedence = Precedence.CALL
CallParselet.parse = function(parser, left, token)
	// Parse the comma-separated arguments until we hit ")".
	args = []
	// There may be no arguments at all
	if not parser.match(TokenType.RIGHT_PAREN) then
		while true
			args.push parser.parseExpression
			if not parser.match(TokenType.COMMA) then break
		end while
		parser.consume TokenType.RIGHT_PAREN
	end if
	return (new CallExpression).init(left, args)
end function

// ConditionalParselet:
//	Parselet for the condition or ternary operator, like "a ? b : c".
globals.ConditionalParselet = new InfixParselet
ConditionalParselet.precedence = Precedence.CONDITIONAL
ConditionalParselet.parse = function(parser, left, token)
	thenArm = parser.parseExpression
	parser.consume TokenType.COLON
	elseArm = parser.parseExpression(Precedence.CONDITIONAL - 1)
	return (new ConditionalExpression).init(left, thenArm, elseArm)
end function

// NameParslet:
// Simple parslet for a named variable like "abc".
globals.NameParselet = new PrefixParselet
NameParselet.parse = function(parser, token)
	return (new NameExpression).init(token.text)
end function

// GroupParselet
//	Parses parentheses used to group an expression, like "a * (b + c)".
globals.GroupParselet = new PrefixParselet
GroupParselet.parse = function(parser, left, token)
	expression = parser.parseExpression
	parser.consume TokenType.RIGHT_PAREN
	return expression
end function

// PostfixOperatorParselet:
//	Generic infix parselet for an unary arithmetic operator.
//
//	Parses postfix unary "a?" or "a!" type expressions.
globals.PostfixOperatorParselet = new InfixParselet
PostfixOperatorParselet.parse = function(parser, left, token)
	return (new PostfixExpression).init(left, token.type)
end function

// PrefixOperatorParselet:
//	Generic prefix parselet for an unary arithmetic operator.
//
//	Parses prefix unary "-", "+", "~", and "!" expressions.
globals.PrefixOperatorParselet = new PrefixParselet
PrefixOperatorParselet.parse = function(parser, token)
	// To handle right-associative operators like "^", we allow a slightly
	// lower precedence when parsing the right-hand side. This will let a
	// parselet with the same precedence appear on the right, which will then
	// take *this* parselet's result as its left-hand argument.
	if token == null then exit
	right = parser.parseExpression(self.precedence)
	return (new PrefixExpression).init(token.type, right)
end function
