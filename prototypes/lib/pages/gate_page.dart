import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rds/rds.dart';

import '../auth.dart';

// ---------------------------------------------------------------------------
// GatePage — password-protected entry to the prototype index
// ---------------------------------------------------------------------------

class GatePage extends StatefulWidget {
  const GatePage({super.key});

  @override
  State<GatePage> createState() => _GatePageState();
}

class _GatePageState extends State<GatePage>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _errorText;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _controller.text.trim();
    if (password == kIndexPassword) {
      signIn();
      context.go('/index');
    } else {
      setState(() => _errorText = 'Incorrect password');
      _controller.clear();
      _shakeController.forward(from: 0);
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              final dx = _shakeController.isAnimating
                  ? 8 * (0.5 - (_shakeAnimation.value - 0.5).abs()) * 2
                  : 0.0;
              return Transform.translate(offset: Offset(dx, 0), child: child);
            },
            child: Container(
              margin: EdgeInsets.all(rds.space6),
              padding: EdgeInsets.all(rds.space8),
              decoration: BoxDecoration(
                color: rds.surface,
                borderRadius: BorderRadius.circular(rds.radiusLg),
                boxShadow: RdsShadows.shadowMd,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Wordmark
                  Text(
                    'Reya',
                    style: rds.displaySmall.copyWith(
                      color: rds.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: rds.space1),
                  Text(
                    'Prototype Library',
                    style: rds.bodyMedium.copyWith(color: rds.onSurfaceMuted),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: rds.space8),

                  // Password field
                  RdsPasswordField(
                    label: 'Password',
                    focusNode: _focusNode,
                    controller: _controller,
                    errorText: _errorText,
                    onChanged: (_) {
                      if (_errorText != null) {
                        setState(() => _errorText = null);
                      }
                    },
                    onSubmitted: (_) => _submit(),
                  ),
                  SizedBox(height: rds.space5),

                  // Unlock button
                  RdsButton(
                    label: 'Unlock',
                    variant: RdsButtonVariant.primary,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
