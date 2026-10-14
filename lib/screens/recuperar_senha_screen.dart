import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Tela visual de recuperação de senha.
/// O envio real do e-mail será implementado com Supabase Auth.
class RecuperarSenhaScreen extends StatefulWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  State<RecuperarSenhaScreen> createState() => _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState extends State<RecuperarSenhaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _solicitarRecuperacao() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'E-mail validado! O envio do link será ativado quando conectarmos o Supabase Auth.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Voltar ao login',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -145,
            right: -125,
            child: IgnorePointer(
              child: Container(
                height: 330,
                width: 330,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.13),
                      AppColors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: const Icon(
                            Icons.mark_email_read_outlined,
                            color: AppColors.primary,
                            size: 39,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'WildLife',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Recuperar senha',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 29,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Informe o e-mail da sua conta. Quando a recuperação estiver ativa, você receberá um link para redefinir sua senha.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 34),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'E-MAIL',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.email],
                                onFieldSubmitted: (_) => _solicitarRecuperacao(),
                                style: const TextStyle(color: AppColors.textPrimary),
                                decoration: InputDecoration(
                                  hintText: 'seuemail@exemplo.com',
                                  hintStyle: const TextStyle(color: AppColors.textMuted),
                                  prefixIcon: const Icon(
                                    Icons.mail_outline_rounded,
                                    color: AppColors.textSecondary,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surfaceElevated,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppColors.borderLight),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppColors.borderLight),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                                  ),
                                ),
                                validator: (value) {
                                  final email = value?.trim() ?? '';
                                  if (email.isEmpty) return 'Informe seu e-mail.';
                                  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                                    return 'Informe um e-mail válido.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 54,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.goldGradient,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: FilledButton.icon(
                                    onPressed: _solicitarRecuperacao,
                                    icon: const Icon(Icons.send_rounded, size: 19),
                                    label: const Text(
                                      'RECUPERAR SENHA',
                                      style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
                                    ),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      foregroundColor: AppColors.navy,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: const Text('Voltar para o login'),
                        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
