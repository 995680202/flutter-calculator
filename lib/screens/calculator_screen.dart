import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    // Request focus for keyboard input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E8F0),
      body: SafeArea(
        child: RawKeyboardListener(
          focusNode: _focusNode,
          onKey: _handleKeyEvent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 主卡片：类似截图风格，浅色磨砂
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Column(
                        children: [
                          // 顶部区域（显示和历史）
                          Expanded(
                            flex: 45,
                            child: _buildDisplayArea(),
                          ),
                          // 按钮区
                          Expanded(
                            flex: 55,
                            child: _buildButtons(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 底部标签栏（装饰）
                const SizedBox(height: 10),
                _buildTabBar(),
                const SizedBox(height: 8),
                const Text(
                  '键盘支持 · 括号/百分号 · 历史记录',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFA28A64),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem('标准', isActive: true),
          _buildTabItem('科学'),
          _buildTabItem('记事'),
          _buildTabItem('我的'),
        ],
      ),
    );
  }
  
  Widget _buildTabItem(String text, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFDEACA) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isActive ? const Color(0xFFB45F1B) : const Color(0xFF8B6F48),
        ),
      ),
    );
  }
  
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final calc = context.read<CalculatorProvider>();
      final logicalKey = event.logicalKey;
      
      // Handle number keys
      if (logicalKey == LogicalKeyboardKey.digit0 || logicalKey == LogicalKeyboardKey.numpad0) {
        calc.inputNumber('0');
      } else if (logicalKey == LogicalKeyboardKey.digit1 || logicalKey == LogicalKeyboardKey.numpad1) {
        calc.inputNumber('1');
      } else if (logicalKey == LogicalKeyboardKey.digit2 || logicalKey == LogicalKeyboardKey.numpad2) {
        calc.inputNumber('2');
      } else if (logicalKey == LogicalKeyboardKey.digit3 || logicalKey == LogicalKeyboardKey.numpad3) {
        calc.inputNumber('3');
      } else if (logicalKey == LogicalKeyboardKey.digit4 || logicalKey == LogicalKeyboardKey.numpad4) {
        calc.inputNumber('4');
      } else if (logicalKey == LogicalKeyboardKey.digit5 || logicalKey == LogicalKeyboardKey.numpad5) {
        calc.inputNumber('5');
      } else if (logicalKey == LogicalKeyboardKey.digit6 || logicalKey == LogicalKeyboardKey.numpad6) {
        calc.inputNumber('6');
      } else if (logicalKey == LogicalKeyboardKey.digit7 || logicalKey == LogicalKeyboardKey.numpad7) {
        calc.inputNumber('7');
      } else if (logicalKey == LogicalKeyboardKey.digit8 || logicalKey == LogicalKeyboardKey.numpad8) {
        calc.inputNumber('8');
      } else if (logicalKey == LogicalKeyboardKey.digit9 || logicalKey == LogicalKeyboardKey.numpad9) {
        calc.inputNumber('9');
      }
      // Handle operators
      else if (logicalKey == LogicalKeyboardKey.add || logicalKey == LogicalKeyboardKey.numpadAdd) {
        calc.inputOperator('+');
      } else if (logicalKey == LogicalKeyboardKey.minus || logicalKey == LogicalKeyboardKey.numpadSubtract) {
        calc.inputOperator('-');
      } else if (logicalKey == LogicalKeyboardKey.asterisk || logicalKey == LogicalKeyboardKey.numpadMultiply) {
        calc.inputOperator('×');
      } else if (logicalKey == LogicalKeyboardKey.slash || logicalKey == LogicalKeyboardKey.numpadDivide) {
        calc.inputOperator('÷');
      }
      // Handle other keys
      else if (logicalKey == LogicalKeyboardKey.period || logicalKey == LogicalKeyboardKey.numpadDecimal) {
        calc.inputDecimal();
      } else if (logicalKey == LogicalKeyboardKey.enter || logicalKey == LogicalKeyboardKey.numpadEnter) {
        calc.calculate();
      } else if (logicalKey == LogicalKeyboardKey.escape) {
        calc.clear();
      } else if (logicalKey == LogicalKeyboardKey.backspace) {
        calc.backspace();
      } else if (logicalKey == LogicalKeyboardKey.percent) {
        calc.percent();
      } else if (logicalKey == LogicalKeyboardKey.parenthesisLeft) {
        calc.inputParentheses();
      } else if (logicalKey == LogicalKeyboardKey.parenthesisRight) {
        // For closing parentheses, we need to add this method to CalculatorProvider
        // calc.closeParentheses();
      }
    }
  }

  Widget _buildDisplayArea() {
    return Consumer<CalculatorProvider>(
      builder: (context, calc, _) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              // 历史记录区域
              Container(
                height: 180,
                color: const Color(0xFFFEFAF5),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // 清空历史按钮
                    if (calc.history.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => calc.clearHistory(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0E0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '清空记录',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFB45F2B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // 历史列表
                    Expanded(
                      child: calc.history.isEmpty
                          ? const Center(
                              child: Text(
                                '✨ 暂无计算记录',
                                style: TextStyle(
                                  color: Color(0xFFC0A16B),
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: calc.history.length,
                              itemBuilder: (context, index) {
                                final item = calc.history[index];
                                final parts = item.split(' = ');
                                final expression = parts.length > 0 ? parts[0] : '';
                                final result = parts.length > 1 ? parts[1] : '';
                                
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: const Color(0xFFF0E4D6).withOpacity(0.8),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          expression,
                                          style: const TextStyle(
                                            color: Color(0xFF4A5B6E),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'SF Mono',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEEF4FC),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Text(
                                          result,
                                          style: const TextStyle(
                                            color: Color(0xFF2C7CB6),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'SF Mono',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              // 结果显示区域
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                color: const Color(0xFF101F2E),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 表达式预览
                    if (calc.expression.isNotEmpty && calc.expression != calc.display)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          calc.expression,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF9FC9EE),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // 主结果
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        calc.display,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButtons() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 第一行: C ⌫ ( ) ÷
          _buildFirstRow(),
          const SizedBox(height: 10),
          // 第二行: 7 8 9 ×
          _buildRow(['7', '8', '9', '×']),
          const SizedBox(height: 10),
          // 第三行: 4 5 6 -
          _buildRow(['4', '5', '6', '-']),
          const SizedBox(height: 10),
          // 第四行: 1 2 3 +
          _buildRow(['1', '2', '3', '+']),
          const SizedBox(height: 10),
          // 第五行: % 0 . =
          _buildLastRow(),
        ],
      ),
    );
  }
  
  Widget _buildFirstRow() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(6, 3, 6, 0),
        child: Row(
          children: [
            // C 按钮
            Expanded(child: _buildButton('C')),
            // ⌫ 按钮
            Expanded(child: _buildButton('⌫')),
            // ( ) 按钮
            Expanded(child: _buildButton('( )')),
            // ÷ 按钮
            Expanded(child: _buildButton('÷')),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(6, 3, 6, 0),
        child: Row(
          children: buttons.map((text) {
            return _buildButton(text);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLastRow() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(6, 3, 6, 6),
        child: Row(
          children: [
            // % 按钮
            Expanded(child: _buildButton('%')),
            // 0 按钮（稍宽一点）
            Expanded(child: _buildButton('0', isWide: true)),
            // . 按钮
            Expanded(child: _buildButton('.')),
            // = 按钮
            Expanded(child: _buildButton('=', isOrange: true)),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, {bool isOrange = false, bool isWide = false}) {
    Color bgColor;
    Color textColor;
    double fontSize = 24;
    FontWeight fontWeight = FontWeight.w600;

    if (isOrange) {
      bgColor = const Color(0xFF3B82F6);
      textColor = Colors.white;
      fontSize = 28;
      fontWeight = FontWeight.bold;
    } else if (['÷', '×', '-', '+'].contains(text)) {
      bgColor = const Color(0xFFFDEACA);
      textColor = const Color(0xFFBC6F1C);
      fontSize = 28;
      fontWeight = FontWeight.w800;
    } else if (text == 'C') {
      bgColor = const Color(0xFFFFE4E4);
      textColor = const Color(0xFFC2410C);
      fontSize = 24;
    } else if (text == '⌫') {
      bgColor = const Color(0xFFEEF2FF);
      textColor = const Color(0xFF4A5568);
      fontSize = 22;
    } else if (text == '( )') {
      bgColor = const Color(0xFFF1E8E0);
      textColor = const Color(0xFFB45F2B);
      fontSize = 22;
      fontWeight = FontWeight.w700;
    } else if (text == '%') {
      bgColor = const Color(0xFFE9F0F5);
      textColor = const Color(0xFF2C6280);
      fontSize = 24;
    } else {
      // 数字按钮
      bgColor = const Color(0xFFF2F5F9);
      textColor = const Color(0xFF1E293B);
      fontSize = 26;
    }

    return GestureDetector(
      onTapDown: (_) {
        // 点击效果
        _handleButtonPress(text);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(String text) {
    final calc = context.read<CalculatorProvider>();

    switch (text) {
      case 'C':
        calc.clear();
        break;
      case '⌫':
        calc.backspace();
        break;
      case '( )':
        calc.inputParentheses();
        break;
      case '%':
        calc.percent();
        break;
      case '÷':
      case '×':
      case '-':
      case '+':
        calc.inputOperator(text);
        break;
      case '=':
        calc.calculate();
        break;
      case '.':
        calc.inputDecimal();
        break;
      default:
        // Check if it's a number
        if (text.length == 1 && int.tryParse(text) != null) {
          calc.inputNumber(text);
        }
    }
  }
}
