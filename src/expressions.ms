import "importUtil"

// Expression:
// Interface for all expression AST node classes.
globals.Expression = {}

// Expression.str:
// Pretty-print the expression to a string.
Expression.str = null

// AssignExpression:
// An assignment expression like "a = b".
globals.AssignExpression = new Expression
AssignExpression.str = function
	return "(" + self.name + " = " + self.right.str + ")"
end function
AssignExpression.init = function(name, right)
	self.name = name
	self.right = right
	return self
end function

// CallExpression:
// A function call like "a(b, c, d)".
globals.CallExpression = new Expression
CallExpression.str = function
	args = []
	for arg in self.args
		args.push arg.str
	end for
	return self.funcExpr.str + "(" + args.join(", ") + ")"
end function
CallExpression.init = function(funcExpr, args)
	self.funcExpr = funcExpr
	self.args = args
	return self
end function

// ConditionalExpression:
// A ternary conditional expression like "a ? b : c".
globals.ConditionalExpression = new Expression
ConditionalExpression.str = function
	return "(" + self.condition.str + " ? " + self.thenArm.str + 
	  " : " + self.elseArm.str + ")"
end function
ConditionalExpression.init = function(condition, thenArm, elseArm)
	self.condition = condition
	self.thenArm = thenArm
	self.elseArm = elseArm
	return self
end function

// NameExpression:
// A simple variable name expression like "abc".
globals.NameExpression = new Expression
NameExpression.str = function
	return self.name
end function
NameExpression.init = function(name)
	self.name = name
	return self
end function

// OperatorExpression
// A binary arithmetic expression like "a + b" or "c ^ d".
globals.OperatorExpression = new Expression
OperatorExpression.str = function
	return "(" + self.left.str + " " + punctuator(self.operator) + 
	  " " + self.right.str + ")"
end function
OperatorExpression.init = function(left, operator, right)
	self.left = left
	self.operator = operator
	self.right = right
	return self
end function

// PostfixExpression:
// A postfix unary arithmetic expression like "a!".
globals.PostfixExpression = new Expression
PostfixExpression.str = function
	return "(" + self.left.str + punctuator(self.operator) + ")"
end function
PostfixExpression.init = function(left, operator)
	self.left = left
	self.operator = operator
	return self
end function

// PrefixExpression:
// A prefix unary arithmetic expression like "!a" or "-b".
globals.PrefixExpression = new Expression
PrefixExpression.str = function
	return "(" + punctuator(self.operator) + self.right.str + ")"
end function
PrefixExpression.init = function(operator, right)
	self.operator = operator
	self.right = right
	return self
end function

