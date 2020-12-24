import Foundation

enum Token {
    case plus
    case star
    case number(Int)
    case leftParen
    case rightParen

    func get() -> Int? {
        switch self {
        case .number(let num):
            return num
        default:
            return nil
        }
    }

    func convert() -> Operation? {
        switch self {
        case .plus:
            return .add
        case .star:
            return .mult
        default:
            return nil
        }
    }
}

enum Operation {
    case add
    case mult
}

enum Expression {
    case integer(Int)
    indirect case binary(Expression, Operation, Expression)
    indirect case grouped(Expression)

    func get() -> Int! {
        switch self {
        case .integer(let num):
            return num
        default:
            return nil
        }
    }
}

extension Token: Equatable {
    public static func ==(lhs: Token, rhs:Token) -> Bool {
        switch (lhs, rhs) {
        case (.plus, .plus):
            return true
        case (.star, .star):
            return true
        case (.number, .number):
            return true
        case (.leftParen, .leftParen):
            return true
        case (.rightParen, .rightParen):
            return true
        default:
            return false
        }
    }
}


struct Lexer {
    var i: Int
    var tokens: [Token]
    var source: [Character]

    init() {
        self.i = 0
        self.tokens = [Token]()
        self.source = [Character]()
    }

    mutating func getTokens(source: String) -> [Token] {
        self.i = 0
        self.tokens = [Token]()
        self.source = Array(source)
        while self.i < self.source.count {
            var char = self.source[self.i]

            if char == "+" {
                self.tokens.append(Token.plus)
            }

            if char == "*" {
                self.tokens.append(Token.star)
            }

            if char == "(" {
                self.tokens.append(Token.leftParen)
            }

            if char == ")" {
                self.tokens.append(Token.rightParen)
            }

            if char.isNumber {
                var num = 0
                while char.isNumber {
                    num = num * 10 + char.wholeNumberValue!
                    self.i += 1
                    if self.i >= self.source.count {
                        char = "\0"
                    } else {
                        char = self.source[self.i]
                    }
                }
                self.i -= 1
                self.tokens.append(Token.number(num))
            }

            self.i += 1
        }
        return self.tokens
    }
}

struct Parser {
    var current: Int
    var tokens: [Token]

    init() {
        self.current = 0
        self.tokens = [Token]()
    }

    func isAtEnd() -> Bool {
        return self.current == tokens.count
    }

    func previous() -> Token {
        return self.tokens[self.current - 1]
    }

    mutating func next() -> Token {
        if !isAtEnd() {
            self.current += 1
        }
        return previous()
    }

    func peek() -> Token {
        if isAtEnd() {
            return previous()
        }
        return self.tokens[self.current]
    }

    mutating func match(tokens: [Token]) -> Bool {
        for token in tokens {
            if token == peek() {
                let _ = next()
                return true
            }
        }
        return false
    }

    mutating func parsePrimaryExpression() -> Expression? {
        if match(tokens: [.number(0)]) {
            if case Token.number(let num) = previous() {
                return Expression.integer(num)
            }
        }

        if match(tokens: [.leftParen]) {
            let expression = parseExpression2()
            if !match(tokens: [.rightParen]) {
                print("Missing )")
            }
            return Expression.grouped(expression!)
        }
        return nil
    }

    mutating func parseExpression() -> Expression? {
        var left = parsePrimaryExpression()
        while match(tokens: [.plus, .star]) {
            let op = previous().convert()
            let right = parsePrimaryExpression()
            left = Expression.binary(left!, op!, right!)
        }
        return left
    }

    mutating func parseAddition() -> Expression? {
        var left = parsePrimaryExpression()
        while match(tokens: [.plus]) {
            let op = previous().convert()
            let right = parsePrimaryExpression()
            left = Expression.binary(left!, op!, right!)
        }
        return left
    }

    mutating func parseExpression2() -> Expression? {
        var left = parseAddition()
        while match(tokens: [.star]) {
            let op = previous().convert()
            let right = parseAddition()
            left = Expression.binary(left!, op!, right!)
        }
        return left
    }

    mutating func parse(tokens: [Token]) -> Expression {
        self.current = 0
        self.tokens = tokens
        return parseExpression2()!
    }
}

struct Interpreter {
    static func eval(expression: Expression) -> Int {
        switch expression {
        case .integer(let number):
            return number
        case .binary(let left, let op, let right):
            let left = eval(expression: left)
            let right = eval(expression: right)
            switch op {
            case .add:
                return left + right
            case .mult:
                return left * right
           }
        case .grouped(let expr):
            return eval(expression: expr)
        }
    }

}

func main() {
    // Note : Please paste your input.txt in here
    // Apparently there is no easy way to do this on non-darwin platforms
    let inputs = ["2 + (3 * 2)", "2 + 3 * 9 + 4"]
    var lexer = Lexer()
    var parser = Parser()

    var sum = 0
    for input in inputs {
        let result = Interpreter.eval(expression: parser.parse(tokens: lexer.getTokens(source: input)))
        sum += result
    }

    print(sum)
}

main()

