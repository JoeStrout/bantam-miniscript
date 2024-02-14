import "importUtil"
ensureImport "mapUtil"
ensureImport "tokens"
ensureImport "lexer"
ensureImport "parselets"
ensureImport "precedence"

Parser = {}
Parser.tokens = null			// a lexer (source of tokens)
Parser.read = null				// list of tokens already read
Parser.prefixParselets = null	// map, key: TokenType; value: PrefixParselet
Parser.infixParselets = null	// map, key: TokenType; value: InfixParselet
Parser.error = null

Parser.init = function(text)
	self.tokens = (new Lexer).init(text)
	self.read = []
	self.prefixParselets = {}
	self.infixParselets = {}
	return self
end function

Parser.throwError = function(msg)
	if not self.error then
		self.error = msg
		print "Error: " + msg
		pprint stackTrace
	end if
end function

Parser.register = function(tokenType, parselet)
	if parselet isa PrefixParselet then
		self.prefixParselets[tokenType] = parselet
	else
		self.infixParselets[tokenType] = parselet
	end if
end function

Parser.parseExpression = function(precedence = 0)
	token = self.consume
	prefix = self.prefixParselets.get(token.type)
	if not prefix then
		self.throwError "Could not parse """ + token.text + """."
		return
	end if
	
	left = prefix.parse(self, token)
		
	while precedence < self.getPrecedence and not self.error
		token = self.consume
		
		infix = self.infixParselets.get(token.type)
		left = infix.parse(self, left, token)
	end while
	return left
end function

Parser.match = function(expectedTokenType)
	token = self.lookAhead
	if token.type != expectedTokenType then return false
	self.consume
	return true
end function

Parser.consume = function(expectedTokenType=null)
	token = self.lookAhead
	if expectedTokenType and token.type != expectedTokenType then
		self.throwError "Expected token " + expectedTokenType +
		  " and found " + token.type
	end if
	return self.read.pull
end function

Parser.lookAhead = function(distance=0)
	// Read in as many as needed.
	while distance >= self.read.len
		self.read.push self.tokens.next
	end while
	
	// Get the queued token.
	return self.read[distance]
end function

Parser.getPrecedence = function
	parser = self.infixParselets.get(self.lookAhead.type)
	if parser != null then return parser.precedence
	return 0
end function
