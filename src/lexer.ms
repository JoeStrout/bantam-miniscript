// A very primitive lexer. Takes a string and splits it into a series of
// Tokens. Operators and punctuation are mapped to unique keywords. Names,
// which can be any series of letters, are turned into NAME tokens. All other
// characters are ignored (except to separate names). Numbers and strings are
// not supported. This is really just the bare minimum to give the parser
// something to work with.


isLetter = function(c)
	return "a" <= c <= "z" or "A" <= c <= "Z"
end function

globals.Lexer = {}

// Lexer.init:
// Creates a new Lexer to tokenize the given string.
//
//      text -- the string to tokenize
Lexer.init = function(text)
	self.index = 0
	self.text = text
	self.punctuators = {}
	
	// Register all of the TokenTypes that are explicit punctuators.
	for type in TokenType.indexes
		punc = punctuator(type)
		if punc then self.punctuators[punc] = type
	end for
	return self
end function

// Lexer.next:
// Get the next token from our text.  At the end of the string,
// return EOF.
Lexer.next = function()
	while self.index < self.text.len
		c = self.text[self.index]
		self.index += 1
		if self.punctuators.hasIndex(c) then
			// Handle punctuation.
			return token(self.punctuators[c], c)
		end if
		if isLetter(c) then
			// Handle names.
			start = self.index - 1
			while self.index < len(self.text)
				if not isLetter(self.text[self.index]) then break
				self.index += 1
			end while
			name = self.text[start:self.index]
			return token(TokenType.NAME, name)
		end if
		// Ignore all other characters (whitespace, etc.)
	end while

	// Once we've reached the end of the string, just return EOF tokens. We'll
	// just keeping returning them as many times as we're asked so that the
	// parser's lookahead doesn't have to worry about running out of tokens.
	return token(TokenType.EOF, "")
end function
