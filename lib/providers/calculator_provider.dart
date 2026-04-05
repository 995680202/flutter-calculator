import 'package:flutter/material.dart';

/// Token-based calculator provider
/// Implemented as a single, robust provider with a tokenized expression model.
/// This mirrors the reference HTML calculator logic in a token-driven Flutter model.
class CalculatorProvider extends ChangeNotifier {
  // Internal token streams for evaluation
  List<String> _tokens = []; // internal tokens: numbers and operators (* / + -)
  List<String> _rawTokens = []; // raw tokens: numbers and user-entered operators (e.g. 20, +, ×, ÷)

  // Display-facing state
  String _display = '0';
  String _expression = ''; // pretty/display expression for UI (built from tokens)
  List<String> _history = [];
  bool _justCalculated = false;

  String get display => _display;
  String get expression => _expression;
  List<String> get history => List.unmodifiable(_history);

  // Helpers
  bool _isInternalOperator(String t) => t == '+' || t == '-' || t == '*' || t == '/';
  bool _isNumber(String t) {
    if (t.isEmpty) return false;
    if (t == '(' || t == ')') return false;
    if (_isInternalOperator(t)) return false;
    // Check if it's a valid number (including negative numbers and decimals)
    return double.tryParse(t) != null || t.contains('.') || (t.startsWith('-') && double.tryParse(t.substring(1)) != null);
  }

  // Format pretty display from internal tokens
  String _buildExpressionFromTokens() {
    if (_tokens.isEmpty) return '0';
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < _tokens.length; i++) {
      String token = _tokens[i];
      
      // Convert internal operators back to display symbols
      if (token == '*') {
        sb.write('×');
      } else if (token == '/') {
        sb.write('÷');
      } else {
        sb.write(token);
      }
      
      // Add space after operators and parentheses for readability
      if (i + 1 < _tokens.length) {
        String next = _tokens[i + 1];
        if (_isInternalOperator(next) || next == '(' || next == ')') {
          sb.write(' ');
        }
      }
    }
    return sb.toString();
  }

  // Refresh pretty/preview display
  void _updateDisplay() {
    // Try preview from tokens
    String pretty = _buildExpressionFromTokens();
    _expression = pretty;
    if (_tokens.isEmpty) {
      _display = '0';
      return;
    }
    // Evaluate a preview (ignore history side effects)
    try {
      double preview = _evaluateTokens(_tokens);
      if (preview.isFinite) {
        _display = _formatNumber(preview);
      } else {
        _display = '?';
      }
    } catch (e) {
      _display = _tokens.isNotEmpty ? _tokens.last : '0';
    }
  }

  // Evaluate a list of tokens (internal representation: numbers, operators, and parentheses)
  double _evaluateTokens(List<String> toks) {
    if (toks.isEmpty) return 0.0;
    
    // Convert to string expression for evaluation
    String expr = toks.join(' ');
    
    // Simple recursive evaluation with parentheses
    return _evaluateExpression(expr);
  }
  
  // Evaluate expression with parentheses support
  double _evaluateExpression(String expr) {
    // Remove spaces
    expr = expr.replaceAll(' ', '');
    
    // Handle parentheses recursively
    while (expr.contains('(')) {
      int openIndex = expr.lastIndexOf('(');
      int closeIndex = expr.indexOf(')', openIndex);
      if (closeIndex == -1) {
        // Missing closing parenthesis, evaluate what we have
        break;
      }
      
      String inner = expr.substring(openIndex + 1, closeIndex);
      double innerResult = _evaluateSimpleExpression(inner);
      
      // Replace the parenthesized expression with its result
      expr = expr.substring(0, openIndex) + innerResult.toString() + expr.substring(closeIndex + 1);
    }
    
    return _evaluateSimpleExpression(expr);
  }
  
  // Evaluate simple expression without parentheses
  double _evaluateSimpleExpression(String expr) {
    if (expr.isEmpty) return 0.0;
    
    // Handle negative numbers at start
    if (expr.startsWith('-')) {
      expr = '0' + expr;
    }
    
    // Split by + and - operators, preserving them
    List<String> parts = [];
    StringBuffer current = StringBuffer();
    
    for (int i = 0; i < expr.length; i++) {
      String char = expr[i];
      if (char == '+' || char == '-') {
        if (current.isNotEmpty) {
          parts.add(current.toString());
          current.clear();
        }
        parts.add(char);
      } else {
        current.write(char);
      }
    }
    if (current.isNotEmpty) {
      parts.add(current.toString());
    }
    
    // First evaluate multiplication and division within each part
    List<double> results = [];
    List<String> operators = [];
    
    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      if (part == '+' || part == '-') {
        operators.add(part);
      } else {
        // Evaluate multiplication and division within this part
        double value = _evaluateMultiplicationDivision(part);
        results.add(value);
      }
    }
    
    // Now apply addition and subtraction
    if (results.isEmpty) return 0.0;
    
    double total = results[0];
    for (int i = 0; i < operators.length; i++) {
      if (i < results.length - 1) {
        if (operators[i] == '+') {
          total += results[i + 1];
        } else if (operators[i] == '-') {
          total -= results[i + 1];
        }
      }
    }
    
    return total;
  }
  
  // Evaluate multiplication and division within a term
  double _evaluateMultiplicationDivision(String term) {
    // Split by * and / operators
    List<String> parts = [];
    StringBuffer current = StringBuffer();
    
    for (int i = 0; i < term.length; i++) {
      String char = term[i];
      if (char == '*' || char == '/') {
        if (current.isNotEmpty) {
          parts.add(current.toString());
          current.clear();
        }
        parts.add(char);
      } else {
        current.write(char);
      }
    }
    if (current.isNotEmpty) {
      parts.add(current.toString());
    }
    
    if (parts.isEmpty) return 0.0;
    
    // Start with first number
    double result = double.tryParse(parts[0]) ?? 0.0;
    
    for (int i = 1; i < parts.length; i += 2) {
      if (i + 1 < parts.length) {
        String op = parts[i];
        double next = double.tryParse(parts[i + 1]) ?? 0.0;
        
        if (op == '*') {
          result *= next;
        } else if (op == '/') {
          if (next == 0) {
            return double.nan;
          }
          result /= next;
        }
      }
    }
    
    return result;
  }

  String _formatNumber(double value) {
    if (value.isNaN) return 'Error';
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    // Keep up to 8 significant decimals, trim trailing zeros
    return value.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  // Public API: input handling (token-based)
  void inputNumber(String number) {
    // number might be digits; append to current or start new expression after equals
    if (_justCalculated) {
      _tokens = [number];
      _rawTokens = [number];
      _justCalculated = false;
      _updateDisplay();
      notifyListeners();
      return;
    }
    if (_tokens.isEmpty || _isInternalOperator(_tokens.last)) {
      _tokens.add(number);
      _rawTokens.add(number);
    } else {
      _tokens[_tokens.length - 1] = _tokens.last + number;
      // append digits to the last raw token instead of creating a new one
      _rawTokens[_rawTokens.length - 1] = _rawTokens.last + number;
    }
    _updateDisplay();
    notifyListeners();
  }

  void inputDecimal() {
    if (_justCalculated) {
      _tokens = ['0.'];
      _rawTokens = ['0.'];
      _justCalculated = false;
      _updateDisplay();
      notifyListeners();
      return;
    }
    if (_tokens.isEmpty) {
      _tokens.add('0.');
      _rawTokens.add('0.');
      _updateDisplay();
      notifyListeners();
      return;
    }
    String last = _tokens.last;
    if (last.contains('.')) {
      // ignore multiple decimals in the same number
      return;
    }
    if (_isInternalOperator(_tokens.last)) {
      _tokens.add('0.');
      _rawTokens.add('0.');
    } else {
      _tokens[_tokens.length - 1] = last + '.';
      _rawTokens[_rawTokens.length - 1] = _rawTokens.last + '.';
    }
    _updateDisplay();
    notifyListeners();
  }

  void inputOperator(String op) {
    // map display op to internal op for calculation
    String internalOp = (op == '×') ? '*' : (op == '÷') ? '/' : op;

    // Do nothing if starting with an operator (not supported in this pass)
    if (_tokens.isEmpty) {
      return;
    }

    // Last token check to implement last-operator-wins
    String last = _tokens.last;
    if (_isInternalOperator(last)) {
      // replace last operator for calculation, and append the new operator to raw history to preserve original input
      _tokens[_tokens.length - 1] = internalOp;
      _rawTokens.add(op);
    } else {
      _tokens.add(internalOp);
      _rawTokens.add(op);
    }

    _updateDisplay();
    notifyListeners();
  }

  // Calculation workflow
  void calculate() {
    if (_justCalculated) return;
    // If there are no tokens, nothing to calculate
    if (_tokens.isEmpty) return;

    // Trailing operator handling on raw input for robust evaluation
    List<String> t = List.from(_rawTokens);
    if (t.isNotEmpty && _isInternalOperator(_mapRawOpToInternal(t.last))) {
      // drop trailing operator for evaluation
      t = t.sublist(0, t.length - 1);
    }
    if (t.isEmpty) return;

    // Build internal calc tokens from raw input and evaluate
    List<String> calcFromRaw = _toCalcTokensFromRaw(t);
    double result = _evaluateTokens(calcFromRaw);
    if (result.isNaN || result.isInfinite) {
      _display = '错误';
      _expression = '错误';
      _justCalculated = true;
      notifyListeners();
      return;
    }

    // Build history entry using original entered expression with proper formatting
    String originalExpression = _rawTokens.join('');
    // Format expression for display (convert * to ×, / to ÷)
    String displayExpr = originalExpression.replaceAll('*', '×').replaceAll('/', '÷');
    String formattedResult = _formatNumber(result);
    String historyEntry = '$displayExpr = $formattedResult';
    _history.insert(0, historyEntry);
    if (_history.length > 40) _history = _history.sublist(0, 40);

    _display = _formatNumber(result);
    _expression = _display;
    _justCalculated = true;
    // Reset for next expression
    _tokens = [];
    _rawTokens = [];
    notifyListeners();
  }

  // Parentheses handling
  void inputParentheses() {
    if (_justCalculated) {
      _tokens = ['('];
      _rawTokens = ['('];
      _justCalculated = false;
      _updateDisplay();
      notifyListeners();
      return;
    }
    
    if (_tokens.isEmpty) {
      _tokens.add('(');
      _rawTokens.add('(');
    } else {
      String last = _tokens.last;
      // If last token is a number or closing parenthesis, add multiplication before opening parenthesis
      if (_isNumber(last) || last == ')') {
        _tokens.add('*');
        _rawTokens.add('×');
        _tokens.add('(');
        _rawTokens.add('(');
      } else {
        _tokens.add('(');
        _rawTokens.add('(');
      }
    }
    _updateDisplay();
    notifyListeners();
  }

  // Close parentheses if there are unmatched opening parentheses
  void closeParentheses() {
    if (_justCalculated) return;
    
    int openCount = _rawTokens.where((t) => t == '(').length;
    int closeCount = _rawTokens.where((t) => t == ')').length;
    
    if (openCount > closeCount) {
      _tokens.add(')');
      _rawTokens.add(')');
      _updateDisplay();
      notifyListeners();
    }
  }

  // Basic operations
  void clear() {
    _display = '0';
    _expression = '';
    _tokens = [];
    _rawTokens = [];
    _justCalculated = false;
    notifyListeners();
  }

  void backspace() {
    if (_tokens.isEmpty) {
      _display = '0';
      _expression = '';
      notifyListeners();
      return;
    }
    if (_justCalculated) {
      _tokens = [];
      _rawTokens = [];
      _display = '0';
      _expression = '';
      _justCalculated = false;
      notifyListeners();
      return;
    }
    // remove last character from last token
    String last = _tokens.last;
    if (_isInternalOperator(last)) {
      _tokens.removeLast();
      if (_rawTokens.isNotEmpty) _rawTokens.removeLast();
    } else if (last.length > 1) {
      _tokens[_tokens.length - 1] = last.substring(0, last.length - 1);
      String rawLast = _rawTokens[_rawTokens.length - 1];
      _rawTokens[_rawTokens.length - 1] = rawLast.substring(0, rawLast.length - 1);
    } else {
      _tokens.removeLast();
      if (_rawTokens.isNotEmpty) _rawTokens.removeLast();
    }
    _updateDisplay();
    notifyListeners();
  }

  void toggleSign() {
    if (_tokens.isEmpty) return;
    // apply sign to the last number token
    int lastIndex = _tokens.length - 1;
    String last = _tokens[lastIndex];
    if (last.startsWith('-')) {
      _tokens[lastIndex] = last.substring(1);
      _rawTokens[_rawTokens.length - 1] = _rawTokens.last.startsWith('-') ? _rawTokens.last.substring(1) : _rawTokens.last; // rough sync
    } else {
      _tokens[lastIndex] = '-' + last;
      _rawTokens[_rawTokens.length - 1] = '-' + _rawTokens.last;
    }
    _updateDisplay();
    notifyListeners();
  }

  void percent() {
    if (_justCalculated) {
      // 对当前结果显示百分比: 例如 50 -> 0.5
      double val = double.tryParse(_display) ?? 0.0;
      if (val.isNaN) return;
      double percentVal = val / 100;
      _tokens = [percentVal.toString()];
      _rawTokens = [percentVal.toString()];
      _justCalculated = false;
      _updateDisplay();
      notifyListeners();
      return;
    }
    
    if (_tokens.isEmpty) return;
    
    // 提取最后一个数字或括号表达式
    String expr = _rawTokens.join('');
    
    // 匹配最后一个数字（包括小数）或者括号表达式
    // 简化实现：获取最后一个token
    if (_rawTokens.isEmpty) return;
    
    String lastToken = _rawTokens.last;
    double lastNum;
    
    if (lastToken == ')') {
      // 查找匹配的括号
      int closeCount = 0;
      int openIndex = -1;
      for (int i = _rawTokens.length - 1; i >= 0; i--) {
        if (_rawTokens[i] == ')') {
          closeCount++;
        } else if (_rawTokens[i] == '(') {
          closeCount--;
          if (closeCount == 0) {
            openIndex = i;
            break;
          }
        }
      }
      
      if (openIndex != -1) {
        // 提取括号内的表达式
        List<String> innerTokens = _rawTokens.sublist(openIndex + 1, _rawTokens.length - closeCount);
        String innerExpr = innerTokens.join('');
        try {
          double innerResult = _evaluateExpression(innerExpr);
          lastNum = innerResult;
        } catch (e) {
          return;
        }
        
        // 计算百分比
        double percentVal = lastNum / 100;
        
        // 替换括号表达式为百分比结果
        _rawTokens.replaceRange(openIndex, _rawTokens.length, [percentVal.toString()]);
        _tokens = _toCalcTokensFromRaw(_rawTokens);
      }
    } else {
      // 简单数字
      lastNum = double.tryParse(lastToken) ?? 0.0;
      if (lastNum.isNaN) return;
      
      double percentVal = lastNum / 100;
      
      // 替换最后一个token
      _rawTokens[_rawTokens.length - 1] = percentVal.toString();
      _tokens = _toCalcTokensFromRaw(_rawTokens);
    }
    
    _updateDisplay();
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  void selectHistoryItem(String item) {
    final parts = item.split(' = ');
    if (parts.length >= 2) {
      _expression = parts[0];
      _display = parts[0];
      _justCalculated = true;
      notifyListeners();
    }
  }

  // public helpers for tests or UI if needed
  void setInitialDisplayFromExpression(String expr) {
    // Not used in current flow; placeholder for potential future wiring
  }

  // Internal: format number for history display
  String _formatHistoryNumber(double value) {
    if (value.isNaN) return 'Error';
    if (value == value.toInt()) return value.toInt().toString();
    return value.toString();
  }

  // Map raw operator symbol (as entered by user) to internal calculation operator
  String _mapRawOpToInternal(String op) {
    if (op == '×') return '*';
    if (op == '÷') return '/';
    return op;
  }

  // Convert a raw token sequence into internal calculation tokens applying last-operator-wins
  List<String> _toCalcTokensFromRaw(List<String> raw) {
    List<String> calc = [];
    if (raw.isEmpty) return calc;

    String? pendingOp;

    for (int i = 0; i < raw.length; i++) {
      String t = raw[i];
      bool isNum = t.isNotEmpty && !_isInternalOperator(t);
      if (isNum) {
        if (calc.isEmpty) {
          calc.add(t);
        } else if (pendingOp != null) {
          calc.add(pendingOp);
          calc.add(t);
          pendingOp = null;
        } else {
          // consecutive numbers without operator; treat as implicit concatenation (rare)
          // We'll append to the last number if possible
          String last = calc.last;
          if (!_isInternalOperator(last)) {
            calc[calc.length - 1] = last + t;
          } else {
            calc.add(t);
          }
        }
      } else {
        // operator token
        String internal = _mapRawOpToInternal(t);
        if (calc.isNotEmpty && _isInternalOperator(calc.last)) {
          // last operator exists, replace with the latest one
          calc[calc.length - 1] = internal;
        } else {
          pendingOp = internal;
        }
      }
    }
    return calc;
  }

  // End helpers
}
