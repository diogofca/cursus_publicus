import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THEME CONFIG — change colors, fonts, radii, and logo here.
// ─────────────────────────────────────────────────────────────────────────────

class LoginThemeConfig {
  // Background
  final Color backgroundColor;

  // Brand logo widget (replace with your own Image.asset / SvgPicture / etc.)
  final Widget logo;

  // Headline & subtitle
  final String headlineText;
  final String subtitleText;
  final TextStyle headlineStyle;
  final TextStyle subtitleStyle;

  // Social buttons
  final SocialButtonStyle googleButtonStyle;
  final SocialButtonStyle appleButtonStyle;
  final SocialButtonStyle emailButtonStyle;

  // Divider
  final Color dividerColor;
  final TextStyle dividerTextStyle;

  // Footer (privacy / terms)
  final TextStyle footerStyle;
  final Color footerLinkColor;

  const LoginThemeConfig({
    this.backgroundColor = const Color(0xFFFAF9F7),
    this.logo = const _DefaultLogo(),
    this.headlineText = 'Welcome to Claude',
    this.subtitleText = 'Log in or create a free account to continue.',
    this.headlineStyle = const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1A1A1A),
      letterSpacing: -0.5,
    ),
    this.subtitleStyle = const TextStyle(
      fontSize: 15,
      color: Color(0xFF6B6B6B),
      height: 1.5,
    ),
    this.googleButtonStyle = const SocialButtonStyle(
      label: 'Continue with Google',
      icon: _GoogleIcon(),
    ),
    this.appleButtonStyle = const SocialButtonStyle(
      label: 'Continue with Apple',
      icon: _AppleIcon(),
    ),
    this.emailButtonStyle = const SocialButtonStyle(
      label: 'Continue with email',
      icon: _EmailIcon(),
    ),
    this.dividerColor = const Color(0xFFE5E5E3),
    this.dividerTextStyle = const TextStyle(
      fontSize: 13,
      color: Color(0xFF9B9B9B),
    ),
    this.footerStyle = const TextStyle(fontSize: 12, color: Color(0xFF9B9B9B)),
    this.footerLinkColor = const Color(0xFF6B6B6B),
  });
}

class SocialButtonStyle {
  final String label;
  final Widget icon;

  // Button chrome
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final double height;
  final TextStyle? labelStyle;

  const SocialButtonStyle({
    required this.label,
    required this.icon,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFD9D9D6),
    this.textColor = const Color(0xFF1A1A1A),
    this.borderRadius = 10,
    this.height = 52,
    this.labelStyle,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN LOGIN WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class LoginWidget extends StatefulWidget {
  final LoginThemeConfig theme;

  /// Callbacks — wire these up to your auth logic.
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onAppleSignIn;
  final VoidCallback? onEmailSignIn;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onTermsTap;

  const LoginWidget({
    super.key,
    this.theme = const LoginThemeConfig(),
    this.onGoogleSignIn,
    this.onAppleSignIn,
    this.onEmailSignIn,
    this.onPrivacyTap,
    this.onTermsTap,
  });

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String? _loadingButton; // tracks which button is in loading state

  Future<void> _handlePress(String key, VoidCallback? callback) async {
    if (_loadingButton != null) return;
    setState(() => _loadingButton = key);
    await Future.delayed(const Duration(milliseconds: 200)); // debounce feel
    callback?.call();
    if (mounted) setState(() => _loadingButton = null);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return Scaffold(
      backgroundColor: t.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              // Card never wider than 400 — mirrors Claude's web layout
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Logo ──────────────────────────────────────────────────
                  t.logo,
                  const SizedBox(height: 28),

                  // ── Headline ──────────────────────────────────────────────
                  Text(
                    t.headlineText,
                    style: t.headlineStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // ── Subtitle ──────────────────────────────────────────────
                  Text(
                    t.subtitleText,
                    style: t.subtitleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // ── Social buttons ────────────────────────────────────────
                  _SocialButton(
                    style: t.googleButtonStyle,
                    isLoading: _loadingButton == 'google',
                    onTap: () => _handlePress('google', widget.onGoogleSignIn),
                  ),
                  const SizedBox(height: 12),
                  _SocialButton(
                    style: t.appleButtonStyle,
                    isLoading: _loadingButton == 'apple',
                    onTap: () => _handlePress('apple', widget.onAppleSignIn),
                  ),

                  // ── "or" divider ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _OrDivider(
                      color: t.dividerColor,
                      textStyle: t.dividerTextStyle,
                    ),
                  ),

                  // ── Email button ──────────────────────────────────────────
                  _SocialButton(
                    style: t.emailButtonStyle,
                    isLoading: _loadingButton == 'email',
                    onTap: () => _handlePress('email', widget.onEmailSignIn),
                  ),

                  const SizedBox(height: 36),

                  // ── Footer ────────────────────────────────────────────────
                  _Footer(
                    baseStyle: t.footerStyle,
                    linkColor: t.footerLinkColor,
                    onPrivacyTap: widget.onPrivacyTap,
                    onTermsTap: widget.onTermsTap,
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

// ─────────────────────────────────────────────────────────────────────────────
// INTERNAL WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final SocialButtonStyle style;
  final VoidCallback onTap;
  final bool isLoading;

  const _SocialButton({
    required this.style,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle =
        style.labelStyle ??
        TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: style.textColor,
          letterSpacing: -0.1,
        );

    return SizedBox(
      width: double.infinity,
      height: style.height,
      child: Material(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(style.borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(style.borderRadius),
          onTap: isLoading ? null : onTap,
          splashColor: Colors.black.withOpacity(0.04),
          highlightColor: Colors.black.withOpacity(0.03),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(style.borderRadius),
              border: Border.all(color: style.borderColor, width: 1.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Icon slot (24×24)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: isLoading
                      ? CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(style.textColor),
                        )
                      : style.icon,
                ),
                const Spacer(),
                // Centered label
                Text(style.label, style: effectiveLabelStyle),
                const Spacer(),
                // Balance the icon on the other side
                const SizedBox(width: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  final Color color;
  final TextStyle textStyle;

  const _OrDivider({required this.color, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: color, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('or', style: textStyle),
        ),
        Expanded(child: Divider(color: color, thickness: 1)),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final TextStyle baseStyle;
  final Color linkColor;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onTermsTap;

  const _Footer({
    required this.baseStyle,
    required this.linkColor,
    this.onPrivacyTap,
    this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: 'By continuing, you agree to our '),
          WidgetSpan(
            child: GestureDetector(
              onTap: onTermsTap,
              child: Text(
                'Terms of Service',
                style: baseStyle.copyWith(
                  color: linkColor,
                  decoration: TextDecoration.underline,
                  decorationColor: linkColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const TextSpan(text: ' and '),
          WidgetSpan(
            child: GestureDetector(
              onTap: onPrivacyTap,
              child: Text(
                'Privacy Policy',
                style: baseStyle.copyWith(
                  color: linkColor,
                  decoration: TextDecoration.underline,
                  decorationColor: linkColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DEFAULT LOGO  (Claude-style hexagonal mark — swap with your own widget)
// ─────────────────────────────────────────────────────────────────────────────

class _DefaultLogo extends StatelessWidget {
  const _DefaultLogo();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(56, 56), painter: _ClaudeLogoPainter());
  }
}

/// Draws the simplified Anthropic/Claude hexagonal "A" mark in coral-orange.
/// Replace this with your own logo asset.
class _ClaudeLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFFCC785C) // Claude's brand coral
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Outer rounded hexagon
    final hexPath = Path();
    final r = w * 0.46;
    final cx = w / 2;
    final cy = h / 2;
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * (3.14159265 / 180);
      final px = cx + r * _cos(angle);
      final py = cy + r * _sin(angle);
      i == 0 ? hexPath.moveTo(px, py) : hexPath.lineTo(px, py);
    }
    hexPath.close();

    canvas.drawPath(hexPath, paint);

    // Inner "A"-like notch — drawn white so the hex looks like a letterform
    final notch = Paint()
      ..color = const Color(0xFFFAF9F7)
      ..style = PaintingStyle.fill;

    final nPath = Path()
      ..moveTo(cx, cy - h * 0.22)
      ..lineTo(cx - w * 0.18, cy + h * 0.18)
      ..lineTo(cx - w * 0.07, cy + h * 0.18)
      ..lineTo(cx, cy - h * 0.02)
      ..lineTo(cx + w * 0.07, cy + h * 0.18)
      ..lineTo(cx + w * 0.18, cy + h * 0.18)
      ..close();

    // Cross-bar of the A
    final barPath = Path()
      ..addRect(Rect.fromLTWH(cx - w * 0.1, cy + h * 0.04, w * 0.2, h * 0.05));

    canvas.drawPath(nPath, notch);
    canvas.drawPath(
      barPath,
      Paint()..color = const Color(0xFFCC785C),
    ); // punches back through
  }

  double _cos(double rad) => _trig(rad, true);
  double _sin(double rad) => _trig(rad, false);
  double _trig(double rad, bool isCos) {
    // Simple inline trig (dart:math not in scope in a painter, import it at
    // the top of your file or use the real dart:math.cos / dart:math.sin)
    return isCos ? _dartCos(rad) : _dartSin(rad);
  }

  // Fallback tiny trig via Taylor series (4-term, accurate enough for a logo)
  double _dartCos(double x) {
    x = x % (2 * 3.14159265);
    double r = 1;
    double t = 1;
    for (int i = 1; i <= 6; i++) {
      t *= -x * x / ((2 * i - 1) * (2 * i));
      r += t;
    }
    return r;
  }

  double _dartSin(double x) {
    x = x % (2 * 3.14159265);
    double r = x;
    double t = x;
    for (int i = 1; i <= 6; i++) {
      t *= -x * x / ((2 * i) * (2 * i + 1));
      r += t;
    }
    return r;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// BUILT-IN ICON WIDGETS  (pure Flutter — no extra packages needed)
// ─────────────────────────────────────────────────────────────────────────────

/// Google "G" logo drawn with Flutter primitives.
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(20, 20), painter: _GoogleIconPainter());
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Background circle
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white);

    // Simplified coloured arcs for the G letterform
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.85);

    void arc(Color c, double start, double sweep) {
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = c
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.22
          ..strokeCap = StrokeCap.butt,
      );
    }

    const pi = 3.14159265;
    arc(const Color(0xFF4285F4), -pi / 6, pi * 0.55); // blue
    arc(const Color(0xFF34A853), pi * 0.39, pi * 0.55); // green
    arc(const Color(0xFFFBBC05), pi * 0.94, pi * 0.53); // yellow
    arc(const Color(0xFFEA4335), -pi * 0.61, pi * 0.47); // red

    // Horizontal bar of the G
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = size.width * 0.21
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(Offset(cx, cy), Offset(cx + r * 0.78, cy), barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

///  Apple logo — monochrome  (drawn with a Bézier approximation)
class _AppleIcon extends StatelessWidget {
  const _AppleIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(20, 20), painter: _AppleIconPainter());
  }
}

class _AppleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Simple stylised apple silhouette
    final path = Path()
      // Right lobe
      ..moveTo(w * 0.73, h * 0.28)
      ..cubicTo(w * 0.80, h * 0.20, w * 0.90, h * 0.22, w * 0.92, h * 0.30)
      ..cubicTo(w * 0.97, h * 0.44, w * 0.92, h * 0.70, w * 0.81, h * 0.82)
      ..cubicTo(w * 0.74, h * 0.91, w * 0.68, h * 0.91, w * 0.60, h * 0.88)
      ..cubicTo(w * 0.52, h * 0.85, w * 0.48, h * 0.85, w * 0.40, h * 0.88)
      ..cubicTo(w * 0.32, h * 0.91, w * 0.26, h * 0.91, w * 0.19, h * 0.82)
      ..cubicTo(w * 0.08, h * 0.70, w * 0.03, h * 0.44, w * 0.08, h * 0.30)
      ..cubicTo(w * 0.10, h * 0.22, w * 0.20, h * 0.20, w * 0.27, h * 0.28)
      ..cubicTo(w * 0.38, h * 0.38, w * 0.62, h * 0.38, w * 0.73, h * 0.28)
      ..close();

    canvas.drawPath(path, paint);

    // Leaf / stem
    final stemPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    final stemPath = Path()
      ..moveTo(w * 0.50, h * 0.22)
      ..cubicTo(w * 0.50, h * 0.10, w * 0.65, h * 0.04, w * 0.70, h * 0.08)
      ..cubicTo(w * 0.65, h * 0.12, w * 0.58, h * 0.16, w * 0.50, h * 0.22)
      ..close();

    canvas.drawPath(stemPath, stemPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

/// Envelope icon for "Continue with email"
class _EmailIcon extends StatelessWidget {
  const _EmailIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.mail_outline_rounded,
      size: 20,
      color: Color(0xFF1A1A1A),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// USAGE EXAMPLE  — drop this in main.dart to see it live
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  runApp(const _DemoApp());
}

class _DemoApp extends StatelessWidget {
  const _DemoApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Widget Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter', // swap for any font you add in pubspec.yaml
        useMaterial3: true,
      ),
      home: LoginWidget(
        // ── Swap theme here ──────────────────────────────────────────────────
        theme: const LoginThemeConfig(
          // Example: dark variant
          // backgroundColor: Color(0xFF1A1A1A),
          // headlineStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w600,
          //     color: Colors.white, letterSpacing: -0.5),
        ),
        onGoogleSignIn: () => debugPrint('Google sign-in tapped'),
        onAppleSignIn: () => debugPrint('Apple sign-in tapped'),
        onEmailSignIn: () => debugPrint('Email sign-in tapped'),
        onPrivacyTap: () => debugPrint('Privacy Policy tapped'),
        onTermsTap: () => debugPrint('Terms tapped'),
      ),
    );
  }
}
